
declare 
function local:summary( $test as element(employee)* ) as element(dept)* {
' example 1: FunctionDecl'
};

declare 
function  local:depth( $e as node() ) as xs:integer {
' example 2: FunctionDecl'
};

declare 

function  local:depth( $e as node() ) as xs:integer {
' example 2: FunctionDecl'
};

declare 
    %test:args("June 30, 2014")
    %test:assertXPath("deep-equal($result, <date>June 30, 2014</date>)")
    function local:anno($string as xs:string) { ()
};

()