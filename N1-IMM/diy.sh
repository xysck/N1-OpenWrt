#!/bin/bash

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
#git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
#git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-aliddns
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-pushbot
#git_sparse_clone master https://github.com/kiddin9/openwrt-packages luci-app-turboacc
git_sparse_clone master https://github.com/kiddin9/kwrt-packages luci-app-adguardhome
git_sparse_clone master https://github.com/kiddin9/kwrt-packages luci-app-aliddns
git_sparse_clone master https://github.com/kiddin9/kwrt-packages luci-app-amlogic
git clone https://github.com/sbwml/luci-app-mosdns -b v5 package/mosdns
git_sparse_clone master https://github.com/kiddin9/kwrt-packages luci-app-ssr-plus
git_sparse_clone master https://github.com/kiddin9/kwrt-packages luci-app-store

# 加入OpenClash核心
#chmod -R a+x $GITHUB_WORKSPACE/preset-clash-core.sh
#$GITHUB_WORKSPACE/N1/preset-clash-core.sh

# 修改默认IP
sed -i 's/192.168.1.1/192.168.1.254/g' package/base-files/files/bin/config_generate

# 修改默认主题
sed -i 's/luci-theme-design/luci-theme-argon/g' feeds/luci/collections/luci/Makefile
sed -i 's/luci-theme-bootstrap/luci-theme-argon/g' feeds/luci/collections/luci/Makefile

# 修改主机名
sed -i 's/ImmortalWrt/OpenWrt/g' package/base-files/files/bin/config_generate
