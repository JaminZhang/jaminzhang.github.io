---
layout: post
title: 深入理解 Linux hostname
description: "深入理解 Linux hostname"
category: Linux
avatarimg:
tags: [Linux, hostname]
duoshuo: true
---

# 引言

问大家怎么修改 Linux 的主机名时？  
大家一般都会知道使用 hostname 来进行临时修改，  
而在永久修改则要在`/etc/sysconfig/network`中进行 HOSTNAME 的修改，然后重启才能生效（此为 CentOS 6.X 系统下）。
上面的回答确实没错，我们知其然了，但我这几天突然多想了下，为什么会是这样？大概搜索了一些资料，其所以然并不简单。 

# 1.1 hostname 命令临时修改主机名

通过`man hostname`我们看到：

<pre>

When called without any arguments, the program displays the current names: 
hostname will print the name of the system as returned by the gethostname(2) function. 

</pre>

意思是当我们执行 hostname 命令时，它会打印出系统主机名，而这个系统主机名是系统的`gethostname(2)`函数返回的。
这个临时修改实际上是修改了 Linux Kernel 中一个同为 hostname 的内核参数。
hostname 是 Linux 系统的一个内核参数，它保存在`/proc/sys/kernel/hostname`下，它的值是 Linux 启动时从 rc.sysinit 读取的。

<pre>

hostname is a kernel parameter which stores hostname of the system. Its location is"/proc/sys/kernel/hostname"
The value for this parameter is loaded to kernel by rc.sysinit file during the boot process.

</pre>


# 1.2 /etc/sysconfig/network 配置文件永久修改主机名

注：CentOS 6.X 系统环境下验证  
为什么永久修改主机名要修改`/etc/sysconfig/network`的 HOSTNAME 参数? 
因为 CentOS 系统在启动时执行`/etc/rc.d/rc.sysinit`脚本，  
它首先读取`/etc/sysconfig/network`中 HOSTNAME 参数，然后将系统主机名配置成获取的 HOSTNAME。
脚本中相关代码如下： 

```bash

if [ -f /etc/sysconfig/network ]; then
    . /etc/sysconfig/network
fi
if [ -z "$HOSTNAME" -o "$HOSTNAME" = "(none)" ]; then
    HOSTNAME=localhost
fi

```   

结论：  
`/etc/sysconfig/network` 确实是 hostname 的配置文件，hostname 的值跟该配置文件中的 HOSTNAME 有一定的关联关系，
但是没有必然关系，hostname 的值来自内核参数`/proc/sys/kernel/hostname`，  
如果我通过命令`sysctl kernel.hostname=Test`修改了内核参数，那么 hostname 就变为了 Test 了。

# 1.3 hostname 与 /etc/hosts 的关系

一般来说 hostname 并不是从`/etc/hosts`中获取的，在 1.2 中说的从`/ect/sysconfig/network`中获取的，  
但是在`/etc/rc.d/rc.sysinit`中，有如下逻辑判断，
当 hostname 为 localhost 或 localhost.localdomain 时，将会使用接口 IP 地址对应的 hostname 来重新设置系统的 hostname。

```bash
\# In theory there should be no more than one network interface active
\# this early in the boot process -- the one we're booting from.
\# Use the network address to set the hostname of the client.  This
\# must be done even if we have local storage.
ipaddr=
if [ "$HOSTNAME" = "localhost" -o "$HOSTNAME" = "localhost.localdomain" ]; then
        ipaddr=$(ip addr show to 0.0.0.0/0 scope global | awk '/[[:space:]]inet / { print gensub("/.*","","g",$2) }')
        for ip in $ipaddr ; do
                HOSTNAME=
                eval $(ipcalc -h $ip 2>/dev/null)
                [ -n "$HOSTNAME" ] && { hostname ${HOSTNAME} ; break; }
        done
fi
```    

上面代码的意思就是如果从`/ect/sysconfig/network`中获取的 HOSTNAME 为 localhost 或 localhost.localdomain 时，
就会获取接口的 IP 地址，根据这个 IP 地址在查找 /etc/hosts 文件对应的主机名（ipcalc 命令的作用），然后将其设置为最终的 hostname。


# 总结

任何概念或操作不仅仅要知其然，要深入理解，就得知其所以然。简单的事情深入理解下去往往并不简单。 

# Ref
[深入理解 Linux 修改 hostname](http://www.cnblogs.com/kerrycode/p/3595724.html)  
[如何在 CentOS 或 RHEL 7上修改主机名](https://linux.cn/article-3937-1.html)


