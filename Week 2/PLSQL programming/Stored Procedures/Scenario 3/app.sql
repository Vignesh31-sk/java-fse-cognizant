-- =====================================================
-- Scenario 3: Transfer Funds Between Customer Accounts
-- =====================================================

-- Create necessary tables
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(15),
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE accounts (
    account_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    account_type VARCHAR2(20) NOT NULL,
    balance NUMBER(12,2) DEFAULT 0,
    created_date DATE DEFAULT SYSDATE,
    status VARCHAR2(10) DEFAULT 'ACTIVE',
    CONSTRAINT fk_acc_cust FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE transaction_history (
    transaction_id NUMBER PRIMARY KEY,
    from_account_id NUMBER,
    to_account_id NUMBER,
    transaction_type VARCHAR2(20) NOT NULL,
    amount NUMBER(12,2) NOT NULL,
    description VARCHAR2(200),
    transaction_date DATE DEFAULT SYSDATE,
    status VARCHAR2(10) DEFAULT 'COMPLETED',
    CONSTRAINT fk_trans_from FOREIGN KEY (from_account_id) REFERENCES accounts(account_id),
    CONSTRAINT fk_trans_to FOREIGN KEY (to_account_id) REFERENCES accounts(account_id)
);

-- Create sequences
CREATE SEQUENCE customer_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE account_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE transaction_seq START WITH 1 INCREMENT BY 1;

-- Insert sample customers
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'John', 'Doe', 'john.doe@email.com', '1234567890', SYSDATE);
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'Jane', 'Smith', 'jane.smith@email.com', '0987654321', SYSDATE);
INSERT INTO customers VALUES (customer_seq.NEXTVAL, 'Bob', 'Johnson', 'bob.johnson@email.com', '5555555555', SYSDATE);

-- Insert sample accounts
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 1, 'CHECKING', 5000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 1, 'SAVINGS', 15000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 2, 'CHECKING', 3000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 2, 'SAVINGS', 8000.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 3, 'CHECKING', 2500.00, SYSDATE, 'ACTIVE');
INSERT INTO accounts VALUES (account_seq.NEXTVAL, 3, 'SAVINGS', 12000.00, SYSDATE, 'INACTIVE');

COMMIT;

-- =====================================================
-- Stored Procedure: TransferFunds
-- =====================================================

CREATE OR REPLACE PROCEDURE TransferFunds (
    p_from_account_id IN NUMBER,
    p_to_account_id IN NUMBER,
    p_amount IN NUMBER
) IS
    v_from_balance NUMBER;
    v_to_balance NUMBER;
    v_from_status VARCHAR2(10);
    v_to_status VARCHAR2(10);
    v_from_customer VARCHAR2(100);
    v_to_customer VARCHAR2(100);
    v_transaction_id NUMBER;
    
    -- Custom exceptions
    invalid_amount EXCEPTION;
    insufficient_funds EXCEPTION;
    account_not_found EXCEPTION;
    same_account EXCEPTION;
    inactive_account EXCEPTION;
    
BEGIN
    -- Validate input parameters
    IF p_amount IS NULL OR p_amount <= 0 THEN
        RAISE invalid_amount;
    END IF;
    
    IF p_from_account_id IS NULL OR p_to_account_id IS NULL THEN
        RAISE account_not_found;
    END IF;
    
    IF p_from_account_id = p_to_account_id THEN
        RAISE same_account;
    END IF;
    
    -- Get source account information
    BEGIN
        SELECT a.balance, a.status, c.first_name || ' ' || c.last_name
        INTO v_from_balance, v_from_status, v_from_customer
        FROM accounts a
        JOIN customers c ON a.customer_id = c.customer_id
        WHERE a.account_id = p_from_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE account_not_found;
    END;
    
    -- Get destination account information
    BEGIN
        SELECT a.balance, a.status, c.first_name || ' ' || c.last_name
        INTO v_to_balance, v_to_status, v_to_customer
        FROM accounts a
        JOIN customers c ON a.customer_id = c.customer_id
        WHERE a.account_id = p_to_account_id;
    EXCEPTION
        WHEN NO_DATA_FOUND THEN
            RAISE account_not_found;
    END;
    
    -- Check if accounts are active
    IF v_from_status != 'ACTIVE' OR v_to_status != 'ACTIVE' THEN
        RAISE inactive_account;
    END IF;
    
    -- Check if source account has sufficient funds
    IF v_from_balance < p_amount THEN
        RAISE insufficient_funds;
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('=== FUND TRANSFER INITIATED ===');
    DBMS_OUTPUT.PUT_LINE('From Account: ' || p_from_account_id || ' (' || v_from_customer || ')');
    DBMS_OUTPUT.PUT_LINE('To Account: ' || p_to_account_id || ' (' || v_to_customer || ')');
    DBMS_OUTPUT.PUT_LINE('Transfer Amount: $' || TRIM(TO_CHAR(p_amount, '999,999.99')));
    DBMS_OUTPUT.PUT_LINE('');
    
    DBMS_OUTPUT.PUT_LINE('BEFORE TRANSFER:');
    DBMS_OUTPUT.PUT_LINE('Source Account Balance: $' || TRIM(TO_CHAR(v_from_balance, '999,999.99')));
    DBMS_OUTPUT.PUT_LINE('Destination Account Balance: $' || TRIM(TO_CHAR(v_to_balance, '999,999.99')));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Perform the transfer
    -- Debit from source account
    UPDATE accounts 
    SET balance = balance - p_amount
    WHERE account_id = p_from_account_id;
    
    -- Credit to destination account
    UPDATE accounts 
    SET balance = balance + p_amount
    WHERE account_id = p_to_account_id;
    
    -- Record the transaction
    SELECT transaction_seq.NEXTVAL INTO v_transaction_id FROM dual;
    
    INSERT INTO transaction_history (
        transaction_id,
        from_account_id,
        to_account_id,
        transaction_type,
        amount,
        description,
        transaction_date,
        status
    ) VALUES (
        v_transaction_id,
        p_from_account_id,
        p_to_account_id,
        'TRANSFER',
        p_amount,
        'Fund transfer from account ' || p_from_account_id || ' to account ' || p_to_account_id,
        SYSDATE,
        'COMPLETED'
    );
    
    -- Commit the transaction
    COMMIT;
    
    -- Display success message with updated balances
    DBMS_OUTPUT.PUT_LINE('AFTER TRANSFER:');
    DBMS_OUTPUT.PUT_LINE('Source Account Balance: $' || TRIM(TO_CHAR(v_from_balance - p_amount, '999,999.99')));
    DBMS_OUTPUT.PUT_LINE('Destination Account Balance: $' || TRIM(TO_CHAR(v_to_balance + p_amount, '999,999.99')));
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== TRANSFER COMPLETED SUCCESSFULLY ===');
    DBMS_OUTPUT.PUT_LINE('Transaction ID: ' || v_transaction_id);
    DBMS_OUTPUT.PUT_LINE('Transfer Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY H