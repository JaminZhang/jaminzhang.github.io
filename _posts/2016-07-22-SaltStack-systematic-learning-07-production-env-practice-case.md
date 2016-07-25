---
layout: post
title: SaltStack 系统性学习 07 - 生产实践案例
description: "SaltStack 系统性学习 07 - 生产实践案例"
category: SaltStack
avatarimg:
tags: [SaltStack, Production]
duoshuo: true
---

# 规划 

1. 系统初始化 
2. 功能模块：设置单独的目录(haproxy/nginx/php/mysql/memcache)，做到尽可能的齐全、独立 
3. 业务模块：根据业务类型划分


# Salt 环境及各功能模块状态 SLS 配置
 
环境可分为开发、测试（功能测试环境、性能测试环境）、预生产、生产 


## 1 Salt base/prod 环境配置准备

* file_roots base: /srv/salt/base
* file_roots prod: /srv/salt/prod
* pillar_roots bash: /srv/pillar/base
* pillar_roots prod: /srv/pillar/prod


```bash
# 创建相关目录
mkdir -p /srv/salt/base
mkdir -p /srv/salt/prod
mkdir -p /srv/pillar/base
mkdir -p /srv/pillar/prod

# 修改 /etc/salt/master 配置文件 file_roots/pillar_roots 如下：
/etc/salt/master

file_roots:
  base:
    - /srv/salt/base 
  prod:
    - /srv/salt/prod 

pillar_roots:
  base:
    - /srv/pillar/base
  prod:
    - /srv/pillar/prod 

systemctl restart salt-master

``` 

## 2 Salt base 基础环境规划及配置

系统初始化在 base 环境下面配置，以下列出系统初始化要配置的部分：

* init 目录 
* DNS 配置 
* history 记录时间 
* 记录命令操作 
* 内核参数优化 
* 安装 YUM 仓库 
* 安装 zabbix-agent 

**创建 init 目录**

```bash
cd /srv/salt/base
mkdir init
cd init
mkdir files
```    

**DNS 配置**

```bash
vim dns.sls
/etc/resolv.conf:
  file.managed:
    - source: salt://init/files/resolv.conf
    - backup: minion
    - user: root
    - group: root
    - mode: 644

# 将 resolv.conf 放置在 /srv/salt/base/init/files

```    

**history 记录时间**

```bash
vim history.sls
/etc/profile:
  file.append:
    - text:
      - export HISTTIMEFORMAT="%F %T `whoami` "
```
**记录命令操作**

```bash
vim audit.sls
/etc/bashrc:
  file.append:
    - text:
      - export PROMPT_COMMAND='{ msg=$(history 1 | { read x y; echo $y; });logger "[euid=$(whoami)]":$(who am i):[`pwd`]"$msg"; }'	  
``` 

 
**内核参数优化**

```bash
vim sysctl.sls
net.ipv4.ip_local_port_range:
  sysctl.present:
    - value: 10000 65000
fs.file-max:
  sysctl.present:
    - value: 2000000
net.ipv4.ip_forward:
  sysctl.present:
    - value: 1
vm.swappiness:
  sysctl.present:
    - value: 0
```    

**安装 YUM 仓库**

```bash
cat epel.sls
yum_repo_release:
  pkg.installed:
    - sources:
      - epel-release: http://mirrors.aliyun.com/epel/epel-release-latest-7.noarch.rpm
```    

**安装配置 zabbix-agent**

```bash
vim zabbix-agent.sls
zabbix-agent:
  pkg.installed:
    - name: zabbix-agent
  file.managed:
    - name: /etc/zabbix/zabbix_agentd.conf
    - source: salt://init/files/zabbix_agentd.conf
    - template: jinja
    - defaults:
      Zabbix_Server: {{ pillar['Zabbix_Server'] }}
      Hostname: {{ grains['fqdn'] }}
    - require:
      - pkg: zabbix-agent
  service.running:
    - enable: True
    - watch:
      - pkg: zabbix-agent
      - file: zabbix-agent

zabbix_agentd.conf.d:
  file.directory:
    - name: /etc/zabbix/zabbix_agentd.d
    - watch_in:
      - service: zabbix-agent
    - require:
      - pkg: zabbix-agent
      - file: zabbix-agent

# 将 zabbix_agentd.conf 放置在 /srv/salt/base/init/files

# 上面的 SLS 中使用 jinja 模板，使用 pillar 设置 Zabbix_Server，使用 grains 设置 Hostname

# 下面详细说明配置 Zabbix_Server Pillar 的过程

# 在 /srv/pillar/base 下创建 zabbix 目录
mkdir -p /srv/pillar/base/zabbix
cd /srv/pillar/base/zabbix

# 配置 Zabbix_Server 的 pillar  SLS
vim agent.sls
Zabbix_Server: 192.168.56.11

# 创建 pillar 的 top file
cd /srv/pillar/base/
vim top.sls
base:
  '*':
    - zabbix.agent

# 刷新 pillar
salt '*' saltutil.refresh_pillar

# 获取 pillar
salt '*' pillar.items Zabbix_Server
linux-node2.example.com:
    ----------
    Zabbix_Server:
        192.168.56.11
linux-node1.example.com:
    ----------
    Zabbix_Server:
        192.168.56.11

```    

**配置 init.sls include 以上各个系统初始化分模块**

```bash
cd /srv/salt/base/init
vim init.sls
include:
  - init.dns
  - init.history
  - init.audit
  - init.sysctl
  - init.epel
  - init.zabbix-agent
```    

**base 环境根目录配置 top file**

```bash
cd /srv/salt/base
vim top.sls
base:
  '*':
    - init.init
	
	
# /srv/salt/base 最终目录结构如下：
/srv/salt/base/
├── init
│   ├── audit.sls
│   ├── dns.sls
│   ├── epel.sls
│   ├── files
│   │   ├── resolv.conf
│   │   └── zabbix_agentd.conf
│   ├── history.sls
│   ├── init.sls
│   ├── sysctl.sls
│   └── zabbix-agent.sls
└── top.sls
```    


**测试并执行状态**

>
salt '*node2*' state.highstate test=True  
salt '*node2*' state.highstate 

## 3 Salt prod 环境规划及配置

### 3.1 Salt prod 环境下 modules 常用服务功能模块配置

/srv/salt/prod/ 为生产环境 file_roots，在此级目录创建 modules 目录，用于放置各功能模块状态配置  
比如 haproxy/nginx/php/mysql/memcached 等

**创建相关 modules 目录**

```bash
mkdir -p /srv/salt/prod/modules
cd /srv/salt/prod/modules
mkdir pkg
mkdir haproxy
mkdir nginx
mkdir php
mkdir mysql
mkdir memcached
```    

**配置编译安装软件包状态 make.sls**

```bash
cd pkg
vim pkg.sls
make-pkg:
  pkg.installed:
    - pkgs:
      - gcc
      - gcc-c++
      - glibc
      - make
      - autoconf
      - openssl
      - openssl-devel
      - pcre
      - pcre-devel
```    

**配置编译安装 haproxy 的 haproxy.sls**

```bash
# 第一次写 SLS 首先要在本地手动编译安装一次以保证安装过程的正确性

cd /usr/local/src
wget http://www.haproxy.org/download/1.6/src/haproxy-1.6.3.tar.gz 
tar zxf haproxy-1.6.3.tar.gz 
cd haproxy-1.6.3
make TARGET=linux2628 PREFIX=/usr/local/haproxy-1.6.3
make install PREFIX=/usr/local/haproxy-1.6.3
ln -s /usr/local/haproxy-1.6.3 /usr/local/haproxy

# 然后配置 haproxy.init 需要修改 BIN 目录（因为编译安装时指定了目录），再添加开机启动

# 配置 net.ipv4.ip_nonlocal_bind

# 配置 /etc/haproxy 目录
```    


以上配置写成 haproxy.sls(放置在/srv/salt/prod/modules/haproxy)如下：

```yaml
include:
  - modules.pkg.make

haproxy-install:
  file.managed:
    - name: /usr/local/src/haproxy-1.6.3.tar.gz
    - source: salt://modules/haproxy/files/haproxy-1.6.3.tar.gz
    - mode: 755
    - user: root
    - group: root
  cmd.run:
    - name: cd /usr/local/src && tar zxf haproxy-1.6.3.tar.gz && cd haproxy-1.6.3 && make TARGET=linux2628 PREFIX=/usr/local/haproxy-1.6.3 && make install PREFIX=/usr/local/haproxy-1.6.3 && ln -s /usr/local/haproxy-1.6.3 /usr/local/haproxy
    - unless: test -L /usr/local/haproxy
    - require:
      - pkg: make-pkg
      - file: haproxy-install

haproxy-init:
  file.managed:
    - name: /etc/init.d/haproxy
    - source: salt://modules/haproxy/files/haproxy.init
    - mode: 755
    - user: root
    - group: root
    - require_in:
      - file: haproxy-install
  cmd.run:
    - name: chkconfig --add haproxy
    - unless: chkconfig --list | grep haproxy

net.ipv4.ip_nonlocal_bind:
  sysctl.present:
    - value: 1

/etc/haproxy:
  file.directory:
    - user: root
    - group: root
    - mode: 755
	
# 将 haproxy-1.6.3.tar.gz haproxy.init 文件放置在 /srv/salt/prod/modules/haproxy/files
mkdir -p /srv/salt/prod/modules/haproxy/files
cd /srv/salt/prod/modules/haproxy/files
[root@linux-node1 haproxy]# pwd
/srv/salt/prod/modules/haproxy
[root@linux-node1 haproxy]# tree
.
├── files
│   ├── haproxy-1.6.3.tar.gz
│   └── haproxy.init
└── install.sls


# 测试 haproxy 安装初始化状态

> 
salt '*node2*' state.sls modules.haproxy.install saltenv=prod test=True

```    

**配置编译安装 haproxy 的 haproxy.sls**

```    

### 3.2 Salt prod 环境下 cluster 业务模块配置

/srv/salt/prod/ 为生产环境 file_roots，在此级目录创建 cluster 目录，用于放置业务模块状态配置  
比如 haproxy/nginx/php/mysql/memcached 等

**创建相关 cluster 目录**

mkdir /srv/salt/prod/cluster
cd /srv/salt/prod/cluster
mkdir files


**配置外部集群中 haproxy 服务器状态文件 haproxy-outside.sls**

vim haproxy-outside.sls
include:
  - modules.haproxy.install

haproxy-service:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://cluster/files/haproxy-outside.cfg
    - user: root
    - group: root
    - mode: 644
  service.running:
    - name: haproxy
    - enable: True
    - reload: True
    - require:
      - cmd: haproxy-install
    - watch:
      - file: haproxy-service

# 将 haproxy-outside.cfg 放置在 /srv/salt/prod/cluster/files
# haproxy-outside.cfg 内容如下：

global
maxconn 100000
chroot /usr/local/haproxy
uid 99
gid 99
daemon
nbproc 1
pidfile /usr/local/haproxy/logs/haproxy.pid
log 127.0.0.1 local3 info
defaults
option http-keep-alive
maxconn 100000
mode http
timeout connect 5000ms
timeout client 50000ms
timeout server 50000ms
listen stats
mode http
bind 0.0.0.0:9999
stats enable
stats uri /haproxy-status
stats auth haproxy:saltstack
frontend frontend_www_example_com
bind 192.168.56.21:80
mode http
option httplog
log global
default_backend backend_www_example_com
backend backend_www_example_com
option forwardfor header X-REAL-IP
option httpchk HEAD / HTTP/1.0
balance source

server web-node1 192.168.56.11:8080 check inter 2000 rise 30 fall 15
server web-node2 192.168.56.12:8080 check inter 2000 rise 30 fall 15	 
     
# 测试外部集群中 haproxy 服务器对外提供服务器的状态

salt '*node2*' state.sls cluster.haproxy-outside saltenv=prod


```   
