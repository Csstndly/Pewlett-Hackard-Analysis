-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (titles) e.emp_no,
e.first_name,
e.last_name,
t.title

--INTO nameyourtable
FROM employees
ORDER BY _____, _____ DESC;
