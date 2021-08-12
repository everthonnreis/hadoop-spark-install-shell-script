# hadoop-spark-install-shell-script
The objective of this project is to implement a standalone SPARK/HADOOP environment for test development.

<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/128548227-8591f6e2-4d23-4f7d-80a9-fa7dafaa2e58.png" width="800" height="400">
</p>
<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/128548304-0fcbbeb8-71b4-4118-aa74-5fad7bcd5288.png" width="800" height="400">
</p>
<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/128548376-ffecf056-021a-4c41-bf05-384575147eaa.png" width="800" height="400">
</p>

### Attention! Settings were made for a test environment!

# Requisites

* CentOS Linux / Red Hat Enterprise Linux

# Versions
* Hadoop: 2.9.2
* Spark: 2.4.6
* Scala: 2.10.1
* Zookeeper: 3.6.2
* Anaconda: 2020.02
* Java JDK: 1.8.0

# Python libraries that will be installed 
* jupyterhub: 0.9.6
* pydoop: 2.0.0
* findspark: 1.3.0 
* python-socketio: 5.4.0
* jellyfish: 0.8.4 
* websocket-client: 1.1.1 
* websockets: 9.1 
* datetime: 4.3 
* pyspark: 3.1.1
* crypto: 1.4.1
* dbfread: 2.0.7 
* esutil: 0.6.8
* pybase64: 1.1.4
* jupyterhub-nativeauthenticator: 0.0.7


# Kernels
* Iron man
  - Cores: 2
  - Memory: 2 GB
  - Competition: Maximum number of CPU cores and RAM memory available on the machine. 
* Black Panther
  - Cores: 4
  - Memory: 4 GB

#### Notes: The kernel configuration can be customized according to the resources you have. All you need to do is change the following options:
Attention! Before the change, kill the open spark contexts.

Swap the total number of cores and memory.

```

$ vim /opt/anaconda/share/jupyter/kernels/ironman/kernel.json`

"PYSPARK_SUBMIT_ARGS": "--master spark://node1:7077 --name my_jarvis_app --total-executor-cores 2 --driver-memory 2g --executor-memory 2g pyspark-shell" 

```

# Execution

```

$ git clone https://github.com/everthonnreis/hadoop-spark-install-shell-script.git

$ cd hadoop-spark-install-shell-script/

$ ./install.sh

```
During execution you will be asked for the sudo password.

After running you need to update your .bash_profile.
```

$ source ${HOME}/.bash_profile

```
Attention! Run the services start script only after updating your .bash_profile.

```

$ ./start-services.sh

```
The hdfs namenode will be formatted. And services will go up. When requesting (yes|no) enter yes to authorize authentication.

# Using the environment

### Jupyterhub
```

http://0.0.0.0:8000

```
On the jupyterhub login screen, click on "signup" and enter the username and password you run the script.
<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/129245229-7824e2ea-3177-421a-af0a-9c072bbfaff9.png" width="800" height="400">
</p>
<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/129246337-3654efa1-b898-4a15-8af9-586ee232d8a9.png" width="800" height="400">
</p>
<p align="center">
  <img src="https://user-images.githubusercontent.com/67954957/129251344-7ba663f5-8a6e-48ef-ada9-aa085a787ff8.png" width="800" height="400">
</p>

After receiving the message "Your information has been sent to the admin", click "Login!" and enter the username and password. The jupyterhub Server will be started.

### Spark Master web UI
```

http://0.0.0.0:8000

```
### HDFS web UI
```

http://0.0.0.0:50070

```
## Accessing from another machine

If you are accessing from another machine, insert in your hosts file the ip and hostname of the server:

#### On Linux
```

$ vim /etc/hosts

127.0.0.1   localhost localhost.localdomain localhost4 localhost4.localdomain4
::1         localhost localhost.localdomain localhost6 localhost6.localdomain6

0.0.0.0 node1

```
#### On Windows
Modify the file as administrator 
```

C:\Windows\System32\drivers\etc\hosts

0.0.0.0 node1

```
# Useful commands

## HDFS
### Start HDFS services
```

$ start-all.sh

```
### Stop HDFS services
```

$ stop-all.sh

```

## Spark
### Start Spark services
```

$ /opt/spark/sbin/start-master.sh && /opt/spark/sbin/start-slave.sh spark://node1:7077

```
### Stop Spark services
```

$ /opt/spark/sbin/stop-master.sh && /opt/spark/sbin/stop-slave.sh 

```
## Jupyterhub
### Check jupyterhub service
```

$ sudo systemctl status jupyterhub.service

```
### Start, restart and stop jupyterhub service
```

$ sudo systemctl [start|restart|stop] jupyterhub.service

```
## Java Virtual Machine Process Status
```

$ jps

```
<p align="center">
<img src="https://user-images.githubusercontent.com/67954957/129253370-c479bb35-96c7-4fd7-9a95-cff25b69306b.png" width="550" height="200">
</p>





