select * from Dept;

create table Cust(
	id bigint unsigned not null auto_increment,
    name VARCHAR(31) not null default '' comment '고객명',
    tel varchar(15) not null default '' comment '전화번호',
    email varchar(255) null comment '이메일주소',
    primary key (id)
);
insert into Cust(name, tel) values('홍길동', '010-1111-2222'), ('김길동', '010-3333-4444');
select * from Cust;