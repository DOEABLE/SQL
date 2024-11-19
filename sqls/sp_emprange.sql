-- 이 function 소스코드를 저장하고 관리해야한다.
SELECT * FROM Emp where id; 

drop procedure if exists sp_emprange;

-- 프로시저->
CREATE DEFINER=`dohee`@`%` PROCEDURE `sp_emprange` (_sid int, _eid int)
BEGIN
declare v_sid int default 0;
	declare v_sid int default _sid;
    declare v_eid int default _eid;
    
    IF _sid < 0 and _eid <0 THEN
		leave xxx;
	END IF;
    
    IF _sid < _eid THEN
		set v_sid = _eid;
    END IF;
    
    select * from Emp;
		where id between v_sid and v_eid;
END
-- 프로시저는 다 function으로 만들어버려.

-- procedure call
call sp_emprange(15,10);
-- 
call sp_emprange(-1,-5);

show procedure status where db='testdb';
show function status;

select* from Emp where id between 15 and 10;