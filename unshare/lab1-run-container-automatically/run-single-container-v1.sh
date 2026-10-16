#!/bin/bash
set -e  # 遇到错误立即停止执行

CONTAINER_DIR="/tmp/my-container"
ROOTFS_DIR="${CONTAINER_DIR}/rootfs"
ALPINE_URL="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/aarch64/alpine-minirootfs-3.19.1-aarch64.tar.gz"
TAR_FILE="alpine-minirootfs-3.19.1-aarch64.tar.gz"

echo "=== 1. 准备目录结构与解压 rootfs ==="
mkdir -p "${ROOTFS_DIR}"
cd "${CONTAINER_DIR}"

if [ ! -f "${TAR_FILE}" ]; then
    echo "正在下载 Alpine Minirootfs..."
    wget "${ALPINE_URL}"
fi

echo "解压镜像到 ${ROOTFS_DIR}..."
tar -xf "${TAR_FILE}" -C rootfs/

echo "检查二进制文件类型："
ls -l rootfs/bin/sh
file rootfs/bin/busybox || true

echo "=== 2. 启动 Namespace 隔离并切入容器执行初始化 ==="
export ROOTFS="${ROOTFS_DIR}"

# 使用 sudo unshare 进入新 Namespace，并利用 Here Document (EOF) 在容器内自动执行步骤 1~4
sudo unshare -m -u -i -p -n -f chroot "$ROOTFS" /bin/sh << 'EOF'
echo "[容器内] 1. 挂载 proc/sysfs/tmpfs..."
mount -t proc proc /proc
mount -t sysfs none /sys
mount -t tmpfs none /tmp

echo "[容器内] 2. 设置独立主机名..."
hostname my-mini-container

echo "[容器内] 3. 验证隔离效果..."
echo "--- 进程列表 (PID 隔离检查) ---"
ps aux

echo "--- 主机名检查 ---"
hostname

echo "[容器内] 初始化完成，退出容器。"
exit
EOF

echo "=== 宿主机：容器进程已安全退出 ==="
