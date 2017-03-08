---
layout: post
title: Redis 持久化
description: "Redis 持久化"
category: NoSQL
avatarimg:
tags: [Redis, Persistence, RDB, AOF]
duoshuo: true
---

# 引言

<pre>

Redis 虽然是一种内存型数据库，一旦服务器进程退出，数据库的数据就会丢失，
为了解决这个问题 Redis 提供了两种持久化的方案，将内存中的数据保存到磁盘中，避免数据的丢失。

</pre>

# RDB 持久化

<pre>

redis 提供了 RDB 持久化的功能，这个功能可以将 redis 在内存中的的状态保存到硬盘中，
它可以手动执行，也可以再 redis.conf 中配置，定期执行。

RDB 持久化产生的 RDB 文件是一个经过压缩的二进制文件，这个文件被保存在硬盘中，
redis 可以通过这个文件还原数据库当时的状态。

</pre>

## RDB 的创建与载入

RDB 文件可以通过两个命令来生成：

* SAVE: 阻塞 redis 的服务器进程，直到 RDB 文件被创建完毕。
* BGSAVE: 派生(fork)一个子进程来创建新的 RDB 文件，记录接收到 BGSAVE 当时的数据库状态，
  父进程继续处理接收到的命令，子进程完成文件的创建之后，会发送信号给父进程，而与此同时，父进程处理命令的同时，通过轮询来接收子进程的信号。

而 RDB 文件的载入一般情况是自动的，redis 服务器启动的时候，redis 服务器再启动的时候如果检测到 RDB 文件的存在，那么 redis 会自动载入这个文件。

如果服务器开启了 AOF 持久化，那么服务器会优先使用 AOF 文件来还原数据库状态。

RDB 是通过保存键值对来记录数据库状态的，采用 copy on write 的模式，每次都是全量的备份。

## 自动保存间隔

BGSAVE 可以在不阻塞主进程的情况下完成数据的备份。可以通过 redis.conf 中设置多个自动保存条件，只要有一个条件被满足，服务器就会执行 BGSAVE 命令。

```bash

# 以下配置表示的条件：
# 服务器在 900 秒之内被修改了 1 次
save 900 1
# 服务器在 300 秒之内被修改了 10 次
save 300 10
# 服务器在 60 秒之内被修改了 10000 次
save 60 10000

```    

# AOF 持久化

AOF 持久化（Append-Only-File），与 RDB 持久化不同，AOF 持久化是通过保存 Redis 服务器锁执行的写状态来记录数据库的。  

具体来说，**RDB 持久化相当于备份数据库状态，而 AOF 持久化是备份数据库接收到的命令，所有被写入 AOF 的命令都是以 redis 的协议格式来保存的。**  

在 AOF 持久化的文件中，数据库会记录下所有变更数据库状态的命令，除了指定数据库的 select 命令，其他的命令都是来自 client 的，
这些命令会以追加(append)的形式保存到文件中。  

服务器配置中有一项 appendfsync，这个配置会影响服务器多久完成一次命令的记录：

* always：将缓存区的内容总是即时写到 AOF 文件中。
* everysec：将缓存区的内容每隔一秒写入 AOF 文件中。
* no ：写入 AOF 文件中的操作由操作系统决定，一般而言为了提高效率，操作系统会等待缓存区被填满，才会开始同步数据到磁盘。

redis 默认使用的是 everysec。  

redis 在载入 AOF 文件的时候，会创建一个虚拟的 client，把 AOF 中每一条命令都执行一遍，最终还原回数据库的状态，它的载入也是自动的。  
在 RDB 和 AOF 备份文件都有的情况下，redis 会优先载入 AOF 备份文件。  

AOF 文件可能会随着服务器运行的时间越来越大，可以利用 AOF 重写的功能，来控制 AOF 文件的大小。
AOF 重写功能会首先读取数据库中现有的键值对状态，然后根据类型使用一条命令来替代之前的键值对多条命令。  

AOF 重写功能有大量写入操作，所以 redis 才用子进程来处理 AOF 重写。  
这里带来一个新的问题，由于处理重写的是子进程，这样意味着如果主线程的数据在此时被修改，备份的数据和主库的数据将会有不一致的情况发生。  
因此 redis 还设置了一个 AOF 重写缓冲区，这个缓冲区在子进程被创建开始之后开始使用，
这个期间，所有的命令会被存两份，一份在 AOF 缓存空间，一份在 AOF 重写缓冲区，
当 AOF 重写完成之后，子进程发送信号给主进程，通知主进程将 AOF 重写缓冲区的内容添加到 AOF 文件中。

## 相关配置

```bash

# AOF 和 RDB 持久化方式可以同时启动并且无冲突。  
# 如果 AOF 开启，启动 redis 时会加载 aof 文件，这些文件能够提供更好的保证。 
appendonly yes

# 只增文件的文件名称。（默认是 appendonly.aof）  
# appendfilename appendonly.aof 
# redis支持三种不同的写入方式：  
#  
# no: 不调用，等待操作系统来清空缓冲区当操作系统要输出数据时。很快。  
# always: 每次更新数据都写入只增日志文件。慢，但是最安全。
# everysec: 每秒调用一次。折中。
appendfsync everysec  

# 设置为 yes 表示 rewrite 期间对新写操作不 fsync，暂时存在内存中，等 rewrite 完成后再写入。
# 官方文档建议如果你有特殊的情况可以配置为'yes'。但是配置为'no'是最为安全的选择。
no-appendfsync-on-rewrite no  

# 自动重写只增文件。  
# redis 可以自动调用‘BGREWRITEAOF’来重写日志文件，如果日志文件增长了指定的百分比。  
# 当前 AOF 文件大小是上次日志重写得到 AOF 文件大小的二倍时，自动启动新的日志重写过程。
auto-aof-rewrite-percentage 100  
# 当前 AOF 文件启动新的日志重写过程的最小值，避免刚刚启动 Reids 时由于文件尺寸较小导致频繁的重写。
auto-aof-rewrite-min-size 64mb

```    

# 对比

* AOF 更安全，可将数据及时同步到文件中，但需要较多的磁盘 IO，AOF 文件尺寸较大，文件内容恢复相对较慢， 也更完整。
* RDB 持久化，安全性较差，它是正常时期数据备份及 master-slave 数据同步的最佳手段，文件尺寸较小，恢复数度较快。


# Ref
[Redis Persistence](http://redis.io/topics/persistence)  
[Redis 持久化](http://redisdoc.com/topic/persistence.html)
[Redis 持久化](http://www.jianshu.com/p/bedec93e5a7b)  
