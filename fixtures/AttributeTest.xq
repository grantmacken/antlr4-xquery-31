

declare 
function local:f1( $var1 as attribute(*) , $var2 as attribute() ) {
    'example 1: KindTest/AttributeTest'
};

declare 
function local:f2( $var as attribute(price)  ) {
    'example 2: attribute( AttributeName ) '
};


declare 
function local:f3( $var as attribute(price, currency)  ) {
    'example 3: attribute( AttributeName, TypeName )'
};

declare 
function local:f4( $var as attribute(price, currency)  ) {
    'example 4: attribute(*, currency)'
};

()
