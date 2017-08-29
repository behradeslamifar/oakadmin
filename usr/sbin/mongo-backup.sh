#!/bin/bash

# Authentication options
# AUTH_OPTIONS="--username backup --password yaeng7Deice6ii"

# DB name
DB_NAME="dbname"

# Path to save bson file
BACKUP_PATH=/backup/home/mongo-$(date +"%Y-%m-%d")

# Run backup process
/usr/bin/mongodump $AUTH_OPTIONS --db $DB_NAME --username backup --password secret --authenticationDatabase admin --out $BACKUP_PATH
