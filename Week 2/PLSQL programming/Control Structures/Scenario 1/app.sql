-- Scenario 1: Senior Citizen Loan Discount (Age > 60)
-- File: scenario1_senior_discount.sql

-- ============================================================================
-- TABLE STRUCTURES REQUIRED FOR THIS SCENARIO
-- ============================================================================

-- Create CUSTOMERS table
CREATE TABLE customers (
    customer_id NUMBER PRIMARY KEY,
    customer_name VARCHAR2(100) NOT NULL,
    date_of_birth DATE NOT NULL,
    email VARCHAR2(100),
    phone VARCHAR2(20),
    address VARCHAR2(200),
    created_date DATE DEFAULT SYSDATE,
    last_modified DATE DEFAULT SYSDATE
);

-- Create LOANS table
CREATE TABLE loans (
    loan_id NUMBER PRIMARY KEY,
    customer_id NUMBER NOT NULL,
    loan_amount NUMBER(15,2) NOT NULL,
    interest_rate NUMBER(5,2) NOT NULL,
    loan_term_months NUMBER NOT NULL,
    remaining_balance NUMBER(15,2),
    monthly_payment NUMBER(10,2),
    loan_type VARCHAR2(50),
    loan_status VARCHAR2(20) DEFAULT 'ACTIVE',
    start_date DATE DEFAULT SYSDATE,
    due_date DATE,
    last_modified DATE DEFAULT SYSDATE,
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

-- Sample data for testing
INSERT INTO customers VALUES (101, 'John Smith', DATE '1950-05-15', 'john.smith@email.com', '555-0101', '123 Main St', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (102, 'Mary Johnson', DATE '1980-08-22', 'mary.johnson@email.com', '555-0102', '456 Oak Ave', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (103, 'Robert Wilson', DATE '1945-12-10', 'robert.wilson@email.com', '555-0103', '789 Pine Rd', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (104, 'Lisa Brown', DATE '1975-03-18', 'lisa.brown@email.com', '555-0104', '321 Elm St', SYSDATE, SYSDATE);

INSERT INTO loans VALUES (1001, 101, 50000, 5.5, 240, 45000, 350, 'Home Loan', 'ACTIVE', SYSDATE-365, SYSDATE+30, SYSDATE);
INSERT INTO loans VALUES (1002, 102, 25000, 6.0, 60, 20000, 483, 'Personal Loan', 'ACTIVE', SYSDATE-180, SYSDATE+60, SYSDATE);
INSERT INTO loans VALUES (1003, 103, 75000, 4.8, 300, 70000, 445, 'Home Loan', 'ACTIVE', SYSDATE-120, SYSDATE+45, SYSDATE);
INSERT INTO loans VALUES (1004, 104, 15000, 7.2, 36, 12000, 466, 'Auto Loan', 'ACTIVE', SYSDATE-90, SYSDATE+75, SYSDATE);

COMMIT;

-- ============================================================================
-- MAIN PL/SQL BLOCK FOR SENIOR CITIZEN DISCOUNT PROCESSING
-- ============================================================================

DECLARE
    -- Cursor to fetch customer and loan information
    CURSOR c_customer_loans IS
        SELECT c.customer_id, c.customer_name, c.date_of_birth, 
               l.loan_id, l.interest_rate
        FROM customers c
        INNER JOIN loans l ON c.customer_id = l.customer_id
        WHERE l.loan_status = 'ACTIVE';
    
    -- Variables
    v_age NUMBER;
    v_new_interest_rate NUMBER;
    v_discount_applied NUMBER := 0;
    v_total_customers NUMBER := 0;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== SENIOR CITIZEN LOAN DISCOUNT PROCESSING ===');
    DBMS_OUTPUT.PUT_LINE('Processing customers for age-based loan discount...');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Loop through all customers with active loans
    FOR rec IN c_customer_loans LOOP
        v_total_customers := v_total_customers + 1;
        
        -- Calculate age
        v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, rec.date_of_birth) / 12);
        
        DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.customer_name || 
                           ' (ID: ' || rec.customer_id || ')');
        DBMS_OUTPUT.PUT_LINE('Age: ' || v_age || ' years');
        DBMS_OUTPUT.PUT_LINE('Current Interest Rate: ' || rec.interest_rate || '%');
        
        -- Check if customer is above 60 years old
        IF v_age > 60 THEN
            -- Apply 1% discount
            v_new_interest_rate := rec.interest_rate - 1;
            
            -- Ensure interest rate doesn't go below 0
            IF v_new_interest_rate < 0 THEN
                v_new_interest_rate := 0;
            END IF;
            
            -- Update the loan interest rate
            UPDATE loans 
            SET interest_rate = v_new_interest_rate,
                last_modified = SYSDATE
            WHERE loan_id = rec.loan_id;
            
            v_discount_applied := v_discount_applied + 1;
            
            DBMS_OUTPUT.PUT_LINE('*** DISCOUNT APPLIED ***');
            DBMS_OUTPUT.PUT_LINE('New Interest Rate: ' || v_new_interest_rate || '%');
            DBMS_OUTPUT.PUT_LINE('Savings: 1% discount applied');
        ELSE
            DBMS_OUTPUT.PUT_LINE('No discount applicable (Age <= 60)');
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
    END LOOP;
    
    -- Summary
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== PROCESSING SUMMARY ===');
    DBMS_OUTPUT.PUT_LINE('Total customers processed: ' || v_total_customers);
    DBMS_OUTPUT.PUT_LINE('Discounts applied: ' || v_discount_applied);
    DBMS_OUTPUT.PUT_LINE('Customers not eligible: ' || (v_total_customers - v_discount_applied));
    
    -- Commit the changes
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('All changes committed successfully.');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: No customer or loan data found.');
        ROLLBACK;
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/