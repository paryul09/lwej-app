# Variables for database user, password, and name
$DB_USER = "postgres"
$DB_PASSWORD = "lwej12"
$DB_NAME = "lwejInv"

# Check if PostgreSQL is installed using Chocolatey
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Host "Error: Chocolatey is required for installation. Please install Chocolatey first."
    exit 1
}

# Install PostgreSQL using Chocolatey (if not already installed)
if (-not (Get-Command psql -ErrorAction SilentlyContinue)) {
    Write-Host "Installing PostgreSQL..."
    choco install postgresql -y
} else {
    Write-Host "PostgreSQL is already installed."
}

# Start PostgreSQL service
Start-Service -Name postgresql

# Set the PostgreSQL password (Windows typically sets a default password during installation)
Write-Host "Setting PostgreSQL user password..."
$env:PGPASSWORD = $DB_PASSWORD
psql -U postgres -c "ALTER USER $DB_USER WITH PASSWORD '$DB_PASSWORD';"

# Create the database and grant privileges if it doesn't already exist
Write-Host "Creating PostgreSQL database and user..."
psql -U postgres -c "
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
\$do\$;"

# Check if the SQL file exists
$SQL_FILE = "createTable.sql"
if (-not (Test-Path $SQL_FILE)) {
    Write-Host "Error: SQL file '$SQL_FILE' not found!"
    exit 1
}

# Run the SQL script to create tables
Write-Host "Creating tables in the $DB_NAME database..."
psql -U $DB_USER -d $DB_NAME -f $SQL_FILE

Write-Host "PostgreSQL setup complete. Database '$DB_NAME', user '$DB_USER', and tables created."
