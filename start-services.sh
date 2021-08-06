#! /bin/sh
#! -*- coding:utf-8; mode:shell-script; -*-

#https://www.programmersought.com/article/25802542377/

program='start_services'
version='1.0'

start_hadoop(){
   
    sed -i 's|export JAVA_HOME=${JAVA_HOME}|export JAVA_HOME='"${JAVA_HOME}"'/jre|g' /opt/hadoop/etc/hadoop/hadoop-env.sh
    echo ""
    echo "| ##### Formating HDFS Namenode ##### |"
    echo ""
    hdfs namenode -format
    echo ""
    echo "| ##### Starting HDFS ##### |"
    echo ""
    /opt/hadoop/sbin/./start-all.sh

    hdfs dfs -mkdir /npd

    create_dir_hdfs(){

        echo ""
        echo "Creating directory..."
        echo ""
        DIR=( "/raw" 
            "/raw/data" 
            "/raw/metadata"
            "/datasets" 
            "/datasets/data"
            "/datasets/metadata"
            "/refined" 
            "/refined/data" 
            "/refined/metadata" 
            "/trusted" 
            "/trusted/data" 
            "/trusted/metadata" )

        for d in "${!DIR[@]}"
        do
           echo ""
           echo "Creating directory /npd${DIR[d]}..."
           hdfs dfs -mkdir /npd${DIR[d]} 
        done 

        echo ""
        echo "HDFS directory structure"
        echo ""
        hdfs dfs -ls -R /

    }

    create_dir_hdfs   
}

start_spark(){

    sed -i 's|${JAVA_HOME}|'"${JAVA_HOME}"'/jre|g' /opt/anaconda/share/jupyter/kernels/ironman/kernel.json
    sed -i 's|${JAVA_HOME}|'"${JAVA_HOME}"'/jre|g' /opt/anaconda/share/jupyter/kernels/blackpanther/kernel.json

    echo ""
    echo "| ##### Starting SPARK ##### |"
    echo ""
    
    /opt/spark/sbin/./start-master.sh
    /opt/spark/sbin/./start-slave.sh spark://node1:7077
}

start_hadoop
start_spark