-- table
show tables;
select * from Dept;
select * from Emp;
select * from Student;

-- 지정된 데이터베이스의 모든 테이블에 대한 생성 시간과 마지막 업데이트 시간 조회
SHOW TABLE STATUS FROM testdb;
-- 특정 테이블에 대한 정보 조회
SHOW CREATE TABLE Emp;
-- 지정된 데이터베이스의 모든 테이블에 대한 생성 시간과 마지막 업데이트 시간 조회
SELECT NOW(), SYSDATE(), CURRENT_TIMESTAMP;
-- 데이터베이스가 올바른 시간대를 가지고 있는지 확인 (UTC 시간 ('+00:00')에서 한국 시간 ('+09:00')으로 변환)
SELECT CONVERT_TZ('2024-11-19 12:00:00', '+00:00', '+09:00') AS converted_time;
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    CREATE_TIME,
    UPDATE_TIME
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'testdb'
ORDER BY 
    CREATE_TIME DESC;
    
select dept, min(ename) as fast_name
from Emp
group by dept;


desc student;
desc Enroll;
-- 1. 직원들의 평균급여
select avg(salary) from Emp;
-- 2. 부서별 평균급여
select dept, avg(salary) from Emp group by dept;
-- 3. 평균 급여보다 높은 부서명 구하기
select 
	e.dept, 
    d.dname, 
    avg(salary) as avg_sal
from EMP e inner join Dept d on e.dept = d.id -- on 으로 조인조건 걸기
group by e.dept, d.dname
HAVING avg(salary)>(select avg(salary) from Emp)-- where 대신 having으로 필터링
;
-- 4. 3에서 구한 부서의 이름까지 춫력
select 
	e.dept, 
    d.dname, 
    avg(salary) as avg_sal
from EMP e inner join Dept d on e.dept = d.id -- on 으로 조인조건 걸기
group by e.dept, d.dname
HAVING avg(salary)>(select avg(salary) from Emp)-- where 대신 having으로 필터링
;
-- 각 부서의 최고 연봉자이름 출력(명단을 부서별로 한 컬럼에 출력하고 싶다.)
select e.dept, d.dname, e.ename, e.salary as '최고연봉'
from emp e inner join Dept d on e.dept = d.id
where e.salary= (
	select max(salary) 
    from Emp e1
    WHERE e1.dept = e.dept
);
-- 부서당 최고연봉자 수
select e.dept, 
	(select avg(e1.salary) from emp e1 where e1.dept=d.id) as avg_sal, 
    max(e.salary) as '최고연봉', 
    count(*) as '최고연봉인원', 
    group_concat(ename) 
from emp e inner join Dept d on e.dept = d.id
where e.salary= (
	select max(salary) 
    from Emp e1
    WHERE e1.dept = e.dept
)
group by e.dept;
select * from emp, dept;
-- 부서평균이 전사평균보다 높은 부서의 최고연봉자 구하기.
select e.dept, 
		(select avg(e1.salary) from emp e1 where e1.dept= e.dept) as avg_sal, 
        max(e.salary) as '최고연봉', 
        count(*) as '최고연봉인원', 
        group_concat(ename) 
from emp e inner join Dept d on e.dept = d.id
where e.salary= (
	select max(e1.salary) 
    from Emp e1
    WHERE e1.dept = e.dept
)
group by e.dept
HAVING avg_sal>(select avg(salary) from Emp);

-- 성능향상1 self join 
select
	e1.dept,
    (select avg(e2.salary) from emp e2 where e2.dept= e1.dept)as avg_sal,
    max(e1.salary) as '최고연봉',
    count(e1.id) as '최고연봉인원',
    group_concat(DISTINCT e1.ename),  -- (group_concat에서 중복된 행이 계속 나오고있음. -> distinct로 제거)
    count(DISTINCT e1.ename)
from emp e1 
	left join emp e2 on e1.dept=e2.dept AND e1.salary <= e2.salary -- 같은 테이블 내에서 비교
	INNER JOIN dept d on e1.dept = d.id
where e1.salary = e2.salary
group by e1.dept
having avg_sal > (select avg(salary) from emp);

-- #1 강사님 방법(group by 안쓰고 self join 사용해서 최고 연봉자 구하기
select e1.*, e2.id, e2.ename, e2.dept, e2.salary
from emp e1 left join emp e2 on e1.dept=e2.dept and e1.salary < e2.salary
where e2.id is null
	-- and e1.dept in (
-- 					select dept
--                     from Emp
--                     group by dept
--                     having avg(salary)> (select avg(salary) from Emp)
--                     )
order by e1.dept;
-- #2 이거다!
select sub.*, e.*
from Emp e inner join (select dept, 
							avg(salary) avgsal,
							max(salary) maxsal
						from Emp
						group by dept having avgsal > (
														select avg(salary) from Emp)) sub
				on e.dept = sub.dept and e.salary = sub.maxsal
order by e.dept, e.ename;


-- 성능향상2 view
-- 부서별 최고연봉을 계산해서 저장함.
CREATE VIEW DeptMaxSalaries AS
SELECT 
    dept, 
    MAX(salary) AS max_salary
FROM 
    emp
GROUP BY 
    dept;
-- 부서별 평균 연봉을 계산하는 뷰 생성
CREATE VIEW DeptAvgSalaries AS
SELECT
	dept,
    avg(salary) as avg_salary
FROM Emp
GROUP BY Dept;
-- 3. 위의 두 테이블 결함해 최고연봉자와 부서 평균 연봉을 동시에 출력
SELECT e.dept,
	avg_s.avg_salary as '부서평균연봉',
    max_s.max_salary as '최고연봉',
    count(e.id) as '최고연봉인원',
    group_concat(e.ename)
FROM Emp e
	inner join Dept d on e.dept = d.id
    inner join DeptAvgSalaries avg_s on e.dept = avg_s.dept
    inner join DeptMaxSalaries max_s on e.dept = max_s.dept and e.salary = max_s.max_salary --    
where avg_s.avg_salary > (select avg(salary) from Emp)
group by e.dept;

select e.dept, count(e.id), avg(e.salary)
from emp e
	inner join DeptAvgSalaries as avg_s on e.dept = avg_s.dept and e.salary = avg_s.avg_salary
group by e.dept;

select * from DeptAvgSalaries;
-- db의 모든 테이블, 뷰확인
SHOW FULL TABLES;
 WHERE Table_type ='VIEW';