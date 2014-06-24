CDH5 install presteps
---------------------
Forked from my colleague Stuart's repo for Ubuntu

A number of steps are required to prep a cluster for the CDH install, these 
rudimentary few scripts eases the pain.

These scripts were created against hosts running in Amazon EC2, where you can use the same key/pair file for access to the ec2-user.

Usage:

- Put nodes into hosts_master.txt and host_worker.txt
- Put the scripts you want to run into scripts_master.txt/scripts_worker.txt (01_date.sh and 02_id.sh
are examples).
- Execute it:
````
run_it.sh <keyFile.pem> <master|worker>
````
# TODO
- get rid of partition layout files
