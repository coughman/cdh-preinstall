#!/bin/bash
echo "" >> /etc/security/limits.conf
echo "# limits for CDH service accounts" >> /etc/security/limits.conf
echo hdfs - nofile 32768 >> /etc/security/limits.conf
echo mapred - nofile 32768 >> /etc/security/limits.conf
echo hbase - nofile 32768 >> /etc/security/limits.conf
echo hdfs - nproc 32768 >> /etc/security/limits.conf
echo mapred - nproc 32768 >> /etc/security/limits.conf
echo hbase - nproc 32768 >> /etc/security/limits.conf
