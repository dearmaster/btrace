#!/bin/bash

. /opt/dear/.profile

usage()
{
        cat << EOF
usage $0 option

compile the specified java file and invoke the main function if have

OPTION:
        -h      show usage
        -m      the instance of running java main class
	-s	the btrace script

EOF
}

while getopts hm:s: OPTION
do
        case $OPTION in
                h)
                        usage
                        exit 1
                        ;;
                m)
                        mainClass=$OPTARG
                        ;;
		s)
			btraceScript=$OPTARG
			;;
        esac
done

process()
{
	if [[ -z $mainClass ]]; then
		error You should at least know which class you wanna trace.
		exit 1
	fi
	if [[ -z $btraceScript ]]; then
		error The btrace script is not specified.
		exit 1
	fi

	pid=`jps | grep $mainClass | awk '{print $1}'`
	if [[ ""$pid = "" ]]; then
		echo $mainClass is not running.
		exit 1
	fi

	#info $mainClass is running with pid $pid
	#exeWithTimestampLog btrace $BTRACE_HOME/build -p $pid $btraceScript
	#exeWithTimestampLog btrace -p $pid $btraceScript
	#exeWithTimestampLog btrace -cp $BTRACE_HOME/build -p $pid $btraceScript

	#classpath=`echo ${btraceScript%/*}`
	
	#exeWithTimestampLog btrace -cp $classpath $pid $btraceScript
	exeWithTimestampLog btrace $pid $btraceScript
}

process
