select conv('FF',16,10), power(2,3),rand();
select '2024-04-25', cast('2024-04-25'as datetime), convert('2024-04-25',date);
select CONVERT(-1.567, unsigned integer),CONVERT(abs(-1.567), unsigned integer);

-- formatting
select str_to_date('2018-01-12','%Y-%m-%d');
select date_format('2018-02-03','%Y-%d-%m');

-- AES암호화
select dname, HEX(AES_ENCRYPT(dname,'암호키')) from Dept;
select dname, AES_ENCRYPT(dname,'암호키') from Dept;
-- 복호화
SELECT dname, AES_DECRYPT(UNHEX(HEX(AES_ENCRYPT(dname,'암호키'))), '암호키') FROM Dept;

SELECT dname, SHA2(dname,256) from Dept;

select dept, group_concat(ename)
from Emp group by Dept;

-- if, null if, ifnull
select ifnull(captain,'공석'),if(captain is null,'공석',captain),
	(case when captain is null then '공석' else captain end),
    (case captain when 30 then '3333' else '공석' end)
from Dept;

select substring('abcdefg',2,3);
select substring_index('a,b,c,d',',',2);

select format(123456789,0), format(78901.012356,4), truncate(789.012356,4);
select left('abc',2), right('abc',2), upper('abc'), lower('ABC'), lpad('5','2','0'), rpad('15','3','0');
select reverse('abc'),repeat('a',3),concat('A', space(5), 'B');
select trim('AB'), trim(both's'from 'ssstrss'), trim(leading 's' from 'ssstrss');

-- 시간
select weekday('2024-11-17'), weekday('2024-11-18'), weekday('2024-11-19');-- 월요일:0~
select dayofweek('2024-11-16'), dayofweek('2024-11-17'); -- 일요일: 1~ 토요일: 7

-- view
select * from v.emp_dept;


