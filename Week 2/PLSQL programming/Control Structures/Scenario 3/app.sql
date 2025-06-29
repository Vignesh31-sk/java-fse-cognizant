-- Scenario 3: Loan Due Reminder System (Next 30 Days)
-- File: scenario3_loan_reminders.sql

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
    last_payment_date DATE,
    next_payment_date DATE,
    last_modified DATE DEFAULT SYSDATE,
    CONSTRAINT fk_loans_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_loan_status CHECK (loan_status IN ('ACTIVE', 'PAID', 'DEFAULTED', 'SUSPENDED'))
);

-- Create LOAN_REMINDERS table (for audit trail)
CREATE TABLE loan_reminders (
    reminder_id NUMBER PRIMARY KEY,
    loan_id NUMBER NOT NULL,
    customer_id NUMBER NOT NULL,
    reminder_date DATE DEFAULT SYSDATE,
    due_date DATE NOT NULL,
    urgency_level VARCHAR2(20),
    message_sent VARCHAR2(1) DEFAULT 'N',
    reminder_method VARCHAR2(20),
    created_date DATE DEFAULT SYSDATE,
    CONSTRAINT fk_reminders_loan FOREIGN KEY (loan_id) REFERENCES loans(loan_id),
    CONSTRAINT fk_reminders_customer FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    CONSTRAINT chk_message_sent CHECK (message_sent IN ('Y', 'N')),
    CONSTRAINT chk_urgency_level CHECK (urgency_level IN ('URGENT', 'STANDARD', 'OVERDUE'))
);

-- Create sequence for loan_reminders
CREATE SEQUENCE loan_reminders_seq START WITH 1 INCREMENT BY 1;

-- Sample data for testing
INSERT INTO customers VALUES (301, 'Alice Johnson', DATE '1985-06-12', 'alice.johnson@email.com', '555-0301', '111 Maple St', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (302, 'Bob Smith', DATE '1978-09-25', 'bob.smith@email.com', '555-0302', '222 Cedar Ave', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (303, 'Carol Davis', DATE '1990-01-08', 'carol.davis@email.com', '555-0303', '333 Birch Blvd', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (304, 'David Wilson', DATE '1982-11-30', 'david.wilson@email.com', '555-0304', '444 Spruce St', SYSDATE, SYSDATE);
INSERT INTO customers VALUES (305, 'Emma Brown', DATE '1988-04-15', 'emma.brown@email.com', '555-0305', '555 Willow Ave', SYSDATE, SYSDATE);

-- Insert loans with various due dates (some within 30 days, some not)
INSERT INTO loans VALUES (2001, 301, 15000, 5.5, 60, 12500, 450, 'Personal Loan', 'ACTIVE', SYSDATE-365, SYSDATE+3, SYSDATE-30, SYSDATE+3, SYSDATE);
INSERT INTO loans VALUES (2002, 302, 25000, 6.0, 72, 18750, 520, 'Auto Loan', 'ACTIVE', SYSDATE-180, SYSDATE+16, SYSDATE-30, SYSDATE+16, SYSDATE);
INSERT INTO loans VALUES (2003, 303, 200000, 4.2, 300, 185000, 1200, 'Mortgage', 'ACTIVE', SYSDATE-120, SYSDATE+25, SYSDATE-30, SYSDATE+25, SYSDATE);
INSERT INTO loans VALUES (2004, 304, 8000, 7.8, 48, 6500, 195, 'Credit Line', 'ACTIVE', SYSDATE-90, SYSDATE+7, SYSDATE-30, SYSDATE+7, SYSDATE);
INSERT INTO loans VALUES (2005, 305, 50000, 5.0, 240, 45000, 320, 'Home Equity', 'ACTIVE', SYSDATE-200, SYSDATE+45, SYSDATE-30, SYSDATE+45, SYSDATE);
-- Loan outside 30-day window (should not appear in reminders)
INSERT INTO loans VALUES (2006, 301, 12000, 6.5, 36, 8000, 375, 'Personal Loan', 'ACTIVE', SYSDATE-60, SYSDATE+60, SYSDATE-30, SYSDATE+60, SYSDATE);

COMMIT;

-- ============================================================================
-- MAIN PL/SQL BLOCK FOR LOAN DUE REMINDER PROCESSING
-- ============================================================================

DECLARE
    -- Cursor to fetch loans due within next 30 days
    CURSOR c_due_loans IS
        SELECT l.loan_id, l.customer_id, l.loan_amount, l.due_date, 
               l.remaining_balance, l.monthly_payment, l.loan_type,
               c.customer_name, c.email, c.phone,
               (l.due_date - SYSDATE) as days_until_due
        FROM loans l
        INNER JOIN customers c ON l.customer_id = c.customer_id
        WHERE l.loan_status = 'ACTIVE'
        AND l.due_date BETWEEN SYSDATE AND (SYSDATE + 30)
        ORDER BY l.due_date ASC, c.customer_name;
    
    -- Variables for categorizing reminders
    v_urgent_reminders NUMBER := 0;    -- Due within 7 days
    v_standard_reminders NUMBER := 0;  -- Due within 8-30 days
    v_total_reminders NUMBER := 0;
    v_total_amount_due NUMBER := 0;
    
    -- Variables for reminder content
    v_reminder_message VARCHAR2(1000);
    v_urgency_level VARCHAR2(20);
    v_days_until_due NUMBER;
    
BEGIN
    DBMS_OUTPUT.PUT_LINE('=== LOAN DUE REMINDER SYSTEM ===');
    DBMS_OUTPUT.PUT_LINE('Generating reminders for loans due within 30 days...');
    DBMS_OUTPUT.PUT_LINE('Processing Date: ' || TO_CHAR(SYSDATE, 'DD-MON-YYYY'));
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Check if there are any due loans
    DECLARE
        v_count NUMBER;
    BEGIN
        SELECT COUNT(*) INTO v_count
        FROM loans l
        WHERE l.loan_status = 'ACTIVE'
        AND l.due_date BETWEEN SYSDATE AND (SYSDATE + 30);
        
        IF v_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('No loans due within the next 30 days.');
            RETURN;
        END IF;
    END;
    
    -- Process each due loan
    FOR rec IN c_due_loans LOOP
        v_total_reminders := v_total_reminders + 1;
        v_total_amount_due := v_total_amount_due + rec.remaining_balance;
        v_days_until_due := ROUND(rec.days_until_due);
        
        -- Determine urgency level
        IF v_days_until_due <= 7 THEN
            v_urgency_level := 'URGENT';
            v_urgent_reminders := v_urgent_reminders + 1;
        ELSE
            v_urgency_level := 'STANDARD';
            v_standard_reminders := v_standard_reminders + 1;
        END IF;
        
        -- Create personalized reminder message
        v_reminder_message := 'Dear ' || rec.customer_name || ', ' ||
                             'your ' || rec.loan_type || ' loan (ID: ' || rec.loan_id || ') ' ||
                             'is due in ' || v_days_until_due || ' day(s) on ' || 
                             TO_CHAR(rec.due_date, 'DD-MON-YYYY') || '. ' ||
                             'Amount due: $' || TO_CHAR(rec.monthly_payment, '999,999.99') || '. ' ||
                             'Please ensure timely payment to avoid late fees.';
        
        -- Display reminder details
        DBMS_OUTPUT.PUT_LINE('REMINDER #' || v_total_reminders || ' [' || v_urgency_level || ']');
        DBMS_OUTPUT.PUT_LINE('========================================');
        DBMS_OUTPUT.PUT_LINE('Customer: ' || rec.customer_name || ' (ID: ' || rec.customer_id || ')');
        DBMS_OUTPUT.PUT_LINE('Contact: ' || NVL(rec.email, 'N/A') || ' | ' || NVL(rec.phone, 'N/A'));
        DBMS_OUTPUT.PUT_LINE('Loan ID: ' || rec.loan_id);
        DBMS_OUTPUT.PUT_LINE('Loan Type: ' || rec.loan_type);
        DBMS_OUTPUT.PUT_LINE('Original Amount: $' || TO_CHAR(rec.loan_amount, '999,999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Remaining Balance: $' || TO_CHAR(rec.remaining_balance, '999,999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Monthly Payment: $' || TO_CHAR(rec.monthly_payment, '999,999.99'));
        DBMS_OUTPUT.PUT_LINE('Due Date: ' || TO_CHAR(rec.due_date, 'DD-MON-YYYY (Day)'));
        DBMS_OUTPUT.PUT_LINE('Days Until Due: ' || v_days_until_due);
        
        -- Display urgency-specific information
        IF v_urgency_level = 'URGENT' THEN
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('*** URGENT ATTENTION REQUIRED ***');
            IF v_days_until_due <= 3 THEN
                DBMS_OUTPUT.PUT_LINE('CRITICAL: Payment due within 3 days!');
                DBMS_OUTPUT.PUT_LINE('Please contact customer immediately.');
            ELSIF v_days_until_due <= 7 THEN
                DBMS_OUTPUT.PUT_LINE('HIGH PRIORITY: Payment due within a week.');
                DBMS_OUTPUT.PUT_LINE('Recommend immediate customer contact.');
            END IF;
        END IF;
        
        DBMS_OUTPUT.PUT_LINE('');
        DBMS_OUTPUT.PUT_LINE('REMINDER MESSAGE:');
        DBMS_OUTPUT.PUT_LINE(v_reminder_message);
        DBMS_OUTPUT.PUT_LINE('');
        
        -- Insert reminder log (optional - for audit trail)
        BEGIN
            INSERT INTO loan_reminders (
                reminder_id, loan_id, customer_id, reminder_date, 
                due_date, urgency_level, message_sent, created_date
            ) VALUES (
                loan_reminders_seq.NEXTVAL, rec.loan_id, rec.customer_id, 
                SYSDATE, rec.due_date, v_urgency_level, 'Y', SYSDATE
            );
        EXCEPTION
            WHEN OTHERS THEN
                -- Table might not exist, continue processing
                NULL;
        END;
        
        DBMS_OUTPUT.PUT_LINE('----------------------------------------');
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    -- Generate summary report
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== REMINDER PROCESSING SUMMARY ===');
    DBMS_OUTPUT.PUT_LINE('Total reminders generated: ' || v_total_reminders);
    DBMS_OUTPUT.PUT_LINE('Urgent reminders (≤7 days): ' || v_urgent_reminders);
    DBMS_OUTPUT.PUT_LINE('Standard reminders (8-30 days): ' || v_standard_reminders);
    DBMS_OUTPUT.PUT_LINE('Total amount at risk: $' || TO_CHAR(v_total_amount_due, '999,999,999.99'));
    
    -- Risk analysis
    DECLARE
        v_risk_percentage NUMBER;
        v_avg_amount_due NUMBER;
    BEGIN
        IF v_total_reminders > 0 THEN
            v_risk_percentage := ROUND((v_urgent_reminders / v_total_reminders) * 100, 2);
            v_avg_amount_due := ROUND(v_total_amount_due / v_total_reminders, 2);
            
            DBMS_OUTPUT.PUT_LINE('');
            DBMS_OUTPUT.PUT_LINE('=== RISK ANALYSIS ===');
            DBMS_OUTPUT.PUT_LINE('Urgent reminder percentage: ' || v_risk_percentage || '%');
            DBMS_OUTPUT.PUT_LINE('Average amount due per loan: $' || TO_CHAR(v_avg_amount_due, '999,999.99'));
            
            -- Risk level assessment
            IF v_risk_percentage >= 50 THEN
                DBMS_OUTPUT.PUT_LINE('RISK LEVEL: HIGH - Majority of loans are urgently due');
            ELSIF v_risk_percentage >= 25 THEN
                DBMS_OUTPUT.PUT_LINE('RISK LEVEL: MEDIUM - Significant portion urgently due');
            ELSE
                DBMS_OUTPUT.PUT_LINE('RISK LEVEL: LOW - Most loans have adequate notice period');
            END IF;
        END IF;
    END;
    
    -- Action recommendations
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('=== RECOMMENDED ACTIONS ===');
    IF v_urgent_reminders > 0 THEN
        DBMS_OUTPUT.PUT_LINE('1. Immediately contact customers with urgent due dates');
        DBMS_OUTPUT.PUT_LINE('2. Prepare collection procedures for overdue accounts');
        DBMS_OUTPUT.PUT_LINE('3. Consider offering payment extensions if appropriate');
    END IF;
    
    IF v_standard_reminders > 0 THEN
        DBMS_OUTPUT.PUT_LINE('4. Send standard reminder notices to customers');
        DBMS_OUTPUT.PUT_LINE('5. Schedule follow-up calls closer to due dates');
    END IF;
    
    DBMS_OUTPUT.PUT_LINE('6. Monitor payment receipts daily');
    DBMS_OUTPUT.PUT_LINE('7. Update loan status upon payment completion');
    
    COMMIT;
    DBMS_OUTPUT.PUT_LINE('');
    DBMS_OUTPUT.PUT_LINE('Reminder processing completed successfully.');
    
EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No loan data found for processing.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error occurred: ' || SQLERRM);
        ROLLBACK;
END;
/