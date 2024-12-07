select * from v_emp_dept;
desc Subject;

select * from Subject;
update Subject set prof = NULL WHERE id =3;

select s.*, p.name
from Subject s left join Prof p on s.prof = p.id;



