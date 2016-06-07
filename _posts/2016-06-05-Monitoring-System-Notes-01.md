---
layout: post
title: 运维监控体系学习笔记-01
description: "运维监控体系学习笔记-01"
category: Automated Ops
avatarimg:
tags: [Linux, Monitoring]
duoshuo: true
---

# 1 监控概述
监控是一个体系，而不是特指使用某一款软件。  
监控是运维最重要的工作。（有人说占到 70%，有人说占到 30%。）

## 1.1 监控对象

1. 监控对象的理解：比如：CPU 是怎么工作的，原理
2. 监控对象的指标：比如：CPU 使用率、负载、个数、上下文切换
3. 确实性能基准线：怎样才算故障？CPU 负载多少才高？
	
## 1.2 监控范围

1. 硬件监控
  * 服务器的硬件监控
2. 操作系统监控
  * CPU 
  * 内存 
  * IO 
  * 进程
3. 应用服务监控
4. 业务监控
  * 了解业务。  
  举例：小型电商网站，BOSS 可能问运维负责人今天的订单量，这个时候运维负责人必须要知道订单量数据从哪里获得。
大型公司可能有专门的 BI 团队负责这个。
    

# 2 硬件监控

## 2.1 远程控制卡
* DELL 服务器：iDRAC
* HP 服务器：ILO
* IBM 服务器：IMM
    
## 2.2 IPMI

Linux 可以使用 IPMI 和 BMC 控制器通信，监控和控制硬件设备。  
    
ipmitool

  1. 硬件要支持
  2. 操作系统要支持  Linux IPMI
  3. 管理工具 ipmitool
    
```bash
安装：
yum install OpenIPMI ipmitool -y
lsmod | grep ipmi
启动：
systemctl start ipmi

ipmitool --help
```    

使用 IPMI 有两种方式：

  1. 本地调用 
  2. 远程调用 （IP 地址 用户名 密码）

IPMI 配置网络，有两种方式：

  1. ipmi over LAN
  2. 独立  (DELL 服务器前面板配置)

## 2.3 路由器和交换机：SNMP 监控

### 2.3.1 安装配置 snmp

```bash
1. 安装 snmp 相关包组：
yum list | grep snmp
yum install net-snmp net-snmp-utils -y

2. 配置 snmpd.conf
[root@linux-node1 ~]# cat /etc/snmp/snmpd.conf
rocommunity	jaminzhang	127.0.0.1
rocommunity	jaminzhang	192.168.56.11

3. 启动 snmpd
[root@linux-node1 ~]# systemctl start snmpd
[root@linux-node1 ~]# netstat -lntup | grep snmp
tcp        0      0 127.0.0.1:199           0.0.0.0:*               LISTEN      28604/snmpd         
udp        0      0 0.0.0.0:161             0.0.0.0:*                           28604/snmpd  

4. 测试 snmp 获取数据
[root@linux-node1 ~]# snmpget -v2c -c jaminzhang 192.168.56.11 1.3.6.1.2.1.1.3.0
DISMAN-EVENT-MIB::sysUpTimeInstance = Timeticks: (11110) 0:01:51.10
[root@linux-node1 ~]# snmpget -v2c -c jaminzhang 192.168.56.11 1.3.6.1.4.1.2021.10.1.3.1
UCD-SNMP-MIB::laLoad.1 = STRING: 0.00
[root@linux-node1 ~]# snmpwalk -v2c -c jaminzhang 192.168.56.11 1.3.6.1.4.1.2021.10.1.3
UCD-SNMP-MIB::laLoad.1 = STRING: 0.15
UCD-SNMP-MIB::laLoad.2 = STRING: 0.07
UCD-SNMP-MIB::laLoad.3 = STRING: 0.06
```    

### 2.3.2 SNMP 协议概念及参考资料

Management information base (MIB)  
Object identifier (OID)  

SNMP protocol data unit (PDU) types:

  * GetRequest
  * SetRequest
  * GetNextRequest
  * GetBulkRequest
  * Response
  * Trap
  * InformRequest


**SNMP 相关参考资料**  
[Simple Network Management Protocol](https://en.wikipedia.org/wiki/Simple_Network_Management_Protocol)  
[SNMP PDU](http://net-snmp.sourceforge.net/wiki/index.php/TUT:SNMP)  
[《Zabbix企业级分布式监控系统》7.5 SNMP 监控方式](https://book.douban.com/subject/25957954/)  
[SNMP 常用 OID](http://linux.chinaunix.net/techdoc/net/2008/08/21/1026818.shtml)  
[浅谈 Linux 系统中的 SNMP Trap](http://www.ibm.com/developerworks/cn/linux/l-cn-snmp/index.html)  
[配置 snmp](http://www.jiankongbao.com/search/snmp)  

	
## 2.4 硬件监控方式
1. 使用 IPMI
2. 使用 SNMP 
2. 机房巡检
    
# 3 系统监控
* CPU
* 内存
* IO（磁盘、网络）

## 3.1 CPU

CPU 三个重要的概念：

  * 上下文切换：CPU 调度器实施的进程的切换过程/CPU 调度器分配时间片
  * 运行队列（负载）
  * 使用率：us sy ni id wa hi si st(虚拟化相关)

[我是一个线程(修订版)](http://mp.weixin.qq.com/s?__biz=MjM5ODI5Njc2MA==&mid=2655807248&idx=1&sn=eebbf2f2ad14a0573f5b09792017f2ea&scene=23&srcid=0507aCbp5SqhnkddJNEtOOO5#rd)  

> 
进程切换也叫上下文切换，contextswitch假如当前进程a的从cpu上被拿走，切换成进程B,那么A的进程描述符要被挂起，意味着它的栈指针、其他寄存器、指令计数器等等在cpu内部维持的信息，
要保存到进程描述符中，这个过程叫保存现场【Suspend】。而进程描述符是由内核维持的。所以这些信息都保存在内核中。描述符文件大小都是固定的。
把B进程的栈指针、其他寄存器、指令计数器等信息以及跟当前进程本身运行所独有的数据从内核读取出而且都必须要装载到cpu里面，
总之B进程调进来的过程叫做恢复现场【Resume】。进程间切换由内核来完成。所以整个过程就是不断的从用户空间转换到内核空间，在转换到用户空间等等所以cpu时间是由用户时间和内核时间共同组成。
	
 
确定服务类型：

  * IO 密集型  比如：数据库
  * CPU 密集型 比如：Web/Mail
    
确定性能基准线：

  * 运行队列：1 核心 1-3个线程，比如：1 CPU 4 核心，负载不超过 12（经验值）
  * CPU 使用率：
    - 65%-70% 用户态利用率
    - 0%-35% 内核态利用率
    - 0%-5%   空闲
  * 上下文切换：基于 CPU 使用率和历史数据来判断
    
监控工具：

  * top   复习 CPU/内存使用率排序 （P/M）
  * sysstat	rpm -ql sysstat
    - vmstat
      - r b in cs 
    - mpstat 
    

## 3.2 内存
    
> 公有云云主机不设置 swap
    
内存页概念 默认大小为 4KB 

  1. 寻址
  2. 空间
    合并成连续内存 大页内存
        
监控工具：  

  * free
  * vmstat
    - swpd free buff cache si(swap->mem) so(mem->swap)

内存使用率、交换分区使用率  
	
>　
理论要结合工作实践反复复习：操作系统原理、TCP/IP、《性能之巅：洞悉系统、企业与云计算》
    
  
## 3.3 磁盘
块概念 
内存的脏页内容写到硬盘
    
IOPS  

  * 顺序 IO
  * 随机 IO
    
监控工具：

  * df
  * iotop
  * iostat
    - tps 
    
## 3.4 网络

监控工具：  

  * ping
  * iftop
  * 带宽
    
    
大厂商提供的在线网络测试工具：  

  * 奇云测 http://ce.cloud.360.cn/
  * 阿里测 http://alibench.com/
  * 站长工具 http://ping.chinaz.com/
    
应用举例：修改 DNS 后，使用以上工具确认 DNS 修改生效
    
## 3.5 Linux 系统监控和性能分析工具 nmon
	
该工具比较有用！用于生成系统性能测试数据，并可使用 nmon_analyser 生成对应图形报表。

[root@linux-node1 ~]# ./nmon16e_x86_rhel72 -f -s 5 -c 10 -f


[nmon performance: A free tool to analyze AIX and Linux performance](https://www.ibm.com/developerworks/aix/library/au-analyze_aix/)  
[nmon for Linux](http://nmon.sourceforge.net/pmwiki.php)  
[nmon_analyser](https://www.ibm.com/developerworks/community/wikis/home?lang=en#!/wiki/Power+Systems/page/nmon_analyser)  

# 4 应用服务监控

举例：通过 Nginx 的 http_stub_status_module 模块提供的状态信息来对 Nginx 服务进行监控。

```bash      
yum install gcc glibc gcc-c++ pcre-devel openssl-devel -y
  
wget https://nginx.org/download/nginx-1.10.1.tar.gz

useradd -s /sbin/nologin -M www
  
  
configure Shell 脚本 作用：产生 Makefile
	  
./configure --prefix=/usr/local/nginx-1.10.1 \
--user=www --group=www \
--with-http_ssl_module \
--with-http_stub_status_module
make && make install
     
ln -s /usr/local/nginx-1.10.1 /usr/local/nginx
nginx -t

vim nginx.conf
	  
location /nginx-status {
	stub_status on;
	access_log   off;
	allow 192.168.56.0/24;
	deny all;
}	
 
```    

# Ref
[中小企业监控体系构建实战](http://mp.weixin.qq.com/s?__biz=MzA4Nzg5Nzc5OA==&mid=400138875&idx=1&sn=01b4ea2978370d215442e4a22d7d2a7f&scene=23&srcid=1028sCxJpZit13UcLIvdvSKo#rd)  
