# Scenario 2: VIP Status Assignment Based on Balance

## Overview
This PL/SQL block automatically assigns VIP status to customers based on their total account balance. Customers with balances over $10,000 are promoted to VIP status.

## Database Schema and Sample Data
**All required table structures and sample data are included in the SQL file for immediate execution.**

The code creates and populates the following tables:

### CUSTOMERS Table
- `customer_id` (Primary Key)
- `customer_name`
- `is_vip` (VARCHAR2 - 'TRUE'/'FALSE')
- `vip_since` (DATE)
- `last_modified` (DATE)

### ACCOUNTS Table
- `account_id` (Primary Key)
- `customer_id` (Foreign Key)
- `balance` (NUMBER)
- `account_status` (VARCHAR2)

## Code Explanation

### 1. Cursor with Aggregation
```sql
CURSOR c_customers IS
    SELECT c.customer_id, c.customer_name, 
           NVL(SUM(a.balance), 0) as total_balance,
           c.is_vip
    FROM customers c
    LEFT JOIN accounts a ON c.customer_id = a.customer_id
    WHERE a.account_status = 'ACTIVE' OR a.account_status IS NULL
    GROUP BY c.customer_id, c.customer_name, c.is_vip
    ORDER BY total_balance DESC;
```
- Uses `LEFT JOIN` to include customers without accounts
- `GROUP BY` aggregates multiple accounts per customer
- `NVL` handles null balances
- Orders by balance (highest first) for better reporting

### 2. VIP Qualification Logic
```sql
IF rec.total_balance > v_vip_threshold THEN
    IF NVL(rec.is_vip, 'FALSE') = 'FALSE' THEN
        -- Promote to VIP
        UPDATE customers 
        SET is_vip = 'TRUE',
            vip_since = SYSDATE,
            last_modified = SYSDATE
        WHERE customer_id = rec.customer_id;
```
- Checks if balance exceeds $10,000 threshold
- Only updates if not already VIP (avoids unnecessary updates)
- Records VIP promotion date

### 3. Status Management
The code handles four scenarios:
- **New VIP**: Promote regular customer to VIP
- **Existing VIP**: Customer already has VIP status
- **VIP Demotion**: Remove VIP status if balance drops (optional)
- **Regular Customer**: Balance below threshold

### 4. Statistical Reporting
```sql
DECLARE
    v_total_vips NUMBER;
    v_vip_percentage NUMBER;
BEGIN
    SELECT COUNT(*) INTO v_total_vips 
    FROM customers 
    WHERE is_vip = 'TRUE';
    
    v_vip_percentage := ROUND((v_total_vips / v_customers_processed) * 100, 2);
```
- Nested PL/SQL block for statistics
- Calculates VIP percentage of customer base

## Expected Output

```
=== VIP STATUS ASSIGNMENT PROCESSING ===
VIP Threshold: $10,000
Processing all customers for VIP status update...

Customer: Robert Wilson (ID: 103)
Total Balance: $25,750.00
Current VIP Status: Regular
*** PROMOTED TO VIP STATUS ***
Qualification: Balance exceeds $10,000
----------------------------------------

Customer: Sarah Davis (ID: 104)
Total Balance: $15,200.00
Current VIP Status: VIP
Status: Already VIP (no change needed)
----------------------------------------

Customer: Mike Brown (ID: 105)
Total Balance: $8,500.00
Current VIP Status: Regular
Status: Regular customer (balance below threshold)
----------------------------------------

=== VIP STATUS PROCESSING SUMMARY ===
Total customers processed: 3
New VIP promotions: 1
Existing VIP customers: 1
Regular customers: 1
VIP threshold: $10,000

=== VIP STATISTICS ===
Total VIP customers: 2
VIP percentage: 66.67%

All changes committed successfully.
```

## Features

### Control Structures Used
- **FOR LOOP**: Iterates through all customers
- **IF-THEN-ELSE**: VIP qualification logic
- **Nested IF**: Status change conditions
- **CASE WHEN**: Status display formatting

### Advanced PL/SQL Features
- **Constants**: `v_vip_threshold CONSTANT NUMBER := 10000`
- **Aggregate Functions**: `SUM(a.balance)`
- **NULL Handling**: `NVL()` functions
- **Nested Blocks**: Statistics calculation
- **Formatting**: `TO_CHAR()` for currency display

### Business Logic
- **Balance Aggregation**: Sums all active accounts per customer
- **Status Tracking**: Records VIP promotion date
- **Audit Trail**: Tracks last modification timestamp
- **Flexible Thresholds**: Easy to modify VIP criteria

## Execution Instructions

1. **Run the complete script**: The SQL file includes table creation, sample data, and the PL/SQL block
2. **Enable output**: `SET SERVEROUTPUT ON`
3. **Execute the entire file**: All components will run in sequence
4. **Review output**: Check the detailed processing and statistical reports

**Note**: The script includes comprehensive sample data with customers having various balance levels to demonstrate VIP status assignment logic.

## Sample Data Included
The script includes diverse test scenarios:
- **Alice Johnson**: $11,700.50 total → Will be promoted to VIP
- **Bob Smith**: $18,250.25 total → Will be promoted to VIP  
- **Carol Davis**: $70,000.75 total → Already VIP, no change
- **David Wilson**: $5,000.50 total → Remains regular customer
- **Emma Brown**: $21,250.25 total → Will be promoted to VIP

## Business Benefits
- **Automated Customer Segmentation**: Identifies high-value customers
- **Revenue Optimization**: Enables targeted VIP services
- **Real-time Processing**: Updates status based on current balances
- **Comprehensive Reporting**: Detailed processing and statistical summary
- **Audit Compliance**: Tracks all status changes with timestamps