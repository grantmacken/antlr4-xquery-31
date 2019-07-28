

declare 
function local:f3( $var1 as function(int, int) as int) {
    'example 1: function(int, int) as int
    matches any functionwith the function signature function(int, int) )'
};


declare 
function local:f5( $var1 as function(xs:anyAtomicType) as item()* ) {
    'example 2: %assertion function(int, int) as int  -  
    matches any map, or any function with the required signature. '
};

declare 
function local:f6( $var1 as function(xs:integer) as item()* ) {
    'example 3: function(xs:integer) as item()*  - 
    matches any array, or any function with the required signature.'
};

()