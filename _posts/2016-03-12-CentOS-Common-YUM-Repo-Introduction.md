---
layout: post
title: CentOS 常见 YUM 源简介
description: "CentOS 常见 YUM 源简介"
category: Linux
avatarimg:
tags: [CentOS, YUM, EPEL, REMI, RPMForge]
duoshuo: true
---

# 引言
我们生产一般都是使用 yum 安装各种相关软件包，但自带的源中的软件一般有很多并不是最新的稳定版，  
还有一些软件包并没有。这时我们会使用一些第三方质量较高的软件源，比如 EPEL/REMI 等等。

# EPEL 源

<pre>
What is Extra Packages for Enterprise Linux (or EPEL)?

Extra Packages for Enterprise Linux (or EPEL) is a Fedora Special Interest Group that creates, maintains, 
and manages a high quality set of additional packages for Enterprise Linux, including, but not limited to, 
Red Hat Enterprise Linux (RHEL), CentOS and Scientific Linux (SL), Oracle Linux (OL).
EPEL packages are usually based on their Fedora counterparts and will never conflict with or 
replace packages in the base Enterprise Linux distributions. 
EPEL uses much of the same infrastructure as Fedora, including buildsystem, bugzilla instance, updates manager, 
mirror manager and more.

EPEL, 即 Extra Packages for Enterprise Linux,是由 Fedora 社区创建维护，
为 RHEL 及衍生发行版如 CentOS、Scientific Linux 等提供高质量软件包的项目。
EPEL 中含有大量的软件，对官方标准源是一个很好的补充。
</pre>

国内用户推荐添加使用[阿里云的 EPEL 源](http://mirrors.aliyun.com/epel/)。


# REMI 源

<pre>

REMI 源大家或许很少听说，不过 REMI 源 GoFace 强烈推荐，尤其对于不想编译最新版的 Linux 使用者，
因为 REMI 源中的软件几乎都是最新稳定版。
或许您会怀疑稳定不？放心吧，这些都是 Linux 骨灰级的玩家编译好放进源里的，他们对于系统环境和软件编译参数的熟悉程度毋庸置疑。

注意：安装 REMI 库不要在启用了 REMI 库时运行 yum update。
因为 REMI 库的包名与 RHEL/CentOS 默认库中的相同，运行 yum update 可能会触发意外的更新。
平时禁用 REMI 库，在你需要安装 RMEI 库中独有的包时再启用。
安装 REMI 库之前，首先需要启用 EPEL 库，因为 REMI 中的一些包依赖于EPEL。

</pre>


# RPMForge 源

<pre>
RPMForge 是 CentOS 系统下的软件仓库，拥有 4000 多种的软件包，被 CentOS 社区认为是最安全也是最稳定的一个软件仓库。
</pre>

[RPMForge 官方网站](http://repoforge.org/)  

# Ref
[RHEL/CentOS/Fedora各种源(EPEL、Remi、RPMForge、RPMFusion)配置](http://www.cnblogs.com/mawanglin2008/p/3532247.html)  
[RHEL/CentOS/OracleLinux 7.x使用EPEL和REMI第三方yum源](http://www.ha97.com/5649.html)  
[EPEL wiki](http://fedoraproject.org/wiki/EPEL)  
[Remi's RPM repository](http://rpms.famillecollet.com/)  
