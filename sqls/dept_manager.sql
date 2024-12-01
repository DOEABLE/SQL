select * from Dept;
desc Dept;
select * from Emp where auth < 9;
desc Emp;
select * from Emp;

select *
	from Dept d inner join Emp e on d.captain = e.id;
    
update Dept d inner join Emp e on d.captain = e.id 
set e.auth = 5
where e.auth =9;

WITH RECURSIVE CteDept(id, pid, dname, captain, depth, h) AS (
  select id, pid, dname, captain, 0, cast(id as char(10)) from Dept where pid = 0 and id<>2
  UNION ALL
  select d.id, d.pid, d.dname, d.captain, depth + 1, concat(c.h, '-', d.id)
    from CteDept c inner join Dept d on c.id = d.pid where d.id<>0
) 
select c.id, c.pid, c.dname, c.captain, c.depth, e.ename
  from CteDept c left join Emp e on c.captain = e.id
  order by c.h;
select id, pid, dname, captain, depth
  from CteDept c order by c.h;
  
  