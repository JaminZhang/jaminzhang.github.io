

CentOS下netstat命令显示不完整程序名的原因

# 引言
使用netstat -lntp查看业务进程，发现显示程序名称显示不完整。
如下：
<pre>
tcp        0      0 0.0.0.0:20811               0.0.0.0:*                   LISTEN      15459/./gate_s9990  
tcp        0      0 0.0.0.0:843                 0.0.0.0:*                   LISTEN      15431/./flash_s9990 
tcp        0      0 0.0.0.0:20812               0.0.0.0:*                   LISTEN      15481/./gate_s9990  
tcp        0      0 127.0.0.1:20821             0.0.0.0:*                   LISTEN      15438/./game_s9990  
tcp        0      0 127.0.0.1:20822             0.0.0.0:*                   LISTEN      15442/./game_s9990  
tcp        0      0 127.0.0.1:20823             0.0.0.0:*                   LISTEN      15446/./game_s9990  
tcp        0      0 127.0.0.1:20824             0.0.0.0:*                   LISTEN      15450/./game_s9990  
tcp        0      0 10.2.80.224:20832           0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 10.2.80.224:20833           0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20801             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 0.0.0.0:20802               0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20803             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20804             0.0.0.0:*                   LISTEN      15434/./center_s999 
tcp        0      0 127.0.0.1:20805             0.0.0.0:*                   LISTEN      15434/./center_s999 
</pre>
上面可以看到center_s999应该是center_s9990，但没显示出来，于是我就想为什么不能显示出来？观察了几个实例，推断PID/Porgram Name宽度限制在19位。  
于是我想netstat没有选项控制显示完整Program Name吗？ 通过man netstat并没有发现有相关选项。

# netstat
