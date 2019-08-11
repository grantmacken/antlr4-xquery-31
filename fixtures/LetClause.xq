(
let $x := $expr1
return ()
,
for $d in fn:doc("depts.xml")/depts/deptno
let $e := fn:doc("emps.xml")/emps/emp[deptno eq $d]
return $e
)
