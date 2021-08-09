#! /bin/sh
#! -*- coding:utf-8; mode:shell-script; -*-

program='install_seg_environment'
version='1.0'

# sudo yum update 

RELEASE=`awk '/^NAME=/' /etc/*-release | awk -F'=' '{ print tolower($2) }'`

echo ""
echo "| ##### Updating and installing packages | ${RELEASE} ##### |"
echo ""
if [ "${RELEASE}" == '"Red Hat Enterprise Linux"' ];
then
     sudo yum update -y
     sudo yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-8.noarch.rpm
     sudo yum update -y
     sudo yum install -y pv compat-openssl10 wget curl git net-tools gcc gcc-c++ java-1.8.0-openjdk-devel.x86_64 libtirpc-devel
else 
     sudo yum update -y
     sudo yum install -y epel-release
     sudo yum update -y
     sudo yum install -y pv compat-openssl10 wget curl git net-tools gcc gcc-c++
fi


# Global variable declartion, Change as per your need

GIT_DIR=${PWD} 
ROOT_DIR="/opt" # Enter a path of your choice
FILE_DIR="${ROOT_DIR}/files"
CONDA_PREFIX="${ROOT_DIR}/anaconda3"
HADOOP='hadoop-2.9.2'
SPARK='spark-2.4.6'
SCALA='scala-2.10.1'
ZOOKEEPER='zookeeper-3.6.2'
ANACONDA='Anaconda3-2020.02-Linux-x86_64'
CONDA_SPEC_FILE='spec_file_nana.txt'
BASH_FILE=".bash_profile"
SPARK_HOME="${ROOT_DIR}/spark"
HADOOP_HOME="${ROOT_DIR}/hadoop"
SCALA_HOME="${ROOT_DIR}/scala"

sudo chmod 757 ${ROOT_DIR}
cd ${ROOT_DIR}

if [ -d "${FILE_DIR}" ] 
then
    echo "Directory ${FILE_DIR} exists."

else
    mkdir ${FILE_DIR}
fi

BASE_URL_HADOOP="https://archive.apache.org/dist/hadoop/common/${HADOOP}/${HADOOP}.tar.gz"
BASE_URL_SPARK="https://archive.apache.org/dist/spark/${SPARK}/${SPARK}-bin-hadoop2.7.tgz"
BASE_URL_SCALA="https://scala-lang.org/files/archive/${SCALA}.tgz"
BASE_URL_ZOOKEEPER="https://archive.apache.org/dist/zookeeper/${ZOOKEEPER}/apache-${ZOOKEEPER}.tar.gz"
BASE_URL_ANACONDA="https://repo.anaconda.com/archive/${ANACONDA}.sh"


echo_version=( ${HADOOP} ${SPARK} ${SCALA} ${ZOOKEEPER} ${ANACONDA} )
echo_url=( ${BASE_URL_HADOOP} ${BASE_URL_SPARK} ${BASE_URL_SCALA} ${BASE_URL_ZOOKEEPER} ${BASE_URL_ANACONDA} )
echo_file=( "${HADOOP}.tar.gz" "${SPARK}-bin-hadoop2.7.tgz" "${SCALA}.tgz" "apache-${ZOOKEEPER}.tar.gz" "${ANACONDA}.sh" )
echo_file_tar=( "${HADOOP}.tar.gz" "${SPARK}-bin-hadoop2.7.tgz" "${SCALA}.tgz" "apache-${ZOOKEEPER}.tar.gz" )
echo_file_dir=( "${HADOOP}" "${SPARK}-bin-hadoop2.7" "${SCALA}" "apache-${ZOOKEEPER}" "anaconda3" )
echo_link=( "hadoop" "spark" "scala" "zookeeper" "anaconda" )


# Install anaconda 
install_anaconda(){

    cd ${FILE_DIR}

    if [ -d "${CONDA_PREFIX}" ] 
    then
        echo "Directory ${CONDA_PREFIX} exists."

    else
        chmod +x "${ANACONDA}.sh"
        ./"${ANACONDA}.sh" -b -f -p ${CONDA_PREFIX}
    fi

    echo "" >> ${HOME}/${BASH_FILE}
    echo "############################ ANACONDA ############################" >> ${HOME}/${BASH_FILE}
    echo ""
    echo    '# >>> conda initialize >>>' >> ${HOME}/${BASH_FILE}
    echo    '# !! Contents within this block are managed by 'conda init' !!' >> ${HOME}/${BASH_FILE}
    echo    '__conda_setup="$('${CONDA_PREFIX}'/bin/conda 'shell.bash' 'hook' 2> /dev/null)"' >> ${HOME}/${BASH_FILE}
    echo    'if [ $? -eq 0 ]; then' >> ${HOME}/${BASH_FILE}
    echo    '    eval "$__conda_setup"' >> ${HOME}/${BASH_FILE}
    echo    'else' >> ${HOME}/${BASH_FILE}
    echo    '    if [ -f "'${CONDA_PREFIX}'/etc/profile.d/conda.sh" ]; then' >> ${HOME}/${BASH_FILE}
    echo    '        . "'${CONDA_PREFIX}'/etc/profile.d/conda.sh"' >> ${HOME}/${BASH_FILE}
    echo    '    else' >> ${HOME}/${BASH_FILE}
    echo    '        export PATH="'${CONDA_PREFIX}'/bin:$PATH"' >> ${HOME}/${BASH_FILE}
    echo    '    fi' >> ${HOME}/${BASH_FILE}
    echo    'fi' >> ${HOME}/${BASH_FILE}
    echo    'unset __conda_setup' >> ${HOME}/${BASH_FILE}
    echo    '# <<< conda initialize <<<' >> ${HOME}/${BASH_FILE}

    source "${HOME}/.bash_profile"

}

# Create install java and create JAVA_HOME 
set_java_home() {

    if type -p java; 
    then
        _JAVA=java
        
        $_JAVA -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' > java_home.txt
        sed -i 's/java.home =//g;s/ //g' java_home.txt
        JAVA_PATH=`cat java_home.txt`
        rm -rf java_home.txt

        $_JAVA -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' > java_home1.txt
        sed -i 's/java.home =//g;s/ //g;s/\/jre//g' java_home1.txt
        JAVA_PATH_1=`cat java_home1.txt`
        rm -rf java_home1.txt

        echo "############################ JAVA ############################" >> ${HOME}/${BASH_FILE}
        echo "export JAVA_HOME=/usr/lib/jvm/jre" >> ${HOME}/${BASH_FILE}
        echo "" >> ${HOME}/${BASH_FILE}
        echo "############################ JAVA HOME ############################" >> ${HOME}/${BASH_FILE}
        echo ""
        echo "export JAVA_HOME=${JAVA_PATH}" >> ${HOME}/${BASH_FILE}
        echo "export JAVA_HOME=${JAVA_PATH_1}" >> ${HOME}/${BASH_FILE}
        echo "" >> ${HOME}/${BASH_FILE}

    else

        echo ""
        echo "No java version"
        echo "Installing Java 1.8.0"
        sudo yum install -y java-1.8.0-openjdk java-1.8.0-openjdk-devel.x86_64 
        sleep 3

        _JAVA="$JAVA_H/bin/java"

        $_JAVA -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' > java_home.txt
        sed -i 's/java.home =//g;s/ //g' java_home.txt
        JAVA_PATH=`cat java_home.txt`
        rm -rf java_home.txt

        $_JAVA -XshowSettings:properties -version 2>&1 > /dev/null | grep 'java.home' > java_home1.txt
        sed -i 's/java.home =//g;s/ //g;s/\/jre//g' java_home1.txt
        JAVA_PATH_1=`cat java_home1.txt`
        rm -rf java_home1.txt

        echo "############################ JAVA ############################" >> ${HOME}/${BASH_FILE}
        echo "export JAVA_HOME=/usr/lib/jvm/jre" >> ${HOME}/${BASH_FILE}
        echo "" >> ${HOME}/${BASH_FILE}
        echo "############################ JAVA HOME ############################" >> ${HOME}/${BASH_FILE}
        echo ""
        echo "export JAVA_HOME=${JAVA_PATH}" >> ${HOME}/${BASH_FILE}
        echo "export JAVA_HOME=${JAVA_PATH_1}" >> ${HOME}/${BASH_FILE}
        echo "" >> ${HOME}/${BASH_FILE}
    fi

    source "${HOME}/.bash_profile"
}

# Download files
download_files() {

    cd ${FILE_DIR}
    
    if type wget > /dev/null ; then
    FETCH='wget'
    else
    FETCH='curl -LO'
    fi

    for i in "${!echo_url[@]}"
    do  
        echo ""
        echo "| ##### Downloading version ${echo_version[i]} ##### |"
        echo ""
        ${FETCH} ${echo_url[i]}
        echo ""
    done
    unset i  
}

# Unzipping files from the FILE directory
descompress_files(){

    for ar in "${!echo_file_tar[@]}"
    do
        package="${echo_file_tar[ar]%.*}"
        case ${echo_file_tar[ar]} in
        *.tar.gz)
            uncompress='tar zxf'
        ;;
        *.bz2)
            uncompress='bzip2 d'
        ;;
        *.tgz)
            uncompress='tar zxf'
        ;;    
        esac
        echo ""
        echo "Decompressing file ${echo_file_tar[ar]}"
        echo ""
        pv "${FILE_DIR}/${echo_file_tar[ar]}" | ${uncompress} - -C "${ROOT_DIR}"
        echo ""
        unset package
    done
    unset ar
}

create_symbolic_link(){

    cd ${ROOT_DIR}

    for l in "${!echo_link[@]}"
    do
        if [ -e "${echo_file_dir[l]}" ]; 
        then
            ln -s ${ROOT_DIR}/${echo_file_dir[l]} ${echo_link[l]} 
        else    
            ln -s ${ROOT_DIR}/${echo_file_dir[l]} ${echo_link[l]}
            descompress_files        
        fi
    done
    unset l
}

set_spark_env(){

    echo ""
    echo "| #####Setting SPARK and HADOOP environment variables... ##### |"
    echo ""    

    echo "" >> ${HOME}/${BASH_FILE}
    echo "############################ SPARK & HADOOP ############################" >> ${HOME}/${BASH_FILE}
    echo "" >> ${HOME}/${BASH_FILE}
    echo "export SPARK_HOME=${SPARK_HOME}" >> ${HOME}/${BASH_FILE}
    echo "export PYSPARK_DRIVER_PYTHON=/opt/anaconda/bin/ipython" >> ${HOME}/${BASH_FILE}
    echo "export PYSPARK_DRIVER_PYTHON=jupyter" >> ${HOME}/${BASH_FILE}
    echo "export PYSPARK_DRIVER_PYTHON_OPTS='notebook'" >> ${HOME}/${BASH_FILE}
    echo "export SCALA_HOME=${SCALA_HOME}" >> ${HOME}/${BASH_FILE}
    echo "export HADOOP_HOME=${HADOOP_HOME}" >> ${HOME}/${BASH_FILE}
    echo "export LD_PRELOAD=/lib64/libssl.so.10" >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native' >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_INSTALL=${HADOOP_HOME}' >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_COMMON_HOME=${HADOOP_HOME}' >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native' >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_OPTS="-Djava.library.path=${HADOOP_HOME}/lib/native"' >> ${HOME}/${BASH_FILE}
    echo 'export YARN_HOME=${HADOOP_HOME}' >> ${HOME}/${BASH_FILE}
    echo 'export HADOOP_COMMON_LIB_NATIVE_DIR=${HADOOP_HOME}/lib/native' >> ${HOME}/${BASH_FILE}
    echo 'export CFLAGS=-I/usr/include/tirpc'
    echo "" >> ${HOME}/${BASH_FILE}
    echo 'PATH=$PATH:$HOME/.local/bin:$HOME/bin:${SPARK_HOME}/bin:${SCALA_HOME}/bin:${HADOOP_HOME}/bin:${HADOOP_HOME}/sbin:$PATH:$JAVA_HOME:$HADOOP_COMMON_LIB_NATIVE_DIR:$PATH' >> ${HOME}/${BASH_FILE}
    echo "export PATH" >> ${HOME}/${BASH_FILE}

    source "${HOME}/.bash_profile"
}

install_hadoop(){


    cd ${ROOT_DIR}

    echo ""
    echo "| ##### Creating SSH Key ##### |"
    echo ""
    ssh-keygen -t rsa -P '' -f ~/.ssh/hadoop
    cat ~/.ssh/hadoop.pub >> ~/.ssh/authorized_keys
    chmod 0600 ~/.ssh/authorized_keys

    echo ""
    echo "| ##### Removing Original HADOOP Files... ##### |"
    echo ""
    rm -rf ${HADOOP_HOME}/etc/hadoop/hadoop-env.sh ${HADOOP_HOME}/etc/hadoop/core-site.xml ${HADOOP_HOME}/etc/hadoop/hdfs-site.xml ${HADOOP_HOME}/etc/hadoop/slaves ${HADOOP_HOME}/etc/hadoop/log4j.properties
    
    cd ${GIT_DIR}
    echo ""
    echo "| ##### Moving configured files... ##### |"
    echo ""
    cp -r ${GIT_DIR}/hadoop_files/* "${HADOOP_HOME}/etc/hadoop/"

    echo ""
    echo "| ##### Configuring hosts and hostname... ##### |"
    echo ""
    HOST="node1"
    ip addr show | grep global | grep -oE '((1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])\.){3}(1?[0-9][0-9]?|2[0-4][0-9]|25[0-5])' | sed -n '1p' > ip_file
    IP=`cat ip_file`
    HOST_N=`cat /etc/hostname`
    sudo sed -i 's/'${HOST_N}'/'${HOST}'/g' /etc/hostname
    echo "${IP} ${HOST} master" | sudo tee -a /etc/hosts

    echo ""
    echo "| ##### Creating HDFS Directories... ##### |"
    echo ""
    if [ -d "${HADOOP_HOME}/hdfs" ] 
    then
        echo "Directory ${HADOOP_HOME}/hdfs exists."
    else
        mkdir -p ${HADOOP_HOME}/hdfs/name
        mkdir -p ${HADOOP_HOME}/hdfs/data
        mkdir -p ${HADOOP_HOME}/hdfs/tmp
    fi

    rm -rf ip_file
    sleep 1 
}

open_ports(){

    ports=( "50070" "50470" "50075" "50475" "50010" "1019" "50090" "9000" "8000" "8080" "8081" "18080" "6066" "7337" "4040" "4041" "4042" "4043" "4044" "4045" "4046" "4047" "4048" "4049") 

    for p in "${!ports[@]}"
    do
        echo "${ports[p]}"
        sudo firewall-cmd --zone=public --add-port=${ports[p]}/tcp --permanent
    done
    unset p

    sudo firewall-cmd --zone=public --permanent --add-service=http
    sudo firewall-cmd --reload
    echo ""
    echo "Already opened ports or services"
    sudo firewall-cmd --list-ports
}

install_jupyterhub(){

   cd ${GIT_DIR}

    conda install -c conda-forge jupyterhub findspark ruamel.yaml
    pip install --upgrade pip
    echo "" 
    echo "| ##### Install python packages... ##### |"
    echo ""    
    pip install git+https://github.com/jupyter/sudospawner
    pip install pydoop python-socketio jellyfish elasticsearch websocket-client websockets datetime pyspark==3.1.1 Crypto dbfread esutil pybase64

    echo "" 
    echo "| ##### Jupyterhub directory ##### |"
    echo ""
    sudo mkdir /etc/jupyterhub/

    echo ""
    echo "| ##### Moving Jupyterhub configured files... ##### |"
    echo ""
    sed -i 's|c.Authenticator.admin_users = {}|c.Authenticator.admin_users = {'\'${USER}\''}||g' ${GIT_DIR}/jupyterhub_file/jupyterhub_config.py
    sudo cp -r ${GIT_DIR}/jupyterhub_file/* /etc/jupyterhub/

    # create jupyter service

    echo '[Unit]
    Description=Jupyterhub
    After=syslog.target network.target

    [Service]
    User=root
    Environment="PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:'${ROOT_DIR}'/anaconda/bin"
    ExecStart='${ROOT_DIR}'/anaconda/bin/jupyterhub -f /etc/jupyterhub/jupyterhub_config.py

    [Install]
    WantedBy=multi-user.target' | sudo tee -a /lib/systemd/system/jupyterhub.service

    sudo systemctl daemon-reload
    sleep 1
    echo "" 
    echo "| ##### Jupyterhub service status ##### |"
    echo ""
    sudo systemctl start jupyterhub && sudo systemctl status jupyterhub

}

create_spark_kernel(){

    cd ${GIT_DIR}

    echo ""
    echo "| ##### Moving kernel files... ##### |"
    echo ""
    cp -r ${GIT_DIR}/kernels/* ${ROOT_DIR}/anaconda/share/jupyter/kernels/

    sudo mkdir /tmp/spark-events
    sudo chmod 777 /tmp/spark-events

    echo ""
    echo "| ##### Moving Spark files... ##### |"
    echo ""
    cp ${GIT_DIR}/spark_files/* ${SPARK_HOME}/conf/

}

# Validations
for j in "${!echo_file[@]}"
do   
    if [ -e "${FILE_DIR}/${echo_file[j]}" ]; 
    then
        echo ""
        echo "${echo_file[j]} Compressed files exist"
        echo ""  
    else    
        download_files
        break
    fi
done
unset j


echo "" 
echo "| ##### Creating symbolic links ##### |"
create_symbolic_link

echo "" 
echo "| ##### Setting JAVA_HOME ##### |"
set_java_home

echo "" 
echo "| ##### Setting SPARK_HOME and HADOOP_HOME ##### |"
set_spark_env

echo "" 
echo "| ##### Installing Anaconda ##### |"
install_anaconda

echo "" 
echo "| ##### Installing Hadoop ##### |"
install_hadoop

echo "" 
echo "| ##### Installing Jupyterhub ##### |"
install_jupyterhub

echo "" 
echo "| ##### Setting Spark kernel ##### |"
create_spark_kernel

echo "" 
echo "| ##### Open TCP/HTTP ports ##### |"
open_ports


source "${HOME}/.bash_profile"