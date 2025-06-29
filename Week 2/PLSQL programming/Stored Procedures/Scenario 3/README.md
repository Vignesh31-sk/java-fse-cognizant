# Scenario 3: Transfer Funds Between Customer Accounts

## Overview
This solution implements a stored procedure `TransferFunds` that safely transfers a specified amount from one customer account to another, with comprehensive validation and error handling.

## Table Structures

### CUSTOMERS Table
- `customer_id` (NUMBER, PRIMARY KEY): Unique customer identifier
- `first_name` (VARCHAR2(50)): Customer's first name
- `last_name` (VARCHAR2(50)): Customer's last name
- `email` (VARCHAR2(100)): Customer's email address
- `phone` (VARCHAR2(15)): Customer's phone number
- `created_date` (DATE): Customer creation date

### ACCOUNTS Table
- `account_id` (NUMBER, PRIMARY KEY): Unique account identifier
- `customer_id` (NUMBER, FOREIGN KEY): References customers table
- `account_type` (VARCHAR2(20)): Type of account (CHECKING, SAVINGS, etc.)
- `balance` (NUMBER(12,2)): Current account balance
- `created_date` (DATE): Account creation date
- `status` (VARCHAR2(10)): Account status (ACTIVE, INACTIVE, etc.)

### TRANSACTION_HISTORY Table
- `transaction_id` (NUMBER, PRIMARY KEY): Unique transaction identifier
- `from_account_id` (NUMBER, FOREIGN KEY): Source account for the transfer
- `to_account_id` (NUMBER, FOREIGN KEY): Destination account for the transfer
- `transaction_type` (VARCHAR2(20)): Type of transaction (TRANSFER, DEPOSIT, etc.)
- `amount` (NUMBER(12,2)): Transaction amount
- `description` (VARCHAR2(200)): Transaction description
- `transaction_date` (DATE): When the transaction occurred
- `status` (VARCHAR2(10)): Transaction status (COMPLETED, PENDING, etc.)

## Stored Procedure: TransferFunds

### Purpose
Transfers funds from one account to another with full validation, error handling, and audit trail creation.

### Parameters
- `p_from_account_id` (IN NUMBER): Source account ID
- `p_to_account_id` (IN NUMBER): Destination account ID
- `p_amount` (IN NUMBER): Amount to transfer (must be positive)

### Features
- **Comprehensive Validation**: Multiple validation checks before processing
- **Sufficient Funds Check**: Ensures source account has adequate balance
- **Account Status Verification**: Only allows transfers between active accounts
- **Transaction Atomicity**: All-or-nothing approach with rollback on errors
- **Audit Trail**: Records all successful transfers in transaction history
- **Detailed Logging**: Provides before/after balance information
- **Custom Error Handling**: Specific error messages for different failure scenarios

### Validation Rules
1. **Amount Validation**: Must be positive and not null
2. **Account Validation**: Both accounts must exist and be different
3. **Status Check**: Both accounts must be ACTIVE
4. **Balance Check**: Source account must have sufficient funds
5. **Same Account**: Cannot transfer to the same account

### Sample Output - Successful Transfer
```
=== FUND TRANSFER INITIATED ===
From Account: 1 (John Doe)
To Account: 3 (Jane Smith)
Transfer Amount: $1,000.00

BEFORE TRANSFER:
Source Account Balance: $5,000.00
Destination Account Balance: $3,000.00

AFTER TRANSFER:
Source Account Balance: $4,000.00
Destination Account Balance: $4,000.00

=== TRANSFER COMPLETED SUCCESSFULLY ===
Transaction ID: 1
Transfer Date: 29-JUN-2025 14:30:25
```

### Sample Output - Error Scenario
```
Error: Insufficient funds in source account.
Available Balance: $2,500.00
Requested Amount: $5,000.00
```

## Test Data Included
- **3 Customers**: John Doe, Jane Smith, Bob Johnson
- **6 Accounts**: Mix of checking/savings accounts with various balances
- **Account Statuses**: Includes one inactive account for testing

### Account Setup
| Account ID | Customer | Type | Balance | Status |
|------------|----------|------|---------|--------|
| 1 | John Doe | Checking | $5,000 | Active |
| 2 | John Doe | Savings | $15,000 | Active |
| 3 | Jane Smith | Checking | $3,000 | Active |
| 4 | Jane Smith | Savings | $8,000 | Active |
| 5 | Bob Johnson | Checking | $2,500 | Active |
| 6 | Bob Johnson | Savings | $12,000 | Inactive |

## Test Cases Included

### Successful Transfers
1. **Test 1**: Transfer $1,000 from Account 1 to Account 3
2. **Test 2**: Transfer $500 from Account 2 to Account 4

### Error Scenarios
3. **Insufficient Funds**: Transfer $5,000 from Account 5 (balance: $2,500)
4. **Invalid Account**: Transfer to non-existent Account 999
5. **Same Account**: Transfer from Account 1 to Account 1
6. **Inactive Account**: Transfer to inactive Account 6
7. **Invalid Amount**: Transfer negative amount (-$100)

## Error Handling Features
- **Automatic Rollback**: All failed transactions are rolled back
- **Specific Error Messages**: Clear explanation of what went wrong
- **Balance Information**: Shows available vs. requested amounts for insufficient funds
- **Account Status Details**: Shows status of both accounts when inactive

## Security & Integrity Features
- **ACID Compliance**: Ensures transaction atomicity
- **Foreign Key Constraints**: Maintains referential integrity
- **Input Validation**: Prevents invalid data entry
- **Audit Trail**: Complete history of all successful transfers
- **Status Verification**: Only active accounts can participate

## How to Run
1. Execute the SQL file in your Oracle database
2. The script will:
   - Create all necessary tables with constraints
   - Insert comprehensive test data
   - Create the stored procedure
   - Run 7 different test scenarios
   - Display before/after account balances
   - Show complete transaction history

## Business Benefits
- **Safe Fund Transfers**: Comprehensive validation prevents errors
- **Complete Audit Trail**: Full tracking of all fund movements
- **Error Prevention**: Multiple validation layers prevent invalid transactions
- **Customer Protection**: Ensures sufficient funds before transfer
- **Data Integrity**: Maintains consistent account balances