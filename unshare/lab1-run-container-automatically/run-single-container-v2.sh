#!/usr/bin/env bash
set -e

# 定义全局路径与变量
CONTAINER_DIR="/tmp/my-container"
ROOTFS="$CONTAINER_DIR/rootfs"
ALPINE_VER="3.19.1"
ARCH="aarch64"
TAR_BALL="alpine-minirootfs-${ALPINE_VER}-${ARCH}.tar.gz"
DOWNLOAD_URL="https://dl-cdn.alpinelinux.org/alpine/v3.19/releases/${ARCH}/${TAR_BALL}"

echo "==> 1. 创建容器根目录与 rootfs 路径..."
mkdir -p "$ROOTFS"
cd "$CONTAINER_DIR"

echo "==> 2. 下载 Alpine Rootfs 文件包..."
if [ ! -f "$TAR_BALL" ]; then
    wget "$DOWNLOAD_URL"
else
    echo "压缩包已存在，跳过下载。"
fi

echo "==> 3. 解压 Rootfs 到指定目录..."
tar -xvf "$TAR_BALL" -C "$ROOTFS" > /dev/null

echo "==> 4. 检查解压结果..."
if [ -f "$ROOTFS/bin/sh" ]; then
    echo "Rootfs 校验通过，busybox 信息如下："
    file "$ROOTFS/bin/busybox"
else
    echo "错误：Rootfs 解压失败，未找到 /bin/sh"
    exit 1
fi

echo "==> 5. 开启 Namespace 隔离并切入 rootfs 执行内部初始化..."
# 使用 sudo 执行 unshare + chroot，并直接运行内部初始化 Shell 命令
sudo unshare -m -u -i -p -n -f chroot "$ROOTFS" /bin/sh -c '
    # 1. 确保目录存在
    mkdir -p /proc /sys /tmp /dev /dev/shm

    # 2. 挂载容器内部的 proc/sys/tmpfs
    mount -t proc proc /proc
    mount -t sysfs none /sys
    mount -t tmpfs none /tmp

    # 3. 挂载设备节点与共享内存（支持 dd 和 /dev/zero, /dev/null, /dev/shm）
    mount -t devtmpfs devtmpfs /dev
    mount -t tmpfs none /dev/shm

    # 4. 设置容器独立的主机名
    hostname my-mini-container

    # 5. 验证隔离效果
    echo "--- [容器内验证] 当前进程列表 (ps aux): ---"
    ps aux

    echo "--- [容器内验证] 当前主机名 (hostname): ---"
    hostname

    echo "=========================================="
    echo "容器初始化完成，已进入交互式 Shell。输入 exit 可退出。"
    echo "=========================================="

    # 6. 用交互式 Shell 替换当前进程，保持留在容器内部
    exec /bin/sh
'

echo "==> 6. 容器已退出，宿主机环境恢复成功。"
