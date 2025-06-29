-- =====================================================
-- Scenario 2: Update Employee Bonus Based on Performance
-- =====================================================

-- Create necessary tables
CREATE TABLE departments (
    department_id NUMBER PRIMARY KEY,
    department_name VARCHAR2(50) NOT NULL,
    manager_id NUMBER,
    created_date DATE DEFAULT SYSDATE
);

CREATE TABLE employees (
    employee_id NUMBER PRIMARY KEY,
    first_name VARCHAR2(50) NOT NULL,
    last_name VARCHAR2(50) NOT NULL,
    email VARCHAR2(100),
    hire_date DATE DEFAULT SYSDATE,
    department_id NUMBER,
    salary NUMBER(10,2) NOT NULL,
    status VARCHAR2(10) DEFAULT 'ACTIVE',
    CONSTRAINT fk_emp_dept FOREIGN KEY (department_id) REFERENCES departments(department_id)
);

-- Create sequences
CREATE SEQUENCE dept_seq START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE emp_seq START WITH 1 INCREMENT BY 1;

-- Insert sample departments
INSERT INTO departments VALUES (dept_seq.NEXTVAL, 'Information Technology', NULL, SYSDATE);
INSERT INTO departments VALUES (dept_seq.NEXTVAL, 'Human Resources', NULL, SYSDATE);
INSERT INTO departments VALUES (dept_seq.NEXTVAL, 'Finance', NULL, SYSDATE);
INSERT INTO departments VALUES (dept_seq.NEXTVAL, 'Marketing', NULL, SYSDATE);

-- Insert sample employees
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Alice', 'Wilson', 'alice.wilson@bank.com', SYSDATE-365, 1, 75000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Bob', 'Davis', 'bob.davis@bank.com', SYSDATE-200, 1, 68000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Charlie', 'Brown', 'charlie.brown@bank.com', SYSDATE-180, 1, 72000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Diana', 'Miller', 'diana.miller@bank.com', SYSDATE-300, 2, 65000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Eve', 'Anderson', 'eve.anderson@bank.com', SYSDATE-120, 2, 60000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Frank', 'Taylor', 'frank.taylor@bank.com', SYSDATE-400, 3, 80000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Grace', 'Thomas', 'grace.thomas@bank.com', SYSDATE-250, 3, 77000, 'ACTIVE');
INSERT INTO employees VALUES (emp_seq.NEXTVAL, 'Henry', 'Jackson', 'henry.jackson@bank.com', SYSDATE-90, 4, 55000, 'ACTIVE');

COMMIT;

-- =====================================================
-- Stored Procedure: UpdateEmployeeBonus
-- =====================================================

CREATE OR REPLACE PROCEDURE UpdateEmployeeBonus (
    p_department_id IN NUMBER,
    p_bonus_percentage IN NUMBER
) IS
    v_emp_count NUMBER := 0;
    v_total_bonus_amount NUMBER := 0;
    v_dept_name VARCHAR2(50);
    
    CURSOR emp_cursor IS
        SELECT e.employee_id, e.first_name, e.last_name, e.salary, d.department_name
        FROM employees e
        JOIN departments d ON e.department_id = d.department_id
        WHERE e.department_id = p_department_id 
        AND e.status = 'ACTIVE';
    
    v_bonus_amount NUMBER;
    v_new_salary NUMBER;
    
    -- Custom exceptions
    invalid_department EXCEPTION;
    invalid_bonus_percentage EXCEPTION;
    
BEGIN
    -- Validate input parameters
    IF p_department_id IS NULL OR p_department_id <= 0 THEN
        RAISE invalid_department;
    END IF;
    
    IF p_bonus_percentage IS NULL OR p_bonus_percentage < 0 OR p_bonus_percentage > 100 THEN
        RAISE invalid_bonus_percentage;
    END IF;
    
    -- Check if department exists
    SELECT department_name INTO v_dept_name
    FROM departments
    WHERE department_id = p_department_id;
    
    DBMS_OUTPUT.PUT_LINE('=== PROCESSING BONUS FOR DEPARTMENT: ' || v_dept_name || ' ===');
    DBMS_OUTPUT.PUT_LINE('Bonus Percentage: ' || p_bonus_percentage || '%');
    DBMS_OUTPUT.PUT_LINE('');
    
    -- Process each employee in the department
    FOR emp_rec IN emp_cursor LOOP
        -- Calculate bonus amount
        v_bonus_amount := emp_rec.salary * (p_bonus_percentage / 100);
        v_new_salary := emp_rec.salary + v_bonus_amount;
        
        -- Update employee salary
        UPDATE employees 
        SET salary = v_new_salary
        WHERE employee_id = emp_rec.employee_id;
        
        -- Keep track of statistics
        v_emp_count := v_emp_count + 1;
        v_total_bonus_amount := v_total_bonus_amount + v_bonus_amount;
        
        -- Log the bonus processed
        DBMS_OUTPUT.PUT_LINE('Employee: ' || emp_rec.first_name || ' ' || emp_rec.last_name);
        DBMS_OUTPUT.PUT_LINE('  Old Salary: $' || TRIM(TO_CHAR(emp_rec.salary, '999,999.99')));
        DBMS_OUTPUT.PUT_LINE('  Bonus Amount: $' || TRIM(TO_CHAR(v_bonus_amount, '999,999.99')));
        DBMS_OUTPUT.PUT_LINE('  New Salary: $' || TRIM(TO_CHAR(v_new_salary, '999,999.99')));
        DBMS_OUTPUT.PUT_LINE('');
    END LOOP;
    
    -- Check if any employees were found
    IF v_emp_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('No active employees found in department: ' || v_dept_name);
    ELSE
        -- Commit the changes
        COMMIT;
        
        -- Display summary
        DBMS_OUTPUT.PUT_LINE('=== BONUS PROCESSING COMPLETE ===');
        DBMS_OUTPUT.PUT_LINE('Department: ' || v_dept_name);
        DBMS_OUTPUT.PUT_LINE('Employees Updated: ' || v_emp_count);
        DBMS_OUTPUT.PUT_LINE('Total Bonus Amount: $' || TRIM(TO_CHAR(v_total_bonus_amount, '999,999.99')));
    END IF;
    
EXCEPTION
    WHEN invalid_department THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid department ID. Please provide a valid department ID.');
        ROLLBACK;
    WHEN invalid_bonus_percentage THEN
        DBMS_OUTPUT.PUT_LINE('Error: Invalid bonus percentage. Please provide a value between 0 and 100.');
        ROLLBACK;
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('Error: Department with ID ' || p_department_id || ' does not exist.');
        ROLLBACK;
    WHEN OTHERS THEN
        ROLLBACK;
        DBMS_OUTPUT.PUT_LINE('Error processing employee bonus: ' || SQLERRM);
        RAISE;
END UpdateEmployeeBonus;
/

-- =====================================================
-- Test the Procedure
-- =====================================================

-- Show employee salaries before bonus
SELECT 'BEFORE BONUS' as status, 
       e.employee_id, 
       e.first_name || ' ' || e.last_name as employee_name,
       d.department_name,
       e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.employee_id;

-- Enable DBMS_OUTPUT
SET SERVEROUTPUT ON;

-- Test 1: Give 10% bonus to IT department (department_id = 1)
DBMS_OUTPUT.PUT_LINE('TEST 1: 10% Bonus to IT Department');
DBMS_OUTPUT.PUT_LINE('=====================================');
EXEC UpdateEmployeeBonus(1, 10);

DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('TEST 2: 5% Bonus to HR Department');  
DBMS_OUTPUT.PUT_LINE('=====================================');
EXEC UpdateEmployeeBonus(2, 5);

-- Test error handling
DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('TEST 3: Error Handling - Invalid Department');
DBMS_OUTPUT.PUT_LINE('==========================================');
EXEC UpdateEmployeeBonus(999, 10);

DBMS_OUTPUT.PUT_LINE('');
DBMS_OUTPUT.PUT_LINE('TEST 4: Error Handling - Invalid Bonus Percentage');
DBMS_OUTPUT.PUT_LINE('================================================');
EXEC UpdateEmployeeBonus(3, 150);

-- Show employee salaries after bonus
SELECT 'AFTER BONUS' as status, 
       e.employee_id, 
       e.first_name || ' ' || e.last_name as employee_name,
       d.department_name,
       e.salary
FROM employees e
JOIN departments d ON e.department_id = d.department_id
ORDER BY d.department_name, e.employee_id;