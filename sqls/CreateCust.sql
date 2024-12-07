select * from Dept;
select * from Emp where auth<9;
desc Emp;

WITH RECURSIVE CteDept(id, pid, dname, captain, depth, h)AS(
	select id,pid, dname, captain,0, cast(id as char(10))from Dept where pid =0
    union all
    select d.id, d.pid, d.dname, d.captain, depth +1, concat(c.h, '-', d.id)
    from CteDept c inner join Dept d on c.id=d.pid
)
select id, pid, dname, captain, depth
from CteDept c order by c.h;
create table Cust(
	id bigint unsigned not null auto_increment,
    name VARCHAR(31) not null default '' comment '고객명',
    tel varchar(15) not null default '' comment '전화번호',
    email varchar(255) null comment '이메일주소',
    primary key (id)
);
insert into Cust(name, tel) values('홍길동', '010-1111-2222'), ('김길동', '010-3333-4444');
select * from Cust;