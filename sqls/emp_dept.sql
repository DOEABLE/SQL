show DATABASES;
USE testdb;
show tables;
SELECT User, Host FROM mysql.user;
SELECT User, Host FROM mysql.user;
select * from Dept;
select * from Emp;

-- Dept테이블에 이름이 가장 빠른 직원을 captain으로 update 하시오.
	-- 부서별 이름이 가장 빠른 직원
    select dept, min(ename) as fast_name, id from Emp group by dept,id;
select ename
from Emp where is_captain =1;

-- self join(best)
select e1.*,e2.id
FROM Emp e1 left join Emp e2 ON e1.dept = e2.dept and e1.ename > e2.ename
where e2.id is null;

 -- 위 쿼리를 이용해서 update
 select d.*,e.* from Dept d
 -- update Dept d SET d.captain = e.id
 INNER JOIN 
	(select e1.dept, e1.id 
		FROM Emp e1 left join Emp e2 ON e1.dept = e2.dept and e1.ename > e2.ename)e
ON d.id=e.dept;

 

-- update
    WITH RankedEmployees AS (
    SELECT 
        id, 
        ename, dept,
        ROW_NUMBER() OVER (PARTITION BY dept ORDER BY ename ASC) AS RowNum
    FROM Emp
)
UPDATE Emp	
SET is_captain=TRUE
WHERE id IN (
SELECT id
FROM RankedEmployees
WHERE RowNum = 1
);

ALTER TABLE Emp
ADD COLUMN is_captain BOOLEAN DEFAULT FALSE;
ALTER TABLE Emp
ADD COLUMN outdt DATE COMMENT '퇴사일';
alter table Emp 
ADD COLUMN auth tinyint(1) not null default 9 comment '권한(0:sys, 1:super,...,9:guest)' after dept;

-- p.46 퇴사일 컬럼추가하고 퇴사처리하기
update Emp set outdt='2024-04-25' where id in (3,5);

update Emp set outdt=curdate() where id in (14,26);

SET SQL_SAFE_UPDATES = 0;
update Dept d inner join Emp e on d.captain = e.id
	set d.captain = null
    where e.outdt is not null;
SET SQL_SAFE_UPDATES = 1;    

-- 위 결과 확인
select * FROM Dept d left join Emp e on d.captain = e.id;

select *, curdate(),curtime(), now() from Emp where id in (3,5,10,14,26);

select * from Emp e inner join Dept d on e.dept = d.id where e.dept in (3,4);
    
update Emp e
INNER JOIN Dept d ON e.dept = d.id
SET d.captain = e.id
WHERE e.dept = 3 AND e.ename = '김나라';

select * from Emp e inner join dept d on e.dept = d.id
where e.dept=3;

CREATE TABLE EmailLog(
id int unsigned not null auto_increment,
sender int unsigned not null comment '발신자 id',
receiver varchar(1024) not null comment '수신자들',
subject varchar(255) not null default '냉무' comment '제목',
body text null comment '내용 및 첨부파일',
PRIMARY KEY (id),
    CONSTRAINT fk_EmailLog_sender_Emp FOREIGN KEY (sender) REFERENCES Emp(id)
);
SELECT id, ename, dept, is_Captain
FROM RankedEmployees
WHERE RowNum = 1;

SHOW CREATE TABLE Dept;
alter table Dept add column captain int unsigned null comment '부서장';
alter table Dept add constraint foreign key fk_Dept_captain_Emp(captain)
	references Emp(id) on DELETE set null on UPDATE CASCADE;
SHOW INDEX FROM DEPT; -- dept 테이블의 참조키 확인query
show table status; -- table들의 형태 확인.