CREATE FUNCTION `f_randmajor`()
RETURNS INTEGER
BEGIN
	declare v_ret tinyint unsigned default 0;
    
    select id into v_ret from Major order by rand() limit 1;
    
RETURN 