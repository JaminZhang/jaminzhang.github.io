---
layout: post
title: Sonar 简介
description: "Sonar 简介"
category: CI/CD
avatarimg:
tags: [CI/CD, Sonar]
duoshuo: true
---

# Sonar 简介

<pre>
Sonar 是一个用于代码质量管理的开放平台。通过插件机制，Sonar 可以集成不同的测试工具，代码分析工具，以及持续集成工具。
与持续集成工具（例如 Hudson/Jenkins 等）不同，Sonar 并不是简单地把不同的代码检查工具结果（例如 FindBugs，PMD 等）
直接显示在 Web 页面上，而是通过不同的插件对这些结果进行再加工处理，通过量化的方式度量代码质量的变化，
从而可以方便地对不同规模和种类的工程进行代码质量管理。
在对其他工具的支持方面，Sonar 不仅提供了对 IDE 的支持，可以在 Eclipse 和 IntelliJ IDEA 这些工具里联机查看结果；
同时 Sonar 还对大量的持续集成工具提供了接口支持，可以很方便地在持续集成中使用 Sonar。
此外，Sonar 的插件还可以对 Java 以外的其他编程语言提供支持，对国际化以及报告文档化也有良好的支持。
</pre>

>
Sonar 现在改名叫 SonarCube。

# Sonar 架构图

![SQArchitecture](http://docs.sonarqube.org/download/attachments/6962415/SQArchitecture5.5.png)  


# Sonar 与其他系统集成

![SQ55Integration](http://docs.sonarqube.org/download/attachments/6962415/SQ55Integration.png)  


# Ref
[SonarQube 官网](http://www.sonarqube.org/)  
[Architecture and Integration](http://docs.sonarqube.org/display/SONAR/Architecture+and+Integration)  
[使用 Sonar 进行代码质量管理](https://www.ibm.com/developerworks/cn/java/j-lo-sonar/)  
