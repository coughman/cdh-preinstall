#!/bin/bash

# Quick and dirty cluster update script
# author: stuart@cloudera.com
# TODO: replace this shit with puppet

USER=ubuntu
keyFile=$1
red='\033[0;31m'
NC='\033[0m'

HOST_FILE=hosts.txt
SCRIPT_FILE=scripts.txt

if [ $# -lt 2 ]
then
	echo "usage: run_it.sh <keyFile.pem> [master|worker]"
	exit 1
else
	echo "using configuration for $2 nodes"
	HOST_FILE=hosts_$2.txt
	SCRIPT_FILE=scripts_$2.txt
	if [[ ! -e $HOST_FILE || ! -e $SCRIPT_FILE ]] ;
		then
		echo "$HOST_FILE or $SCRIPT_FILE does not exist.  Aborting..."
		exit 1
	fi	
fi

keyFileBase=`basename $keyFile`

i=1

for host in `cat $HOST_FILE`
do
	# only handles the uncommented lines
	if [[ ! "$host" =~ ^\#.* ]] ;	
		then
		echo -e "${red}--> Preparing node $i: $host${NC}"
		echo -e "${red}--> Creating cloudera directory on $host...${NC}"		
		ssh -i $keyFile $USER@$host 'rm -rf cloudera && mkdir -p cloudera/files'

		# Copy all files to host
		echo -e "${red}--> Copying files to $host...${NC}"
		scp -i $keyFile -r files/* $USER@$host:cloudera/files

		scp -i $keyFile $keyFile $USER@$host:cloudera/files
		ssh -i $keyFile $USER@$host -t "mv -f cloudera/files/$keyFileBase .ssh"

		for script in `cat $SCRIPT_FILE`
		do
			# only handles the uncommented lines
			if [[ ! "$script" =~ ^\#.* ]] ;
				then
				echo -e "${red}--> Copying $script to $host...${NC}"
				scp -i $keyFile $script $USER@$host:cloudera
				echo -e "${red}--> Executing $script on $host...${NC}"
				ssh -i $keyFile $USER@$host -t "sudo bash /home/$USER/cloudera/$script"
			fi
		done	
		echo -e "${red}--> Finished node $i: $host${NC}"		
		i=$[i+1]		
	fi
done

exit 0
