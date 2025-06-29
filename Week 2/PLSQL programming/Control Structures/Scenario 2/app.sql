-- Scenario 2: VIP Status Assignment Based on Balance
-- File: scenario2_vip_status.sql

-- ============================================================================
-- TABLE STRUCTURES REQUIRED FOR THIS SCENARIO
-- ============================================================================

-- Create CUSTOMERS table (with VIP fields)
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(20),
    address VARCHAR2(200),
    is_vip VARCHAR2(5) DEFAULT 'FALSE' CHECK (is_vip IN ('TRUE', 'FALSE')),
    vip_since DATE,
    created_date DATE DEFAULT SYSDATE,
    last_modified DATE DEFAULT SYSDATE
);

-- Create ACCOUNTS table
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    account_number VARCHAR2(20) UNIQUE NOT NULL,
    account_type VARCHAR2(20) NOT NULL,
    balance NUMBER(15,2) DEFAULT 0,
    account_status VARCHAR2(20) DEFAULT 'ACTIVE',
    opening_date DATE DEFAULT SYSDATE,
    last_transaction_date DATE,
    CONSTRAINT fk_accounts_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_account_status CHECK (account_status IN ('ACTIVE', 'INACTIVE', 'CLOSED'))
);

-- Sample data for testing
INSERT INTO customers VALUES (201, 'Alice Johnson', DATE '1985-06-12', 'alice.johnson@email.com', '555-0201', '111 First St', 'FALSE', NULL, SYSDATE, SYSDATE);
INSERT INTO customers VALUES (202, 'Bob Smith', DATE '1978-09-25', 'bob.smith@email.com', '555-0202', '222 Second Ave', 'FALSE', NULL, SYSDATE, SYSDATE);
INSERT INTO customers VALUES (203, 'Carol Davis', DATE '1990-01-08', 'carol.davis@email.com', '555-0203', '333 Third Blvd', 'TRUE', SYSDATE-30, SYSDATE, SYSDATE);
INSERT INTO customers VALUES (204, 'David Wilson', DATE '1982-11-30', 'david.wilson@email.com', '555-0204', '444 Fourth St', 'FALSE', NULL, SYSDATE, SYSDATE);
INSERT INTO customers VALUES (205, 'Emma Brown', DATE '1988-04-15', 'emma.brown@email.com', '555-0205', '555 Fifth Ave', 'FALSE', NULL, SYSDATE, SYSDATE);

INSERT INTO accounts VALUES (10001, 201, 'ACC-001-201', 'SAVINGS', 8500.00, 'ACTIVE', SYSDATE-365, SYSDATE-1);
INSERT INTO accounts VALUES (10002, 201, 'ACC-002-201', 'CHECKING', 3200.50, 'ACTIVE', SYSDATE-200, SYSDATE-2);
INSERT INTO accounts VALUES (10003, 202, 'ACC-001-202', 'SAVINGS', 15750.00, 'ACTIVE', SYSDATE-180, SYSDATE-1);
INSERT INTO accounts VALUES (10004, 202, 'ACC-002-202', 'CHECKING', 2500.25, 'ACTIVE', SYSDATE-90, SYSDATE-3);
INSERT INTO accounts VALUES (10005, 203, 'ACC-001-203', 'SAVINGS', 25000.00, 'ACTIVE', SYSDATE-300, SYSDATE-1);
INSERT INTO accounts VALUES (10006, 203, 'ACC-002-203', 'INVESTMENT', 45000.75, 'ACTIVE', SYSDATE-150, SYSDATE-5);
INSERT INTO accounts VALUES (10007, 204, 'ACC-001-204', 'CHECKING', 1200.00, 'ACTIVE', SYSDATE-60, SYSDATE-1);
INSERT INTO accounts VALUES (10008, 204, 'ACC-002-204', 'SAVINGS', 3800.50, 'ACTIVE', SYSDATE-45, SYSDATE-2);
INSERT INTO accounts VALUES (10009, 205, 'ACC-001-205', 'SAVINGS', 12500.00, 'ACTIVE', SYSDATE-120, SYSDATE-1);
INSERT INTO accounts VALUES (10010, 205, 'ACC-002-205', 'CHECKING', 8750.25, 'ACTIVE', SYSDATE-75, SYSDATE-3);

COMMIT;

-- ============================================================================
-- MAIN PL/SQL BLOCK FOR VIP STATUS PROCESSING
-- ============================================================================

DECLARE
    -- Cursor to fetch all customers with their account balances
    CURSOR c_customers IS
        SELECT c.customer_id, c.customer_name, 
               NVL(SUM(a.balance), 0) as total_balance,
               c.is_vip
        FROM customers c
        LEFT JOIN accounts a ON c.customer_id = a.customer_id
        WHERE a.account_status = 'ACTIVE' OR a.account_status IS NULL
        GROUP BY c.customer_id, c.customer_name, c.is_vip
        ORDER BY total_balance DESC;
    
    -- Variables
    v_vip_threshold CONSTANT NUMBER := 10000; -- $10,000 threshold
    v_customers_processed NUMBER := 0;
    v_new_vips NUMBER := 0;
    v_existing_vips NUMBER := 0;
    v_non_vips NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== VIP STATUS ASSIGNMENT PROCESSING ===');
    DBMS_OUTPUT.PUT_LINE('VIP Threshold: $' || TO_CHAR(v_vip_threshold, '999,999,999'));
    DBMS_OUTPUT.PUT_LINE('Processing all customers for VIP status update...');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Loop through all customers
    FOR rec IN c_customers LOOP
        v_customers_processed := v_customers_processed + 1;
        
        DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.customer_name || 
                           ' (ID: ' || rec.customer_id || ')');
        DBMS_OUTPUT.PUT_LINE('Total Balance: $' || TO_CHAR(rec.total_balance, '999,999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Current VIP Status: ' || 
                           CASE WHEN NVL(rec.is_vip, 'FALSE') = 'TRUE' THEN 'VIP' ELSE 'Regular' END);
        
        -- Check if customer qualifies for VIP status
        IF rec.total_balance > v_vip_threshold THEN
            -- Customer qualifies for VIP status
            IF NVL(rec.is_vip, 'FALSE') = 'FALSE' THEN
                -- New VIP - update status
                UPDATE customers 
                SET is_vip = 'TRUE',
                    vip_since = SYSDATE,
                    last_modified = SYSDATE
                WHERE customer_id = rec.customer_id;
                
                v_new_vips := v_new_vips + 1;
                DBMS_OUTPUT.PUT_LINE('*** PROMOTED TO VIP STATUS ***');
                DBMS_OUTPUT.PUT_LINE('Qualification: Balance exceeds $' || 
                                   TO_CHAR(v_vip_threshold, '999,999,999'));
            ELSE
                -- Already VIP
                v_existing_vips := v_existing_vips + 1;
                DBMS_OUTPUT.PUT_LINE('Status: Already VIP (no change needed)');
            END IF;
        ELSE
            -- Customer does not qualify for VIP status
            IF NVL(rec.is_vip, 'FALSE') = 'TRUE' THEN
                -- Demote from VIP (optional business rule)
                UPDATE customers 
                SET is_vip = 'FALSE',
                    vip_since = NULL,
                    last_modified = SYSDATE
                WHERE customer_id = rec.customer_id;
                
                DBMS_OUTPUT.PUT_LINE('*** VIP STATUS REMOVED ***');
                DBMS_OUTPUT.PUT_LINE('Reason: Balance below threshold');
            ELSE
                v_non_vips := v_non_vips + 1;
                DBMS_OUTPUT.PUT_LINE('Status: Regular customer (balance below threshold)');
            END IF;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
    
    -- Summary Report
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== VIP STATUS PROCESSING SUMMARY ===');
    DBMS_OUTPUT.PUT_LINE('Total customers processed: ' || v_customers_processed);
    DBMS_OUTPUT.PUT_LINE('New VIP promotions: ' || v_new_vips);
    DBMS_OUTPUT.PUT_LINE('Existing VIP customers: ' || v_existing_vips);
    DBMS_OUTPUT.PUT_LINE('Regular customers: ' || v_non_vips);
    DBMS_OUTPUT.PUT_LINE('VIP threshold: $' || TO_CHAR(v_vip_threshold, '999,999,999'));
    
    -- VIP Statistics
    DECLARE
        v_total_vips NUMBER;
        v_vip_percentage NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_total_vips 
        FROM customers 
        WHERE is_vip = 'TRUE';
        
        v_vip_percentage := ROUND((v_total_vips / v_customers_processed) * 100, 2);
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('=== VIP STATISTICS ===');
        DBMS_OUTPUT.PUT_LINE('Total VIP customers: ' || v_total_vips);
        DBMS_OUTPUT.PUT_LINE('VIP percentage: ' || v_vip_percentage || '%');
    END;
    
    -- Commit the changes
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('All changes committed successfully.');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No customer data found.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/