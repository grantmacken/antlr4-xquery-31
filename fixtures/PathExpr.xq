(
child::div1 / child::para / string() ! concat("id-", .),
$emp ! (@first, @middle, @last),
$docs ! ( //employee),
avg( //employee / salary ! translate(., '$', '') ! number(.)),
$values!(.*.) => fn:sum(),
fn:string-join((1 to $n)!"*")
)
