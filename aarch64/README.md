# BonusCloud Image for ARMv8

This image supports N1 and our cloud/particle cloud, and supports multiple data disks.

After installation, execute `bash hdd-arm.sh` on SSH to add the data disk.

This image is not pre-installed with smartmontools

----------------------------------------------------------------------------------------------------------------------

此镜像支持N1和我家云/粒子云，且支持多个数据盘。

安装后在SSH执行`bash hdd-arm.sh`来添加数据盘

PS：多盘支持目前处于测试阶段

----------------------------------------------------------------------------------------------------------------------

1.1版更新内容：修复了我家云未使用内置接口时添加磁盘错误的问题，优化了添加磁盘脚本的逻辑

1.2版更新内容：针对多盘版创建数据盘的脚本进行更新，在硬盘存在VG卷时询问是否需要格式化硬盘。同时修改了逻辑避免在特定环境下磁盘被意外跳过。

----------------------------------------------------------------------------------------------------------------------

下载地址：


我家云/粒子云：

https://cloud.189.cn/t/NnAvQbYFzQNr （访问码：eir8）

https://github.com/404404/BonusCloud-Image/releases/download/v1.2-arm/armbian_wjy_Debian_stretch_dual_1.2.tar.xz


N1： 

https://cloud.189.cn/t/yQRBf2eEzUzq （访问码：p1ma）

https://github.com/404404/BonusCloud-Image/releases/download/v1.2-arm/armbian_n1_Debian_stretch_dual_1.2.img.xz
