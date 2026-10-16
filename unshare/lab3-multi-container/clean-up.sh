#!/bin/bash
# cleanup.sh - 彻底清理所有 unshare 容器、网络接口及挂载资源

set -euo pipefail

# 1. 检查是否具备 root 权限
if [ "$(id -u)" -ne 0 ]; then
    echo "[错误] 该脚本需要 root 权限，请使用 sudo 执行！" >&2
    exit 1
fi

echo "==> 1. 正在获取并精确终止容器进程..."
# 优先使用保存的 PID 进行精准杀进程
if compgen -G "/tmp/c*.pid" > /dev/null; then
    for pid_file in /tmp/c*.pid; do
        if [ -f "$pid_file" ]; then
            c_pid=$(cat "$pid_file" 2>/dev/null || true)
            if [ -n "$c_pid" ] && kill -0 "$c_pid" 2>/dev/null; then
                echo "   终止 PID 为 ${c_pid} 的容器进程..."
                kill -9 "$c_pid" 2>/dev/null || true
            fi
        fi
    done
fi

# 备用方案：杀死所有挂起的 sleep infinity 守护进程
pkill -9 -f "unshare.*sleep infinity" 2>/dev/null || true
pkill -9 -f "sleep infinity" 2>/dev/null || true

echo "==> 2. 正在清理残留的 Mount/UTS/Net 命名空间挂载..."
# 强制解绑可能残留在 /tmp 或系统中的容器挂载点（防止未正常退出的 mount 占满资源）
awk '$2 ~ /^\/tmp\/c/ {print $2}' /proc/mounts | sort -r | xargs -r -I {} umount -l {} 2>/dev/null || true

echo "==> 3. 正在清理虚拟网口与网桥..."
# 先批量强删所有匹配 veth-c* 的虚拟网卡对（防止孤立网卡残留）
ip -br link 2>/dev/null | awk '/veth-c/ {print $1}' | xargs -r -I {} ip link delete {} 2>/dev/null || true

# 删除网桥设备
if ip link show br-unshare >/dev/null 2>&1; then
    ip link delete br-unshare type bridge 2>/dev/null || true
fi

echo "==> 4. 正在清理临时配置文件与 PID 标记..."
rm -f /tmp/c*.pid

echo "==> 5. 验证清理结果..."
REMAIN_VETH=$(ip -br link 2>/dev/null | awk '/veth-c/ {print $1}' | tr '\n' ' ')
REMAIN_BR=$(ip link show br-unshare 2>/dev/null || true)

if [ -z "$REMAIN_VETH" ] && [ -z "$REMAIN_BR" ]; then
    echo "=================================================="
    echo " 清理成功！所有容器进程、veth 网卡与网桥已完全销毁。"
    echo "=================================================="
else
    echo "[警告] 部分网络接口可能未完全卸载："
    [ -n "$REMAIN_VETH" ] && echo "  - 残留网卡: $REMAIN_VETH"
    [ -n "$REMAIN_BR" ] && echo "  - 残留网桥: br-unshare"
fi
