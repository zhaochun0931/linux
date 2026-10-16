#!/bin/bash
set -e

# ================= 配置区 =================
CONTAINER_NUM=3              # 要创建的容器数量
BRIDGE="br-unshare"          # 网桥名称
BRIDGE_IP="192.168.100.1"    # 宿主机网桥 IP（网关）
NET_MASK="24"                # 子网掩码
HOST_IF="ens160"             # 宿主机外网网卡
DNS_SERVER="223.5.5.5"       # 容器使用的公共 DNS
# ==========================================

echo "==> 1. 开启内核 IP 转发功能..."
sysctl -w net.ipv4.ip_forward=1 >/dev/null

echo "==> 2. 清理并重新配置网桥 ${BRIDGE}..."
# 彻底清理残留网卡与网桥
ip link delete "$BRIDGE" type bridge 2>/dev/null || true

ip link add name "$BRIDGE" type bridge
ip addr flush dev "$BRIDGE"
ip addr add "${BRIDGE_IP}/${NET_MASK}" dev "$BRIDGE"
ip link set "$BRIDGE" up

echo "==> 3. 配置 iptables 防火墙与 NAT 外网转发..."
iptables -P FORWARD ACCEPT
iptables -t nat -D POSTROUTING -s 192.168.100.0/24 -o "$HOST_IF" -j MASQUERADE 2>/dev/null || true
iptables -t nat -A POSTROUTING -s 192.168.100.0/24 -o "$HOST_IF" -j MASQUERADE

echo "==> 4. 批量创建容器并配置网络与 UTS..."
for i in $(seq 1 $CONTAINER_NUM); do
    C_NAME="c$i"
    C_IP="192.168.100.$((i + 1))"
    VETH_HOST="veth-${C_NAME}-h"
    VETH_GUEST="veth-${C_NAME}-g"

    # 清理残留的虚拟网卡对（防重关键步骤）
    ip link delete "$VETH_HOST" 2>/dev/null || true

    # 1. 启动并后台运行 unshare 容器进程
    unshare --net --uts --mount --fork sleep infinity &
    C_PID=$!

    # 2. 创建 veth pair 虚拟网卡对
    ip link add "$VETH_HOST" type veth peer name "$VETH_GUEST"
    ip link set "$VETH_HOST" master "$BRIDGE"
    ip link set "$VETH_HOST" up

    # 3. 将客户端 veth 移入容器网络命名空间
    ip link set "$VETH_GUEST" netns "$C_PID"

    # 4. 在容器 Namespace 内部配置网络、主机名与 DNS
    nsenter -t "$C_PID" -n -m -u bash -c "
        hostname '$C_NAME'
        ip link set lo up
        ip link set '$VETH_GUEST' name eth0
        ip addr add '${C_IP}/${NET_MASK}' dev eth0
        ip link set eth0 up
        ip route add default via '$BRIDGE_IP'
        echo 'nameserver $DNS_SERVER' > /etc/resolv.conf
    "

    # 保存 PID 方便进入容器
    echo "$C_PID" > "/tmp/${C_NAME}.pid"
    echo "容器 ${C_NAME} (${C_IP}) 配置完成！"
done

echo ""
echo "=================================================="
echo " 搭建成功！输入以下命令进入容器 c1 并验证："
echo " nsenter -t \$(cat /tmp/c1.pid) -n -m -u bash"
echo "=================================================="
