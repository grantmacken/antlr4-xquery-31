
(
for $e in $employees
order by $e/salary descending
return $e/name 
,
for $car in    ($license = "PFQ519", $make = "Ford",  $value = 16500)
                ($license = "HAJ865", $make = "Honda", $value = 22750)
                ($license = "NKV473", $make = "Ford",  $value = 21650)
                ($license = "RCM922", $make = "Dodge", $value = 11400)
                ($license = "ZBX240", $make = "Ford",  $value = 16500)
                ($license = "KLM030", $make = "Dodge", $value = () )
stable order by $make, $value descending empty least
   return $car
)
