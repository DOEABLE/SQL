UPDATE Major SET name='소프트웨어학과' where id=3;

select * from Major limit 0,2;
select * from Major limit 3,2; -- 세개를 건너뛰고!(offset) 
desc Major;
insert into Major(name) values ('컴퓨터공학과'),('소프트웨어공학과');

insert into Major(name) select ('산업공학과') from dual;
insert into Major set name = '경제학과';
insert into Major set name = '경영학과';
select 1+2 from dual;

select * from Student;
select * from Major;
desc Student;


insert into Student(name, birthdt, major, mobile, email)
			values('Hong', '990102', 1, '010-2322-3422', 'hong@gmail.com');
insert into Student(name, birthdt, major, mobile, email)
			values('kim', '980322', 1, '010-1231-3422', 'kim@gmail.com');
insert into Student(name, birthdt, major, mobile, email)
			values('lee', '901112', 6, '010-1231-6782', 'lee@gmail.com');
insert into Student(name, birthdt, major, mobile, email)
			values('choi', '970502', 3, '010-000-4785', 'choi@gmail.com');
ALTER TABLE Student
MODIFY major  tinyint unsigned NULL;
UPDATE Student SET major =null where name='choi';

select * from Student where name='kim';
select * from Student where gender=0;
select * from Student where birthdt like '98%';
select * from Student where birthdt BETWEEN '980101' AND '981231';
select * from Student where birthdt >='980101' AND birthdt <= '981231';

select * from Student where major in(5,6);
select * from Student where major=5 or major=6; -- 이 범위가 작은 것이 좋음.
select * from Student where major in (select major from Student where major >=5);
select * from Student where major in (select distinct major from Student where major >=5); -- distinct : 중복제거.
select * from Student where major = (select min(major) from Student); -- in보다 '='가 성능이 좋음.
select * from Student where major <= ANY(select major from Student); -- 1-5중 아무거나보다 작은것 = MAX값보다 작은 것.
select * from Student where major > SOME(select major from Student); 
select * from Student where major < ALL(select major from Student); 
select * from Student ORDER BY rand();
select major, count(*) cnt from Student where id>0 group by major HAVING cnt >1 ;

select max(major),min(birthdt) from Student;
select * FROM STUDENT;
select * FROM MAJOR;
select * FROM Student INNER JOIN Major ON Student.major = Major.id where Student.id>=2;

select * FROM Student s left outer join Major m on s.major = m.id;
-- UNION
select * FROM Student s right outer join Major m on s.major = m.id;

select * from Major where id<=3
UNION
select * from Major where id>=3;