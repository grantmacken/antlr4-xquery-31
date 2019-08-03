
(
try {
    $x cast as xs:integer
}
catch * {
    ()
},
try {
    $x cast as xs:integer
}
catch err:FORG0001 {
    0
},
try {
    $x cast as xs:integer
}
catch err:FORG0001 | err:XPTY0004 {
    0
}

)

