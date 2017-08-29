#!/bin/bash

BACKUP_HOME=""
DBNAME="db_name"
DBUSER="user"
DBPASS="secret"

# remove old backup
cd $BACKUP_HOME/.. && find $BACKUP_HOME -mtime 7 -exec rm '{}' \;

# backup schema and full database
mysqldump -u $DBUSER  -p$DBPASS $DBNAME --no-data > $BACKUP_HOME/database-schema-$(date +"%Y%m%d-%H%M").sql

mysqldump --quick --single-transaction -u $DBUSER -p$DBPASS $DBNAME \
    --ignore-table=$DBNAME.tablename  | gzip -v > $BACKUP_HOME/database-data-$(date +"%Y%m%d-%H%M").sql.gz
