Linux中的TCP端口

# 引言
CentOS系统下某个业务进程需要监听843端口，但该业务进程是用普通用户运行。此进程可以运行起来，但是通过netstat命令查看到这个进程并没有在843端口监听。为什么呢？


# TCP端口范围规范

> 
The first 1000 ports are reserved for specific applications, and on Linux can normally own be used by a daemon / application that has super user privileges. These are referred to as well known ports. Some are defined in RFC 1340, and more are defined by IANA.

> 
# The latest IANA port assignments can be gotten from
#       http://www.iana.org/assignments/port-numbers
# The Well Known Ports are those from 0 through 1023.
# The Registered Ports are those from 1024 through 49151
# The Dynamic and/or Private Ports are those from 49152 through 65535


从上面可以规范可以看出来，在Linux下1024以下的端口只能被超级用户权限的进程使用。即普通用户运行的进程是不能使用这个843这个端口。

那么如何让普通用户使用1024以下的端口？
