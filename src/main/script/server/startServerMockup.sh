#!/bin/bash

.  ~/.profile

usage()
{
	cat << EOF
usage $0 option

compile the specified java file and invoke the main function if have

OPTION:
	-h	show usage
	-f	specify the java class list. Enclosed in double quotation if multi class to be compiled

EOF
}

while getopts hf: OPTION
do
	case $OPTION in
		h)
			usage
			exit 1
			;;
		f)
			javaFiles=$OPTARG
			;;
	esac
done

process()
{

	echo JAVA_HOME: $JAVA_HOME
	echo CLASSPATH: $CLASSPATH

	if [[ -z $javaFiles ]]; then
		error No java files specified.
		exit 1
	fi

	OLD_IFS="$IFS" 
	IFS=" " 
	arr=($javaFiles) 
	IFS="$OLD_IFS" 

	initializedFlag=false


	for javaFile in ${arr[@]} 
	do 
		exeWithTimestampLog cp $javaFile .

		if [[ $initializedFlag = false ]]; then
			removeParentFolder $javaFile
			initializedFlag=true
		fi

		exeWithTimestampLog javac -encoding utf-8 -d . $javaFile

		#fixme there might be multi main classes
		mainClassIdentifier=`cat $javaFile | grep public | grep static | grep void | grep main`
		if [[ ""$mainClassIdentifier != "" ]]; then
			javaFileInWorkSpace=`echo ${javaFile##*/}`
			#echo checking $javaFileInWorkSpace ...
			mainClassFile=`cat $javaFileInWorkSpace | grep -v "^$" | grep "^package " | awk '{print $2}' | cut -d \; -f 1`.`echo ${javaFileInWorkSpace%%.*}`

			exeWithTimestampLog rm $javaFileInWorkSpace
		fi

	done

	echo mainClassFile is $mainClassFile

	exeWithTimestampLog java -cp . $mainClassFile

	if [[ ! -z $parentPkg ]]; then
		exeWithTimestampLog rm -r $parentPkg
	fi

}

#assume all the java classes are contained in a same parent folder. e.g com
removeParentFolder()
{
	if [[ $# -ne 1 ]]; then
		error Incorrect number of parameters for removing the parent class folder
		exit 1
	fi
	parentPkg=`cat $1 | grep -v "^$" | grep "^package " | awk '{print $2}' | cut -d \. -f 1`
	if [[ -d $parentPkg ]]; then
	        exeWithTimestampLog rm -rf $parentPkg
	fi
}

process
