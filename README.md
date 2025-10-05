# 项目简介
本固件适配斐讯 N1 旁路由模式，共有两个版本固件（详见下面的一、二），集成自己需要的一些插件，追求精简纯净!<br>
<br>
一、本云编译基于 LEAN 源码编译而成的固件。<br>
1、对L大固件默认勾选的部分插件做了精简！<br>
2、自编译脚本吸取各个大佬的精华，重点解决了action编译硬盘不够导致编译失败。<br>
3、配置文件很精简，自己要什么增减就行。但N1编译必须的Basic Dependence不要精简！<br>
4、目前配置第一次编译约2.5小时左右，第二次编译使用缓存可以节省个把小时。<br>
5、ipv6完整支持！<br>
6、为了拥有自己的定制固件，不停修改测试等待了N多个的编译周期，如果对你有帮助，欢迎fork！<br>
7、集成晶晨宝盒，可直接在线升级openwrt版本，默认配置的是我的项目地址！<br>
8、内核是5.15.148，很稳定，不建议升级。有部分用户反馈5.15.160以上的内核科学有问题！<br>
<br>
二、本云编译基于 ImmortalWrt-23.05 源码编译而成的固件。<br>
1、追求轻量（不具备 PPPoE功能）。<br>
2、固件包含默认皮肤、完整 IPv6 支持。<br>
<br>
# 使用方法
基本流程如下：<br>
1、fork我的项目。<br>
2、根据需求修改.github/workflows目录下的YAML配置文件，选择您想要的编译配置。<br>
3、修改N1/CONIG文件增减你要的插件。<br>
4、点击action页面，选择Build OpenWRT-LEAN for N1，点击run workflow开始编译。<br>
5、编译完成后到自己项目的releases下载即可。<br>
# 个性化修改
1、修改.github/workflows目录下的YAML配置文件。<br>
2、修改.config增减需要的插件。<br>
3、修改diy.sh相关插件源。<br>
4、添加Samba自启动文件（20-smb、30-smb）。<br>
5、集成你需要的软件。<br>
# 致谢
代码使用LEAN大的[项目](https://github.com/coolsnowwolf/lede) 和天灵的项目 [ImmortalWrt-23.05](https://github.com/immortalwrt/immortalwrt/tree/openwrt-23.05) 源码编译。 <br>
使用 flippy 的[脚本](https://github.com/unifreq/openwrt_packit)和 breakings 维护的[内核](https://github.com/breakings/OpenWrt/releases/tag/kernel_stable)打包成完整固件，感谢开发者们的无私分享。<br>
flippy 固件的更多细节参考[恩山论坛帖子](https://www.right.com.cn/forum/thread-4076037-1-1.html)。
