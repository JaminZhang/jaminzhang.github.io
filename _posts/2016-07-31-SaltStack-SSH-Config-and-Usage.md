---
layout: post
title: SaltStack SSH 配置使用
description: "SaltStack SSH 配置使用"
category: SaltStack
avatarimg:
tags: [SaltStack, SSH]
duoshuo: true
---



# Salt SSH 介绍

在之前我们一直在围绕着需要在受控端安装 Minion 的前提下进行架构扩展，那么如果在实际的环境中，由于某些限制无法在受控端服务器安装 Minion 客户端，该怎么办呢？  

Salt 在版本 0.17.0 当中，引入了新的传输系统，它支持通过 SSH 通道来实现 Salt 的通信。通过这种方式，我们可以直接通过 SSH 通道在远程主机上执行使用 SaltStack，而不需要在远程主机上运行 Salt Minion ，同时又能支持 SaltStack 的大部分功能，而且 Salt Master 也不需要运行了。这样，也就实现了免客户端方式的部署和实施。  

但是由于无客户端本身的局限性 Salt SSH 并不能完全取代标准的 Salt 通信方式，只是简单地提供了一个基于 SSH 通道的可选方式，这种方式不需要 ZeroMQ 和远程 Agent 的支持；整体的工作流程和基于客户端架构大致相同。但必须意识到，通过 Salt SSH 的执行速度会远远低于 ZeroMQ 支持的标准的 Salt 通信方式。  

安装 salt-ssh 如下：
>
yum install salt-ssh -y

在传统的 Master 和 Minion 的架构中，Minion 会主动连接 Master，所以 Master 不需要手工配置目标系统的信息。但是使用 Salt SSH，控制服务器就需要这些。SaltStack 使用 Rosters 来管理这些数据。

# Salt Rosters

Roster 系统为可插拔设计，可以非常方便地加入到已有的系统中，用于 Salt SSH 获取需要连接的服务器信息。默认情况下 Roster 文件本地路径为：/etc/salt/roster。  

Roster 系统编译了一个内部数据结构，称为 Targets。Targets 是一个目标系统和关于如何连接到系统属性的列表。对于一个在 Salt 中的 Roster 模块来说，唯一要求是返回 Targets 数据结构：

```bash
<SaltID>： 	# 目标 ID
  host： 	# 远程主机的 IP 地址或者主机名
  user： 	# 可以登录的用户
  passwd： 	# 可以登录用户的密码
# 可选参数
  port： 	# SSH 端口
  sudo： 	# 是否运行 sudo，设置 True 或者 False
  priv： 	# SSH 私钥的路径，默认是 salt-ssh.rsa
  timeout： # 连接 SSH 时的超时时间
  thin_dir：# 目标系统 Salt 的存储路径，默认是 /tmp/salt-<hash>
```    

添加两个测试 Minion，如下所示：  

```bash
[root@linux-node1 ~]# cat /etc/salt/roster
linux-node1.example.com:
  host: 192.168.56.11
  port: 22
  user: root

linux-node2.example.com:
  host: 192.168.56.12
  port: 22
  user: root
```    

# 使用 Salt SSH

第一次运行 Salt SSH 会提示进行 salt-ssh key 的部署，需要在 Rosters 中配置用户的密码，即可进行 Key 的部署，初始化代码如下：  

```bash
[root@linux-node1 ~]# salt-ssh '*' test.ping -i
Permission denied for host linux-node2.example.com, do you want to deploy the salt-ssh key? (password required):
[Y/n] Y
Password for root@linux-node2.example.com: 
linux-node2.example.com:
    True
Permission denied for host linux-node1.example.com, do you want to deploy the salt-ssh key? (password required):
[Y/n] Y
Password for root@linux-node1.example.com: 
linux-node1.example.com:
    True
```    

当部署过 Key 之后，后期再执行 Salt SSH 就会通过密钥认证，不需要用户再输入密码了：

```bash
[root@linux-node1 ~]# salt-ssh '*' test.ping 
linux-node1.example.com:
    True
linux-node2.example.com:
    True
```    

# 基本使用

salt-ssh 命令的语法和 Salt 命令类似，下面看几个典型的使用场景。

## 1 Salt SSH Target

相对于 C/S 模式，salt-ssh 在 Target 中还有一定的局限性，目前支持如下匹配模式：

* -E pcre 正则匹配
* -L list 列表匹配
* -G grain grains 匹配
* -grain-pcre grains 加正则匹配
* -N nodegroup 组匹配
* -R range 范围匹配

## 2 命令执行

默认情况下 salt-ssh 可以直接在远程系统上运行 Salt 执行模块。通过 salt-ssh 也可以直接执行原始 shell 命令：
>
[root@linux-node1 ~]# salt-ssh '*' -r 'w'

该命令基本等同于 salt '*' cmd.run 'w'   
执行其他模块时也类似，如 salt-ssh '*' disk.usage

## 3 状态管理

salt-ssh 命令可以直接使用 Salt 状态管理系统。使用时将 salt 命令直接替换为 salt-ssh 即可：
>
salt-ssh '*' state.sls init.dns

上面的命令基本等同于 salt '*' state.sls init.dns

# 生产实践

在实际的生产使用中，建议将传统的 Master、Minion 和 salt-ssh 一起使用，比如我们可以使用 salt-ssh 来进行 Salt Minion 的升级，可以使用 salt-minion 来实现 salt-ssh 的自动化部署等。  

这里我们来介绍如何基于现有的 Master、Minion 架构自动构建 Salt SSH 环境。经过上面对 Salt SSH 的介绍，相信大家已经知道要实现 Salt SSH 架构需要两个重要的步骤：  

1. 生成 Rosters 配置文件。
2. 把密钥放置到 Salt Minion 上。

针对这两个需求，我们可以使用下面的方法进行实现。

* 使用 salt-mine 实现 Salt Rosters 文件的自动生成。
* 使用 Salt 的文件状态模块管理 Minion 上的 authorized_keys。本质是将 ssh-key（注：第一次执行 salt-ssh 添加主机时会生成，默认存放在 /etc/salt/pki/master/ssh/salt-ssh.rsa.pub 的公钥）写入到用户主目录 .ssh/authorized_keys 文件中。

## 1 编写状态配置

首先我们在 base 环境中创建 salt 目录，用来存放我们编写的 salt-ssh 相关的状态配置：

```bash
[root@linux-node1 ]# mkdir /srv/salt/base/salt/files -p
[root@linux-node1 ]# mkdir /srv/pillar/base/salt -p
[root@linux-node1 ]# vim /srv/salt/base/salt/ssh.sls
# 创建 salt 用户
salt-user:
  user.present:
    - name: salt

# 管理 salt-ssh 的 sudo 文件
salt-ssh-sudo:
  file.managed:
    - name: /etc/sudoers.d/salt
    - source: salt://salt/files/salt-sudo
    - user: root
    - group: root
    - mode: 644
    - require:
      - user: salt-user

# 使用 ssh_auth 模块管理公钥
salt-ssh-key:
  ssh_auth.present:
    - user: salt
    - source: salt://salt/files/salt-ssh.rsa.pub
    - require:
      - user: salt-user

[root@linux-node1 salt]# vim /srv/salt/base/salt/roster.sls
# 生成 roster-auto 文件，为了和默认的 roster 进行区分
salt-ssh-roster:
  file.managed:
    - name: /etc/salt/roster-auto
    - source: salt://salt/files/roster
    - template: jinja
```    

## 2 配置 Salt-Mine

下面我们需要使用 salt mine 来获取所有 Minion 的 IP 地址，用于自动填充 roster 文件：

```bash
vim /srv/pillar/base/salt/mine.sls
mine_functions:
  network.ip_addrs:
    - eth0

# 增加到 Pillar 的 top file 中：

vim /srv/pillar/base/top.sls
base:
  '*':
    - salt.mine

# 刷新 Pillar 的 数据
[root@linux-node1 salt]# salt '*' saltutil.refresh_pillar
linux-node1.example.com:
    True
linux-node2.example.com:
    True

# 测试 Mine 配置
[root@linux-node1 salt]# salt '*' pillar.get mine_functions
linux-node1.example.com:
    ----------
    network.ip_addrs:
        - eth0
linux-node2.example.com:
    ----------
    network.ip_addrs:
        - eth0

# 更新 Mine 数据
[root@linux-node1 salt]# salt '*' mine.update
linux-node1.example.com:
    True
linux-node2.example.com:
    True

# 测试 Mine 获取 Minion ID 和 IP 地址：
[root@linux-node1 salt]# salt '*node1*' mine.get '*' network.ip_addrs
linux-node1.example.com:
    ----------
    linux-node1.example.com:
        - 192.168.56.11
    linux-node2.example.com:
        - 192.168.56.12
# 可以看到。我们可以正常获取到所有 Minion 的 ID 和 IP 地址。下面我们将数据写入到 roster 文件即可。
```    

# 3 准备相关文件

```bash
# 将 Salt SSH的公钥复制到 files 目录下：
cp /etc/salt/pki/master/ssh/salt-ssh.rsa.pub /srv/salt/base/salt/files/

# 创建 Salt 的 sudo 文件：
vim /srv/salt/base/salt/files/salt-sudo
Defaults:salt !requiretty
salt ALL=(ALL) NOPASSWD: ALL

# 创建 roster 模板，在 Jinja 中使用 salt-mine 获取主机的 Minion ID 和 IP 地址：
vim /srv/salt/base/salt/files/roster
[roster 文件](https://jaminzhang.github.io/soft-conf/SaltStack/salt-roster-template.yaml)
```    

# 4 执行状态并测试

下面我们就可以来执行状态，自动化部署 Salt SSH 的 key 和 自动生成 roster 文件。下面是我们之前配置的目录结构：

```bash
[root@linux-node1 ~]# cd /srv/salt/base/salt/
[root@linux-node1 salt]# tree
.
├── files
│   ├── roster
│   ├── salt-ssh.rsa.pub
│   └── salt-sudo
├── roster.sls
└── ssh.sls
```   

第一步：执行 salt.ssh 状态，在所有 Minion 端创建 salt 用户，放置 sudo 配置和公钥
>
salt '*node1*' state.sls salt.ssh

第二步：执行 salt.roster 状态，注意只在 Salt Master 执行即可，生成 roster 文件

```bash
[root@linux-node1 salt]# salt '*node1*' state.sls salt.roster
[root@linux-node1 salt]# cat /etc/salt/roster-auto 
linux-node1.example.com:
  host: 192.168.56.11
  user: salt
  sudo: True
linux-node2.example.com:
  host: 192.168.56.12
  user: salt
  sudo: True
```    

可以看到已经正确生成了 roster 文件，我们就可以使用 salt ssh 进行操作了。  
注意：需要使用 --roster-file 来指定 roster 文件。这样一些自定义的主机可以在默认的 /etc/salt/roster 文件中，
自动生成的使用 /etc/salt/roster-auto。

```bash
[root@linux-node1 salt]# salt-ssh --roster-file=/etc/salt/roster-auto '*' test.ping
linux-node1.example.com:
    True
linux-node2.example.com:
    True
```   

# 遇到的问题

```bash
[root@linux-node1 ~]# salt-ssh -i '*' test.ping
[ERROR   ] An un-handled exception was caught by salt's global exception handler:
UnicodeEncodeError: 'ascii' codec can't encode character u'\uff1a' in position 23: ordinal not in range(128)
```    

/etc/salt/roster 文件中包含中文符号

# Ref
[SALT SSH](https://docs.saltstack.com/en/latest/topics/ssh/index.html)  





