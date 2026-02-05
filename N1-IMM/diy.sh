#!/bin/bash

# 移除要替换的包
rm -rf feeds/packages/net/v2ray-geodata

# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Add packages
# 添加自定义的软件包源
#git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git clone https://github.com/sbwml/v2ray-geodata package/v2ray-geodata
git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-adguardhome
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git clone --depth=1 https://github.com/sbwml/luci-app-mosdns package/luci-app-mosdns
git clone --depth=1 https://github.com/sbwml/luci-app-alist package/luci-app-alist
git clone --depth=1 https://github.com/DustReliant/luci-app-filetransfer package/luci-app-filetransfer
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-fileassistant
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages ddns-go
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-ddns-go

# 添加自定的科学上网源
git clone --depth=1 https://github.com/fw876/helloworld package/helloworld

# 修改默认IP、默认主机名、默认时区
sed -i 's/192.168.1.1/192.168.1.254/g' package/base-files/files/bin/config_generate
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
sed -i 's/UTC/Asia\/Shanghai/g' package/base-files/files/bin/config_generate

# 修改默认主题
sed -i 's/luci-theme-design/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 调整 zerotier 到 服务 菜单
sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/root/usr/share/luci/menu.d/luci-app-zerotier.json

# 添加 OpenClash Meta 内核
mkdir -p files/etc/openclash/core
wget -qO "clash_meta.tar.gz" "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
tar -zxvf "clash_meta.tar.gz" -C files/etc/openclash/core/
mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta
rm -f "clash_meta.tar.gz"

