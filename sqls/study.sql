-- table
show tables;
select * from Dept;
select * from Emp;
select * from Student;

-- 지정된 데이터베이스의 모든 테이블에 대한 생성 시간과 마지막 업데이트 시간 조회
SHOW TABLE STATUS FROM testdb;
-- 특정 테이블에 대한 정보 조회
SHOW CREATE TABLE Emp;
-- 지정된 데이터베이스의 모든 테이블에 대한 생성 시간과 마지막 업데이트 시간 조회
SELECT NOW(), SYSDATE(), CURRENT_TIMESTAMP;
-- 데이터베이스가 올바른 시간대를 가지고 있는지 확인 (UTC 시간 ('+00:00')에서 한국 시간 ('+09:00')으로 변환)
SELECT CONVERT_TZ('2024-11-19 12:00:00', '+00:00', '+09:00') AS converted_time;
SELECT 
    TABLE_SCHEMA,
    TABLE_NAME,
    CREATE_TIME,
    UPDATE_TIME
FROM 
    INFORMATION_SCHEMA.TABLES
WHERE 
    TABLE_SCHEMA = 'testdb'
ORDER BY 
    CREATE_TIME DESC;