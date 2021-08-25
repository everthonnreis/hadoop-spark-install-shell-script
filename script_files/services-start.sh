#! /bin/sh
#! -*- coding:utf-8; mode:shell-script; -*-


program='start_services'
version='1.0'

start_hadoop(){
	
    echo ""	
    echo "| ##### Start HADOOP service ##### |"
    echo ""	    
    /opt/hadoop/sbin/./start-dfs.sh
}

start_spark(){
	
    echo ""	
    echo "| ##### Start SPARK service ##### |"
    echo ""
    /opt/spark/sbin/./start-master.sh && /opt/spark/sbin/./start-slave.sh spark://node1:7077
}

start_jupyter(){
	
    echo ""	
    echo "| ##### Start Jupyterhub service ##### |"
    sudo systemctl start jupyterhub.service
    
    ACTIVE=`sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print}'`

    INACTIVE="Active: inactive (dead)"


    if [[ ${ACTIVE} != ${INACTIVE} ]];
    then
        sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print "\033[34m" $1 "\033[32m" $2 }'
    else
        sudo systemctl status jupyterhub.service | awk 'NR>=3 && NR<4  {print "\033[34m" $1 "\033[31m" $2 }'
    fi

}


start_hadoop
start_spark
start_jupyter
sleep 3
echo "| ##### checking services ##### |"
jps

