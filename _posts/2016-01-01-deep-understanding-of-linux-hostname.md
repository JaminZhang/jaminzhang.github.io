---
layout: post
title: 深入理解Linux hostname
description: "深入理解Linux hostname"
category: Linux
avatarimg:
tags: [Linux, hostname]
duoshuo: true
---

# 引言
问大家怎么修改Linux的主机名时？  
大家一般都会知道使用hostname来进行临时修改，而在永久修改则要在/etc/sysconfig/network中进行HOSTNAME的修改，然后重启才能生效（此为CentOS 6.X系统下）。
上面的回答确实没错，我们知其然了，但我这几天突然多想了下，为什么会是这样？大概搜索了一些资料，其所以然并不简单。 

# 1.1 hostname命令临时修改主机名
通过man hostname我们看到：
> 
When called without any arguments, the program displays the current names: 
hostname will print the name of the system as returned by the gethostname(2) function. 

意思是当我们执行hostname命令时，它会打印出系统主机名，而这个系统主机名是系统的gethostname(2)函数返回的。
这个临时修改实际上是修改了Linux Kernel中一个同为hostname的内核参数。
> 
hostname是Linux系统下的一个内核参数，它保存在/proc/sys/kernel/hostname下，但是它的值是Linux启动时从rc.sysinit读取的。
hostname is a kernel parameter which stores hostname of the system. Its location is"/proc/sys/kernel/hostname"
The value for this parameter is loaded to kernel by rc.sysinit file during the boot process.

# 1.2 /ect/sysconfig/network配置文件永久修改主机名
注：CentOS 6.X系统环境下验证
为什么永久修改主机名要修改/ect/sysconfig/network的HOSTNAME参数? 
因为Linux CentOS系统在启动时执行/etc/rc.d/rc.sysinit脚本，它首先读取/ect/sysconfig/network中HOSTNAME参数，然后将系统主机名配置成获取的HOSTNAME。
脚本中相关代码如下： 
<pre>
if [ -f /etc/sysconfig/network ]; then
    . /etc/sysconfig/network
fi
if [ -z "$HOSTNAME" -o "$HOSTNAME" = "(none)" ]; then
    HOSTNAME=localhost
fi
</pre>

结论：/etc/sysconfig/network 确实是hostname的配置文件，hostname的值跟该配置文件中的HOSTNAME有一定的关联关系，但是没有必然关系，hostname的值来自内核参数/proc/sys/kernel/hostname，如果我通过命令sysctl kernel.hostname=Test修改了内核参数，那么hostname就变为了Test了。

# 1.3 hostname与/etc/hosts的关系
一般来说hostname并不是从/etc/hosts中获取的，在1.2中说的从/ect/sysconfig/network中获取的，但是在/etc/rc.d/rc.sysinit中，有如下逻辑判断，当hostname为localhost后localhost.localdomain时，将会使用接口IP地址对应的hostname来重新设置系统的hostname。
<pre>
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
</pre>
上面代码的意思就是如果从/ect/sysconfig/network中获取的HOSTNAME为localhost后localhost.localdomain时，就会获取接口的IP地址，根据这个IP地址在查找/etc/hosts文件对应的主机名（ipcalc命令的作用），然后将其设置为最终的hostname。


# 总结
任何概念或操作不仅仅要知其然，要深入理解，就得知其所以然。简单的事情深入理解下去往往并不简单。 

# Ref
[深入理解Linux修改hostname](http://www.cnblogs.com/kerrycode/p/3595724.html)  
[如何在CentOS或RHEL 7上修改主机名](https://linux.cn/article-3937-1.html)


