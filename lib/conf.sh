source ./conf/config.ini

bashrc(){
    if [ -d "/home/$username" ];then
	echo "export SCALA_HOME=/home/$username/scala-2.10.4" >> /home/$username/.bashrc
	echo "export PATH=\$PATH:\$SCALA_HOME/bin" >> /home/$username/.bashrc
	su $username -c "source /home/$username/.bashrc"
    else
        echo "Dont add scala to environment .Please create username[$username]"
    fi
}

copy_spark(){
    if [ -d "/home/$username" ];then
	cp -rf ./package/scala-2.10.4 /home/$username
        cp -rf ./package/spark-2.4.0-bin-hadoop2.7 /home/$username
        echo "----Wait for permission..."
        chown -R $username:$username /home/$username/scala-2.10.4
        chown -R $username:$username /home/$username/spark-2.4.0-bin-hadoop2.7
        echo "----successfully!"
    else
        echo "Dont move spark to /home/xxx.Please create username[$username]"
    fi 
}


config_spark(){
    if [ -d "/home/$username" ];then
	spark_env_file=/home/$username/spark-2.4.0-bin-hadoop2.7/conf
	cp -rf $spark_env_file/spark-env.sh.template $spark_env_file/spark-env.sh
	echo "export SCALA_HOME=/home/$username/scala-2.10.4" >> $spark_env_file/spark-env.sh
	echo "export JAVA_HOME=/home/$username/jdk1.8.0_171" >> $spark_env_file/spark-env.sh
	echo "export HADOOP_HOME=/home/$username/hadoop-2.9.2" >> $spark_env_file/spark-env.sh
	echo "export HADOOP_CONF_DIR=\$HADOOP_HOME/etc/hadoop" >> $spark_env_file/spark-env.sh
	echo "SPARK_MASTER_IP=$master" >> $spark_env_file/spark-env.sh
	echo "SPARK_LOCAL_DIRS=/home/$username/spark-2.4.0-bin-hadoop2.7" >> $spark_env_file/spark-env.sh
	echo "SPARK_DRIVER_MEMORY=$spark_memory" >> $spark_env_file/spark-env.sh
	chown -R $username:$username $spark_env_file/spark-env.sh
	echo "----successfully!"
    else
	echo "Dont config spark .Please create username[$username]"
    fi
}

slaves_(){
    if [ -d "/home/$username" ];then
	slaves_file=/home/$username/spark-2.4.0-bin-hadoop2.7/conf
	cp -rf $slaves_file/slaves.template $slaves_file/slaves
	echo "" > $slaves_file/slaves
        sed -i "1d" $slaves_file/slaves
	for server in ${slaves[@]}
	    do
		echo $server >> $slaves_file/slaves
	    done
	chown -R $username:$username $slaves_file/slaves
    else
        echo "Dont config slaves .Please create username[$username]"
    fi
}

synchronization(){
    if [ -d "/home/$username" ];then
	scala_file=/home/$username/scala-2.10.4.tgz
	spark_file=/home/$username/spark-2.4.0-bin-hadoop2.7.tgz	
	rm -rf $scala_file
	rm -rf $spark_file
	su - $username -c "tar -cvzf scala-2.10.4.tgz scala-2.10.4"
	su - $username -c "tar -cvzf spark-2.4.0-bin-hadoop2.7.tgz spark-2.4.0-bin-hadoop2.7"
	for server in ${syn_server[@]}
	    do
		echo "scp to $server..."
		su - $username -c "scp -r /home/$username/.bashrc $username@$server:/home/$username"
		su - $username -c "scp -r $scala_file $username@$server:/home/$username"
		su - $username -c "scp -r $spark_file $username@$server:/home/$username"
		su - $username -c "ssh $username@$server 'cd /home/$username && tar -xvzf scala-2.10.4.tgz && tar -xvzf spark-2.4.0-bin-hadoop2.7.tgz'"
		su - $username -c "ssh $username@$server 'cd /home/$username && rm -rf scala-2.10.4.tgz && rm -rf spark-2.4.0-bin-hadoop2.7.tgz'"
		su - $username -c "ssh $username@$server 'source ~/.bashrc'"
	    done
	rm -rf $scala_file
        rm -rf $spark_file
    else
	echo "Dont synchronization config .Please create username[$username]"
    fi
}





