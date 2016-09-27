---
layout: post
title: salt minion pulic key冲突
description: "SaltStack file 模块使用"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# SaltStack file 模块 append 方法用例

需要写一个添加 SSH 公钥到部分服务器的状态文件。使用 Salt file 模块 append 方法。
SLS 文件内容如下：

```bash
[root@localhost custom]# cat add_test_key.sls 
Add-test-ssh-key:
  file.append:
    - name: /root/.ssh/.keys
    - text:
      - "#test"     # 注意此处，当时这里没加上双引号，导致这行没有加上，如果要追加的行首是 # 号，刚需要将此行用双引号引起来
      - environment="SSH_USER=test" ssh-dss AAAAB3+xBhAo...省略...HFGoiETbIz+f6Ty4Q5j6uUhN+08= test@test.com
```    


#Ref 
[SALT.MODULES.FILE](https://docs.saltstack.com/en/latest/ref/modules/all/salt.modules.file.html)
