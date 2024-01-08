#!/bin/bash

# Prompt for the postgres user's password
echo -n "Enter password for postgres user: "
read -s postgres_password
echo

# Export the password to PGPASSWORD to use in psql commands
export PGPASSWORD=$postgres_password

# Connect to PostgreSQL and create the database if it doesn't exist
psql -U postgres -h localhost -c "SELECT 'CREATE DATABASE curriculum_tracking_db' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'curriculum_tracking_db')" | psql -U postgres -h localhost

# Check if curriculum_tracking_usr exists and create it if not
user_exists=$(psql -U postgres -h localhost -tAc "SELECT 1 FROM pg_roles WHERE rolname='curriculum_tracking_usr'")
if [ -z "$user_exists" ]; then
    psql -U postgres -h localhost -c "CREATE USER curriculum_tracking_usr"
fi

# Run the rekey_pass.sh script
./rekey_pass.sh

# Read the password from .dbpass file and set it for curriculum_tracking_usr
password=$(<.dbpass)
psql -U postgres -h localhost -c "ALTER USER curriculum_tracking_usr WITH PASSWORD '$password'"

# Clear the PGPASSWORD
unset PGPASSWORD

echo "Script execution completed."
