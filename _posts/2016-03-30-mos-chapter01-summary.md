---
layout: post
title: 《现代操作系统》学习笔记-第1章
description: "《现代操作系统》学习笔记-第1章"
category: OS
avatarimg:
tags: [Book, OS, ReadingNotes]
duoshuo: true
---

# 课后习题

1.什么是多道程序设计？  
Multiprogramming is the rapid switching of the CPU between multiple processes in memory. It is commonly used to keep the CPU busy while one or more processes are doing I/O.

2.什么是SPOOLing？读者是否认为将来的高级个人计算机会把SPOOLing作为标准功能？  
Input spooling is the technique of reading in jobs, for example, from cards, onto the disk, so that when the currently executing processes are finished, there will be work waiting for the CPU. Output spooling consists of first copying printable files to disk before printing them, rather than printing directly as the output is generated. Input spooling on a personal computer is not very likely, but output spooling is.

3.在早期计算机中，每个字节的读写直接由CPU处理（即没有DMA）。对于多道程序设计而言这种组织方式有什么含义？  
The prime reason for multiprogramming is to give the CPU something to do while waiting for I/O to complete. If there is no DMA, the CPU is fully occupied doing I/O, so there is nothing to be gained (at least in terms of CPU utilization) by multiprogramming. No matter how much I/O a program does, the CPU will be 100% busy. This is of course assume the major delay is the wait while data are copied. A CPU could do other work if the I/O were slow for other reasons (arriving on serial line, for instance).

4.系列计算机的思想在20世纪60年代由IBM引入进System/360大型机。现在这种思想已经消亡还是继续活跃着？  
It is still alive. For example, Intel makes Pentium I, II, and III, and 4 CPUs with a variety of different properites including spped and power consumption.  All of these machines ar architecturally compatible. They differ only in price and perfermance, which is the essence of the family idea.

5.缓慢采用GUI的一个原因是支持它的硬件的成本（高昂）。为了支持25行80列字符的单色文本屏幕应该需要多少视频RAM？对于1024x768像素24位色彩位图需要多少视频RAM？在1989年（$5/KB）这些RAM的成本是多少？现在它的成本是多少？  
A 25x80 character monochrome text screen requires a 2000-byte buffer. 25*80=2000
The 1024x768 pixel 24-bit color bitmap requires 2359296 bytes. 1024*768*24/8=2359296
In 1980 these two options would have cost $10 and $11520, respectively. 2000*5/1024=9.77 2359296*5/1024=11520
For current prices, check on how much RAM currently costs, probably less than $1/MB.

6.在建立一个操作系统时有几个设计目的，例如资源利用、及时性，健壮性等。请列举两个可能互相矛盾的设计目的。  
Consider fairness and real time. Fairness requires that each process be allocated it resources in a fair way, with no process getting more than its fair share. On the other hand, real time requires that resources be allocated based on the times when different processes must complete their execution. A real time process may get a disproportionate share of the resources.

7.下面哪一条指令只能在内核态中使用？  
a)禁止所有的中断。
b)读日期-时间时钟。
c)设置日期-时间时钟。
d)改变存储器映像。

acd

8.考虑一个有两个CPU的系统，并且每一个CPU有两个线程（超线程）。假设有三个程序P0,P1,P2，分别以运行时间5ms,10ms,20ms开始。运行这些程序需要多少时间？假设这三个程序都是100%限于CPU，在运行时无阻塞，并且一旦设定就不改变CPU。  

It may take 20, 25, 30 or 35 msec to complete the execution of these programs
depending on how the operating system schedules them. If P0 and P1 are
scheduled on the same CPU and P2 is scheduled on the other CPU, it will
take 20 mses. If P0 and P2 are scheduled on the same CPU and P1 is
scheduled on the other CPU, it will take 25 msec. If P1 and P2 are scheduled
on the same CPU and P0 is scheduled on the other CPU, it will take 30 msec.
If all three are on the same CPU, it will take 35 msec.


9.一台计算机有一个四级流水线，每一级都花费相同的时间执行其工作，即1ns。这台机器每秒可执行多少条指令？  
Every nanosecond one instruction emerges from the pipeline. This means the
machine is executing 1 billion instructions per second. It does not matter at
all how many stages the pipeline has. A 10-stage pipeline with 1 nsec per
stage would also execute 1 billion instructions per second. All that matters is
how often a finished instruction pops out the end of the pipeline.

10.假设一个计算机系统有高速缓存、内存（RAM）以及磁盘，操作系统用虚拟内存。读取缓存中的一个词需要2ns，RAM需要10ns，磁盘需要10ms。如果缓存的命中率是95%，内存的是（缓存失效）99%，读取一个词的平均时间是多少？  

Average access time =
0.95 × 2 nsec (word is cache)
+ 0.05 × 0.99 × 10 nsec (word is in RAM, but not in cache)
+ 0.05 × 0.01 × 10,000,000 nsec (word on disk only)
= 5002.395 nsec
= 5.002395 μsec

11.一位校对人员注意到在一部将要出版的操作系统教科书手稿中有一个多次出现的拼写错误。这本书大致有700页。每页50行，一行80个字符。若把文稿用电子扫描，那么，主副本进入图1-9中的每个存储系统的层次要花费多少时间？对于内存储方式，考虑所给定的存取时间是每次一个1024字符的盘块，而对于磁带，假设给定开始时间后的存取时间和和磁盘存储时间相同。  
The manuscript contains 80 X 50 X 700 = 2.8 million characters. This is, of course, impossible to fit into the registers of any currently available CPU and is too big for a 1-MB cache, but if such hardware were available, the manuscript could be scanned in 2.8 msec ( 2.8 X 10^6 X 10^-9 s) from the registers or 5.8 msec (2.8 X 10^6 X 2 X 10^-9 s) from the cache. There are approximately 2700 ( 2.8 X 10^6 % 1024 = 2735 ) 1024-byte blocks of data, so scanning from the disk would require about 27 seconds (2700 X 10 X 10^-3= 27s ), and from tape 2 minutes 7 senconds 
( 100 + 27 = 127s tape不考虑读入时的文件大小？ ).

12.**在用户程序进行一个系统调用，以读写磁盘文件时，该程序提供指示说明了所需要的文件，一个指向数据缓冲区的指针以及计数。然后，控制权转给操作系统，它调用相关的驱动程序。假设驱动程序启动磁盘并且直到中断发生才终止。在从磁盘读的情况下，很明显，调用者会被阻塞（因为文件中没有数据）。在向磁盘写时会发生什么情况？需要把调用者阻塞一直等到磁盘传送完成为止吗？  
Maybe. If the caller get control back and immediately overwrites the data, when the write finally occurs, the wrong data will be written. However, if the driver first copied the data to a private buffer before returning, then the caller can be allowed to continue immediately. Another possiblity is to allow the caller to continue and give it a singal when the buffer may be used, but this is tricky and error prone.


13.什么是陷阱指令？在操作系统中解释它的用途。  
A trap instruction switches the execution mode of a CPU from the user mode to the kernel mode. This instruction allow a user program to invoke functions in the operation system kernel.

14.陷阱和中断的主要差别是什么？  
A trap is caused by the program and is synchronous with it. If the program is run again and again, the trap will always occur exactly the same position in the instruction stream. An interrupt is caused by an external event and its timing is not reproducible.

15.在分时系统中为什么需要进程表？在只有一个进程存在的个人计算机系统中，该进程控制整个机器直到进程结束，这种机器也需要进程表吗？  
The process table is needed to store the state of a process that is currently suspended, either ready or blocked. It is not needed in a single process system because the single process is never suspended.

16.说明有没有理由要在一个非空的目录中安装一个文件系统？如果要这样做，如何做？  
Mounting a file system makes any files already in the mount point directory inaccessible, so mount points are normally empty. However, a system administrator might want to copy some of the most important files normally located in the mounted directory to the mount point so they could be  found in their noraml path in an emergency when the mounted device was being repaired.

17.在一个操作系统中系统调用的目的是什么？  
A system call allows a user process to access and execute operating system functions indside the kernel. User programs use system calls to invoke operating system services.

18.对于下列系统调用，给出引起失败的条件：fork、exec以及unlink。  
Fork can fail if there are no free slot left in the process table (and possibley if there is no memory or swap space left).
Exec can fail if the file name given does not exist or is not a valid executable file.
Unlink can fail if the file to be unlinked does not exist or the calling process does not have authority to unlink it.

19.在count = write(fd, buffer, nbytes);调用中，能在count中而不是nbytes中返回值吗？如果能，为什么？  
If the call fails, for example because fd is incorrect, it can return -1. It can also fail because the disk is full and it is not possible to write the number of bytes requested. On a correct termination, it always return nbytes.

20.有一个文件，其文件描述符是fd，内含字节序列：3,1,4,1,5,9,2,6,5,3,5。有如下系统调用：lseek(fd,3,SEEK_SET); read(fd,&buffter,4);
其中lseek调用寻找文件中的字节3。在读操作完成后，buffer中的内容是什么？  
It contains the bytes: 1, 5, 9, 2.

21.假设一个10MB的文件存在磁盘连续扇区的同一个轨道上（轨道号：50）。磁盘的磁头臂此时位于第100号轨道。要想从磁盘上找回这个文件，需要多长时间？假设碰头臂从一个柱面移动到下一个柱面需要1ms，当文件的开始部分存储在的扇区旋转到磁头下需要5ms，并且读的速率是100MB/s。  
(100-50)*1ms+5ms+10MB/100MB/s=55ms+0.1X10^3ms=155ms

Time to retrieve the file =
1 * 50 ms (Time to move the arm over track # 50)
+ 5 ms (Time for the first sector to rotate under the head)
+ 10/100 * 1000 ms (Read 10 MB)
= 155 ms

22.块特殊文件和字符特殊文件的基本差别是什么？  
Block special files consist of numbered blocks, each of which can be read or written independently of all the other ones. It is possible to seek to any block and start reading and writing. This is not possible with character specical files.

23.在图1-17的例子中库调用称为read，而系统调用自身称为read。这两者都有相同的名字是正常的吗？如果不是，哪一个更重要？  
System calls do not really have names, other than in a documentation sence.
When the libray procedure read traps to the kernel, it puts the number of the system call in a register ro on the stack. This number is used to index into a table. There is really no name used anywhere. On the other hand, the name of the library procedure is very import, since this is what appears in the program.

24.在分布式系统中，客户机-服务器模式很普遍。这种模式能用在单个计算机的系统中吗？  
Yes it can, especially if the kernel is message-passing system.

25.对于程序员而言，系统调用就像对其他库过程的调用一样。有无必要让程序员了解哪一个库过程导致了系统调用？在什么情形下，为什么？  
As far as program logic is concerned it does not matter whether a call to a library procedure results in a system call. But if perfermance is an issue, if a task can be accomplished without  a system call the program will run faster. Every system call involves overhead time in switching from the user context to the kernel context. Furthermore, on a multiuser system the operatiing system may schedule another process o run when a system call completes, further slowing the progress in real time of a calling process.

26.图1-23说明有一批UNIX的系统调用没有与之相等价的Win32 API。对于所列出的每一个没有Win32等价的调用，若程序员要把一个UNIX程序转换到Windows下运行，会有什么后果？  
Serval UNIX calls have no counterpart in the Win32 API:
Link: a Win32 program cannot refer to a file by an alternative name or see it in more than one directory. Also, attempting to create a link is a convenient way to test fro and create a lock on a file.
Mount and umount: a Windows program cannot make assumptions about standard path names because on systems with multiple disk drives the drive name  part of the path may be different.
Chmod: Windows uses access control lists
Kill: Windows programmers cannot kill a misbehaving program that is not cooperating.

27.可移植的操作系统是能从一个系统体系结构到另一个体系结构的移动不需要任何修改的操作系统。请解释为什么建立一个完全可移植性的操作系统是不可行的。描述一下在设计一个高度可移植的操作系统时你设计的高级的两层是什么样的。  
Every system architecture has its own set of instructions that it can execute. Thus a Pentumn cannot excute SPARC programs and SPARC cannot execute Pentium programs. Also, different architectures differ in bus architecture used (such as VME, ISA, PCI, MCA, SBus, ..) as well as the word size of the CPU (usually 32 or 64 bit). Because of these differences in hardware, it is not feasible to build an operating system that is completely portable. A highly portable operating system will consist of two high-level layers---a machine-dependent layer and a machine independent layer.
The machine-dependent layer addresses the specifics of the hardware, and must be implemented separately for every architecture. This layer provides a uniform interface on which the machine-independent layer is built. The machine-independent layer has to be implemented only onece. To be highly protable, the size of the machine-dependent layer must be kept as small as possible. 


28.请解释在建立基于微内核的操作系统时策略与机制的分离带来的好处。  
Separation of policy and mechanism allows OS designers to implement a small number of basic primitives in the kernel. These primitives are simpified, because they are not dependent of any specific policy. They can then be used to implement more complex mechanisms and policies at the user level.

29.下面是单位转换的练习：  
a)一微年是多少秒？  
b)微米常称为micron。那么gigamicron是多长？  
c)1TB存储器有多少字节？  
d)地球的质量是6000yottagram，换算成kilogram是多少？  

a) A micro year is 10^-6 X 365 X 24 X 3600 = 31.536 sec.  
b) 10^9*10^-6=1000m  
c) 2^10 X 2^10 X 2^10 X 2^10 = 2^40 Bytes  
d) 6000 X 10^24 X 10^-3 = 6 X 10^24 kilogram  

30.写一个各图1-19类似的shell，但是包含足够的实际可工作的代码，这样读者可以测试它。读者还可以添加某些功能，如输入输出重定向、管道以及后台作业等。  

31.如果读者拥有一个个人UNIX类操作系统（Linux/MINIX/FreeBSD等），可以安全地崩溃和再启动，请写一个可以试图创建一个无限制数量子进程的shell脚本并观察所发生的事。在运行实验之前 ，通过shell键入sync，在磁盘上备份好文件缓冲区以避免毁坏文件系统。（注意：在没有得到系统管理呐的允许之前，不要在分时系统上进行这一尝试。其后果将会立即发生，尝试者可能会被抓住并受到惩罚。）  

32.用一个类似于UNIX od或MS-DOS DEBUG的程序考察并尝试解释UNIX类系统或Windows的目录。提示：如何进行取决于OS允许做什么。一个有益的技巧是在一个有某个操作系统的软盘上创建一个目录，然后使用一个允许进行此类的访问的不同的操作系统读盘上的原始数据。  

# Ref
[《现代操作系统》精读与思考笔记 第一章 引论](http://www.cnblogs.com/wuyuegb2312/p/3369082.html) 


