-- Create the database
CREATE DATABASE lwejInv;

-- Connect to the newly created database
\c lwejInv;

-- Create a user with the given username and password (if not already existing)
CREATE USER postgres WITH PASSWORD 'lwej12';

-- Grant all privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE lwejInv TO postgres;