show processlist;
SHOW databases;
USE testdb;
USE mysql;
SHOW TABLES;

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


create table Prof(
	id smallint unsigned not null auto_increment comment '교수번호',
    createdate timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '등록일시',
    updatedate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    name VARCHAR(31) NOT NULL COMMENT '이름',
    likecnt INT default 0,
    PRIMARY KEY(id)
);
create table Subject(
	id smallint unsigned not null auto_increment comment '과목번호',
    createdate timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    name varchar(45) not null COMMENT '과목명',
    prof smallint unsigned null comment '담당교수',
    PRIMARY KEY(id),
    Constraint Foreign Key fk_Subject_prof_Prof (Prof)
					References Prof(id) ON DELETE SET NULL ON UPDATE CASCADE
);

alter table Subject add constraint unique key uniq_Subject_name(name);
show index from Subject;

create table Enroll(
	id mediumint unsigned not null auto_increment primary key comment '수강신청코드',
    createdate timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '신청일시',
    updatedate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
	subject smallint unsigned not null comment '과목번호',
    student int unsigned not null comment '학번',
    PRIMARY KEY(id),
    Constraint Foreign Key fk_Enroll_subject_Subject(subject)
					References Subject(id) on delete cascade on Update cascade,
	Constraint Foreign Key fk_Enroll_student_Student(student)
					References Student(id) on delete cascade on Update cascade
);

-- drop table Enroll;

select * from STUDENT;
RENAME TABLE STUDENT TO Student;
CREATE TABLE EmailLog(
id int unsigned not null auto_increment,
sender int unsigned not null comment '발신자 id',
receiver varchar(1024) not null comment '수신자들',
subject varchar(255) not null default '냉무' comment '제목',
body text null comment '내용 및 첨부파일',
PRIMARY KEY (id),
    CONSTRAINT fk_EmailLog_sender_Emp FOREIGN KEY (sender) REFERENCES Emp(id)
);
    select * from Emp;
    -- select
    WITH RankedEmployees AS (
    SELECT 
        id, 
        ename, dept, is_Captain,
        ROW_NUMBER() OVER (PARTITION BY dept ORDER BY ename ASC) AS RowNum
    FROM Emp
)
SELECT id, ename, dept, is_Captain
FROM RankedEmployees
WHERE RowNum = 1;

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

    
    select * from Dept;
CREATE TABLE Student (
    id mediumint unsigned not null auto_increment comment '학번',
    createdate timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '생성일',
    updatedate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일',
    name VARCHAR(31) NOT NULL COMMENT '이름',
    birthdt DATE NOT NULL COMMENT '생일(YYMMDD)',
    major tinyint unsigned not null comment '학과코드',
    mobile VARCHAR(15) not null COMMENT '전화번호',
    email VARCHAR(150) NOT NULL COMMENT '이메일주소',
    gender boolean not null default 0 COMMENT '성별(0:여성, 1:남성)',
    graduatedt DATE NULL COMMENT '졸업일',
    PRIMARY KEY(id),
    UNIQUE KEY uniq_Student_email(email),
    UNIQUE KEY uniq_Student_name_mobile(name,mobile)
    );
    ALTER TABLE STUDENT MODIFY COLUMN NAME VARCHAR(25) NOT NULL DEFAULT '' COMMENT '학생명';
    
    ALTER TABLE STUDENT MODIFY COLUMN major tinyint unsigned null comment '학과코드';
    
    ALTER TABLE STUDENT add constraint foreign key fk_Student_major_Major(major)
								references Major(id) on DELETE set null on UPDATE CASCADE;
    alter table Emp add column auth tinyint(1) not null default 9 comment '권한(0:sys, 1:super,...,9:guest)' after dept;
    
    desc Student;
    CREATE TABLE Major(
    id tinyint unsigned not null auto_increment primary key comment '학과코드',
    name varchar(20) not null comment '학과명'
);



