
(
for $e in $employees
order by $e/salary descending
return $e/name,
for $car in $cars
stable order by $make,$value descending empty least
return $car
)


