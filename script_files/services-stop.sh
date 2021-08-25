#! /bin/sh
#! -*- coding:utf-8; mode:shell-script; -*-


program='start_services'
version='1.0'

stop_hadoop(){

    echo "| ##### Stopping HADOOP service ##### |"	
    echo ""
    /opt/hadoop/sbin/./stop-all.sh
   
}

stop_spark(){

    echo "| ##### Stopping SPARK service ##### |"
    echo ""
    /opt/spark/sbin/./stop-master.sh && /opt/spark/sbin/./stop-slave.sh
}

stop_jupyter(){

    echo "| ##### Stopping Jupyterhub service ##### |"
    echo ""
    sudo systemctl stop jupyterhub.service
    
    ACTIVE=`sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print}'`

    INACTIVE="Active: inactive (dead)"


    if [[ ${ACTIVE} != ${INACTIVE} ]];
    then
        sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print "\033[34m" $1 "\033[31m" $2 }'
    else
        sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print "\033[34m" $1 "\033[32m" $2 }'
    fi

}


stop_hadoop
stop_spark
stop_jupyter
sleep 3
echo ""
echo "| ##### checking services ##### |"
jps
