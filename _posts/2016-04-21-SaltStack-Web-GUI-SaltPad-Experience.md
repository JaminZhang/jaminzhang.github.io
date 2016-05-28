---
layout: post
title: SaltStack Web GUI之SaltPad体验
description: "SaltStack Web GUI之SaltPad体验"
category: SaltStack
avatarimg:
tags: [SaltStack]
duoshuo: true
---

# 引言
最近有个需求，海外服务器独立出来用另一套SaltStack，业务运维人员现在是登录salt-master命令行方式执行相关维护操作。
所以开始调研SaltStack是否有开源的WebGUI实现。

# SaltStack WebGUI的几种实现方式
## 1. Halite
这个是SaltStack官方推出的，不过现在已经弃用不再维护更新了，看截图，其界面信息量太大，学习门槛高，必须对salt很熟悉。
听说SaltStack企业版中有WebGUI。

## 2. SaltPad
界面简洁美观，对用户较友好。GitHub上加星300多，说明还是有很多人在关注，但现在还是Alpha测试阶段，bug较多，部署起来并不简单。

## 3. Molten
使用方式和Halite类似，其界面稍微比Halite简洁友好。

## 4.Foreman的saltstack支持插件
Foreman系统实现的功能较多，用其中的一个saltstack插件来管理，实在是杀鸡用牛刀。

## 5.自己开发SaltStack系统
如果有相关的DevOps人员，可以让其根据自己的公司的运维系统来开发。  
现在的一个情况是好多人想通过WebGUI来使用SaltStack，但他们并没有DevOps的相关人员。

综上各种情况，我先选择体验SaltPad.

# SaltPad部署
这个到官方GitHub网址，看README吧，这里我就不详述了。

部署中我遇到了问题，作者写的README中有些错误，我提了一个[issue](https://github.com/Lothiraldan/saltpad/issues/158)，
然后作者fix了，发布了Pre-alpha 3.1。

# SaltPad使用体验
我部署成功登录进去进行使用，我的感觉是它的这个使用逻辑和我公司的运维系统不一样，我起初想的是先选定minion，对minion执行命令操作。  
但SaltPad并不是这样的逻辑，它的minion列表是不可做选定操作的。你不能在minion列表中选择minion来执行命令。  
你要执行命令是在Run Job模块中选择指定minion来执行命令（现在好像还只能选择一个minion）。  

我觉得它的一个使用逻辑是使用任务模板，在任务模板中指定目标、命令等，然后点击按钮执行，这个是把重复执行的命令提取成一个模板的思想。

总结：还是在Alpha阶段的SaltPad，可能bug很多，使用逻辑也需要学习下，没有DevOps人员开发和minion数量不大的情况下，  
我觉得可以了解使用下。

# Ref  
[Saltpad: A saltstack Web GUI](https://speakerdeck.com/lothiraldan/saltpad-a-saltstack-web-gui)  
[SaltPad](https://github.com/Lothiraldan/saltpad)  
[While visiting saltpad it returns blank page (using v0.3 release version )](https://github.com/Lothiraldan/saltpad/issues/158)  



