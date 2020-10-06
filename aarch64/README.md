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

1.6版更新内容：同步到官方0.5.0版本，支持内置拨号等功能。

----------------------------------------------------------------------------------------------------------------------

更多详情及下载地址，请参考：

我家云/粒子云：https://bonuscloud.club/viewtopic.php?f=54&t=13468

N1： https://bonuscloud.club/viewtopic.php?f=48&t=13457&p=42192#p42192
