(
    $products[price gt 100] 
    ,
    (1 to 100)[. mod 5 eq 0]
    ,
    (21 to 29)[5]
    ,
    $orders[fn:position() = (5 to 9)]
    ,
    $book/(chapter | appendix)[fn:last()]
)
 