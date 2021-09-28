--After creating the tables we can no analyze the future for the comapny. Finding out How many people
--will be retiring? And from those employees who is eligible for a retirement package?
-- These are the births with the people that will begin to retire. So getting a lsit of these employees
SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1955-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1952-01-01' AND '1952-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1953-01-01' AND '1953-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1954-01-01' AND '1954-12-31';

SELECT first_name, last_name
FROM employees
WHERE birth_date BETWEEN '1955-01-01' AND '1955-12-31';

--Narrow Search for Retirement Eligibility

-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--Exporting New Tables

--First create the table to be exported
SELECT first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

--To confirm table was created query it
SELECT * FROM retirement_info;
--Then export it very similar to import

-- Join The Tables
-- Join tables so, employees retiring and their dept is listed with them
    --can join the Employees table with the dept table, hoever neither one is filtered by retirement
    -- so must find way to add retirement table as well......

--recreating the retirement table
DROP TABLE retirement_info;
-- Create new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
-- Check the table
SELECT * FROM retirement_info;

--Inner Join
-- Joining departments and dept_manager tables/// so each department name and other info in departmant table is shown
SELECT departments.dept_name,
     managers.emp_no,
     managers.from_date,
     managers.to_date
FROM departments
INNER JOIN managers
ON departments.dept_no = managers.dept_no;

--Overlooked information.... do the employees still work for the company??
-- Joining retirement_info and dept_emp tables/// need employee #, name as reitrement doesn't have a unique identfier
SELECT retirement_info.emp_no,
    retirement_info.first_name,
retirement_info.last_name,
    dept_emp.to_date
    --Also can be written as such
SELECT ri.emp_no,
    ri.first_name,
ri.last_name,
    de.to_date
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no;

--Join for current employment
SELECT ri.emp_no,
    ri.first_name,
    ri.last_name,
de.to_date
INTO current_emp
FROM retirement_info as ri
LEFT JOIN dept_emp as de
ON ri.emp_no = de.emp_no
WHERE de.to_date = ('9999-01-01');

--USING COUNT, GROUP BY, AND ORDER BY
-- Employee count by department number in order
SELECT COUNT(ce.emp_no), de.dept_no
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;
--Exporting
SELECT COUNT(ce.emp_no), de.dept_no
INTO department_count
FROM current_emp as ce
LEFT JOIN dept_emp as de
ON ce.emp_no = de.emp_no
GROUP BY de.dept_no
ORDER BY de.dept_no;

SELECT * FROM department_count;

-- Because of the # pf people leaving we need to make 3 more list
    -- Employee Information: A list of employees containing their unique employee number, their last name,
    -- first name, gender, and salary
    --Management: A list of managers for each department, including the department number, name,
    --and the manager's employee number, last name, first name, and the starting and ending employment dates
    --Department Retirees: An updated current_emp list that includes everything it currently has, but also the
    --employee's departments

-- Employee and Salary table has everything needed for the list but will show all employees nothing filtered

--Check out the data in the tables
SELECT * FROM salaries;
    -- dates aren't uniformed and need the recent dates
SELECT * FROM salaries
ORDER BY to_date DESC;
    --not giving recent date of employment, cant use data in the from + to date i this table,but is the salary
    -- starting or ending

--Reuse and update code that filters the retirees
    --FROM THIS
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');
    --TO THIS
SELECT emp_no, first_name, last_name, gender
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31')

-- Then join all 3 tables together, but first run it make sure the able is created properly, uncomment if it is
SELECT e.emp_no,
    e.first_name,
e.last_name,
    e.gender,
    s.salary,
    de.to_date
--INTO emp_info
FROM employees as e
INNER JOIN salaries as s
ON (e.emp_no = s.emp_no)
INNER JOIN dept_emp as de
ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
     AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
	 AND (de.to_date = '9999-01-01');

--LIST 2/////  shows up only 5 dept managers.....
SELECT  mg.dept_no,
        d.dept_name,
        mg.emp_no,
        ce.last_name,
        ce.first_name,
        mg.from_date,
        mg.to_date
--INTO manager_info
FROM managers AS mg
    INNER JOIN departments AS d
        ON (mg.dept_no = d.dept_no)
    INNER JOIN current_emp AS ce
        ON (mg.emp_no = ce.emp_no);

--LIST 3//// employee duplication.....
SELECT ce.emp_no,
ce.first_name,
ce.last_name,
d.dept_name
-- INTO dept_info
FROM current_emp as ce
INNER JOIN dept_emp AS de
ON (ce.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

-- CREATE A TAILORED LIST
-- Sales want a list for their dept only of retirees

SELECT ri.emp_no, ri.first_name, ri.last_name,d.dept_name
INTO sales_info
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name LIKE '%Sales%';

-- Sales+Development want a list together of retirees
SELECT ri.emp_no, ri.first_name, ri.last_name,d.dept_name
INTO s_d_info
FROM retirement_info AS ri
INNER JOIN dept_emp AS de
ON (ri.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');