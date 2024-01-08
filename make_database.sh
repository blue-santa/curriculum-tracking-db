#!/bin/sh
# Create (or update) the postgres database used to store robot data.

pass=`cat .dbpass`

sudo -su postgres << EOF

psql << SQL

ALTER USER curriculum_tracking_usr PASSWORD '$pass';
CREATE DATABASE curriculum_tracking_db;

SQL

EOF

