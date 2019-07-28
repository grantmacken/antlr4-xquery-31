
(
for $s in $sales   
let $storeno := $s/storeno
group by $storeno
return (),
let $g2 := $expr1
let $g3 := $expr2
group by $g1, $g2, $g3 collation "Spanish"
return (),
let $revenue := $s/qty * $p/price
group by $storeno := $s/storeno, 
    $category := $p/category
return ()

)



