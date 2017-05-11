---
layout: post
title: Tcpdump 简介
description: "Tcpdump 简介"
category: Network
avatarimg:
tags: [Tcpdump]
duoshuo: true
---

# Tcpdump 简介

<pre>

tcpdump - dump traffic on a network  

DESCRIPTION

Tcpdump prints out a description of the contents of packets on a network interface 
that match the boolean expression; 
the description is preceded by a time stamp, printed, by default, 
as hours, minutes, seconds, and fractions of a second since midnight. 
It can also be run with the -w flag, which causes it to save the packet data to a file for later analysis, 
and/or with the -r flag, 
which causes it to read from a saved packet file rather than to read packets from a network interface. 
It can also be run with the -V flag, which causes it to read a list of saved packet files. 
In all cases, only packets that match expression will be processed by tcpdump.

Tcpdump will, if not run with the -c flag, 
continue capturing packets until it is interrupted by a SIGINT signal 
(generated, for example, by typing your interrupt character, typically control-C) or 
a SIGTERM signal (typically generated with the kill(1) command); 
if run with the -c flag, it will capture packets until it is interrupted by a SIGINT or SIGTERM signal 
or the specified number of packets have been processed.

When tcpdump finishes capturing packets, it will report counts of:

packets ``captured'' (this is the number of packets that tcpdump has received and processed);

packets ``received by filter'' (the meaning of this depends on the OS on which you're running tcpdump, 
and possibly on the way the OS was configured - if a filter was specified on the command line, 
on some OSes it counts packets regardless of whether they were matched by the filter expression and, 
even if they were matched by the filter expression, regardless of whether tcpdump has read and processed them yet, 
on other OSes it counts only packets that were matched by the filter expression 
regardless of whether tcpdump has read and processed them yet, 
and on other OSes it counts only packets that were matched by the filter expression and were processed by tcpdump);

packets ``dropped by kernel'' (this is the number of packets that were dropped, 
due to a lack of buffer space, by the packet capture mechanism in the OS on which tcpdump is running, 
if the OS reports that information to applications; if not, it will be reported as 0).

On platforms that support the SIGINFO signal, such as most BSDs (including Mac OS X) and Digital/Tru64 UNIX, 
it will report those counts when it receives a SIGINFO signal 
(generated, for example, by typing your ``status'' character, typically control-T, 
although on some platforms, such as Mac OS X, the ``status'' character is not set by default, 
so you must set it with stty(1) in order to use it) and will continue capturing packets. 
On platforms that do not support the SIGINFO signal, the same can be achieved by using the SIGUSR1 signal.

Reading packets from a network interface may require that you have special privileges; 
see the pcap (3PCAP) man page for details. Reading a saved packet file doesn't require special privileges. 


</pre>

# Ref

[Tcpdump man page](http://www.tcpdump.org/manpages/tcpdump.1.html)  
