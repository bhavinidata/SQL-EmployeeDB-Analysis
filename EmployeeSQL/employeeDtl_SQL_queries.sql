-- Exported from QuickDBD: https://www.quickdatabasediagrams.com/
-- NOTE! If you have used non-SQL datatypes in your design, you will have to change these here.


CREATE TABLE "employees" (
    "emp_no" VARCHAR(50)   NOT NULL,
    "birth_date" DATE   NOT NULL,
    "first_name" VARCHAR(50)   NOT NULL,
    "last_name" VARCHAR(50)   NOT NULL,
    "gender" VARCHAR(25)   NOT NULL,
    "hire_date" DATE   NOT NULL,
    CONSTRAINT "pk_employees" PRIMARY KEY (
        "emp_no"
     )
);

CREATE TABLE "departments" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "dept_name" VARCHAR(50)   NOT NULL,
    CONSTRAINT "pk_departments" PRIMARY KEY (
        "dept_no"
     )
);

CREATE TABLE "salaries" (
    "emp_no" VARCHAR(50)   NOT NULL,
    "salary" DECIMAL   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_emp" (
    "emp_no" VARCHAR(50)   NOT NULL,
    "dept_no" VARCHAR(50)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "dept_manager" (
    "dept_no" VARCHAR(50)   NOT NULL,
    "emp_no" VARCHAR(50)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

CREATE TABLE "titles" (
    "emp_no" VARCHAR(50)   NOT NULL,
    "title" VARCHAR(50)   NOT NULL,
    "from_date" DATE   NOT NULL,
    "to_date" DATE   NOT NULL
);

ALTER TABLE "salaries" ADD CONSTRAINT "fk_salaries_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "dept_emp" ADD CONSTRAINT "fk_dept_emp_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_dept_no" FOREIGN KEY("dept_no")
REFERENCES "departments" ("dept_no");

ALTER TABLE "dept_manager" ADD CONSTRAINT "fk_dept_manager_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");

ALTER TABLE "titles" ADD CONSTRAINT "fk_titles_emp_no" FOREIGN KEY("emp_no")
REFERENCES "employees" ("emp_no");


-- At this point, import all the csv files to respective tables. As csv doesn't contain auto 
-- increamented id coloumn (which can be assigned as primary key), we can add column for id once cvs files has been imported.

select * from titles;
ALTER TABLE titles ADD COLUMN title_id SERIAL PRIMARY KEY;

SELECT * FROM salaries;
ALTER TABLE salaries ADD COLUMN salary_id SERIAL PRIMARY KEY;

SELECT * FROM dept_manager;
ALTER TABLE dept_manager ADD COLUMN dept_manager_id SERIAL PRIMARY KEY;

SELECT * FROM dept_emp;
ALTER TABLE dept_emp ADD COLUMN dept_emp_id SERIAL PRIMARY KEY;


--<1> List the following details of each employee: employee number, last name, first name, gender, and salary.
SELECT e.emp_no, e.first_name, e.last_name, e.gender, s.salary 
	FROM employees e
	INNER JOIN salaries s on e.emp_no = s.emp_no


--<2> List employees who were hired in 1986.
SELECT * FROM employees WHERE hire_date BETWEEN '1986-01-01' AND '1986-12-31';


--<3> List the manager of each department with the following information: 
-- department number, department name, the manager's employee number, last name, first name, and start and end employment dates.

CREATE VIEW manager_deptname AS
SELECT dm.emp_no, dm.from_date, dm.to_date, d.dept_no, d.dept_name from departments d
INNER JOIN dept_manager dm
ON d.dept_no = dm.dept_no;

SELECT e.first_name, e.last_name, dmn.* 
	FROM employees e
INNER JOIN manager_deptname dmn
ON e.emp_no = dmn.emp_no



--<4> List the department of each employee with the following information: employee number, last name, first name, and department name.
CREATE VIEW emp_deptname AS
SELECT de.emp_no, d.dept_name from departments d
INNER JOIN dept_emp de
ON d.dept_no = de.dept_no;

SELECT e.first_name, e.last_name, den.* 
	FROM employees e
INNER JOIN  emp_deptname den 
ON e.emp_no = den.emp_no

--<5> List all employees whose first name is "Hercules" and last names begin with "B."
SELECT * 
	FROM employees
WHERE first_name = 'Hercules' AND last_name LIKE 'B%'

--<6> List all employees in the Sales department, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.first_name, e.last_name, edn.dept_name
	FROM employees e
INNER JOIN (SELECT emp_no, dept_name
	FROM emp_deptname
WHERE dept_name = 'Sales') edn
ON e.emp_no = edn.emp_no



--<7> List all employees in the Sales and Development departments, including their employee number, last name, first name, and department name.
SELECT e.emp_no, e.first_name, e.last_name, edn.dept_name
	FROM employees e
INNER JOIN (SELECT emp_no, dept_name
	FROM emp_deptname
WHERE dept_name = 'Sales' OR dept_name='Development') edn
ON e.emp_no = edn.emp_no


--<8> In descending order, list the frequency count of employee last names, i.e., how many employees share each last name.
SELECT last_name, count(*) as "Number of Employees" FROM employees GROUP BY last_name ORDER BY "Number of Employees" DESC

