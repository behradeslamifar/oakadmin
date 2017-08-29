#!/bin/bash

# befor run this script you must have user for backup
# GRANT RELOAD, LOCK TABLES, REPLICATION CLIENT ON *.* TO 'backupuser'@'localhost' IDENTIFIED BY 'backuppass';
# GRANT ALL PRIVILEGES ON mdbutil.* TO 'backupuser'@'localhost';
# FLUSH PRIVILEGES; 
#
# mysql> CREATE USER 'bkpuser'@'localhost' IDENTIFIED BY 's3cret';
# mysql> GRANT RELOAD, LOCK TABLES, PROCESS, REPLICATION CLIENT ON *.* TO 'bkpuser'@'localhost';
# mysql> FLUSH PRIVILEGES;
#
# my.cnf
# [mysqld]
# [xtrabackup]
# target_dir = /data/backups/mysql/
# 

DATA_DIR=
BACKUP_DIR=/var/backup
BASE=full-$(date +"%W")
INC=inc-$(date +"%W-%Y%m%d-%H%M%S")
TYPE=$1
WEEK=$2

DBNAME=dbname

if [ "$TYPE" == "full" ]
then
    echo -e "\e[92mBackup \"$DBNAME\" database .... \e[0m"
    xtrabackup --backup --databases $DBNAME --target-dir=$BACKUP_DIR/$BASE

    if [ "$?" == "0" ]
    then 
	echo -e "\n\n\n"
	echo -e "\e[92mPreparing backup ...\e[0m"
	xtrabackup --prepare --apply-log-only --target-dir=$BACKUP_DIR/$BASE
    else
	exit 1
    fi
elif [ "$TYPE" == "inc" ]
then
    echo -e "\e[92mBackup \"$DBNAME\" database (incremental) .... \e[0m"
    xtrabackup --backup --databases $DBNAME --target-dir=$BACKUP_DIR/$INC --incremental-basedir=$BACKUP_DIR/$BASE

    if [ "$?" == "0" ]
    then 
	echo -e "\n\n\n"
	echo -e "\e[92mPreparing incremental backup ...\e[0m"
	xtrabackup --prepare --apply-log-only --target-dir=$BACKUP_DIR/$BASE --incremental-dir=$BACKUP_DIR/$INC
    else
	exit 1
    fi
elif [ "$TYPE" == "restore" ]
then
    xtrabackup --copy-back --databases=$DBNAME --target-dir=$BACKUP_DIR-$WEEK
fi

exit 0
