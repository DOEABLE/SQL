select sum(salary) from Emp;
select conv('FF', 16, 10), power(2,3), rand();
select '2024-04-25', cast('2024-04-25' as date), convert('2024-04-25', datetime);
select CONVERT(-1.567, signed Integer), CONVERT(abs(-1.567), unsigned Integer);

select cast(str_to_date('2018-02-03', '%Y-%d-%m') as date);  
select date_format('2018-02-03', '%Y-%d-%m');
-- ***
select dname, AES_ENCRYPT(dname, '암호키') from Dept; -- AES_DECRYPT
select dname, HEX(AES_ENCRYPT(dname, '암호키')) enc from Dept; -- AES_DECRYPT, 암호화키를 생성일 등으로 만든다.(table을 따로 두지 않음(보안))
select dname, UNHEX(HEX(AES_ENCRYPT(dname, '암호키'))) from Dept;
select dname, AES_DECRYPT(UNHEX(HEX(AES_ENCRYPT(dname, '암호키'))), '암호키') from Dept; -- AES_DECRYPT
select sub.*, CAST(AES_DECRYPT(UNHEX(sub.enc), '암호키') as char)
from (select dname, HEX(AES_ENCRYPT(dname, '암호키')) enc from Dept) sub;
SELECT dname,
	CAST(AES_DECRYPT(UNHEX(HEX(AES_ENCRYPT(dname, '암호키'))), '암호키') AS CHAR)
    FROM Dept;
select dname, SHA2(dname, 256) from Dept;


select dept, group_concat(ename)
  from Emp group by dept;
  
select concat('abc', ':', 'efg', ':', null, ':', 'hij'), 
       concat_ws(':', 'abc', 'efg', null, 'hij'); 
       
select ifnull(captain, '공석'), if(captain is null, '공석', captain),
       (case when captain is null then '공석' else captain end), -- CASE문은 END까지 써야함
       (case captain when 30 then '3333' when 51 then '555' else '공석' end),
       NullIf(captain, 150) -- captain이 null인 경우엔 150으로 변환
  from Dept;
  
select ascii('A'), char(65, 66), CAST(char(65, 66) as char);
select length('AB한글'), char_length('AB한글'), bit_length('A'), sign(-2), sign(2);
select 5 % 2, mod(5, 2);
-- 
select elt(2, 'str1', 'str2', 'str3'), field('s1', 's0', 's1');
select substring('abcdefg', 2, 3);
select substring_index('a,b,c,d', ',', 2);
-- DB는 INDEX 1부터 시작.(시험 출제)
select substring_index(substring_index('a,b,c,d', ',', 2), ',', -1);
select substring_index(substring_index('a,b,c,d', ',', 3), ',', -1);
-- 문자열의 위치 찾기(시험 출제) 서버api에서 미리 조작을 해서 front에 보내줄게.
select find_in_set('s3','s1,s2,s3,s4,s5'); -- index 몇번째에 존재하는지 찾아줌.
-- '3'이라는 문자부터 두개를 //로 바꿔줘.(js의 splice) [syntax] insert(문자열, 위치, 제거갯수, 추가할 문자)
select instr('str', 't'), locate('s1', 's0s1s2');
select insert('12345', 3, 2, '/');
select format(123456789, 0), format(78901.012356, 4), truncate(789.012356, 4);
-- lpad, 많이 쓰임
select left('abc', 2), right('abc', 2), upper('abc'), lower('AB'), 
lpad('5', 2, '0'), rpad('15', 3, '0');
select reverse('abc'), repeat('a', 3), concat('A', space(5), 'B');
select replace('abcdefg', 'cde', 'xxx');
select trim(' AB '), trim(LEADING's' from 'ssstrss');
select trim(leading 's' from 'ssstrss'), trim(trailing 's' from 'ssstrss');
select concat('X', ltrim(' AB '), 'X'), concat('X', rtrim(' AB '), 'X');
select now(), sysdate(), curdate(), curtime();
SELECT NOW(), SLEEP(2), NOW();
-- 결과: 두 NOW() 값이 동일
SELECT SYSDATE(), SLEEP(2), SYSDATE();
-- 결과: 두 SYSDATE() 값이 2초 차이(함수가 호출되는 시점의 시간을 반환)
select year(now()), month(now()), day(now()), month('2020-11-29'),
	   hour(now()), minute(now()), second(now()), quarter(now()), week(now());
SET GLOBAL time_zone = 'Asia/Seoul'; -- 전역 시간대 변경
-- 현재 시간대 확인
SELECT @@global.time_zone, @@session.time_zone;
select weekday('2024-11-17'), weekday('2024-11-18'), weekday('2024-11-19');   -- 월요일 0 ~
select dayofweek('2024-11-16'), dayofweek('2024-11-17'), dayofweek('2024-11-18'); -- 일요일 1 ~

select DATE(now()), TIME(now()), MAKEDATE(2024, 336), MAKETIME(19,3,50), TIME('19:03:50');
select time_to_sec('0:1:30'), period_add(202012, 12), period_diff(202103, 202011);
select datediff('2024-12-01', '2025-03-11'), timediff('12:20:33', '11:30:20');

select DATE_FORMAT(DATE_ADD(NOW(), INTERVAL -1 DAY), '%Y-%m-%d %H:%i:%s');

select '12aBcdEf' regexp '[a-z]';
SELECT REGEXP_INSTR('dog cat dog', 'dog', 2);
SELECT REGEXP_INSTR('aa aaa aaaa', 'a{4}');
SELECT REGEXP_LIKE('abc', 'ABC', 'c');
SELECT REGEXP_REPLACE('abc def ghi', '[a-z]+', 'X', 2, 2);