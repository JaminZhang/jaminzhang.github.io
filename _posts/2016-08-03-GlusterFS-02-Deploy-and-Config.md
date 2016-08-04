---
layout: post
title: GlusterFS 02 部署配置
description: "GlusterFS 02 部署配置"
category: GlusterFS
avatarimg:
tags: [FileSystem, GlusterFS, NFS]
duoshuo: true
---

# 2 部署安装

## 2.1 GlusterFS 安装前的准备

服务器规划(采用 VMware Workstation 虚拟机环境)

|      操作系统     |        IP      |   主机名   |   数据盘(2 块)  |
|-------------------|----------------|------------|-----------------|
| CentOS 6.8 x86_64 |  192.168.56.11 | mystorage1 | sdb:10G sdc:10G |
| CentOS 6.8 x86_64 |  192.168.56.12 | mystorage2 | sdb:10G sdc:10G |
| CentOS 6.8 x86_64 |  192.168.56.13 | mystorage3 | sdb:10G sdc:10G |
| CentOS 6.8 x86_64 |  192.168.56.14 | mystorage4 | sdb:10G sdc:10G |


## 2.2 GlusterFS 安装

### 2.2.1 修改主机名

修改：
* /etc/sysconfig/network 


分别在各台服务器上执行 hostname 临时生效，不用重启

### 2.2.2 添加 hosts 文件实现集群主机之间相互能够解析

```bash
echo '192.168.56.11   mystorage1 
192.168.56.12   mystorage2
192.168.56.13   mystorage3
192.168.56.14   mystorage4' >> /etc/hosts
```    

### 2.2.3 关闭 SELinux 和 防火墙

```bash
sed -i 's#SELINUX=enforcing#SELINUX=disabled#' /etc/selinux/config
/etc/init.d/iptables stop
# 检查
getenforce
/etc/init.d/iptables status

```    

### 2.2.4 安装 EPEL 源

GlusterFS yum 源有部分包依赖 epel 源

>
yum install epel-release -y

### 2.2.5 安装 GlusterFS 源及相关软件包

```bash
yum install centos-release-gluster37.noarch -y
yum --enablerepo=centos-gluster*-test install glusterfs-server glusterfs-cli glusterfs-geo-replication -y

# 安装完成后的包
rpm -qa | grep gluster*
centos-release-gluster37-1.0-4.el6.centos.noarch
glusterfs-api-3.7.13-1.el6.x86_64
glusterfs-3.7.13-1.el6.x86_64
glusterfs-client-xlators-3.7.13-1.el6.x86_64
glusterfs-fuse-3.7.13-1.el6.x86_64
glusterfs-server-3.7.13-1.el6.x86_64
glusterfs-libs-3.7.13-1.el6.x86_64
glusterfs-cli-3.7.13-1.el6.x86_64
glusterfs-geo-replication-3.7.13-1.el6.x86_64
```    


## 2.3 配置 GlusterFS

### 2.3.1 查看 GlusterFS 版本信息

使用 `glusterfs -V` 命令

```bash
[root@mystorage1 ~]# glusterfs -V
glusterfs 3.7.13 built on Jul  8 2016 15:25:47
Repository revision: git://git.gluster.com/glusterfs.git
Copyright (c) 2006-2013 Red Hat, Inc. <http://www.redhat.com/>
GlusterFS comes with ABSOLUTELY NO WARRANTY.
It is licensed to you under your choice of the GNU Lesser
General Public License, version 3 or any later version (LGPLv3
or later), or the GNU General Public License, version 2 (GPLv2),
in all cases as published by the Free Software Foundation.
```   

### 2.3.2 启动、停止服务

```bash
/etc/init.d/glusterd start
/etc/init.d/glusterd status
chkconfig glusterd on
```    

在 4 台服务器上都执行

### 2.3.3 存储主机加入信任主机池

在一台主机上执行，将其他主机加入，如下是在 mystorage1 上执行

```bash
[root@mystorage1 ~]# gluster peer probe mystorage2
peer probe: success. 
[root@mystorage1 ~]# gluster peer probe mystorage3
peer probe: success. 
[root@mystorage1 ~]# gluster peer probe mystorage4
peer probe: success. 
```    

### 2.3.4 查看状态

在另外的机器查看状态：

```bash
[root@mystorage2 ~]# gluster peer status
Number of Peers: 3

Hostname: mystorage1
Uuid: 6e6a84af-ac7a-44eb-85c9-50f1f46acef1
State: Peer in Cluster (Connected)

Hostname: mystorage3
Uuid: 36e4c45c-466f-47b0-b829-dcd4a69ca2e7
State: Peer in Cluster (Connected)

Hostname: mystorage4
Uuid: c607f6c2-bdcb-4768-bc82-4bc2243b1b7a
State: Peer in Cluster (Connected)

```    

### 2.3.5 配置前的准备工作

安装 xfs 支持包  

>
yum install xfsprogs -y

`fdisk -l` 查看磁盘设备，确认新加的数据盘在线

>
如果磁盘大于 4T 的话就用 parted 来分区，这里我们不会用分区（可以不分区）  
做分布式文件系统的时候数据盘一般不需要做 RAID，一般系统盘会做 RAID 1  
如果磁盘有 RAID 卡(cache)，最好用上(RAID 5)  
也可以在单机做了 RAID 5 的基础上，再用 glusterfs 做成一个大的文件系统

格式化创建文件系统

>
mkfs.xfs -f /dev/sdb

在四台机器上创建挂载块设备的目录，挂载硬盘到目录：

```bash
mkdir -p /storage/brick1 /storage/brick2
mount /dev/sdb /storage/brick1
df -h
```   

加入到 /etc/fstab

>
echo "/dev/sdb  /storage/brick1  xfs defaults 0 0"  >> /etc/fstab  
mount -a

### 2.3.6 创建 volume 及其他操作

GlusterFS 五种卷

* Distributed：分布式卷，文件通过 hash 算法随机分布到由 bricks 组成的卷上。
* Replicated: 复制式卷，类似 RAID 1，replica 数必须等于 volume 中 brick 所包含的存储服务器数，可用性高。
* Striped: 条带式卷，类似 RAID 0，stripe 数必须等于 volume 中 brick 所包含的存储服务器数，文件被分成数据块，以 Round Robin 的方式存储在 bricks 中，并发粒度是数据块，大文件性能好。
* Distributed Striped: 分布式的条带卷，volume中 brick 所包含的存储服务器数必须是 stripe 的倍数（>=2倍），兼顾分布式和条带式的功能。
* Distributed Replicated: 分布式的复制卷，volume 中 brick 所包含的存储服务器数必须是 replica 的倍数（>=2倍），兼顾分布式和复制式的功能。

glustfs 最常用的卷就是分布式复制卷。  
striped 的目的就提高性能，读取更快。    

企业一般用后两种，大部分会用分布式复制（可用容量为 总容量/复制份数），通过网络传输的话最好用万兆交换机，万兆网卡来做。这样就会优化一部分性能。它们的数据都是通过网络来传输的。

**分布式卷**

```bash

# 创建分布式卷
[root@mystorage1 ~]# gluster volume create gv1 mystorage1:/storage/brick1 mystorage2:/storage/brick1 force
volume create: gv1: success: please start the volume to access data

# 启动创建的卷
[root@mystorage1 ~]# gluster volume start gv1
volume start: gv1: success

# 在另一台机器（mystorage4）查看卷信息
[root@mystorage4 ~]# gluster volume info
 
Volume Name: gv1
Type: Distribute
Volume ID: b6ec2f8a-d1f0-4d1b-806b-238efb6dcb84
Status: Started
Number of Bricks: 2
Transport-type: tcp
Bricks:
Brick1: mystorage1:/storage/brick1
Brick2: mystorage2:/storage/brick1
Options Reconfigured:
performance.readdir-ahead: on

# 挂载卷到目录
[root@mystorage4 ~]# mount -t glusterfs 127.0.0.1:/gv1 /mnt
[root@mystorage4 ~]# df -h
Filesystem      Size  Used Avail Use% Mounted on
/dev/sda3        33G  1.3G   30G   5% /
tmpfs           242M     0  242M   0% /dev/shm
/dev/sda1       976M   38M  888M   5% /boot
/dev/sdb         10G   33M   10G   1% /storage/brick1
127.0.0.1:/gv1   20G   65M   20G   1% /mnt

# 在 mystorage1 创建测试文件
[root@mystorage1 ~]# touch /mnt/{a..d}
[root@mystorage1 ~]# ll /mnt
total 0
-rw-r--r-- 1 root root 0 Jul 30 00:54 a
-rw-r--r-- 1 root root 0 Jul 30 00:54 b
-rw-r--r-- 1 root root 0 Jul 30 00:54 c
-rw-r--r-- 1 root root 0 Jul 30 00:54 d

# 在 mystorage4 也可看到新创建的文件，信任存储池中的每一台主机挂载这个卷后都可以看到
[root@mystorage4 ~]# ll /mnt/
total 0
-rw-r--r-- 1 root root 0 Jul 30 00:54 a
-rw-r--r-- 1 root root 0 Jul 30 00:54 b
-rw-r--r-- 1 root root 0 Jul 30 00:54 c
-rw-r--r-- 1 root root 0 Jul 30 00:54 d

# 文件实际存在位置
[root@mystorage1 ~]# ls /storage/brick1
a  b  c  e
[root@mystorage2 ~]# ls /storage/brick1
d

# 上面可以看到文件根据 hash 算法随机分布到由不同的 brick 上

```    

**使用 NFS 方式挂载**

```bash
[root@mystorage3 ~]# mount -o mountproto=tcp -t nfs mystorage1:/gv1 /mnt/		# host 可以写主机名
[root@mystorage3 ~]# ll /mnt
total 0
-rw-r--r-- 1 root root 0 Jul 30 00:54 a
-rw-r--r-- 1 root root 0 Jul 30 00:54 b
-rw-r--r-- 1 root root 0 Jul 30 00:54 c
-rw-r--r-- 1 root root 0 Jul 30 00:54 d

[root@mystorage2 ~]# mount -o mountproto=tcp -t nfs 192.168.56.13:/gv1 /mnt/	
# host 可以写 IP，可以看到这个 mystorage3 的 IP，说明 gv1 是共享给信任存储池的所有主机的
[root@mystorage2 ~]# ll /mnt/
total 0
-rw-r--r-- 1 root root 0 Jul 30 00:54 a
-rw-r--r-- 1 root root 0 Jul 30 00:54 b
-rw-r--r-- 1 root root 0 Jul 30 00:54 c
-rw-r--r-- 1 root root 0 Jul 30 00:54 d
```    


**复制式卷**

```bash

# 创建复制式卷
[root@mystorage1 ~]# gluster volume create gv2 replica 2 mystorage3:/storage/brick1 mystorage4:/storage/brick1 force
volume create: gv2: success: please start the volume to access data

# 启动创建的卷
[root@mystorage1 ~]# gluster volume start gv2
volume start: gv2: success

# 查看卷信息
[root@mystorage1 ~]# gluster volume info gv2
 
Volume Name: gv2
Type: Replicate
Volume ID: 11928696-263a-4c7a-a155-5115af29221f
Status: Started
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: mystorage3:/storage/brick1
Brick2: mystorage4:/storage/brick1
Options Reconfigured:
performance.readdir-ahead: on

# 挂载卷到目录，创建测试文件
[root@mystorage1 ~]# mount -t glusterfs 127.0.0.1:/gv2 /opt
[root@mystorage1 ~]# touch /opt/{a..d}
[root@mystorage1 ~]# ls /opt
a  b  c  d

# 在 mystorage3,4 可看到新创建的文件
[root@mystorage3 ~]# mount -t glusterfs 127.0.0.1:/gv2 /opt
[root@mystorage3 ~]# ls /opt/
a  b  c  d

[root@mystorage4 ~]# mount -t glusterfs 127.0.0.1:/gv2 /opt
[root@mystorage4 ~]# ls /opt/
a  b  c  d

# 文件实际存在位置
[root@mystorage3 ~]# ls /storage/brick1
a  b  c  d
[root@mystorage4 ~]# ls /storage/brick1
a  b  c  d

# 上面可以看到文件根据在 2 台机器上的 brick 上都有 

```    

格式化挂载第二块硬盘

```bash
mkfs.xfs -f /dev/sdc
mkdir -p /storage/brick2
echo "/dev/sdc  /storage/brick2  xfs defaults 0 0"  >> /etc/fstab
mount -a
df -h
```    

**分布式条带卷**

```bash

# 创建分布式条带卷
[root@mystorage1 ~]# gluster volume create gv3 stripe 2 mystorage3:/storage/brick2 mystorage4:/storage/brick2 force
volume create: gv3: success: please start the volume to access data

# 启动创建的卷
[root@mystorage1 ~]# gluster volume start gv3
volume start: gv3: success

# 查看卷信息
[root@mystorage1 ~]# gluster volume info gv3
 
Volume Name: gv3
Type: Stripe
Volume ID: 2871801f-b125-465c-be3a-4eeb2fb44916
Status: Started
Number of Bricks: 1 x 2 = 2
Transport-type: tcp
Bricks:
Brick1: mystorage3:/storage/brick2
Brick2: mystorage4:/storage/brick2
Options Reconfigured:
performance.readdir-ahead: on

# 挂载卷到目录，创建测试文件
mkdir /gv1 /gv2 /gv3
mount -t glusterfs 127.0.0.1:gv1 /gv1
mount -t glusterfs 127.0.0.1:gv2 /gv2
mount -t glusterfs 127.0.0.1:gv3 /gv3
df -h

dd if=/dev/zero bs=1024 count=10000 of=/gv3/10M.file
dd if=/dev/zero bs=1024 count=20000 of=/gv3/20M.file

# 查看新创建的文件
[root@mystorage1 ~]# ll /gv3/
total 30000
-rw-r--r-- 1 root root 10240000 Jul 30 02:26 10M.file
-rw-r--r-- 1 root root 20480000 Jul 30 02:26 20M.file

# 文件实际存放位置
[root@mystorage3 ~]# ll -h /storage/brick2/
total 15M
-rw-r--r-- 2 root root 4.9M Jul 30 02:26 10M.file
-rw-r--r-- 2 root root 9.8M Jul 30 02:26 20M.file
[root@mystorage4 ~]# ll -h /storage/brick2/
total 15M
-rw-r--r-- 2 root root 4.9M Jul 30 02:25 10M.file
-rw-r--r-- 2 root root 9.8M Jul 30 02:26 20M.file

# 上面可以看到 10M 20M 的文件分别分成了 2 块（这是条带的特点），每块又分别在同的 brick 下（这是分布式的特点）
```    

**分布式复制卷**

```bash
# 查看复制式卷的效果
cd /gv2
rm -f *
dd if=/dev/zero bs=1024 count=10000 of=/gv2/10M.file
dd if=/dev/zero bs=1024 count=20000 of=/gv2/20M.file
dd if=/dev/zero bs=1024 count=30000 of=/gv2/30M.file


[root@mystorage3 ~]# ll -h /storage/brick1/
total 59M
-rw-r--r-- 2 root root 9.8M Jul 30 02:41 10M.file
-rw-r--r-- 2 root root  20M Jul 30 02:41 20M.file
-rw-r--r-- 2 root root  30M Jul 30 02:41 30M.file
[root@mystorage4 ~]# ll -h /storage/brick1
total 59M
-rw-r--r-- 2 root root 9.8M Jul 30 02:40 10M.file
-rw-r--r-- 2 root root  20M Jul 30 02:40 20M.file
-rw-r--r-- 2 root root  30M Jul 30 02:40 30M.file

# gv2 添加 brick 进行扩容
[root@mystorage1 ~]# gluster volume stop gv2
Stopping volume will make its data inaccessible. Do you want to continue? (y/n) y

[root@mystorage1 ~]# gluster volume add-brick gv2 replica 2 mystorage1:/storage/brick2 mystorage2:/storage/brick2 force
volume add-brick: success

[root@mystorage1 ~]# gluster volume start gv2
volume start: gv2: success

[root@mystorage1 ~]# gluster volume info gv2
 
Volume Name: gv2
Type: Distributed-Replicate				# 这里显示是分布式复制卷，是在 gv2 复制卷的基础上增加 2 块 brick 形成的
Volume ID: 11928696-263a-4c7a-a155-5115af29221f
Status: Stopped
Number of Bricks: 2 x 2 = 4
Transport-type: tcp
Bricks:
Brick1: mystorage3:/storage/brick1
Brick2: mystorage4:/storage/brick1
Brick3: mystorage1:/storage/brick2
Brick4: mystorage2:/storage/brick2
Options Reconfigured:
performance.readdir-ahead: on

```

注意：当你给分布式复制卷和分布式条带卷增加 bricks 时，你增加的 bricks 数目必须是复制或条带数目的倍数，例如：你给一个分布式复制卷的 replica 为 2，你在增加 bricks 的时候数量必须为2、4、6、8等。
扩容后进行测试，发现文件都分布在扩容前的卷中。

**磁盘存储的平衡**

注意：平衡布局是很有必要的，因为布局结构是静态的，当新的 bricks 加入现有卷，新创建的文件会分布到旧的 bricks 中，所以需要平衡布局结构，使新加入的 bricks 生效。布局平衡只是使新布局生效，并不会在新的布局中移动老的数据，如果你想在新布局生效后，重新平衡卷中的数据，还需要对卷中的数据进行平衡。

```bash

# 再在 /gv2 下创建 2 个新的文件 10M.file1 20M.file1

[root@mystorage1 ~]# dd if=/dev/zero bs=1024 count=10000 of=/gv2/10M.file1
[root@mystorage1 ~]# dd if=/dev/zero bs=1024 count=20000 of=/gv2/20M.file1
[root@mystorage1 ~]# ll -rht /gv2/
total 88M
-rw-r--r-- 1 root root 9.8M Jul 30 02:40 10M.file
-rw-r--r-- 1 root root  20M Jul 30 02:40 20M.file
-rw-r--r-- 1 root root  30M Jul 30 02:40 30M.file
-rw-r--r-- 1 root root 9.8M Jul 30 03:10 10M.file1
-rw-r--r-- 1 root root  20M Jul 30 03:10 20M.file1

[root@mystorage1 ~]# ll /storage/brick2
total 0
[root@mystorage2 ~]# ll /storage/brick2
total 0
[root@mystorage3 ~]# ll -hrt /storage/brick1
total 88M
-rw-r--r-- 2 root root 9.8M Jul 30 02:41 10M.file
-rw-r--r-- 2 root root  20M Jul 30 02:41 20M.file
-rw-r--r-- 2 root root  30M Jul 30 02:41 30M.file
-rw-r--r-- 2 root root 9.8M Jul 30 03:12 10M.file1
-rw-r--r-- 2 root root  20M Jul 30 03:13 20M.file1
[root@mystorage4 ~]# ll -hrt /storage/brick1
total 88M
-rw-r--r-- 2 root root 9.8M Jul 30 02:40 10M.file
-rw-r--r-- 2 root root  20M Jul 30 02:40 20M.file
-rw-r--r-- 2 root root  30M Jul 30 02:40 30M.file
-rw-r--r-- 2 root root 9.8M Jul 30 03:10 10M.file1
-rw-r--r-- 2 root root  20M Jul 30 03:10 20M.file1

# 从上面可以看到，新创建的文件还是在之前的 bricks 中，并没有分布中新加的 bricks 中


# 下面进行磁盘存储平衡
[root@mystorage1 ~]# gluster volume rebalance gv2 start
volume rebalance: gv2: success: Rebalance on gv2 has been started successfully. Use rebalance status command to check status of the rebalance process.
ID: e23213be-7771-4a2b-87b4-259fd048ec46

[root@mystorage1 ~]# gluster volume rebalance gv2 status
                                    Node Rebalanced-files          size       scanned      failures       skipped               status  run time in h:m:s
                               ---------      -----------   -----------   -----------   -----------   -----------         ------------     --------------
                               localhost                0        0Bytes             0             0             0            completed        0:0:1
                              mystorage2                0        0Bytes             0             0             0            completed        0:0:0
                              mystorage3                2        39.1MB             5             0             0            completed        0:0:2
                              mystorage4                0        0Bytes             0             0             0            completed        0:0:1
volume rebalance: gv2: success

# 查看磁盘存储平衡后文件在 bricks 中的分布情况
[root@mystorage1 ~]# ll /storage/brick2
total 40000
-rw-r--r-- 2 root root 20480000 Jul 30 02:41 20M.file
-rw-r--r-- 2 root root 20480000 Jul 30 03:13 20M.file1
[root@mystorage2 ~]# ll /storage/brick2
total 40000
-rw-r--r-- 2 root root 20480000 Jul 30 02:41 20M.file
-rw-r--r-- 2 root root 20480000 Jul 30 03:13 20M.file1
[root@mystorage3 ~]# ll -hrt /storage/brick1
total 49M
-rw-r--r-- 2 root root 9.8M Jul 30 02:41 10M.file
-rw-r--r-- 2 root root  30M Jul 30 02:41 30M.file
-rw-r--r-- 2 root root 9.8M Jul 30 03:12 10M.file1
[root@mystorage4 ~]# ll -hrt /storage/brick1
total 49M
-rw-r--r-- 2 root root 9.8M Jul 30 02:40 10M.file
-rw-r--r-- 2 root root  30M Jul 30 02:40 30M.file
-rw-r--r-- 2 root root 9.8M Jul 30 03:10 10M.file1

# 从上面可以看到 20M.file 20M.file1 2 个文件 平衡到 新加的 2 个 brick 中了
```    

每做一次扩容后都需要做一次磁盘平衡。
磁盘平衡是在万不得已的情况下再做的，一般再创建一个卷就可以了。

**移除 brick**

你可能想在线缩小卷的大小，例如：当硬件损坏或网络故障的时候，你可能想在卷中移除相关的 bricks。  
注意：当你移除 bricks 的时候，你在 gluster 的挂载点将不能继续访问数据，只有配置文件中的信息移除后你才能继续访问 bricks 中的数据。当移除分布式复制卷或者分布式条带卷的时候，移除的 bricks 数目必须是 replica 或者 stripe 的倍数。  
例如：一个分布式条带卷的 stripe 是 2，当你移除 bricks 的时候必须是 2、4、6、8 等。

```bash

# 下面移除 gv2 卷的 2 个 bricks

[root@mystorage1 ~]# gluster volume stop gv2
Stopping volume will make its data inaccessible. Do you want to continue? (y/n) y
volume stop: gv2: success
[root@mystorage1 ~]# gluster volume remove-brick gv2 replica 2 mystorage3:/storage/brick1 mystorage4:/storage/brick1 force
Removing brick(s) can result in data loss. Do you want to Continue? (y/n) y
volume remove-brick commit force: success
[root@mystorage1 ~]# gluster volume start gv2
volume start: gv2: success
[root@mystorage1 ~]# ll /gv2/
total 40000
-rw-r--r-- 1 root root 20480000 Jul 30 02:41 20M.file
-rw-r--r-- 1 root root 20480000 Jul 30 03:13 20M.file1

# 如果误操作删除了后，其实文件还在 /storage/brick1 里面的，加回来就可以了
[root@mystorage1 ~]# gluster volume stop gv2
Stopping volume will make its data inaccessible. Do you want to continue? (y/n) y
volume stop: gv2: success
[root@mystorage1 ~]# gluster volume add-brick gv2 replica 2 mystorage3:/storage/brick1 mystorage4:/storage/brick1 force
volume add-brick: success
[root@mystorage1 ~]# gluster volume info gv2
 
Volume Name: gv2
Type: Distributed-Replicate
Volume ID: 11928696-263a-4c7a-a155-5115af29221f
Status: Stopped
Number of Bricks: 2 x 2 = 4
Transport-type: tcp
Bricks:
Brick1: mystorage1:/storage/brick2
Brick2: mystorage2:/storage/brick2
Brick3: mystorage3:/storage/brick1
Brick4: mystorage4:/storage/brick1
Options Reconfigured:
performance.readdir-ahead: on
[root@mystorage1 ~]# gluster volume start gv2
volume start: gv2: success
[root@mystorage1 ~]# ll /gv2/					# 文件还在
total 90000
-rw-r--r-- 1 root root 10240000 Jul 30 02:40 10M.file
-rw-r--r-- 1 root root 10240000 Jul 30 03:10 10M.file1
-rw-r--r-- 1 root root 20480000 Jul 30 02:41 20M.file
-rw-r--r-- 1 root root 20480000 Jul 30 03:13 20M.file1
-rw-r--r-- 1 root root 30720000 Jul 30 02:40 30M.file
```    

**删除卷**

一般会用在命名不规范的时候才会删除

```bash
[root@mystorage1 ~]# umount /gv1
[root@mystorage1 ~]# gluster volume stop gv1
Stopping volume will make its data inaccessible. Do you want to continue? (y/n) y
volume stop: gv1: success
[root@mystorage1 ~]# gluster volume delete gv1
Deleting volume will erase all information about the volume. Do you want to continue? (y/n) y
volume delete: gv1: success
[root@mystorage1 ~]# gluster volume info gv1
Volume gv1 does not exist

```    


# 遇到的问题

## 1 NFS rpcbind 没启动

```bash
[root@mystorage3 ~]# mount -o mountproto=tcp -t nfs mystorage1:/gv1 /mnt/
mount.nfs: rpc.statd is not running but is required for remote locking.
mount.nfs: Either use '-o nolock' to keep locks local, or start statd.
mount.nfs: an incorrect mount option was specified
[root@mystorage3 ~]# gluster volume status gv1
Status of volume: gv1
Gluster process                             TCP Port  RDMA Port  Online  Pid
------------------------------------------------------------------------------
Brick mystorage1:/storage/brick1            49152     0          Y       3839 
Brick mystorage2:/storage/brick1            49152     0          Y       3959 
NFS Server on localhost                     N/A       N/A        N       N/A  
NFS Server on mystorage1                    N/A       N/A        N       N/A  
NFS Server on mystorage2                    N/A       N/A        N       N/A  
NFS Server on mystorage4                    N/A       N/A        N       N/A  
 
Task Status of Volume gv1
------------------------------------------------------------------------------
There are no active volume tasks

# 启动 rpcbind，重启 glusterd 
[root@mystorage3 ~]# /etc/init.d/rpcbind start
Starting rpcbind:                                          [  OK  ]
[root@mystorage3 ~]# /etc/init.d/glusterd restart
Starting glusterd:                                         [  OK  ]
```    

## 2 VMware Workstation 虚拟机在线增加硬盘，CentOS 没有自动识别

```bash
# 使用如下命令，其中 host2 表示新增加的硬盘
echo "- - -" >  /sys/class/scsi_host/host2/scan
fdisk -l
```    

# Ref
[Troubleshooting NFS](https://gluster.readthedocs.io/en/latest/Administrator%20Guide/Troubleshooting/#nfs)  
[Linux不重启识别新添加的磁盘](http://www.361way.com/linux-scan-newdisk/4683.html)   

