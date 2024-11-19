-- WITH , RECURSIVE
SELECT d.id, max(d.dname), avg(e.salary)
	FROM Dept d inner join Emp e on d.id = e.dept
    group by d.id
    -- order by avgsal limit 1 //UNION이랑 order by를 쓰고 싶으면 1개밖에 사용 할 수 없어 -> 프로시저나 with절 사용.
UNION ALL    
SELECT d.id, max(d.dname), avg(e.salary)
	FROM Dept d inner join Emp e on d.id = e.dept
    group by d.id
    order by avgsal limit 1;
    
WITH
	AvgSal AS(
SELECT d.id, max(d.dname), avg(e.salary)
	FROM Dept d inner join Emp e on d.id = e.dept
    group by d.id
    ),
    MaxAvgSal AS(
		select * from AvgSal order by avgsal desc limit 1
	),
    MinAvgSal AS(
		select * from AvgSal order by avgsal desc limit 1
	),
    Sumup AS(
		select * from MaxAvgSal
		UNION ALL
		select * from MinAvgSal
    )
    select '최고' as '구분', dname as '부서명', format(avgsal,0) '평균급여' from MaxAvgSal
	UNION ALL
	select '최고' as '구분', dname as '부서명', format(avgsal,0) '평균급여' from MinAvgSal
UNION ALL
select '','평균 급여 차액', max('평균급여')-min('평균급여') from Sumup;
select * from MaxAvgSal;

-- RECURSIVE(p.81)
insert into Dept(pid, dname) values(6, '인프라셀');
insert into Dept(pid, dname) values(6, 'DB셀');
insert into Dept(pid, dname) values(7, '모바일셀');
select * from Dept;

-- 테이블 구조 확인
DESCRIBE Dept;
CREATE TEMPORARY TABLE Temp_Dept AS 
SELECT pid, dname, captain FROM Dept ORDER BY id;
DROP TABLE Temp_Dept;
select * from Temp_Dept; 
select * from Dept; 
-- 2. 기존 데이터 삭제
SET SQL_SAFE_UPDATES = 1;

DELETE FROM Dept;

-- 3. 임시 테이블 데이터 다시 삽입
INSERT INTO Dept (name)
SELECT name FROM Temp_Dept;

-- 4. AUTO_INCREMENT 값 초기화
ALTER TABLE Dept AUTO_INCREMENT = 1;

-- 결과 확인
SELECT * FROM Dept;

WITH recursive fibonacci(n, fib_n, fib_next_n) AS (
	SELECT 1,0,1
    UNION ALL
    SELECT n+1, fib_next_n, fib_n + fib_next_n
		FROM fibonacci where n<10
	) select * from fibonacci;
    
select * from Dept;

WITH RECURSIVE CteDept(id, pid, dname, depth) AS (
	select id, pid, dname, 0 from Dept where pid = 0
    UNION ALL
    select d.id, d.pid, d.dname, depth + 1
		from CteDept c inner join Dept d on c.id = d.pid
)
select concat(repeat('', c.depth),'', c.dname) from CteDept c;

-- JSON
select * from Student;
alter table Emp add column remark json;

select * from Emp where id<5;
update Emp set remark = '{"id":1, "age":30, "fam":[{"id": 1, "name":"유세차"}]}'-- json은 js로테이션
	where id =2;
update Emp set remark = '{"id":3, "age":33, "fam":[{"id": 1, "name":"유세차"}, {"id": 2, "name":"유세차"}]}'-- json은 js로테이션
	where id =3;
update Emp set remark = '{"id":4, "age":36, "fam":[{"id": 1, "name":"유세차"}]}'-- json은 js로테이션
	where id =4;
update Emp set remark = json_object('id','5','age','44',
	'fam',json_array(
	json_object('id',1,'name','지세차'),json_object('id',2,'name','지세창')
    ))
where id =5;
select id, ename, remark ->'$.age', remark->'$.fam' as family,
		json_pretty(remark), 
        json_unquote(remark-> '$.fam[0].name'),
        remark ->'$.fam[0].name'
	from Emp where id<5;
    
select json_valid('{"id":1}');
select * from Emp where remark->'$.age' >30;
select * from Emp where json_contains(remark,'44','$.age');
update Emp set remark= json_set(remark,'$.age', 39) where id =3;
update Emp set remark= json_insert(remark,'$.addr', 'Seoul') where id =3;

select id, remark from Emp where remark is not null;
select id, remark, json_keys(remark) from Emp where remark is not null;
select id, json_keys(remark), json_type(remark->'$.fam[0].name') 
	from Emp where remark is not null;
    
select remark, json_search(remark,'all','유세차')
	from Emp where remark is not null;




