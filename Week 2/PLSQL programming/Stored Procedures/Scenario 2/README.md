# Scenario 2: Update Employee Bonus Based on Performance

## Overview
This solution implements a stored procedure `UpdateEmployeeBonus` that updates employee salaries by adding a specified bonus percentage for all active employees in a given department.

## Table Structures

### DEPARTMENTS Table
- `department_id` (NUMBER, PRIMARY KEY): Unique department identifier
- `department_name` (VARCHAR2(50)): Name of the department
- `manager_id` (NUMBER): Department manager's employee ID
- `created_date` (DATE): Department creation date

### EMPLOYEES Table
- `employee_id` (NUMBER, PRIMARY KEY): Unique employee identifier
- `first_name` (VARCHAR2(50)): Employee's first name
- `last_name` (VARCHAR2(50)): Employee's last name
- `email` (VARCHAR2(100)): Employee's email address
- `hire_date` (DATE): Employee's hire date
- `department_id` (NUMBER, FOREIGN KEY): References departments table
- `salary` (NUMBER(10,2)): Current employee salary
- `status` (VARCHAR2(10)): Employee status (ACTIVE, INACTIVE, etc.)

## Stored Procedure: UpdateEmployeeBonus

### Purpose
Updates salaries of all active employees in a specified department by adding a bonus percentage to their current salary.

### Parameters
- `p_department_id` (IN NUMBER): The department ID for which to process bonuses
- `p_bonus_percentage` (IN NUMBER): The bonus percentage to apply (0-100)

### Features
- **Parameter Validation**: Validates department ID and bonus percentage
- **Department Verification**: Ensures the department exists before processing
- **Selective Processing**: Only processes ACTIVE employees
- **Transaction Safety**: Uses COMMIT/ROLLBACK for data integrity
- **Comprehensive Error Handling**: Custom exceptions for different error scenarios
- **Detailed Logging**: Shows individual employee bonus calculations
- **Summary Statistics**: Displays total employees updated and total bonus amount

### Validation Rules
- Department ID must be positive and not null
- Bonus percentage must be between 0 and 100
- Department must exist in the database
- Only active employees are eligible for bonuses

### Sample Output
```
=== PROCESSING BONUS FOR DEPARTMENT: Information Technology ===
Bonus Percentage: 10%

Employee: Alice Wilson
  Old Salary: $75,000.00
  Bonus Amount: $7,500.00
  New Salary: $82,500.00

Employee: Bob Davis
  Old Salary: $68,000.00
  Bonus Amount: $6,800.00
  New Salary: $74,800.00

Employee: Charlie Brown
  Old Salary: $72,000.00
  Bonus Amount: $7,200.00
  New Salary: $79,200.00

=== BONUS PROCESSING COMPLETE ===
Department: Information Technology
Employees Updated: 3
Total Bonus Amount: $21,500.00
```

## Test Data Included
- 4 departments: IT, HR, Finance, Marketing
- 8 employees across different departments
- Various salary levels for testing

## Test Cases Included
1. **Normal Operation**: 10% bonus to IT department
2. **Second Department**: 5% bonus to HR department
3. **Error Handling**: Invalid department ID (999)
4. **Error Handling**: Invalid bonus percentage (150%)

## Error Handling Scenarios
- **Invalid Department ID**: Null or non-positive department ID
- **Invalid Bonus Percentage**: Null, negative, or greater than 100%
- **Department Not Found**: Department ID doesn't exist in database
- **No Active Employees**: Department has no active employees
- **General Database Errors**: Any other database-related errors

## How to Run
1. Execute the SQL file in your Oracle database
2. The script will:
   - Create necessary tables and sequences
   - Insert sample data
   - Create the stored procedure
   - Run multiple test cases including error scenarios
   - Display before/after salary comparisons

## Business Benefits
- **Performance-Based Compensation**: Allows targeted bonuses by department
- **Flexible Bonus Rates**: Customizable bonus percentages
- **Audit Trail**: Detailed logging of all bonus calculations
- **Data Integrity**: Ensures all-or-nothing updates with rollback capability