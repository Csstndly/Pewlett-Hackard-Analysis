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
SELECT DISTINCT ON (emp_no), emp_no, first_name, last_name,
title
--INTO unique_titles
FROM retirement_titles AS e
ORDER BY 1 ASC,
    to_date DESC;

--RETRIEVING THE NUMBER OF TITLES IN U_T
SELECT COUNT(title)
--INTO retiring_titles
FROM unique_titles
GROUP BY title
ORDER BY DESC;