#!/bin/bash

# Database credentials
DB_USER="postgres"
DB_PASSWORD="lwej12"
DB_NAME="lwejInv"

# Install Homebrew if not installed
if ! command -v brew &> /dev/null
then
    echo "Homebrew not found. Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install PostgreSQL using Homebrew
if ! command -v psql &> /dev/null
then
    echo "Installing PostgreSQL..."
    brew install postgresql
else
    echo "PostgreSQL is already installed."
fi

# Start PostgreSQL service
echo "Starting PostgreSQL service..."
brew services start postgresql

# Create a new PostgreSQL role and database
echo "Creating PostgreSQL user and database..."
psql postgres <<EOF
DO
\$do\$
BEGIN
   IF NOT EXISTS (SELECT FROM pg_catalog.pg_user WHERE usename = '$DB_USER') THEN
      CREATE USER $DB_USER WITH PASSWORD '$DB_PASSWORD';
   END IF;
END
\$do\$;

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
psql -U $DB_USER -d $DB_NAME -f "$SQL_FILE"

echo "PostgreSQL setup complete. Database '$DB_NAME', user '$DB_USER', and tables have been created."
