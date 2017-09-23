---
layout: post
title: CentOS 下安装 Python 3.X/PIP/Git 2.X
description: "CentOS 下安装 Python 3.X/PIP/Git 2.X"
category: Python
avatarimg:
tags: [Python, PIP, Git]
duoshuo: true
---

# 安装依赖

`yum install -y gcc openssl openssl-devel sqlite-devel xml2 libxml2-devel libxslt libxslt-devel python-pyasn1 libffi-devel python-pyasn1-modules `

 
# 安装 Python 3.X 和 PIP (Python 3 自带 PIP)

```bash

wget https://www.python.org/ftp/python/3.5.3/Python-3.5.3.tgz
tar xzvf Python-3.5.3.tgz
cd Python-3.5.3
./configure 
make
make install

python3
pip3 --version

```    

# 安装 Git 2.X

```bash

## 安装依赖(依据实际需求，这里我要使用)
yum install libcurl-devel -y
yum install expat-devel perl-ExtUtils-MakeMaker -y

wget https://www.kernel.org/pub/software/scm/git/git-2.9.5.tar.gz
tar xzvf git-2.9.5.tar.gz
cd git-2.9.5
./configure 
make
make install

mv /usr/bin/git /usr/bin/git-1.7    # 备份旧版本 Git 
git --version   # Git 默认编译安装在 /usr/local/bin/

```    


# Ref
[Redhat/Centos/Fedora 下 Python, Pip 和 Git 的安装](https://python.freelycode.com/contribution/detail/284)  
