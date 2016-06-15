---
layout: post
title: SmokePing 部署实践
description: "SmokePing 部署实践"
category: Monitoring
avatarimg: 
tags: [Monitoring, Network, SmokePing, IDC]
duoshuo: true
---

# 1 通过 yum 安装依赖的库以及环境

```bash
yum install rrdtool wqy* fping curl bind-utils httpd httpd-devel \
perl perl-FCGI perl-CGI perl-CGI-SpeedyCGI perl-libwww-perl perl-Socket6 perl-Net-Telnet perl-Net-OpenSSH perl-Net-DNS perl-LDAP perl-IO-Socket-SSL perl-ExtUtils-MakeMaker rrdtool-perl perl-Sys-Syslog
```    

以下软件包现在的 EPEL 源中没有

```bash
No package echoping available.
No package perl-CGI-Fast available.
No package perl-Config-Grammar available.
No package perl-Authen-Radius available.
```    

# 2 编译安装 smokeping

```bash
cd /usr/local/src/ 
wget http://oss.oetiker.ch/smokeping/pub/smokeping-2.6.11.tar.gz
tar xvf smokeping-2.6.11.tar.gz 
cd smokeping-2.6.11
./setup/build-perl-modules.sh /usr/local/smokeping/thirdparty
./configure --prefix=/usr/local/smokeping
gmake install
```    

# 3 配置 smokeping 相关文件目录

```bash
cd /usr/local/smokeping/
mkdir cache data var
touch /var/log/smokeping.log
chown apache.apache cache/ data/ var/ /var/log/smokeping.log
cd /usr/local/smokeping/htdocs/
cp smokeping.fcgi.dist smokeping.fcgi
cp /usr/local/smokeping/etc/config.dist /usr/local/smokeping/etc/config
vim /usr/local/smokeping/etc/config

# 修改 /usr/local/smokeping/etc/config 文件

# 修改 cgiurl
sed -i 's#some.url#192.168.56.11#' /usr/local/smokeping/etc/config

# 默认检测时间 300 秒修改 60 秒
sed -i 's#300#60#g' /usr/local/smokeping/etc/config        

# 默认 60 秒 ping 20 次，修改为 60 秒 ping 60 次
sed -i 's#pings    = 20#pings    = 60#' /usr/local/smokeping/etc/config

# 在 presentation 后添加 utf-8 中文字符集
vim /usr/local/smokeping/etc/config               

*** Presentation ***

charset = utf-8

# 修改密码文件权限
chmod 600 /usr/local/smokeping/etc/smokeping_secrets.dist
```    

# 4 配置 apache

## 4.1 设置登录密码认证
htpasswd -c /usr/local/smokeping/htdocs/htpasswd jamin

## 4.2 修改 apache 配置文件，配置 smokeping 站点目录 

```bash
vim /etc/httpd/conf/httpd.conf
DocumentRoot "/var/www/html" 下添加如下内容

Alias /cache "/usr/local/smokeping/cache/"
Alias /cropper "/usr/local/smokeping/htdocs/cropper/"
Alias /smokeping "/usr/local/smokeping/htdocs/smokeping.fcgi"

<Directory "/usr/local/smokeping">
    AllowOverride None
    Options All
    AddHandler cgi-script .fcgi .cgi
    Order allow,deny
    Allow from all
    AuthName "Smokeping"
    AuthType Basic
    AuthUserFile /usr/local/smokeping/htdocs/htpasswd
    Require valid-user
    DirectoryIndex smokeping.fcgi
</Directory>
```        

# 5 设置 smokeping 启动脚本

CentOS 7 暂定

# 6 启动服务以及访问 smokeping

> 
systemctl start httpd  
/usr/local/smokeping/bin/smokeping  

访问 URL:  
http://192.168.56.11/smokeping



# 7 smokeping 使用

## 7.1 添加需要监控的节点

注意事项：

1 在 /usr/local/smokeping/etc/config 中添加  
2 smokeping 就这点不好，添加节点不能在前台 Web 页面添加，一定要在后台的配置文件中添加  
3 修改 /usr/local/smokeping/etc/config 后，必须重启 smokeping 程序，配置才会生效    
4 smokeping 会根据配置文件 config 在 /usr/local/smokeping/data 之下添加文件夹及子文件夹  
5 用 VMware Workstation 的虚拟机测试有一点好处，虚拟网卡可以设置出入的丢包率，适合 smokeping 做丢包测试，经过测试 smokeping 检测出的丢包率与 VMware Workstation 虚拟网卡设置的丢包率基本相同，也就是说 smokeping 能够反应网络的真实状况  

添加监控节点示例：注意 + 是第一层，++ 是第二层，+++ 是第三层

以下附上一份三大运营商网络监控样例配置（在 /usr/local/smokeping/etc/config 最后添加）：  

```bash
+ Other
menu = 三大网络监控
title = 监控统计

++ CT

menu = 电信网络监控
title = 电信网络监控列表
host = /Other/CT/CT-BJ /Other/CT/CT-TJ /Other/CT/CT-HLJ /Other/CT/CT-SH /Other/CT/CT-SC /Other/CT/CT-GZ

+++ CT-BJ

menu = 北京电信
title = 北京电信
alerts = someloss
host = 202.96.199.133

+++ CT-TJ

menu = 天津电信
title = 天津电信
alerts = someloss
host = 219.150.32.132

+++ CT-HLJ

menu = 黑龙江电信
title = 黑龙江电信
alerts = someloss
host = 219.147.198.242

+++ CT-SH

menu = 上海电信
title = 上海电信
alerts = someloss
host = 116.228.111.118

+++ CT-SC

menu = 四川电信
title = 四川电信
alerts = someloss
host = 61.139.2.69

+++ CT-GZ

menu = 广东电信
title = 广东电信
alerts = someloss
host = 113.111.211.22
 

++ CU

menu = 联通网络监控
title = 联通网络监控列表
host = /Other/CU/CU-BJ /Other/CU/CU-TJ /Other/CU/CU-HLJ /Other/CU/CU-SH /Other/CU/CU-SC /Other/CU/CU-GZ

+++ CU-BJ

menu = 北京联通
title = 北京联通
alerts = someloss
host = 61.135.169.121

+++ CU-TJ

menu = 天津联通
title = 天津联通
alerts = someloss
host = 202.99.96.68

+++ CU-HLJ

menu = 黑龙江联通
title = 黑龙江联通
alerts = someloss
host = 202.97.224.69

+++ CU-SH

menu = 上海联通
title = 上海联通
alerts = someloss
host = 210.22.84.3


+++ CU-SC

menu = 四川联通
title = 四川联通
alerts = someloss
host = 119.6.6.6

+++ CU-GZ

menu = 广东联通
title = 广东联通
alerts = someloss
host = 221.5.88.88

 

++ CMCC

menu = 移动网络监控
title = 移动网络监控列表
host = /Other/CMCC/CMCC-BJ /Other/CMCC/CMCC-TJ /Other/CMCC/CMCC-HLJ /Other/CMCC/CMCC-SH /Other/CMCC/CMCC-SC /Other/CMCC/CMCC-GZ

+++ CMCC-BJ

menu = 北京移动
title = 北京移动
alerts = someloss
host = 221.130.33.52

+++ CMCC-TJ

menu = 天津移动
title = 天津移动
alerts = someloss
host = 211.137.160.5 

+++ CMCC-HLJ

menu = 黑龙江移动
title = 黑龙江移动
alerts = someloss
host = 211.137.241.35
 
+++ CMCC-SH

menu = 上海移动
title = 上海移动
alerts = someloss
host = 117.131.19.23

+++ CMCC-SC

menu = 四川移动
title = 四川移动
alerts = someloss
host = 218.201.4.3

+++ CMCC-GZ

menu = 广东移动
title = 广东移动
alerts = someloss
host = 211.136.192.6
```    

出图效果截图如下：  
![SmokePing](https://raw.githubusercontent.com/JaminZhang/jaminzhang.github.io/master/images/SmokePing-01.png)  

# 报错

## 报错 1

```bash
[root@linux-node1 smokeping-2.6.11]# ./setup/build-perl-modules.sh /usr/local/smokeping/thirdparty
Building in /usr/local/smokeping/thirdparty
--> Working on FCGI
Fetching http://www.cpan.org/authors/id/E/ET/ETHER/FCGI-0.78.tar.gz ... OK
==> Found dependencies: ExtUtils::MakeMaker
--> Working on ExtUtils::MakeMaker
Fetching http://www.cpan.org/authors/id/B/BI/BINGOS/ExtUtils-MakeMaker-7.18.tar.gz ... OK
Configuring ExtUtils-MakeMaker-7.18 ... OK
Can't locate ExtUtils/Manifest.pm in @INC (@INC contains: FatPacked::35736456=HASH(0x2214b88) /usr/local/smokeping/thirdparty/lib/perl5 /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at /usr/local/smokeping/thirdparty/bin/cpanm line 132.
```    

解决方法：

> 
yum install perl-ExtUtils-MakeMaker

## 报错 2

```bash
checking checking for perl module 'RRDs'... Can't locate RRDs.pm in @INC (@INC contains: /usr/local/smokeping/thirdparty/lib/perl5/x86_64-linux-thread-multi /usr/local/smokeping/thirdparty/lib/perl5 /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at -e line 1.
BEGIN failed--compilation aborted at -e line 1.
Failed
```    

解决方法：

> 
yum search all perl | grep "rrd"  
yum install rrdtool-perl  

## 报错 3

```bash
Can't locate Sys/Syslog.pm in @INC (@INC contains: /usr/local/smokeping/thirdparty/lib/perl5/x86_64-linux-thread-multi /usr/local/smokeping/thirdparty/lib/perl5 ../lib /usr/local/lib64/perl5 /usr/local/share/perl5 /usr/lib64/perl5/vendor_perl /usr/share/perl5/vendor_perl /usr/lib64/perl5 /usr/share/perl5 .) at ../lib/Smokeping.pm line 16.
BEGIN failed--compilation aborted at ../lib/Smokeping.pm line 16.
Compilation failed in require.
BEGIN failed--compilation aborted.
gmake[1]: *** [Smokeping_probes_EchoPingSmtp.pod] Error 2
rm Smokeping_probes_EchoPingSmtp.pod
gmake[1]: Leaving directory `/usr/local/src/smokeping-2.6.11/doc'
gmake: *** [install-recursive] Error 1
```    

解决方法：

> 
[root@linux-node1 ~]# yum search all perl | grep -i "syslog"  
perl-Unix-Syslog.x86_64 : Perl interface to the UNIX syslog(3) calls  
perl-Sys-Syslog.x86_64 : Perl interface to the UNIX syslog(3) calls  
yum install perl-Sys-Syslog  

## 报错 4

ERROR: /usr/local/smokeping/bin/../etc/config, line 153: unknown section 'China Telecom'

解决方法：  

> 
根据 host /Other/CT/CT-BJ，  
++ China Telecom 应该修改成 ++ CT  


## 报错 5
不显示中文  
安装中文字体  
yum install wqy*


# Ref
[smokeping_install](http://oss.oetiker.ch/smokeping/doc/smokeping_install.en.html)  
[smokeping安装部署最佳实践](http://www.xuliangwei.com/xubusi/507.html)  

