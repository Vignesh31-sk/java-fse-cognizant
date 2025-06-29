# Scenario 3: Loan Due Reminder System

## Overview
This PL/SQL block creates an automated loan reminder system that identifies loans due within the next 30 days and generates personalized reminder messages for each customer. The system categorizes reminders by urgency and provides comprehensive reporting.

## Database Schema and Sample Data
**All required table structures and sample data are included in the SQL file for immediate execution.**

The code creates and populates the following tables:

### LOANS Table
- `loan_id` (Primary Key)
- `customer_id` (Foreign Key)
- `loan_amount` (NUMBER)
- `remaining_balance` (NUMBER)
- `monthly_payment` (NUMBER)
- `due_date` (DATE)
- `loan_type` (VARCHAR2)
- `loan_status` (VARCHAR2)

### CUSTOMERS Table
- `customer_id` (Primary Key)
- `customer_name` (VARCHAR2)
- `email` (VARCHAR2)
- `phone` (VARCHAR2)

### LOAN_REMINDERS Table (Optional - for audit trail)
- `reminder_id` (Primary Key)
- `loan_id` (Foreign Key)
- `customer_id` (Foreign Key)
- `reminder_date` (DATE)
- `due_date` (DATE)
- `urgency_level` (VARCHAR2)
- `message_sent` (VARCHAR2)
- `created_date` (DATE)

## Code Explanation

### 1. Advanced Cursor with Date Filtering
```sql
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
```
- Calculates `days_until_due` in the cursor for efficiency
- Filters for loans due within 30 days
- Orders by due date (most urgent first)
- Includes customer contact information

### 2. Urgency Classification Logic
```sql
IF v_days_until_due <= 7 THEN
    v_urgency_level := 'URGENT';
    v_urgent_reminders := v_urgent_reminders + 1;
ELSE
    v_urgency_level := 'STANDARD';
    v_standard_reminders := v_standard_reminders + 1;
END IF;
```
- **URGENT**: Loans due within 7 days
- **STANDARD**: Loans due within 8-30 days
- Separate counters track each category

### 3. Dynamic Message Generation
```sql
v_reminder_message := 'Dear ' || rec.customer_name || ', ' ||
                     'your ' || rec.loan_type || ' loan (ID: ' || rec.loan_id || ') ' ||
                     'is due in ' || v_days_until_due || ' day(s) on ' || 
                     TO_CHAR(rec.due_date, 'DD-MON-YYYY') || '. ' ||
                     'Amount due: $' || TO_CHAR(rec.monthly_payment, '999,999.99') || '. ' ||
                     'Please ensure timely payment to avoid late fees.';
```
- Personalized messages with customer names
- Includes loan-specific details
- Professional tone for customer communication

### 4. Risk Assessment and Analytics
```sql
v_risk_percentage := ROUND((v_urgent_reminders / v_total_reminders) * 100, 2);
v_avg_amount_due := ROUND(v_total_amount_due / v_total_reminders, 2);

IF v_risk_percentage >= 50 THEN
    DBMS_OUTPUT.PUT_LINE('RISK LEVEL: HIGH - Majority of loans are urgently due');
```
- Calculates risk metrics
- Provides automated risk level assessment
- Supports management decision-making

## Expected Output

```
=== LOAN DUE REMINDER SYSTEM ===
Generating reminders for loans due within 30 days...
Processing Date: 29-JUN-2025

REMINDER #1 [URGENT]
========================================
Customer: Alice Johnson (ID: 201)
Contact: alice.johnson@email.com | 555-0123
Loan ID: 1001
Loan Type: Personal Loan
Original Amount: $15,000.00
Remaining Balance: $12,500.00
Monthly Payment: $450.00
Due Date: 02-JUL-2025 (Wednesday)
Days Until Due: 3

*** URGENT ATTENTION REQUIRED ***
CRITICAL: Payment due within 3 days!
Please contact customer immediately.

REMINDER MESSAGE:
Dear Alice Johnson, your Personal Loan loan (ID: 1001) is due in 3 day(s) on 02-JUL-2025. Amount due: $450.00. Please ensure timely payment to avoid late fees.

----------------------------------------

REMINDER #2 [STANDARD]
========================================
Customer: Bob Smith (ID: 202)
Contact: bob.smith@email.com | 555-0456
Loan ID: 1002
Loan Type: Auto Loan
Original Amount: $25,000.00
Remaining Balance: $18,750.00
Monthly Payment: $520.00
Due Date: 15-JUL-2025 (Tuesday)
Days Until Due: 16

REMINDER MESSAGE:
Dear Bob Smith, your Auto Loan loan (ID: 1002) is due in 16 day(s) on 15-JUL-2025. Amount due: $520.00. Please ensure timely payment to avoid late fees.

----------------------------------------

=== REMINDER PROCESSING SUMMARY ===
Total reminders generated: 2
Urgent reminders (≤7 days): 1
Standard reminders (8-30 days): 1
Total amount at risk: $31,250.00

=== RISK ANALYSIS ===
Urgent reminder percentage: 50.00%
Average amount due per loan: $485.00
RISK LEVEL: HIGH - Majority of loans are urgently due

=== RECOMMENDED ACTIONS ===
1. Immediately contact customers with urgent due dates
2. Prepare collection procedures for overdue accounts
3. Consider offering payment extensions if appropriate
4. Send standard reminder notices to customers
5. Schedule follow-up calls closer to due dates
6. Monitor payment receipts daily
7. Update loan status upon payment completion

Reminder processing completed successfully.
```

## Features

### Control Structures Used
- **FOR LOOP**: Processes each due loan
- **IF-THEN-ELSE**: Multi-level urgency classification
- **Nested IF**: Critical timing alerts
- **Nested PL/SQL Blocks**: Risk analysis and data validation

### Advanced PL/SQL Features
- **Date Arithmetic**: `(l.due_date - SYSDATE)` for days calculation
- **Dynamic SQL**: Conditional insert for audit logging
- **Exception Handling**: Graceful handling of missing audit table
- **Complex String Concatenation**: Message building
- **Mathematical Operations**: Risk calculations and averages

### Business Intelligence Features
- **Risk Categorization**: Urgent vs Standard reminders
- **Financial Analysis**: Total amounts at risk
- **Performance Metrics**: Average payment amounts
- **Automated Recommendations**: Action-oriented guidance

## Execution Instructions

1. **Run the complete script**: The SQL file includes table creation, sample data, and the PL/SQL block
2. **Enable output**: `SET SERVEROUTPUT ON SIZE 1000000`
3. **Execute the entire file**: All components will run in sequence
4. **Review output**: Analyze the comprehensive reminder report

**Note**: The script includes loans with strategic due dates to demonstrate both urgent and standard reminders.

## Sample Data Included
The script includes strategic test data:
- **Alice Johnson**: Personal Loan due in 3 days (URGENT)
- **Bob Smith**: Auto Loan due in 16 days (STANDARD)
- **Carol Davis**: Mortgage due in 25 days (STANDARD)
- **David Wilson**: Credit Line due in 7 days (URGENT)
- **Emma Brown**: Home Equity due in 45 days (Outside 30-day window)
- **Additional loan**: Outside processing window to test filtering

## Complete Solution Features
- **Ready-to-Run**: No separate table setup required
- **Comprehensive Test Data**: Multiple scenarios included
- **Audit Trail**: Optional reminder logging table included
- **Error Handling**: Graceful handling of missing audit table

## Business Benefits
- **Proactive Risk Management**: Early identification of potential defaults
- **Customer Relationship Management**: Professional, personalized communication
- **Operational Efficiency**: Automated reminder generation and prioritization
- **Financial Protection**: Reduces bad debt through timely notifications
- **Management Reporting**: Comprehensive analytics and risk assessment
- **Audit Compliance**: Optional reminder logging for regulatory requirements
- **Scalability**: Handles any number of loans efficiently