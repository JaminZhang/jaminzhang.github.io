---
layout: post
title: Git 分支模型
description: "Git 分支模型"
category: Git
avatarimg:
tags: [Git, CI]
duoshuo: true
---

# 引言
之前简单介绍了持续集成的概念，当我们计划在生产上使用 CI 时，必须考虑的是一个问题是如何从 SCM（Git/SVN等） 中拉取代码到 CI Server上。

# CI Server 拉取代码的 3 种方案

1. git pull 拉取最新代码，适用于更新非常频繁的情况，这时没有严格的项目管理。
2. git tag 获取指定标签的代码，适用于更新没那么频繁的情况，有一定的项目管理。
3. 获取指定的 commit id 的代码。

>
大公司版本发布不那么频繁，一是因为本来就比较稳定，另外会有一些规定，如周五不发布，节假日封版本不发布等。

由以上延伸的是 Git 分支的管理策略。这里我们来学习下。

# Git 分支的管理策略

## 1. 主分支 Master

首先，代码库应该有一个、且仅有一个主分支。所有提供给用户使用的正式版本，都在这个主分支上发布。  

Git 主分支的名字，默认叫做 Master。它是自动建立的，版本库初始化以后，默认就是在主分支在进行开发。


## 2. 开发分支 Develop

主分支只用来分布重大版本，日常开发应该在另一条分支上完成。我们把开发用的分支，叫做 Develop。  

这个分支可以用来生成代码的最新隔夜版本（nightly）。如果想正式对外发布，就在 Master 分支上，对Develop分支进行"合并"（merge）。


## 3. 临时性分支

前面讲到版本库的两条主要分支：Master 和 Develop 。前者用于正式发布，后者用于日常开发。其实，常设分支只需要这两条就够了，不需要其他了。  

但是，除了常设分支以外，还有一些临时性分支，用于应对一些特定目的的版本开发。临时性分支主要有三种：

* 功能（feature）分支
* 预发布（release）分支
* 修补 bug（fixbug）分支

这三种分支都属于临时性需要，使用完以后，应该删除，使得代码库的常设分支始终只有 Master 和 Develop。

## 4. 功能分支

接下来，一个个来看这三种"临时性分支"。  
第一种是功能分支，它是为了开发某种特定功能，从 Develop 分支上面分出来的。开发完成后，要再并入 Develop。
功能分支的名字，可以采用 feature-* 的形式命名。

## 5. 预发布分支

第二种是预发布分支，它是指发布正式版本之前（即合并到 Master 分支之前），我们可能需要有一个预发布的版本进行测试。
预发布分支是从 Develop 分支上面分出来的，预发布结束以后，必须合并进 Develop 和 Master 分支。它的命名，可以采用 release-* 的形式。

## 6. 修补 bug 分支
最后一种是修补 bug 分支。软件正式发布以后，难免会出现 bug。这时就需要创建一个分支，进行 bug 修补。
修补 bug 分支是从 Master 分支上面分出来的。修补结束以后，再合并进 Master 和 Develop 分支。它的命名，可以采用 fixbug-* 的形式。

以下图示了以上介绍的各种分支之间的关系
![Git branching model](http://nvie.com/img/git-model@2x.png)  

>
运维要做自动化部署时一定要对 git 熟悉，不然就做不了，因为在推进的过程中是要跟开发合作，有时还要说服他们。

以上内容来自以下文章，写得不错，推荐阅读。  
[Git分支管理策略](http://www.ruanyifeng.com/blog/2012/07/git.html)  
[A successful Git branching model](http://nvie.com/posts/a-successful-git-branching-model/)  
