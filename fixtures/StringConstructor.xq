(
for $s in ("one", "two", "red", "blue")
return ``[`{$s}` fish and chips]``,
``[`{ $i, ``[literal text]``, $j, ``[more literal text]`` }`]``,
``[Hello `{$a?name}`
You have just won `{$a?value}` dollars!
`{ 
   if ($a?in_ca) 
   then ``[Well, `{$a?taxed_value}` dollars, after taxes.]``
   else ""
}`]``

)


