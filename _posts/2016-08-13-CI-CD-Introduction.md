---
layout: post
title: 持续集成、持续交付、持续部署简介
description: "持续集成、持续交付、持续部署简介"
category: CI/CD
avatarimg:
tags: [CI, CD]
duoshuo: true
---

# 前言

之前说过持续集成，现在我们可以看看持续集成后续的持续交付、持续部署概念。

# 持续集成

持续集成(Continuous Integration)是指在软件开发过程中，频繁地将代码集成到主干上，然后进行自动化测试。

![Continuous Integration](http://jaminzhang.github.io/images/CI-CD/Contiunous-Integration.png)  

# 持续交付

持续交付(Continuous Delivery)是指在持续集成的基础上，将集成后的代码部署到更贴近真实运行环境的“类生产环境”（production-like environments）中。
比如，我们完成单元测试后，可以把代码部署到连接数据库的 Staging 环境中进行更多的测试。如果代码没有问题，可以继续手动部署到生产环境中。

![Continuous Delivery](http://jaminzhang.github.io/images/CI-CD/Continuous-Delivery.png)  

# 持续部署

持续部署(Continuous Deploy)是在持续交付的基础上，把部署到生产环境的过程自动化。持续部署和持续交付的区别就是最终部署到生产环境是自动化的。

![Continuous Deploy](http://jaminzhang.github.io/images/CI-CD/Continuous-Deploy.png)  

# Ref
[持续集成、持续交付、持续部署简介](https://www.unixhot.com/article/57)  
