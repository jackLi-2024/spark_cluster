source ./lib/conf.sh

if [ "$1" == "scala-to-env" ];then
        bashrc
elif [ "$1" == "copy-spark" ];then
	copy_spark

elif [ "$1" == "config-spark" ];then
	config_spark
	slaves_
elif [ "$1" == "synchronization" ];then
	synchronization

elif [ "$1" == "help" ];then
	echo "Help:"
	help="true"
else
	echo "Dont support the command [$1]:"
        help="true"
fi


if [ -n "$help" ];then
        echo "    scala-to-env:        Add scala to the environment variable"
        echo "    copy-spark:          Copy Spark to some user"
	echo "    config-spark:        Config spark params"
	echo "    synchronization:     synchronization spark information to other servers"
        echo "    help:                Get help"
	
else
        echo ""

fi
