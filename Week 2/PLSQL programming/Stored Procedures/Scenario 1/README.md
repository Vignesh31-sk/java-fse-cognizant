# Scenario 1: Process Monthly Interest for Savings Accounts

## Overview
This solution implements a stored procedure `ProcessMonthlyInterest` that calculates and applies 1% monthly interest to all active savings accounts in the bank database.

## Table Structures

### CUSTOMERS Table
- `customer_id` (NUMBER, PRIMARY KEY): Unique customer identifier
- `first_name` (VARCHAR2(50)): Customer's first name
- `last_name` (VARCHAR2(50)): Customer's last name
- `email` (VARCHAR2(100))`: Customer's email address
- `phone` (VARCHAR2(15))`: Customer's phone number
- `created_date` (DATE): Account creation date

### ACCOUNTS Table
- `account_id` (NUMBER, PRIMARY KEY): Unique account identifier
- `customer_id` (NUMBER, FOREIGN KEY): References customers table
- `account_type` (VARCHAR2(20)): Type of account (SAVINGS, CHECKING, etc.)
- `balance` (NUMBER(12,2)): Current account balance
- `created_date` (DATE): Account creation date
- `status` (VARCHAR2(10)): Account status (ACTIVE, INACTIVE, etc.)

## Stored Procedure: ProcessMonthlyInterest

### Purpose
Processes monthly interest for all active savings accounts by adding 1% interest to the current balance.

### Features
- **Selective Processing**: Only processes SAVINGS accounts with ACTIVE status
- **Transaction Safety**: Uses COMMIT/ROLLBACK for data integrity
- **Error Handling**: Comprehensive exception handling with rollback on errors
- **Detailed Logging**: Provides detailed output for each account processed
- **Summary Statistics**: Shows total accounts processed and total interest added

### Algorithm
1. Cursor loops through all active savings accounts
2. For each account:
   - Calculate 1% interest on current balance
   - Update account with new balance (original + interest)
   - Log the transaction details
3. Commit all changes
4. Display processing summary

### Sample Output
```
Account ID: 1, Old Balance: 5000, Interest: 50, New Balance: 5050
Account ID: 3, Old Balance: 10000, Interest: 100, New Balance: 10100
Account ID: 4, Old Balance: 7500, Interest: 75, New Balance: 7575
=== MONTHLY INTEREST PROCESSING COMPLETE ===
Total Accounts Processed: 3
Total Interest Added: $225.00
```

## Test Data Included
- 3 customers with various account types
- 5 accounts total (3 savings, 2 checking)
- Only savings accounts will receive interest

## How to Run
1. Execute the SQL file in your Oracle database
2. The script will:
   - Create necessary tables and sequences
   - Insert sample data
   - Create the stored procedure
   - Run a test execution
   - Display before/after balances

## Error Handling
- Automatic rollback on any errors
- Detailed error messages via DBMS_OUTPUT
- Exception re-raising for proper error propagation