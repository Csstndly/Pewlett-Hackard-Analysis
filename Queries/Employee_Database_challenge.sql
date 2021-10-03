--CREATE a RETIREMENT TABLE
SELECT e.emp_no, e.first_name, e.last_name,
t.title, t.from_date, t.to_date
--INTO retirement_titles
FROM employees AS e
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY 1 ASC;

--Original table created has duplicates of employees from promotions, so removing them and keeping recent titles
SELECT DISTINCT ON (emp_no) emp_no, first_name, last_name,
title
--INTO unique_titles
FROM retirement_titles
ORDER BY 1 ASC,
    to_date DESC;

--RETRIEVING THE NUMBER OF TITLES IN U_T
SELECT COUNT(title), title
--INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY 1 DESC;

--CREATING TABLE FOR MENTORSHIP Eligibility
SELECT DISTINCT ON(e.emp_no) e.emp_no, e.first_name, e.last_name,e.birth_date,
de.from_date, de.to_date,
t.title
--INTO mentorship_eligibilty
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
     AND (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
ORDER BY 1 ASC;

-- Which depts are effected the most??
SELECT DISTINCT ON (u.emp_no) u.emp_no, u.first_name, u.last_name,
u.title, d.dept_name
--INTO re_staff
FROM unique_titles AS u
INNER JOIN dept_emp AS de
ON (u.emp_no = de.emp_no)
INNER JOIN departments AS d
ON (de.dept_no = d.dept_no);

SELECT COUNT(dept_name), dept_name
--INTO retirement_departments
FROM retirement_staff
GROUP BY dept_name
ORDER BY 1 DESC;

SELECT COUNT(title), title
INTO mentorship_titles
FROM mentorship_eligibilty
GROUP BY title
ORDER BY 1 DESC;

--Expanding MENTORSHIP Criteria
SELECT DISTINCT ON (e.emp_no) e.emp_no, e.first_name, e.last_name,e.birth_date,
de.from_date, de.to_date,
t.title
INTO mentorship_expanded
FROM employees AS e
INNER JOIN dept_emp AS de
ON (e.emp_no = de.emp_no)
INNER JOIN titles AS t
ON (e.emp_no = t.emp_no)
WHERE (de.to_date = '9999-01-01')
     AND (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY 1 ASC;

SELECT COUNT(*)
FROM mentorship_expanded;
