-- =====================================================
-- Scenario 1: Process Monthly Interest for Savings Accounts
-- =====================================================

-- Create necessary tables
CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    account_type VARCHAR2(20) NOT NULL,
    balance NUMBER(12,2) DEFAULT 0,
    created_date DATE DEFAULT SYSDATE,
    status VARCHAR2(10) DEFAULT 'ACTIVE'
);

CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(15),
    created_date DATE DEFAULT SYSDATE
);

-- Create sequence for account_id
CREATE SEQUENCE account_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;

-- Insert sample data
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'John', 'Doe', 'john.doe@email.com', '1234567890', SYSDATE);
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'Jane', 'Smith', 'jane.smith@email.com', '0987654321', SYSDATE);
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'Bob', 'Johnson', 'bob.johnson@email.com', '5555555555', SYSDATE);

INSERT INTO accounts VALUES (account_seq.NEXTVAL, 1, 'SAVINGS', 5000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 1, 'CHECKING', 2500.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 2, 'SAVINGS', 10000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 3, 'SAVINGS', 7500.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 3, 'CHECKING', 1200.00, SYSDATE, 'ACTIVE');

COMMIT;

-- =====================================================
-- Stored Procedure: ProcessMonthlyInterest
-- =====================================================

CREATE OR REPLACE PROCEDURE ProcessMonthlyInterest IS
    v_count NUMBER := 0;
    v_total_interest NUMBER := 0;
    CURSOR savings_cursor IS
        SELECT account_id, balance
        FROM accounts
        WHERE account_type = 'SAVINGS' 
        AND status = 'ACTIVE';
    
    v_interest_amount NUMBER;
    v_new_balance NUMBER;
    
BEGIN
    -- Process each savings account
    FOR account_rec IN savings_cursor LOOP
        -- Calculate 1% interest
        v_interest_amount := account_rec.balance * 0.01;
        v_new_balance := account_rec.balance + v_interest_amount;
        
        -- Update the account balance
        UPDATE accounts 
        SET balance = v_new_balance
        WHERE account_id = account_rec.account_id;
        
        -- Keep track of statistics
        v_count := v_count + 1;
        v_total_interest := v_total_interest + v_interest_amount;
        
        -- Log the interest processed
        DBMS_OUTPUT.PUT_LINE('Account ID: ' || account_rec.account_id || 
                           ', Old Balance: ' || account_rec.balance ||
                           ', Interest: ' || v_interest_amount ||
                           ', New Balance: ' || v_new_balance);
    END LOOP;
    
    -- Commit the changes
    COMMIT;
    
    -- Display summary
    DBMS_OUTPUT.PUT_LINE('=== MONTHLY INTEREST PROCESSING COMPLETE ===');
    DBMS_OUTPUT.PUT_LINE('Total Accounts Processed: ' || v_count);
    DBMS_OUTPUT.PUT_LINE('Total Interest Added: $' || ROUND(v_total_interest, 2));
    
EXCEPTION
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing monthly interest: ' || SQLERRM);
        RAISE;
END ProcessMonthlyInterest;
/

-- =====================================================
-- Test the Procedure
-- =====================================================

-- Show balances before processing
SELECT 'BEFORE PROCESSING' as status, account_id, account_type, balance 
FROM accounts 
ORDER BY account_id;

-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Execute the procedure
EXEC ProcessMonthlyInterest;

-- Show balances after processing
SELECT 'AFTER PROCESSING' as status, account_id, account_type, balance 
FROM accounts 
ORDER BY account_id;