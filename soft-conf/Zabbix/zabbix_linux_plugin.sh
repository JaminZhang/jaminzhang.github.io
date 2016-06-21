#!/bin/bash
############################################################
# $Name:		zabbix_linux_plugin.sh
# $Version:		v1.1
# $Function:		zabbix plugin
# $Forkd by:		Jamin Zhang
# $Author:		Jason Zhao
# $Organization:	www.unixhot.com
# $Update Date:		2016-06-21
# $Description:		Monitor Linux Service Status
############################################################

tcp_status_fun(){
	TCP_STAT=$1
	#netstat -n | awk '/^tcp/ {++state[$NF]} END {for(key in state) print key,state[key]}' > /tmp/netstat.tmp
	ss -ant | awk 'NR>1 {++s[$1]} END {for(k in s) print k,s[k]}' > /tmp/netstat.tmp
	TCP_STAT_VALUE=$(grep "$TCP_STAT" /tmp/netstat.tmp | cut -d ' ' -f2)
	if [ -z $TCP_STAT_VALUE ];then
		TCP_STAT_VALUE=0
	fi
	echo $TCP_STAT_VALUE
}

nginx_status_fun(){
	NGINX_PORT=$1
	NGINX_COMMAND=$2
	nginx_active(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| grep 'Active' | awk '{print $NF}'
        }
	nginx_reading(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| grep 'Reading' | awk '{print $2}'
       }
	nginx_writing(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| grep 'Writing' | awk '{print $4}'
       }
	nginx_waiting(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| grep 'Waiting' | awk '{print $6}'
       }
	nginx_accepts(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $1}'
       }
	nginx_handled(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $2}'
       }
	nginx_requests(){
        /usr/bin/curl "http://127.0.0.1:"$NGINX_PORT"/nginx_status/" 2>/dev/null| awk NR==3 | awk '{print $3}'
       }
  	case $NGINX_COMMAND in
		active)
			nginx_active;
			;;
		reading)
			nginx_reading;
			;;
		writing)
			nginx_writing;
			;;
		waiting)
			nginx_waiting;
			;;
		accepts)
			nginx_accepts;
			;;
		handled)
			nginx_handled;
			;;
		requests)
			nginx_requests;
		esac 
}

memcached_status_fun(){
	M_PORT=$1
	M_COMMAND=$2
	echo -e "stats\nquit" | nc 127.0.0.1 "$M_PORT" | grep "STAT $M_COMMAND " | awk '{print $3}'
}

redis_status_fun(){
	R_PORT=$1
	R_COMMAND=$2
	(echo -en "INFO \r\n";sleep 1;) | nc 127.0.0.1 "$R_PORT" > /tmp/redis_"$R_PORT".tmp
	REDIS_STAT_VALUE=$(grep ""$R_COMMAND":" /tmp/redis_"$R_PORT".tmp | cut -d ':' -f2)
 	echo $REDIS_STAT_VALUE	
}

main(){
	case $1 in
		tcp_status)
			tcp_status_fun $2;
			;;
		nginx_status)
			nginx_status_fun $2 $3;
			;;
		memcached_status)
			memcached_status_fun $2 $3;
			;;
		redis_status)
			redis_status_fun $2 $3;
			;;
		*)
			echo $"Usage: $0 {tcp_status key|memcached_status key|redis_status key|nginx_status key}"
	esac
}

main $1 $2 $3
