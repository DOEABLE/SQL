create table book(
	bno INT PRIMARY KEY auto_increment,
    title VARCHAR(50) NOT NULL comment '도서 이름',
    author VARCHAR(30) NOT NULL comment '저자',
    publisher VARCHAR(30) NOT NULL comment '출판사',
    description VARCHAR(2000) NOT NULL comment '내용 요약',
    isbn VARCHAR(30) NOT NULL comment 'ISBN',
    availability TINYINT NOT NULL DEFAULT 1 comment '대출 가능 여부(0:불가, 1:가능)',
    borrowerId VARCHAR(30) comment '대출자 아이디',
    startDate DATETIME comment '도서 대출일',
    endDate DATETIME comment '도서 반납일, 도서 대출일 기준 일주일 후'
);