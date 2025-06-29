# Scenario 1: Senior Citizen Loan Discount

## Overview
This PL/SQL block implements an automated system to apply a 1% discount to loan interest rates for customers above 60 years old.

## Database Schema and Sample Data
**All required table structures and sample data are included in the SQL file for immediate execution.**

The code creates and populates the following tables:

### CUSTOMERS Table
- `customer_id` (Primary Key)
- `customer_name`
- `date_of_birth`

### LOANS Table
- `loan_id` (Primary Key)
- `customer_id` (Foreign Key)
- `interest_rate`
- `loan_status`
- `last_modified`

## Code Explanation

### 1. Cursor Declaration
```sql
CURSOR c_customer_loans IS
    SELECT c.customer_id, c.customer_name, c.date_of_birth, 
           l.loan_id, l.interest_rate
    FROM customers c
    INNER JOIN loans l ON c.customer_id = l.customer_id
    WHERE l.loan_status = 'ACTIVE';
```
- Joins customers and loans tables
- Only processes active loans
- Retrieves necessary information for age calculation and discount application

### 2. Age Calculation
```sql
v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, rec.date_of_birth) / 12);
```
- Uses `MONTHS_BETWEEN` function to calculate precise age
- `FLOOR` function ensures we get complete years only

### 3. Discount Logic
```sql
IF v_age > 60 THEN
    v_new_interest_rate := rec.interest_rate - 1;
    -- Safety check to prevent negative interest rates
    IF v_new_interest_rate < 0 THEN
        v_new_interest_rate := 0;
    END IF;
```
- Applies 1% discount for customers over 60
- Includes safety check to prevent negative interest rates

### 4. Database Update
```sql
UPDATE loans 
SET interest_rate = v_new_interest_rate,
    last_modified = SYSDATE
WHERE loan_id = rec.loan_id;
```
- Updates the loan record with new interest rate
- Tracks modification timestamp

## Expected Output

```
=== SENIOR CITIZEN LOAN DISCOUNT PROCESSING ===
Processing customers for age-based loan discount...

Customer: John Smith (ID: 101)
Age: 65 years
Current Interest Rate: 5.5%
*** DISCOUNT APPLIED ***
New Interest Rate: 4.5%
Savings: 1% discount applied
----------------------------------------

Customer: Mary Johnson (ID: 102)
Age: 45 years
Current Interest Rate: 6.0%
No discount applicable (Age <= 60)
----------------------------------------

=== PROCESSING SUMMARY ===
Total customers processed: 2
Discounts applied: 1
Customers not eligible: 1
All changes committed successfully.
```

## Features

### Control Structures Used
- **FOR LOOP**: Iterates through cursor results
- **IF-THEN-ELSE**: Age condition checking
- **Nested IF**: Safety check for negative rates

### Error Handling
- `NO_DATA_FOUND`: Handles empty result sets
- `OTHERS`: Catches unexpected errors
- Automatic `ROLLBACK` on errors

### Transaction Management
- `COMMIT`: Saves all changes after successful processing
- `ROLLBACK`: Undoes changes if errors occur

## Execution Instructions

1. **Run the complete script**: The SQL file includes table creation, sample data, and the PL/SQL block
2. **Enable output**: `SET SERVEROUTPUT ON`
3. **Execute the entire file**: All components will run in sequence
4. **Review output**: Check the detailed processing report

**Note**: The script will create tables and insert sample data automatically. If tables already exist, you may need to drop them first or modify the sample data section.

## Business Benefits
- Automated senior citizen discount application
- Audit trail with processing summary
- Safe transaction handling
- Detailed logging for compliance