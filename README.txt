**** Build a spark cluster on a Hadoop cluster, so make sure your hadoop cluster is set up


****download spark_package.tgz
address: https://pan.baidu.com/s/1vVuKyRWCUEQSsKpnkVmZQA 
password: 9obt

tar -xvzf spark_package.tgz


step 1. Add scala to environment variables and copy spark to some user
	sh bin/init.sh copy-spark

step 2. Modify config.ini 
	
	vim conf/config.ini

	=================================================
	username=hadoop_test      //  spark work user == hadoop work user
	userpwd=123456		// user passwrd

	# 
	master=hserver1    //  master server
	spark_memory=1G    // spark memory

	slaves=(hserver2 hserver3)    //   datanode server

	syn_server=(hserver2 hserver3)   // synchronization spark information to other servers
	=================================================

step 3. Add scala to environment variables
	
	sh bin/init.sh scala-to-env

step 4. config spark
	sh bin/init.sh config-spark

step 5. synchronization spark information to other servers
	sh bin/init.sh synchronization

step 6. validate
	su {your username}     //   su hadoop_test
	cd /home/{your username}/spark-2.4.0-bin-hadoop2.7           //  cd /home/hadoop_test/spark-2.4.0-bin-hadoop2.7
	bin/spark-submit --master yarn --class org.apache.spark.examples.SparkPi  examples/jars/spark-examples_2.11-2.4.0.jar 10
	you can get a result:
		Pi is roughly 3.1414551414551415   (PI=3.1414551414551415)






