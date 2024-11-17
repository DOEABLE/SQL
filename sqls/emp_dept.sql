show DATABASES;
USE testdb;
show tables;
SELECT User, Host FROM mysql.user;
SELECT User, Host FROM mysql.user;
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

select *
	from Emp e inner join Dept d on e.dept = d.id
	where e.dept in (3,4);
    
UPDATE Emp e
INNER JOIN Dept d ON e.dept = d.id
SET d.captain = e.id
WHERE e.dept = 3 AND e.name = '김나라';

-- select d.id as dept, d.dname, e.id, e.ename, d.captain from
UPDATE Emp e 
inner join Dept d on e.dept = d.id 
	set d.captain = e.id
	where e.dept=3 and e.name='김나라';
    
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