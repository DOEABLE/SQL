-- 수강신청한 과목 명과 학생 명도 함께 출력
SELECT e.*, sub.name as subjectName, stu.name as studentName
	from Enroll e inner join Subject sub on e.subject = sub.id
				inner join Student stu on e.student = stu.id;
                
-- 수강신청한 학생의 과까지 출력
SELECT e.*, sub.name as subjectName, stu.name as studentName,
				m.name as studentMajor
	from Enroll e inner join Subject sub on e.subject = sub.id
				inner join Student stu on e.student = stu.id
                left outer join Major m on stu.major = m.id;
                
                
-- p.40 전직원의 급여 평균보다 더 높은 평균 급여를 가진 부서를 출력하시오.
select sub.*, e.*
from Emp e inner join (select dept, avg(salary) avgsal, max(salary) maxsal
		from Emp 
		group by dept having avg(salary)>(select avg(salary) from Emp)) sub
;
-- sub table 
select dept, avg(salary) avgsal, max(salary) maxsal
		from Emp
		group by dept
        having avg(salary)>(select avg(salary) from Emp);

select sub.*, e.*
from Emp e inner join (select dept, avg(salary) avgsal, max(salary) maxsal
		from Emp 
		group by dept having avg(salary)>(select avg(salary) from Emp)) sub
        on e.dept = sub.dept and e.salary = sub.maxsal
order by e.dept, e.ename
;
select * FROM Emp;

-- 위 bad 처럼 짜면 group by는 되게 부담스러운 쿼린데 이걸 서브로까지 넣는건 엄청 부담스러운 쿼리가 됨.
-- good
select e1.*, e2.id, e2.ename
	from Emp e1 left join Emp e2 on e1.dept =e2.dept and e1.salary < e2.salary
	where e2.id is null
		and e1.dept in (select dept from Emp
			group by dept having avg(salary) > (select avg(salary) from Emp))
    order by e1.dept;
    

-- 아래는 self join 이용, 최적화
select e.*, avg_sal.avgsal, avg_sal.maxsal
FROM Emp e
	JOIN(SELECT dept, AVG(salary) AS avgsal, MAX(salary) AS maxsal
			FROM Emp
            GROUP BY dept
)avg_sal ON e.dept = avg_sal.dept
JOIN (
    SELECT AVG(salary) AS overall_avgsal
    FROM Emp
) overall_avg ON 1=1
WHERE avg_sal.avgsal > overall_avg.overall_avgsal
  AND e.salary = avg_sal.maxsal
ORDER BY e.dept, e.ename;
-- count
SELECT COUNT(*) AS result_count
FROM(select e.*, avg_sal.avgsal, avg_sal.maxsal
FROM Emp e
	JOIN(SELECT dept, AVG(salary) AS avgsal, MAX(salary) AS maxsal
			FROM Emp
            GROUP BY dept
)avg_sal ON e.dept = avg_sal.dept
JOIN (
    SELECT AVG(salary) AS overall_avgsal
    FROM Emp
) overall_avg ON 1=1
WHERE avg_sal.avgsal > overall_avg.overall_avgsal
  AND e.salary = avg_sal.maxsal
  )AS result_table;

    
select * from Emp 
-- update Emp set salary =800
where dept =2 and salary=900;

-- last class
