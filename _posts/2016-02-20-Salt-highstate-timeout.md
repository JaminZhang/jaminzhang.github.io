---
layout: post
title: Salt state.highstate 超时
description: "Salt state.highstate 超时"
category: SaltStack
avatarimg:
tags: [SaltStack, highstat, timeout]
duoshuo: true
---


# 引言
最近 2 天在编写 Salt 状态文件时，执行 state.highstate 出现超时问题。具体说明如下。


# Salt state.highstate 超时


在执行 `salt "IP" state.highstate test=True` 提示如下：  
`Minion did not return. [Not connected]`  
使用 salt test.ping 是通的。  
下面我们执行 `salt "IP" state.highstate test=True --async`，使用异步方式。  
过会再去查看 job 执行结果。
使用 `salt-run jobs.lookup_jid JID` 查看 job 执行情况，可以看到状态是执行了的。

所以上面的提示 `Minion did not return. [Not connected]` 应该是超时的问题，查看了下，配置文件中配置的超时时间是 30s。  
当通过 state.sls 执行 top file 中指定的状态时，用时是 40 多秒，所以超时了。  
这里我们可以加个 -t 参数指定超时时间。比如：  
`salt "IP" state.highstate test=True -t 60`，这样就不会提示 `Minion did not return. [Not connected]` 了。

