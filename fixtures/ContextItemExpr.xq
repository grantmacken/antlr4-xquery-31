(
(1 to 100)[. mod 5 eq 0])
,
fn:doc("bib.xml")/books/book[fn:count(./author)>1])
)