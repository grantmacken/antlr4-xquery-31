# antlr4-xquery-31

WIP xQuery 3.1 g4 lexer and grammar files

This is my very green attempt to construct antlr4 Lexer and Parser files for [xQuery 3.1](https://www.w3.org/TR/xquery-31/).


# Tests

I use a simple Makefile to generate build and test.


``` 
# to build
make
# to test
make test
```

When developing these g4 files, I have tried to use the examples provided 
in the [xQuery 3.1](https://www.w3.org/TR/xquery-31/) recommendation.
These examples are in the fixtures directory.
Each test name is derived from the substring id found in the xQuery recomendation document URL
e.g. `https://www.w3.org/TR/xquery-31/#doc-xquery31-VersionDecl`
should  be fixture test name `VersionDecl`


## Developing

I use these test fixtures when I am working on the g4 files.  e.g.

```
make
make show-tokens TEST=VersionDecl
make show-gui TEST=VersionDecl
```

The above example will build, 
then show the tokens produced by the lexer  using the VersionDecl fixture,
then show the AST tree  produced by the parser

## Notes:

In the lexer I have made heavy use modes.

For example the symbols for SequenceType OccurrenceIndicators "?", "*" and "+" also 
 appear in other contexts. Since the OccurrenceIndicators are bound to Sequencetype.

 ' ( 4 treat as item()+ ) - 5 '
The 'treat' will goto mode(INSTANCE),
where it may consume 'as' which will push it into mode(SEQUENCE_TYPE), 
which will pop back to mode(INSTANCE) where it may consume an Occurrence Indicator.
If it consumes an ')' it will pop back to default.

This open close mode movement, depends on the expression 'treat as item()+'
being enclosed in parentheses, so I might make this parentheses enclosure for instanceofExpr and treatExpr a parser requirement.



 


  
 

