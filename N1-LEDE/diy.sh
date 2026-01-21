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
# 添加自定义的软件包源
git clone --depth=1 https://github.com/kenzok8/openwrt-packages package/openwrt-packages
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
#git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
git clone -b lua --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/alist
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky

# 添加科学上网源
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone --depth=1 https://github.com/kenzok8/small package/small

# Remove packages
# 删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns

# 修改默认IP、默认主机名、默认时区
sed -i 's/192.168.1.1/192.168.2.254/g' package/base-files/files/bin/config_generate
sed -i 's/LEDE/OPForN1/g' package/base-files/files/bin/config_generate
sed -i 's/UTC/Asia\/Shanghai/g' package/base-files/files/bin/config_generate

# coremark跑分定时清除
sed -i '/\* \* \* \/etc\/coremark.sh/d' feeds/packages/utils/coremark/*

# 修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")

# 调整 zerotier 到 服务 菜单
sed -i '/"VPN"/d' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/luasrc/controller/zerotier.lua
sed -i 's/vpn/services/g' feeds/luci/applications/luci-app-zerotier/luasrc/view/zerotier/zerotier_status.htm

# 修改默认主题为argone
sed -i 's/bootstrap/argone/g' feeds/luci/collections/luci/Makefile
sed -i 's/bootstrap/argone/g' feeds/luci/collections/luci-ssl-nginx/Makefile
sed -i 's/bootstrap/argone/g' feeds/luci/collections/luci-nginx/Makefile

# #添加旁路由的防火墙规则
sed -i "\$i echo 'iptables -t nat -I POSTROUTING -o eth0 -j MASQUERADE' >> /etc/firewall.user\n" ./package/lean/default-settings/files/zzz-default-settings

# 添加 OpenClash Meta 内核
mkdir -p files/etc/openclash/core
wget -qO "clash_meta.tar.gz" "https://raw.githubusercontent.com/vernesong/OpenClash/core/master/meta/clash-linux-arm64.tar.gz"
tar -zxvf "clash_meta.tar.gz" -C files/etc/openclash/core/
mv files/etc/openclash/core/clash files/etc/openclash/core/clash_meta
chmod +x files/etc/openclash/core/clash_meta
rm -f "clash_meta.tar.gz"
