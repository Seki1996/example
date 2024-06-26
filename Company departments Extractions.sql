-- To show all tables
  
show tables;
............................................................................................
-- Showing a specific table
  
select * from account;
..............................................................................................
-- Showing number of accounts. There are 24 rows(accounts)
  
select count(*) from account;
....................................................................................................

-- To see how many accounts are pasiv or active. There are 24 active accounts
  
select status, count(status) from account group by status;
......................................................................................................
--  Updating a value from a row
  
update account set open_branch_id=1 where account_id=1;
....................................................................................................
-- Returning the previous value to it's original value
  
update account set open_branch_id=2 where account_id=1;
......................................................................................................
-- Selecting more columns from a table
  
select account_id, cust_id, open_date, status
from account where account_id=2;
......................................................................................................
-- Using regex to find all employees which name starts with M or R
  
select  emp_id, fname, lname, title
from employee
where fname REGEXP '^[MR]';
.......................................................................................................
-- Order and limit
  
select * from individual
order by birth_date desc limit 5;
.......................................................................................................
-- Order by right, means ordering from a certain column based on certain specified range of numbers
  
select cust_id, address, city, state, fed_id
from customer
order by right(fed_id,2);
.........................................................................................................
-- Creating a view and extracting information from it
  
create view customer_vw as
select cust_id, address, city, postal_code from customer;
select * from customer_vw;
.........................................................................................................
-- Let's say the bank decides to take 2% procent from every transaction
  
select amount as original_amount, '-2%' as banks_income, amount-(0.02*amount) as customers_account
from transaction;
...........................................................................................................
-- Simple join
  
select e.emp_id, e.fname, e.lname, e.title, d.name
from employee e join department d
on e.emp_id=d.dept_id
order by 2,3;
............................................................................................................
-- Give me all accounts who opened in the company between march 2003 and march 2004
  
select a.account_id, i.fname, i.lname, a.open_date
from account a join individual i
on a.cust_id=i.cust_id
where  a.open_date between '2003-03-01' and '2004-03-31'
order by a.open_date asc;
............................................................................................................
-- Joining table with itself, an inner join
  
select e.fname as employee_name, e.lname as employee_lname, emp.fname as supervisor_name,emp.lname as supervisor_lname
from employee e join employee emp
on emp.emp_id=e.superior_emp_id;
...............................................................................................................
-- Using subqueries for joining tables
  
SELECT a.account_id, a.cust_id, a.open_date, a.product_cd
FROM account a INNER JOIN
(SELECT emp_id, assigned_branch_id
FROM employee
WHERE start_date < '2003-01-01'
and title='Head Teller')e #second table
ON a.open_emp_id = e.emp_id
INNER JOIN
(SELECT branch_id
FROM branch
WHERE name = 'Woburn Branch') b  #third table
ON e.assigned_branch_id = b.branch_id;
........................................................................................................................
-- Selecting all active acccounts, grouping them by account types, filtering having available balance more then 10,000$
  
SELECT product_cd, SUM(avail_balance) prod_balance
FROM account
WHERE status = 'ACTIVE'
GROUP BY product_cd
HAVING SUM(avail_balance) >= 10000
order by prod_balance desc;
............................................................................................................................
-- How many accounts has each employee opened
  
select e.emp_id,e.fname, e.lname, count(a.open_emp_id)
from employee e join account a
on a.open_emp_id=e.emp_id
group by a.open_emp_id;
..........................................................................................................................
-- Using two subqueries in where clause
  
SELECT account_id, product_cd, cust_id
FROM account
WHERE open_branch_id = (SELECT branch_id
FROM branch
WHERE name = 'Woburn Branch')
AND open_emp_id IN (SELECT emp_id FROM employee
WHERE title = 'Teller' OR title = 'Head Teller');
...........................................................................................................................
-- Simple joining of three tables
  
select e.fname, e.lname, a.product_cd, b.city
from account a join employee e
on a.open_emp_id=e.emp_id
join branch b
on e.assigned_branch_id=b.branch_id
join product p
on a.product_cd=p.product_cd
where a.product_cd='CHK' or a.product_cd='SAV';
...............................................................................................................................
-- Joining all tables whit columns which l wantto take further to visualisation step
  
select *
from account a join employee e
on a.open_emp_id=e.emp_id
join branch b
on e.assigned_branch_id=b.branch_id
join product p
on a.product_cd=p.product_cd;




