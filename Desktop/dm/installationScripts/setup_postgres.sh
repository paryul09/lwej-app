#!/bin/bash

# Update package lists
echo "Updating package lists..."
sudo apt-get update -y

# Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt-get install postgresql postgresql-contrib -y

# Start PostgreSQL service
echo "Starting PostgreSQL service..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Database credentials
DB_USER="postgres"
DB_PASSWORD="lwej12"
DB_NAME="lwejInv"

# Create a new PostgreSQL role and database (only if the database does not exist)
echo "Creating PostgreSQL user and database..."
sudo -u postgres psql <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '$DB_USER') THEN
      CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
   END IF;
END
\$do\$;

-- Create the database if it does not exist
DO
\$do\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_database WHERE datname = '$DB_NAME') THEN
      CREATE DATABASE $DB_NAME;
      GRANT ALL PRIVILEGES ON DATABASE $DB_NAME TO $DB_USER;
   END IF;
END
\$do\$;
EOF

# Check if the SQL script file exists
SQL_FILE="create_tables.sql"
if [[ ! -f "$SQL_FILE" ]]; then
    echo "Error: SQL file '$SQL_FILE' not found!"
    exit 1
fi

# Run the SQL script to create tables
echo "Creating tables in the $DB_NAME database..."
sudo -u postgres psql -U $DB_USER -d $DB_NAME -f "$SQL_FILE"

# Final success message
echo "PostgreSQL setup complete. Database '$DB_NAME', user '$DB_USER', and tables have been created."
