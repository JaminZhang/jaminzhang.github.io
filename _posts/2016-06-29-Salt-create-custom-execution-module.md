---
layout: post
title: Salt 创建自定义的执行模块
description: "SaltStack 创建自定义的执行模块"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
之前 Salt 远程执行的学习谈到了可以创建自定义的执行模块（一个模块实际就是一个 Python 文件），现在我们来实际配置下。  

# 1 Salt Modules 模块放置目录

* 系统模块放置在 /usr/lib/python2.7/site-packages/salt/modules/
* 自定义模块放置在 /srv/salt/_modules （不存在时需创建）

# 2 编写模块（即编写 Python 文件）

Python 文件名是模块名。
下面我们写一个简单的示例文件 my_disk.py

```python
#!/usr/bin/env python
# -*- conding: utf-8 -*-

def list():
    cmd = 'df -h'
    ret = __salt__['cmd.run'](cmd)
    return ret
```    
# 3 刷新同步模块

```bash
# 使用 saltutil.sync_modules
[root@linux-node1 _modules]# salt '*' saltutil.sync_modules
linux-node1.example.com:
    - modules.my_disk
linux-node2.example.com:
    - modules.my_disk

# 可以在 minion 相关目录看到同步过去的模块
[root@linux-node1 _modules]# tree /var/cache/salt/minion/
/var/cache/salt/minion/
├── extmods
│   └── modules
│       └── my_disk.py
├── files
│   └── base
│       └── _modules
│           └── my_disk.py
├── module_refresh
├── pkg_refresh
└── proc

[root@linux-node2 ~]# tree /var/cache/salt/minion/
/var/cache/salt/minion/
├── accumulator
├── extmods
│   └── modules
│       └── my_disk.py
├── files
│   └── base
│       ├── apache.sls
│       └── _modules
│           └── my_disk.py
├── highstate.cache.p
├── module_refresh
├── pkg_refresh
├── proc
└── sls.p
```    


# 4 执行自定义模块

执行命令及结果如下：

```bash
[root@linux-node1 _modules]# salt '*' my_disk.list
linux-node2.example.com:
    Filesystem               Size  Used Avail Use% Mounted on
    /dev/mapper/centos-root   48G  1.6G   46G   4% /
    devtmpfs                 907M     0  907M   0% /dev
    tmpfs                    917M   12K  917M   1% /dev/shm
    tmpfs                    917M  8.5M  908M   1% /run
    tmpfs                    917M     0  917M   0% /sys/fs/cgroup
    /dev/sda1                497M  168M  329M  34% /boot
    tmpfs                    184M     0  184M   0% /run/user/0
linux-node1.example.com:
    Filesystem               Size  Used Avail Use% Mounted on
    /dev/mapper/centos-root   48G  2.1G   46G   5% /
    devtmpfs                 907M     0  907M   0% /dev
    tmpfs                    917M   28K  917M   1% /dev/shm
    tmpfs                    917M   17M  900M   2% /run
    tmpfs                    917M     0  917M   0% /sys/fs/cgroup
    /dev/sda1                497M  168M  329M  34% /boot
    tmpfs                    184M     0  184M   0% /run/user/0
```    
