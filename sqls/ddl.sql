show processlist;
SHOW databases;
USE testdb;
SHOW TABLES;
show index from Prof;
desc Prof;
insert into Prof(name) values ("김교수");
insert into Prof(name) values ("홍교수");
insert into Prof(name) values ("박교수");
insert into Prof(name) values ("윤교수");

insert into Subject(name, prof)
	select concat(p.name,'과목'),p.id from Prof p;
select * from Subject;
select * from Prof;
delete from Subject where id=1;
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME='Subject';

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
    -- add constraint는 alter에서만 사용하는거다.
    constraint Foreign Key fk_Subject_prof_Prof(prof)
					references Prof(id) ON DELETE SET NULL ON UPDATE CASCADE
);

alter table Subject add constraint unique key uniq_Subject_name(name);
show index from Subject;
-- 수강신청table
create table Enroll(
	id mediumint unsigned not null auto_increment PRIMARY key comment '수강신청코드',
    createdate timestamp DEFAULT CURRENT_TIMESTAMP COMMENT '신청일시',
    updatedate timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '수정일시',
	subject smallint unsigned not null comment '과목번호',
    student mediumint unsigned not null comment '학번',
    -- PRIMARY KEY(id),
    constraint Foreign Key fk_Enroll_subject_Subject(subject)
					References Subject(id) on delete cascade on Update cascade,
	constraint Foreign Key fk_Enroll_student_Student(student)
					References Student(id) on delete cascade on Update cascade
);
-- 테이블의 데이터 타입 확인
show columns from student;
show columns from Enroll;
select * from student;
truncate table student;
insert into Enroll(subject,student) values(1,1),(2,2),(9,3),(4,4),(8,1);
desc enroll;
desc Student;
select * from Enroll;
select * from subject; -- 6,7,8,9
select * from student; -- 4,5,10,11
-- legion com
insert into Enroll(subject,student) values(6,4),(7,5),(8,10),(9,11);

select e.*, sub.name as subjectName
	from Enroll e inner join Subject sub on e.subject = sub.id;

select e.*, sub.name as subjectName, stu.name
	from Enroll e inner join Subject sub on e.subject = sub.id
				inner join Student stu on e.student = stu.id;
                
select e.*, sub.name as subjectName, stu.name, stu.major as major_id, m.name as majorName
	from Enroll e inner join Subject sub on e.subject = sub.id
				inner join Student stu on e.student = stu.id
                left outer join Major m on stu.major =m.id;
	


-- drop table Enroll;
ALTER TABLE STUDENT MODIFY COLUMN NAME VARCHAR(25) NOT NULL DEFAULT '' COMMENT '학생명';
ALTER TABLE STUDENT MODIFY COLUMN major tinyint unsigned null comment '학과코드';   
ALTER TABLE STUDENT add constraint foreign key fk_Student_major_Major(major)
								references Major(id) on DELETE set null on UPDATE CASCADE;
    select * from Major;
CREATE TABLE Major(
    id tinyint unsigned not null auto_increment primary key comment '학과코드',
    name varchar(20) not null comment '학과명'
);
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
    UNIQUE KEY uniq_Student_email(email),-- unique column은 모아놓으면 where조건 걸때 유리함.
    UNIQUE KEY uniq_Student_name_mobile(name,mobile)
    );
-- serve query
select s.*, m.name
	from Student s left join Major m on s.major = m.id;
select s.*, m.name
	from Student s inner join Major m on s.major =m.id
    where m.id<=3;



