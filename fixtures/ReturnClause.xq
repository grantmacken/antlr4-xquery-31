
for $d in fn:doc("depts.xml")//dept
let $e := fn:doc("emps.xml")//emp[deptno eq $d/deptno]
where fn:count($e) >= 10
order by fn:avg($e/salary) descending
return
   <big-dept>
      {
      $d/deptno,
      <headcount>{fn:count($e)}</headcount>,
      <avgsal>{fn:avg($e/salary)}</avgsal>
      }
   </big-dept>


