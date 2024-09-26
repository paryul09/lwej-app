\c lwejinv;

-- Create the employees table
CREATE TABLE employees (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    father_name VARCHAR(255),
    town VARCHAR(255),
    contact_number VARCHAR(20),
    department VARCHAR(255) NOT NULL,
    designation VARCHAR(255)
);

-- Create the attendance table
CREATE TABLE attendance (
    id SERIAL PRIMARY KEY,
    employee_id BIGINT NOT NULL,
    date DATE NOT NULL,
    present BOOLEAN NOT NULL,
    CONSTRAINT unique_attendance UNIQUE (employee_id, date),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES employees(id) ON DELETE CASCADE
);

-- Create the customer table
CREATE TABLE customer (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    father_name VARCHAR(255),
    village_name VARCHAR(255)
);

-- Create the customercontact table
CREATE TABLE customercontact (
    customer_id BIGINT REFERENCES customer(id),
    contact_number VARCHAR(20),
    PRIMARY KEY (customer_id, contact_number)
);

-- Create the supplier table
CREATE TABLE supplier (
    id SERIAL PRIMARY KEY,
    firm_name VARCHAR(255),
    mobile_number VARCHAR(20),
    account_number VARCHAR(50),
    ifsc_code VARCHAR(20),
    total_balance DECIMAL(15, 2) DEFAULT 0,
    gold_balance DECIMAL(15, 2) DEFAULT 0,
    silver_balance DECIMAL(15, 2) DEFAULT 0,
    cash_balance DECIMAL(15, 2) DEFAULT 0
);

-- Create the itemType table
CREATE TABLE item_type (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    image_url VARCHAR(255),
    available_in VARCHAR(50) -- Values can be "gold", "silver", or "both"
);

-- Create the metalRate table
CREATE TABLE metal_rate (
    id SERIAL PRIMARY KEY,
    gold_rate DECIMAL(15, 2),
    silver_rate DECIMAL(15, 2),
    date_updated DATE
);

-- Create the item table
CREATE TABLE item (
    id SERIAL PRIMARY KEY,
    metal VARCHAR(50) NOT NULL,
    weight DOUBLE PRECISION NOT NULL,
    net_weight DOUBLE PRECISION NOT NULL,
    purity INTEGER NOT NULL,
    subtype VARCHAR(255),
    default_rate DECIMAL(15, 2),
    sold BOOLEAN NOT NULL,
    price DECIMAL(15, 2),
    quantity INTEGER,
    item_type_id BIGINT NOT NULL,
    supplier_id BIGINT NOT NULL,
    metal_rate_id BIGINT,
    CONSTRAINT fk_item_type FOREIGN KEY (item_type_id) REFERENCES item_type(id),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id),
    CONSTRAINT fk_metal_rate FOREIGN KEY (metal_rate_id) REFERENCES metal_rate(id)
);

-- Create the transaction table
CREATE TABLE transaction (
    id SERIAL PRIMARY KEY,
    transaction_type VARCHAR(50), -- E.g., "Sell", "Customer", "Supplier"
    transaction_nature VARCHAR(50),
    amount DECIMAL(15, 2),
    transaction_date TIMESTAMP,
    description TEXT,
    reverted BOOLEAN DEFAULT FALSE,
    customer_id BIGINT, -- Optional
    supplier_id BIGINT, -- Optional
    CONSTRAINT fk_customer FOREIGN KEY (customer_id) REFERENCES customer(id),
    CONSTRAINT fk_supplier FOREIGN KEY (supplier_id) REFERENCES supplier(id)
);

-- Create the sell_transaction_details table
CREATE TABLE sell_transaction_details (
    id SERIAL PRIMARY KEY,
    transaction_id BIGINT NOT NULL,
    item_id BIGINT NOT NULL,
    quantity INTEGER,
    sold_weight DOUBLE PRECISION,
    sold_net_weight DOUBLE PRECISION,
    CONSTRAINT fk_transaction FOREIGN KEY (transaction_id) REFERENCES transaction(id),
    CONSTRAINT fk_item FOREIGN KEY (item_id) REFERENCES item(id)
);

-- Create the opening_closing_balance table
CREATE TABLE opening_closing_balance (
    id SERIAL PRIMARY KEY,
    date DATE,
    opening_balance DECIMAL(15, 2),
    closing_balance DECIMAL(15, 2)
);
