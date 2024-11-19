-- 이 function 소스코드를 저장하고 관리해야한다.
SELECT * FROM Emp where id; 

-- 프로시저는 다 function으로 만들어버려.

-- procedure call
call sp_emprange(15,10);
-- 
call sp_emprange(-1,-5);
call sp_student_bulk_insert(5);

show procedure status where db='testdb';
show function status;

select* from Emp where id between 15 and 10;


drop procedure if exists sp_student_bulk_insert;

delimiter $$
-- 프로시저->
CREATE DEFINER=`dohee`@`%` PROCEDURE `sp_student_bulk_insert` (_cnt int)

BEGIN
	declare v_i int default 0;
    
    select max(id) + 1 into v_i from student;
    
    WHILE v_i<= _cnt DO
		INSERT INTO Student (name, birthdt, major, mobile, email)
        select 	concat('학생', v_i), '970821',f_randmajor(), 
				concat('010-1112-',LPAD(v_i,4,'0')),
                concat('stu', v_i, '@gmail.com');
		
        set v_i =v_i+1;
	END WHILE;
    
END $$

-- 부서명을 입력받아, 해당부서의 직원수와 해당 부서의 평균 급여를 반환하는 프로시저 작성(p.72 )
CREATE DEFINER=`dohee`@`%` PROCEDURE `sp_deptinfo` (_cnt int)
BEGIN
	SELECT count(*) empcnt, avg(salary)
    FROM v_emp_dept
    where dname =_dname;
END $$
