lexer grammar XQueryLexer;
// Tokens declared but not defined
// tokens declared in the tokens section 
// take precedence over those defined in normal lexer rules

tokens {
	VarName,
	Wildcard,  // '*'
	EscapeApos,
	EscapeQuot,
	QuotStart,
	QuoteContentChar,
	QuotEnd,
	AposStart,
	AposContentChar,
	AposEnd,
	// XML
	TagStartOpen, 
	TagStartClose,
	TagEndOpen,
	TagEndClose,
    QuotAttrValueContent,
	DoubleCurlyOpen,  // {{ escapes for XML AND StringLiteral 
	DoubleCurlyClose, // }}
	CharRef, // TODO also in StringLiteral
    // XQUERY tokens  
	// tests
	EmptySequence,
	OccurrenceIndicator,
	Param,
	SymEquals,
	ValueComparison,  
	GeneralComparison,
	NodeComparison
}  

// start DEFAULT MODE
WS: [ \t\r\n]+ -> channel(HIDDEN);
Separator: ';' ; //  VarDecl: binds to expression so this will end VarDecl
SymBind:  ':=' ; 
// patterns that occur at the beginning of an expression or subexpression
// Push then pop back when we get to a seperator
XQuery: 'xquery' -> pushMode(VERSION_DECL);
Module: 'module' -> pushMode(MODULE_DECL);
// PROLOG  
Declare: 'declare'  ->  pushMode(PROLOG) ; // BoundarySpaceDecl DefaultCollationDecl: DefaultNamespaceDecl Setter NamespaceDecl 
Import:  'import'   ->  pushMode(PROLOG) ;
// FLWORExpr:
For:       'for'    ->  mode( FOR_CLAUSE ) ; // ForClause
Let:       'let'    ->  mode( LET_CLAUSE ) ; // LetClause
Some:      'some'   ->  pushMode( QUANTIFIED_EXPR ) ; // QuantifiedExpr 
Every:     'every'  ->  pushMode( QUANTIFIED_EXPR ) ; // QuantifiedExpr
Satisfies: 'satisfies'  ;                              // QuantifiedExpr
Group:     'group'  ->     mode( GROUP_BY_CLAUSE ) ;      // GroupByClause:
Collation: 'collation' ->  pushMode( COLLATION ) ;    // GroupingSpec OrderModifier

Stable:     'stable';       // orderByClause
Order:      'order'      ->   mode( ORDER_BY_CLAUSE ); // orderByClause
Ascending:  'ascending'  ->   mode( ORDER_BY_CLAUSE ); // OrderModifier
Descending: 'descending' ->   mode( ORDER_BY_CLAUSE ); // OrderModifier:
Empty:      'empty';           // OrderModifier  ForBinding/AllowingEmpty , also defined in mode PROLOG EmptyOrderDecl

VarPrefix:   '$'         ->  pushMode( VAR_NAME ) ;   // VarName no whitespace after '$'
At:          'at' ;  // forBinding contains PositionalVar ...  ref modes 'at' ModuleImport: SchemaImport
In:          'in' ;        //  ForBinding quantifiedExpr

// Greatest:    'greatest';     // OrderModifier , also defined in mode PROLOG EmptyOrderDecl:
// Least:       'least';           // OrderModifier , also defined in mode PROLOG EmptyOrderDecl:
Count:       'count';           // CountClause
Where:       'where';           // WhereClause
As:          'as'   ->  pushMode( SEQUENCE_TYPE )  ;       // TypeDeclarationsequenceTypeUnion InlineFunctionExpr:
By:          'by' ;       // GroupByClause OrderByClause

Switch:     'switch'       -> pushMode( SWITCH_EXPR ) ; //-> mode( PARENTHESIZED_EXPR ) ; // switchExpr
Typeswitch: 'typeswitch'   -> mode( TYPESWITCH_EXPR ) ; //-> mode( PARENTHESIZED_EXPR ) ; // typeswitchExpr
Case:       'case'         -> pushMode( CASE_CLAUSE );        // switchExpr typeswitchExpr

Default:    'default'  ;   // switchExpr  typeswitchExpr
Return:     'return' ;     // switchExpr  typeswitchExpr

If:         'if'         -> pushMode( IF_EXPR );         //ifExpr
//Then:       'then';       // in mode Expr
Else:       'else';       //ifExpr

Try:   'try'   ->   pushMode( ENCLOSED_EXPR ); // tryCatchExpr
Catch: 'catch' ->   pushMode( CATCH_CLAUSE );  // tryCatchExpr


Or:   'or';   // orExpr
And:  'and';  /// andExpr


Ques:  '?'  -> pushMode( LOOKUP_KEYSPECIFIER );  //  also ref in CastExpr CastableExpr
Arrow: '=>' -> pushMode( ARROW_FUNCTION_SPECIFIER ); // arrowExpr

TagStartOpen: '<' QName ->pushMode(START_TAG);

// COMPARISON EXPRESSIONS
// -------------
// Node Comparison 
NodeComp_is:               'is' -> type(NodeComparison);
NodeComp_DoubleLeftAngle:  '<<' -> type(NodeComparison);   // longer match first
NodeComp_DoubleRightAngle: '>>' -> type(NodeComparison);   // longer match first
// May be tag tag  or GeneralComp_LessThan
// General Comparison
GeneralComp_Equals:	            '=' ->  type(GeneralComparison);  //also appears in 'modes' as type symEquals
GeneralComp_NotEqual:	        '!=' -> type(GeneralComparison); 
GeneralComp_LessThanOrEqual:    '<=' -> type(GeneralComparison);  // longer match first
GeneralComp_LessThan:           '<'  -> type(GeneralComparison);
GeneralComp_GreaterThanOrEqual: '>=' -> type(GeneralComparison);  // longer match first
GeneralComp_GreaterThan:        '>'  -> type(GeneralComparison);

// Value Comparison
ValueComp_eq: 'eq' -> type(ValueComparison) ;
ValueComp_ne: 'ne' -> type(ValueComparison);
ValueComp_lt: 'lt' -> type(ValueComparison);
ValueComp_le: 'le' -> type(ValueComparison);
ValueComp_gt: 'gt' -> type(ValueComparison);
ValueComp_ge: 'ge' -> type(ValueComparison);


//Additive  
AdditivePlus : '+'; // additiveExpr
AdditiveMinus: '-'; // additiveExpr
// Multiplicative   
MultiplicativeMod : 'mod';   // multiplicativeExpr
MultiplicativeIdiv : 'idiv'; // multiplicativeExpr
MultiplicativeDiv : 'div';   // multiplicativeExpr
MultiplicativeTimes : '*';   // multiplicativeExpr
// Combining Results
// StringConcat
StringConcat: '||';
Union : 'union';         // unionExpr
VBar : '|';  // unionExpr
Intersect : 'intersect'; // intersectExceptExpr
Except : 'except';       // intersectExceptExpr
 
// Range
RangeTo: 'to'; //rangeExpr

Instance: 'instance'    -> mode( INSTANCE ) ;     // instanceofExpr
Treat:    'treat'       -> pushMode( INSTANCE ) ; // treatExpr
Castable: 'castable'    -> pushMode( AS_TYPE_NAME ) ;  // castableExpr
Cast:     'cast'        -> pushMode( AS_TYPE_NAME ) ;  // castExpr
Validate:   'validate'  -> pushMode( VALIDATE_EXPR ) ;     //  TODO validateExpr
Ordered:    'ordered'   -> pushMode( ENCLOSED_EXPR );  // orderedExpr   also in mode PROLOG OrderingModeDecl
Unordered:  'unordered' -> pushMode( ENCLOSED_EXPR );  // unorderedExpr also in mode PROLOG OrderingModeDecl

/*  
CONSTRUCTORS and Kind Tests
*/

Document:   'document' ;     // CompDocConstructor
Element:    'element' ;      // CompElemConstructor  ElementTest also in modes for DefaultNamespaceDecl  SchemaImport/SchemaPrefix
// also in declaration-modes SchemaPrefix: DefaultNamespaceDecl:
Attribute:  'attribute' ;    // CompAttrConstructor:  AttributeTest: ForwardAxis:
Namespace:  'namespace' ;    // CompNamespaceConstructor: 
// also in declaration-modes ModuleDecl: SchemaPrefix: ModuleImport: NamespaceDecl: DefaultNamespaceDecl
Text: 'text' ; //  CompTextConstructor: TextTest:
Comment: 'comment' ; // CompCommentConstructor CommentTest:
ProcessingInstruction: 'processing-instruction' ; // CompPIConstructor: PITest
 // functionItemExpr: namedFunctionRef | inlineFunctionExpr
Function: 'function' -> pushMode( INLINE_FUNCTION ) ; // InlineFunctionExpr: AnyFunctionTest TypedFunctionTest:
// also in modes FunctionDecl: DefaultNamespaceDecl 
         // MapConstructorOpen
Map:   'map';     // MapConstructor         MapTest/ (AnyMapTest | TypedMapTest)
Array: 'array' ;  // CurlyArrayConstructor  ArrayTest/ ( AnyArrayTest TypedArrayTest)
StringConstructorOpen:  '``['  -> pushMode( STRING_CONSTRUCTOR );
StringConstructorClose:  ']``' -> popMode ;

// StringConstructorClose @see mode STRING_CONSTRUCTOR 
// StringConstructorInterpolationOpen @see mode STRING_CONSTRUCTOR
// StringConstructorInterpolationOpen: '`{'  -> pushMode(DEFAULT_MODE) ;
StringConstructorInterpolationClose: '}`' -> popMode ;  // back into STRING_CONSTRUCTOR 

SquareOpen: '[';  // SquareArrayConstructor:
SquareClose: ']';  // SquareArrayConstructor:

// Constructor open close
CurlyOpen: '{'  -> pushMode(DEFAULT_MODE); // we want to pop back EnclosedExpr MapConstructor push
// NOTE  also pushes onto stack in mode PROLOG (FunctionDecl/EnclosedExpr), APOS_ATTRIBUTE_CONTENT and APOS_ATTRIBUTE_CONTENT
CurlyClose: '}' -> popMode ;               // EnclosedExpr MapConstructor
// NOTE  also pops back into modes PROLOG (FunctionDecl/EnclosedExpr) , APOS_ATTRIBUTE_CONTENT and APOS_ATTRIBUTE_CONTENT

ParenOpen:  '(' -> pushMode(DEFAULT_MODE) ;  // ParenthesizedExpr
ParenClose: ')' -> popMode ;                // ParenthesizedExpr


Dot:  '.' ; // ContextItemExpr
Hash: '#' ;
Anno: '%' ;
SymAt: '@';        //  AbbrevForwardStep:
SymBang: '!';     //   SimpleMapExpr:
Comma: ',';

// Literals
QuotStart: '"'  -> pushMode(QUOT_COMMON_CONTENT);
AposStart: '\'' -> pushMode(APOS_COMMON_CONTENT);
IntegerLiteral: Digits;
DecimalLiteral: (('.' Digits) | (Digits '.' '0'..'9'*)); 
DoubleLiteral: ('.' Digits | Digits ('.' [0-9]*)?) [eE] [+-]? Digits; 
PredefinedEntityRef : '&' ( 'lt' | 'gt' | 'amp' | 'quot' | 'apos' ) ';' ;
// PredefinedEntityRef : '&' -> more;

NCNameWithLocalWildcard:    NCName ':' '*' ;
NCNameWithPrefixWildcard:   '*' ':' NCName ;


//  Expressions


// XPATH
DoubleForwardSlash: '//' ; //PathExpr: RelativePathExpr:
ForwardSlash:       '/' ;     //PathExpr: RelativePathExpr:
DoubleColon:        '::' ;               //ForwardAxis
Child:      'child' ;                    //ForwardAxis
Descendant: 'descendant' ;               //ForwardAxis
Self: 'self' ;                           //ForwardAxis
DescendantOrSelf: 'descendant-or-self' ; //ForwardAxis
FollowingSibling: 'following-sibling' ;  //ForwardAxis
Following: 'following' ;                 //ForwardAxis
Parent: 'parent' ;                       //ReverseAxis
Ancestor: 'ancestor' ;                   //ReverseAxis
PrecedingSibling: 'preceding-sibling' ;  //ReverseAxis
Preceding: 'preceding' ;                 //ReverseAxis
AncestorOrSelf: 'ancestor-or-self' ;     //ReverseAxis

AbbrevReverseStep : '..';

// Tests
// order by xquery-31 tokenizer.ebnf
// XML-SPECIFIC
XML_CDATA:  '<![CDATA[' .*? ']]>' -> channel(HIDDEN);
XML_Comment: '<!--' ('-' ~[-] | ~[-])* '-->' -> channel(HIDDEN);
XML_PI: '<?' NCName ([ \t\r\n] .*?)? '?>';
XML_DECL: '<?' [Xx] [Mm] [Ll] ([ \t\r\n] .*?)? '?>' -> channel(HIDDEN);
XML_PRAGMA: '(#' WS? (NCName ':')? NCName (WS .*?)? '#)';
XQDocComment: '(' ':' '~'(XQComment | '(' ~[:] | ':' ~[)] | ~[:(])* ':'* ':'+ ')' -> channel(HIDDEN);
XQComment: '(' ':' ~'~' (XQComment | '(' ~[:] | ':' ~[)] | ~[:(])* ':'* ':'+ ')' -> channel(HIDDEN);

// Expanded Qualified Name 
// EQName : QName | URIQualifiedName;
// Qualified Name 
Colon: ':';
QName : ((NCName Colon NCName) | NCName) ;
BracedURIOpen: 'Q{' ->  pushMode( URI_QUALIFIED_NAME ) ;

// According to http://www.w3.org/TR/REC-xml-names/#NT-NCName, it is 'an XML Name, minus the ":"'
NCName : NameStartChar NameChar*;
//NCName : Name ~ NCNameInternal ; /* xgc: xml-version */    /* An XML Name, minus the ":" */
//NCNameInternal : (Char* ':' Char*);
// WHITESPACE
// S ::= (#x20 | #x9 | #xD | #xA)+



fragment CharRef: '&#' [0-9]+ ';' | '&#x' [0-9a-fA-F]+ ';';
// Digits:
fragment Digits: [0-9]+ ;
fragment HexDigits : 
	('0'..'9' | 'a'..'f' | 'A'..'F')+
	;


// Names and Tokens:
fragment NameStartChar:
	[_a-zA-Z]
	| '\u00C0' ..'\u00D6'
	| '\u00D8' ..'\u00F6'
	| '\u00F8' ..'\u02FF'
	| '\u0370' ..'\u037D'
	| '\u037F' ..'\u1FFF'
	| '\u200C' ..'\u200D'
	| '\u2070' ..'\u218F'
	| '\u2C00' ..'\u2FEF'
	| '\u3001' ..'\uD7FF'
	| '\uF900' ..'\uFDCF'
	| '\uFDF0' ..'\uFFFD'
	;

fragment NameChar:
	NameStartChar
	| '-'
	| '.'
	| [0-9]
	| '\u00A1' ..'\u00BF'
	| '\u0300' ..'\u036F'
	| '\u203F' ..'\u2040'
	;

fragment Name : NameStartChar (NameChar)* ;
fragment Names : Name ('\u0020' Name)* ;
fragment Nmtoken : (NameChar)+ ;
fragment Nmtokens : Nmtoken ('\u0020' Nmtoken)* ;


// Characters:
fragment Char : 
      '\u0009'                 // horizontal tab
    |  '\u000A'                // line feed
    |  '\u000D'                // carriage return / enter
    |  '\u0020' .. '\u0039'    // other Unicode char
    |  '\u003B' .. '\uD7FF'   
    |  '\uE000' .. '\uFFFD' ;

// LEXER MODES

mode VERSION_DECL;
VD_WS: WS -> type(WS),channel(HIDDEN);
Version:  'version' ; 
Encoding: 'encoding' ; 
VD_QuoteStringLiteral:  '"'   -> type(QuotStart),pushMode(QUOT_COMMON_CONTENT) ;
VD_AposStringLiteral:   '\''  -> type(AposStart),pushMode(APOS_COMMON_CONTENT) ; 
VD_Separator:           ';'   -> type(Separator),popMode ; 

mode MODULE_DECL;
MOD_WS: WS -> type(WS),channel(HIDDEN);
MOD_Namespace: 'namespace' -> type(Namespace),mode(NAMESPACE_KEYWORD); // NamespaceDecl




// mode PREDEFINED_ENTITY_REF;
// PER_LT: ( 'lt' | 'gt' | 'amp' | 'quot' | 'apos' ) -> more;
// PER_Sep: ';' -> type(PredefinedEntityRef);


mode URI_QUALIFIED_NAME;  /* ws: explicit */
BRL_CharRef: CharRef -> type(CharRef);
BRL_PredefinedEntityRef: PredefinedEntityRef -> type(PredefinedEntityRef) ;
BracedURIContent: ~[&{}]+ ;
BRL_CurlyClose: '}' ->  type(CurlyClose),mode(NCNAME);

mode NCNAME; /* ws: explicit */
NCN_NCName: NCName -> type(NCName),popMode ;

mode QUOT_COMMON_CONTENT;
QCC_EscapeQuot: '""' -> type(EscapeQuot);
QCC_CharRef: CharRef -> type(CharRef);
QCC_PredefinedEntityRef: PredefinedEntityRef -> type(PredefinedEntityRef);
Apos: '\'' ;
QCC_QuoteContentChar: ~["&]+ -> type(QuoteContentChar);
QCC_EndQuot: '"' -> type(QuotEnd),popMode;

mode APOS_COMMON_CONTENT;
ACC_EscapeApos : '\'\''-> type(EscapeApos) ;
ACC_CharRef: CharRef -> type(CharRef);
ACC_PredefinedEntityRef: PredefinedEntityRef -> type(PredefinedEntityRef);
Quot: '"' ;
QCC_AposeContentChar: ~['&]+ -> type(AposContentChar);
QCC_EndApos: '\''  -> type(AposEnd),popMode;


/*
NamespaceDecl
Import
DefaultNamespaceDecl
Setter
*/
mode PROLOG;
PROLOG_WS: WS -> type(WS),channel(HIDDEN);

PROLOG_Namespace: 'namespace' -> type(Namespace),mode(NAMESPACE_KEYWORD); // NamespaceDecl
// Import 
Schema:        'schema'   -> mode(NAMESPACE_KEYWORD);               //SchemaImport:
PROLOG_Module: 'module'   -> type(Module),mode(NAMESPACE_KEYWORD); //ModuleImport:
// DefaultNamespaceDecl  and Setters: DefaultCollationDecl, EmptyOrderDecl

PROLOG_Default: 'default' -> type(Default),mode(EXPECT_NAMESPACE_KEYWORD); 

// Setter
BoundarySpace: 'boundary-space'; //BoundarySpaceDecl
BaseURI: 'base-uri' ;           // BaseURIDecl

Construction: 'construction'; // ConstructionDecl

Ordering: 'ordering';   // OrderingModeDecl
PROLOG_Ordered:   'ordered'   -> type(Ordered);   // OrderingModeDecl
PROLOG_Unordered: 'unordered' -> type(Unordered); // OrderingModeDecl
PROLOG_Empty:     'empty'     -> type(Empty),pushMode(EMPTY_LIST);     // EmptyOrderDecl

CopyNamespaces: 'copy-namespaces';   // CopyNamespacesDecl
NoPreserve:    'no-preserve';      // CopyNamespacesDecl  
Inherit:       'inherit';          // CopyNamespacesDecl
NoInherit:     'no-inherit';       // CopyNamespacesDecl

DecimalFormat: 'decimal-format';     // DecimalFormatDecl
DFPropertyName:
      'decimal-separator'
	| 'grouping-separator'
	| 'infinity'
	| 'minus-sign'
	| 'NaN'
	| 'percent'
	| 'per-mille'
	| 'zero-digit'
	| 'digit'
	| 'pattern-separator'
	| 'exponent-separator'; // DecimalFormatDecl

PROLOG_Comma: ',' ->    type(Comma); // CopyNamespacesDecl
Preserve: 'preserve'; // BoundarySpaceDecl ConstructionDecl CopyNamespacesDecl
Strip:    'strip';       // BoundarySpaceDecl ConstructionDecl
PROLOG_Equals: '=' -> type(SymEquals);

Option: 'option'   -> pushMode(VAR_REF) ; // optionDecl

// TODO //ContextItemDecl:
Context: 'context' ;   //ContextItemDecl:
External: 'external';  // TODO VarDecl

PROLOG_QuotAttr:  '"'   -> type(QuotStart),pushMode(QUOT_COMMON_CONTENT); // DefaultCollationDecl BaseURIDecl
PROLOG_AposAttr:  '\''  -> type(AposStart),pushMode(APOS_COMMON_CONTENT); // DefaultCollationDecl BaseURIDecl

// AnnotatedDecl:   NOTE annotation can occur elsewere ( FunctionTest |  InlineFunctionExpr )
// So we push then pop back to PROLOG mode
PROLOG_Annotate: '%' -> type( Anno ), pushMode(ANNOTATION) ; 
// AnnotatedDecl  ( VarDecl | FunctionDecl ) 
// VarDecl NOTE file:///home/gmack/projects/grantmacken/grammar-xQuery/notes/xquery-31/index.html#VarDecl

PROLOG_Function:   'function'  -> type(Function), pushMode(VAR_REF) ;  // ,mode(FUNCTION_DECLARATION); // FunctionDecl 
Variable:          'variable'  -> pushMode(VAR_REF) ; // -> pushMode(VAR_REF);

PROLOG_ParenOpen:  '('  -> type(ParenOpen), pushMode(PARAM_LIST) ;  // FunctionDecl/ParamList:

/* TypeDeclaration  " 'as' -> SequenceType  -> OccurrenceIndicator?" */
/* mode PARAM_LIST should pop back here, then may consume last as */
PROLOG_As:         'as'        -> type(As),pushMode(SEQUENCE_TYPE);  // VarValue  VarDefaultValue:
/* mode SEQUENCE_TYPE should pop back here, then may consume any OccurrenceIndicator */
PROLOG_OnceOrZero: '?'  -> type(OccurrenceIndicator) ;  
PROLOG_ZeroOrMore: '*'  -> type(OccurrenceIndicator) ;
PROLOG_OneOrMore:  '+'  -> type(OccurrenceIndicator) ;

/* variable -> mode VAR_REF should pop back here, 
 then should consume bind symbol, then pop back into default and seach for any expression  */
PROLOG_Bind:      ':='  -> type(SymBind), popMode; // VarValue  VarDefaultValue:
PROLOG_CurlyOpen: '{'   -> type(CurlyOpen), pushMode(DEFAULT_MODE) ;  // always push curly open enclosedExpr
PROLOG_Sep:       ';'   -> type(Separator), popMode;                 // all mode PROLOG declarations pop back to default 

mode VAR_REF;  //FunctionDecl InlineFunctionExpr
REF_WS: WS -> type(WS),channel(HIDDEN);
REF_Prefix: '$' -> type(VarPrefix);
REF_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),mode( URI_QUALIFIED_NAME ) ; // also pops
REF_Name: QName -> type(QName),popMode;

mode VAR_NAME;  //
VAR_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),mode( URI_QUALIFIED_NAME ) ; // also pops
VAR_Name: QName -> type(QName),popMode;

mode PARAM_LIST;  // functionDecl InlineFunctionExpr
PARAM_WS:     WS  -> type(WS),channel(HIDDEN);
// PL_POpen: '('  -> type(ParenOpen);
PARAM_As: 'as' -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
PARAM_VarPrefix: '$' -> type(VarPrefix), pushMode(VAR_NAME);
//Item:      'item' -> mode( SIMPLE_TYPE ) ;
PARAM_Comma:  ','  -> type(Comma);
PARAM_OnceOrZero: '?'  -> type(OccurrenceIndicator) ;  
PARAM_ZeroOrMore: '*'  -> type(OccurrenceIndicator) ;
PARAM_OneOrMore:  '+'  -> type(OccurrenceIndicator) ;
PL_PClose:  ')' -> type(ParenClose), popMode;

mode FOR_CLAUSE; // ForBinding, LetBinding, QuantifiedExpr may contain TypeDeclaration  
FOR_WS:     WS  -> type(WS),channel(HIDDEN);
FOR_VarPrefix:  '$'     -> type(VarPrefix), pushMode(VAR_NAME);
// start TypeDeclaration pattern
FOR_As:         'as'    -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
FOR_OnceOrZero: '?'     -> type(OccurrenceIndicator) ;  
FOR_ZeroOrMore: '*'     -> type(OccurrenceIndicator) ;
FOR_OneOrMore:  '+'     -> type(OccurrenceIndicator) ;
// end TypeDeclaration pattern
Allowing:       'allowing' ;   // forBinding/allowingEmpty ; 
FOR_Empty:      'empty' -> type(Empty);
FOR_At:         'at'    -> type(At), pushMode(VAR_REF); // PositionalVar
FOR_In:         'in'    -> type(In), mode(DEFAULT_MODE); // seek ExprSingle 

mode LET_CLAUSE; 
LET_WS: WS  -> type(WS),channel(HIDDEN);
LET_VarPrefix:  '$'     -> type(VarPrefix), pushMode(VAR_NAME);
// start TypeDeclaration pattern
LET_As:         'as'    -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
LET_OnceOrZero: '?'     -> type(OccurrenceIndicator) ;  
LET_ZeroOrMore: '*'     -> type(OccurrenceIndicator) ;
LET_OneOrMore:  '+'     -> type(OccurrenceIndicator) ;
// end TypeDeclaration pattern
LET_Bind:       ':='    -> type(SymBind), mode(DEFAULT_MODE) ;  // seek ExprSingle 

mode QUANTIFIED_EXPR;
QE_WS: WS  -> type(WS),channel(HIDDEN);
QE_VarPrefix:  '$'     -> type(VarPrefix), pushMode(VAR_NAME);
// start TypeDeclaration pattern
QE_As:         'as'    -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
QE_OnceOrZero: '?'     -> type(OccurrenceIndicator) ;  
QE_ZeroOrMore: '*'     -> type(OccurrenceIndicator) ;
QE_OneOrMore:  '+'     -> type(OccurrenceIndicator) ;
// end TypeDeclaration pattern
QE_In:         'in'    -> type(In), mode(DEFAULT_MODE); // seek ExprSingle 

mode GROUP_BY_CLAUSE; //  
GROUP_WS: WS  -> type(WS),channel(HIDDEN);
GROUP_By:        'by'   -> type(By) ; // GroupByClause OrderByClause
GROUP_VarPrefix: '$'    -> type(VarPrefix), pushMode(VAR_NAME); // GroupingVariable:
GROUP_Comma: ','    -> type(Comma) ; 
// start TypeDeclaration pattern
GROUP_As:         'as'    -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
GROUP_OnceOrZero: '?'     -> type(OccurrenceIndicator) ;  
GROUP_ZeroOrMore: '*'     -> type(OccurrenceIndicator) ;
GROUP_OneOrMore:  '+'     -> type(OccurrenceIndicator) ;
// end TypeDeclaration pattern
GROUP_Bind:       ':='    -> type(SymBind), mode(DEFAULT_MODE) ;  //   -> ExprSingle 
// we have to pop after bind because we a looking for  ExprSingle
GROUP_Collation: 'collation' -> type(Collation), pushMode( COLLATION ) ;    // GroupingSpec OrderModifier
// patterns for ending clause
// FLWORExpr InitialClause IntermediateClause* ReturnClause
GROUP_Let:    'let'   ->   type(Let),    mode(LET_CLAUSE);       // InitialClause/LetClause
GROUP_For:    'for'   ->   type(For),    mode(FOR_CLAUSE);       // InitialClause/ForClause
GROUP_Where:  'where'  ->  type(Where),  mode(DEFAULT_MODE);     // IntermediateClause/WhereClause
GROUP_Stable: 'stable' ->  type(Stable), mode(ORDER_BY_CLAUSE);  // IntermediateClause/OrderByClause
GROUP_Order:  'order'  ->  type(Order),  mode(ORDER_BY_CLAUSE);  // IntermediateClause/OrderByClause
GROUP_Count:  'count'  ->  type(Count),  mode(DEFAULT_MODE);     // IntermediateClause/CountClause
GROUP_Return: 'return' ->  type(Return), mode(DEFAULT_MODE);     // ReturnClause: 
// IntermediateClause always has return so this acts as closure

mode ORDER_BY_CLAUSE;
ORDER_WS: WS  -> type(WS),channel(HIDDEN);
ORDER_Oder:  'order'   -> type(By), mode(DEFAULT_MODE); 
ORDER_By:    'by'      -> type(By),    mode(DEFAULT_MODE);  //  ExprSingle
// we have to pop after by because we a looking for  ExprSingle
// then if 'ascending' | 'descending' collect
ORDER_Empty:     'empty' -> type(Empty), pushMode(EMPTY_LIST); 
ORDER_Collation: 'collation' -> type(Collation), pushMode( COLLATION ) ;    // GroupingSpec OrderModifier
ORDER_Comma:      ','    -> type(Comma),mode(DEFAULT_MODE);
// patterns for ending clause
// FLWORExpr InitialClause IntermediateClause* ReturnClause
ORDER_Let:     'let'   ->   type(Let), mode(LET_CLAUSE);  // InitialClause/LetClause:
ORDER_For:     'for'   ->   type(For), mode(FOR_CLAUSE);  // InitialClause/ForClause:
// IntermediateClause: | WhereClause| GroupByClause| OrderByClause | CountClause
ORDER_Where:     'where'   ->   type(Where), mode(DEFAULT_MODE);  // WhereClause:
ORDER_Group:     'group'    ->  type(Group), mode(GROUP_BY_CLAUSE);  // GroupByClause:
ORDER_Count:     'count'   ->   type(Count), mode(DEFAULT_MODE);  // CountClause::
ORDER_Return:    'return'  ->   type(Return),mode(DEFAULT_MODE);     // ReturnClause:

mode EMPTY_LIST;
EMPTY_WS: WS         -> type(WS),channel(HIDDEN);
Greatest: 'greatest' -> popMode; 
Least:    'least'    -> popMode; 

mode CATCH_CLAUSE; // nameTest
CATCH_WS: WS  -> type(WS),channel(HIDDEN);
CATCH_VBar:  '|'     -> type(VBar) ;
CATCH_QName:         QName -> type(QName) ; 
CATCH_BracedURIOpen: 'Q{'  -> type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ; // come back here
CATCH_NCNameWithLocalWildcard:  NCNameWithLocalWildcard  -> type(NCNameWithLocalWildcard);
CATCH_NCNameWithPrefixWildcard: NCNameWithPrefixWildcard -> type(NCNameWithPrefixWildcard);
CATCH_Wildcard:  '*' -> type( Wildcard ) ;
CATCH_CurlyOpen:  '{'  -> type(CurlyOpen), mode(DEFAULT_MODE) ;  
// in default '}' will pop off this CATCH_CLAUSE stack

mode COLLATION;
COLLATION_WS: WS  -> type(WS),channel(HIDDEN);
COLLATION_QuotAttr:  '"'   -> type(QuotStart),mode(QUOT_COMMON_CONTENT); // pop back into origin
COLLATION_AposAttr:  '\''  -> type(AposStart),mode(APOS_COMMON_CONTENT); // pop back into origin


mode IF_EXPR;
IF_WS: WS  -> type(WS),channel(HIDDEN);
IF_Popen:  '('   -> type(ParenOpen), pushMode( DEFAULT_MODE ); // pop back here
Then:      'then' -> popMode ;


mode SWITCH_EXPR;
SWITCH_WS: WS  -> type(WS),channel(HIDDEN);
SWITCH_POpen: '('      -> type(ParenOpen), pushMode( DEFAULT_MODE ); // come back here
SWITCH_case:  'case'   -> type(Case), mode( CASE_CLAUSE );

mode TYPESWITCH_EXPR;
TYPESWITCH_WS: WS  -> type(WS),channel(HIDDEN);
TYPESWITCH_POpen: '('      -> type(ParenOpen), pushMode( DEFAULT_MODE ); // come back here
TYPESWITCH_case:  'case'   -> type(Case), mode( CASE_CLAUSE );

mode CASE_CLAUSE; // TODO also cover SwitchCaseClause SwitchCaseOperand ::=  ExprSingle 
CASE_WS:      WS       -> type(WS), channel(HIDDEN);
TYPESWITCH_VarPrefix: '$'    -> type(VarPrefix), pushMode(VAR_NAME); // GroupingVariable:
TYPESWITCH_As:         'as'    -> type(As), pushMode(SEQUENCE_TYPE); // should pop back here
TYPESWITCH_Vbar:       '|'    -> type(VBar), pushMode(SEQUENCE_TYPE); // should pop back here
TYPESWITCH_OnceOrZero: '?'     -> type(OccurrenceIndicator) ;  
TYPESWITCH_ZeroOrMore: '*'     -> type(OccurrenceIndicator) ;
TYPESWITCH_OneOrMore:  '+'     -> type(OccurrenceIndicator) ;
CASE_Return: 'return' -> type(Return), mode( DEFAULT_MODE);  // look for expression





// TYPESWITCH_VarPre:  '$'   -> type(VarPrefix), pushMode( VAR_NAME );     // come back here


mode ENCLOSED_EXPR;
ENCLOSED_WS: WS  -> type(WS),channel(HIDDEN);
ENCLOSED_CurlyOpen:  '{'   -> type(CurlyOpen), mode( DEFAULT_MODE ); // pop back into origin
// in default '}' will pop off this ENCLOSED_EXPR stack

mode PARENTHESIZED_EXPR;
PAREN_WS: WS  -> type(WS),channel(HIDDEN);
PAREN_Open:  '('   -> type(ParenOpen), mode( DEFAULT_MODE ); // pop back into originM
// in default ')' will pop off this PARENTHESIZED_EXPR stack




mode INLINE_FUNCTION;  // PrimaryExpr/FunctionItemExpr ( InlineFunctionExpr )
IFUNC_WS:     WS  -> type(WS),channel(HIDDEN);
IFUNC_ParenOpen:  '('  -> type(ParenOpen), pushMode(PARAM_LIST) ;
IFUNC_As:         'as'        -> type(As),pushMode(SEQUENCE_TYPE);  // VarValue  VarDefaultValue:
/* mode SEQUENCE_TYPE should pop back here, then may consume any OccurrenceIndicator */
IFUNC_OnceOrZero: '?'  -> type(OccurrenceIndicator) ;  
IFUNC_ZeroOrMore: '*'  -> type(OccurrenceIndicator) ;
IFUNC_OneOrMore:  '+'  -> type(OccurrenceIndicator) ;
IFUNC_CurlyOpen:  '{'  -> type(CurlyOpen), mode(DEFAULT_MODE) ;  
// in default '}' will pop off this INLINE_FUNCTION stack

mode INSTANCE; // InstanceofExp TreatExpr
INSTANCE: WS -> type(WS),channel(HIDDEN);
Of:                 'of' -> pushMode(SEQUENCE_TYPE); //  should pop back here;
INSTANCE_AS:        'as' -> type(As),pushMode(SEQUENCE_TYPE);
INSTANCE_OnceOrZero: '?'  -> type(OccurrenceIndicator) ;  
INSTANCE_ZeroOrMore: '*'  -> type(OccurrenceIndicator) ;
INSTANCE_OneOrMore:  '+'  -> type(OccurrenceIndicator) ;
INSTANCE_Comma:      ','  -> type(Comma),     mode(DEFAULT_MODE) ; // end of expresion via seperator
INSTANCE_PClose:     ')'  -> type(ParenClose),mode(DEFAULT_MODE) ; // end of enclosed expression
// TODO depends on separators ')' ','

mode AS_TYPE_NAME; // (CastableExpr | CastExpr ) /singleType/TypeName
CASTING_WS: WS -> type(WS),channel(HIDDEN);
CASTING_AS:            'as'  -> type(As) ;
CASTING_QName:        QName  -> type(QName), popMode  ;  
CASTING_BracedURIOpen: 'Q{'  -> type(BracedURIOpen),mode( URI_QUALIFIED_NAME ) ; // will pop back to origin
// CASTING_QMark:  '?'  should be picked up in default

mode VALIDATE_EXPR;  // pushed onto VALIDATE_EXPR stack
VALIDATE_WS: WS -> type(WS),channel(HIDDEN);
Lax:     'lax' ;
Strict:  'strict' ;
Type:    'type' ;  
VALIDATE_QName:         QName -> type(QName) ; 
VALIDATE_BracedURIOpen: 'Q{'  -> type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ; // come back here
VALIDATE_CurlyOpen:     '{'   -> type(CurlyOpen), mode( DEFAULT_MODE ) ; 

 // in default '}' will pop off this VALIDATE_EXPR stack

/* TODO
 OccurrenceIndicator
 How to close 
 OK  Clear Closure Symbol  e.g. ';'  for function delarations
 Not OK Closure depends on end of expression seperators ',' ')' '}'
referenced by: 
    FunctionDecl        OK  {'  FunctionBody '}' -> ';' into default
    InlineFunctionExpr  OK  '{' FunctionBody            into default
    InstanceofExpr      Not OK ',' ')' '}'
    SequenceTypeUnion   Not OK ',' ')' '}'
    TreatExpr           Not OK ',' ')' '}
    TypeDeclaration     Not OK 
		ForBinding      OK  'in' with no comma repeat in parser
		GroupingSpec
		LetBinding      OK  ':=' with no comma repeat in parser
		Param           OK?  contained in  FunctionDecl   InlineFunctionExpr  
		QuantifiedExpr  OK  'in' with no comma repeat in parser
		SlidingWindowClause  Removed from parser
		TumblingWindowClause Removed from parser
		VarDecl         OK ':='      
    TypedArrayTest      OK ')' 
    TypedFunctionTest   OK if contained in FunctionDecl otherwise Not OK  
    TypedMapTest        OK ')'
*/
mode SEQUENCE_TYPE;  // as SequenceType:
ST_WS: WS -> type(WS),channel(HIDDEN);
// ST_Vbar:  '|' -> type(VBar) ;
EmptySequenceTest: 'empty-sequence' '(' ')'  -> popMode ;
/* Everything else below is an ItemType  */
Item:  'item' '(' ')'            ->             popMode ;  // itemType:
AnyKindTest:   'node'  '(' ')'   ->             popMode  ;  // anyKindTest
DocumentNode:  'document-node'   ->             popMode  ;    // TODO  kindTest/documentTest
TextTest:      'text' '(' ')'    ->             popMode  ; //  CompTextConstructor: TextTest:
CommentTest:   'comment' '(' ')' ->             popMode   ; // CompCommentConstructor CommentTest:
NamespaceNodeTest: 'namespace-node'  '(' ')' -> popMode ;   // NamespaceNodeTest
PITest:    'processing-instruction' -> type(ProcessingInstruction ) ; // TODO  PITest CompPIConstructor: 
ST_Attribute:    'attribute'        -> type(Attribute), mode(ELEMENT_ATTR_TEST) ;   // AttributeTest: CompAttrConstructor:  ForwardAxis: 
SchemaAttribute: 'schema-attribute' ->                  mode( SIMPLE_TYPE ) ; // SchemaAttributeTest
ElementTest:     'element'          ->   type(Element), mode(ELEMENT_ATTR_TEST) ;  // KindTest  DocumentTest CompElemConstructo SchemaPrefix DefaultNamespaceDecl:
SchemaElement:   'schema-element'   ->                  mode( SIMPLE_TYPE ) ;   // DocumentTest KindTest
AnyFunctionTest: 'function' '(' '*' ')'  ->             popMode ;       // -> type(Function), pushMode(TYPED_FUNCTION_TEST) ; 
AnyMapTest:      'map' '(' '*' ')'       ->             popMode ;
AnyArrayTest:    'array' '(' '*' ')'     ->             popMode ;
ST_TypedFunctionTest: 'function' ->     type(Function), mode(TYPED_FUNCTION_TEST) ;//  FunctionTest/TypedFunctionTest InlineFunctionExpr
ST_TypedMapTest:    'map'     ->             type(Map), mode(TYPED_MAP_TEST); // mapTest/TypedMapTest
ST_Array:  'array'   ->                    type(Array), mode(TYPED_ARRAY_TEST) ;      // arrayTest/TypedArrayTest
// TODO ParenthesizedItemType
ST_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),mode( URI_QUALIFIED_NAME ) ; // like QName will pop out
ST_QName:  QName   -> type(QName), popMode ;                                // ItemType/AtomicOrUnionType

mode ELEMENT_ATTR_TEST;
EAT_WS: WS -> type(WS),channel(HIDDEN);
EAT_ParenOpen:  '('  -> type(ParenOpen);
EAT_Wildcard:   '*'  -> type(Wildcard);
EAT_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ; // come back here
EAT_QName:    QName  -> type(QName); 
EAT_Comma:       ',' -> type(Comma) ;
ElementTypeName: '?' -> type(Ques) ;  /// https://www.w3.org/TR/xquery-31/#doc-xquery31-ElementTest
EAT_ParenClose:  ')' -> type(ParenClose), popMode;

mode SIMPLE_TYPE;  // as SequenceType:
SIMPLE_ParenOpen:  '('  -> type(ParenOpen);
//SIMPLE_Wildcard:   '*'  -> type(Wildcard);
SIMPLE_QName:   QName   -> type(QName); // TypedMapTest SchemaAttributeTest:
SIMPLE_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ; // come back here
SIMPLE_ParenClose:  ')' -> type(ParenClose), popMode ;
// will pop backe to  PARAM_LIST 

///as 'function' '(' ( SequenceType ( ',' SequenceType )* )? ')' 'as' SequenceType
mode TYPED_FUNCTION_TEST;  // as SequenceType:
TFT_WS: WS -> type(WS),channel(HIDDEN);
TFT_ParenOpen:  '('  -> type(ParenOpen), pushMode(SEQUENCE_TYPE); // come back here
TFT_ParenClose:  ')' -> type(ParenClose) ;
TFT_Comma: ',' -> type(Comma) ;
TFT_As: 'as' -> type(As), mode(SEQUENCE_TYPE);
/* the last as move to mode SEQUENCE_TYPE which 
   closes bracket and pops back to origin FunctionDecl
   e.g. 
    FunctionDecl
    InlineFunctionExpr
    InstanceofExpr
    SequenceTypeUnion
    TreatExpr
    TypeDeclaration
    TypedArrayTest
    TypedFunctionTest
    TypedMapTest
*/

// "map" "(" AtomicOrUnionType "," SequenceType ")" 	
mode TYPED_MAP_TEST;
TMT_ParenOpen:  '('  -> type(ParenOpen) ;
TMT_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ;
TMT_QName:   QName   -> type(QName);  // AtomicOrUnionType
TMT_Comma:  ','  -> type(Comma), pushMode(SEQUENCE_TYPE); // come back here
TMT_ParenClose:  ')' -> type(ParenClose),popMode;

mode TYPED_ARRAY_TEST;
TAT_ParenOpen:  '('  -> type(ParenOpen), pushMode(SEQUENCE_TYPE); // come back here
TAT_ParenClose:  ')' -> type(ParenClose),popMode;


// DefaultNamespaceDecl DefaultCollationDecl: EmptyOrderDecl
// If 'declare default'    
// Then check if has namespace keyword
// Otherwise check for EmptyOrderDecl or DefaultCollationDecl
mode EXPECT_NAMESPACE_KEYWORD;
ENK_WS: WS -> channel(HIDDEN);
ENK_Element:   'element'   -> type(Element),mode(NAMESPACE_KEYWORD);  //DefaultNamespaceDecl
ENK_Function:  'function'  -> type(Function),mode(NAMESPACE_KEYWORD); //DefaultNamespaceDecl
ENK_Collation: 'collation' -> type(Collation),mode(PROLOG);           // DefaultCollationDecl
ENK_Order:     'order'     -> type(Order),mode(PROLOG);               // EmptyOrderDecl

//This state occurs at places where the keyword "namespace" is expected, 
// which would otherwise be ambiguous compared to a QName.
//  QNames can NOT occur in this state
//  DefaultNamespaceDecl SchemaPrefix:
mode NAMESPACE_KEYWORD;
NK_WS: WS -> channel(HIDDEN);
NK_Default:   'default'   -> type(Default);   // SchemaPrefix:
NK_Element:   'element'   -> type(Element);   // SchemaPrefix:
NK_Comma:     ','         -> type(Comma);
NK_NameSpace: 'namespace' -> type(Namespace); // SchemaPrefix:
NK_Equals:    '='         -> type(SymEquals); // SchemaPrefix:
NK_At:        'at'        -> type(At); // SchemaImport:
NK_Quot:       '"'         -> type(QuotStart),pushMode(QUOT_COMMON_CONTENT);
NK_Apos:       '\''        -> type(AposStart),pushMode(APOS_COMMON_CONTENT);
NK_NCName:    NCName      -> type(NCName);    // ( lowest priority  )  SchemaPrefix:
Nk_Separator: ';'         -> type(Separator), popMode; 

// This state occurs inside of a namespace declaration, 
// and is needed to recognize a NCName that is to be used as the prefix, 
// as opposed to allowing a QName to occur. 
// (Otherwise, the difference between NCName and QName are ambiguous.)

mode NAMESPACE_DECLARATION; //TODO
ND_WS: WS -> channel(HIDDEN);
ND_AtLocation: 'at' -> type(At);
ND_QuotAttr:  '"' -> type(QuotStart),pushMode(QUOT_COMMON_CONTENT);
ND_AposAttr:  '\'' -> type(AposStart),pushMode(APOS_COMMON_CONTENT);
ND_Equals: '=' -> type(SymEquals);
ND_Comma: ',' -> type(Comma);
ND_NCName: NCName -> type(NCName);
ND_Separator: ';' -> type(Separator), popMode; // back to default

mode ITEM_TYPE;
IT_Return: 'return'        -> type(Return), mode(DEFAULT_MODE); 

mode ANNOTATION;
ANNO_WS: WS -> channel(HIDDEN);
// ANNO_QName: QName -> type(QName);
ANNO_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ;
ANNO_QName: QName -> type(QName);
ANNO_POpen:  '('  -> type(ParenOpen);
ANNO_PClose: ')' -> type(ParenClose),popMode;
LIT_Comma:   ','  -> type(Comma);
LIT_Quot:    '"'  -> type(QuotStart),pushMode(QUOT_COMMON_CONTENT);
LIT_Apos:    '\'' -> type(AposStart),pushMode(APOS_COMMON_CONTENT);
LIT_IntegerLiteral: IntegerLiteral -> type(IntegerLiteral) ; 
LIT_DecimalLiteral: DecimalLiteral -> type(DecimalLiteral) ;
LIT_DoubleLiteral:  DoubleLiteral  -> type(DecimalLiteral); 

/* XML constructors */

mode START_TAG;   // inside a tag
TAG_WS:  WS  -> type(WS),channel(HIDDEN);
TagEmptyClose: '/>' ->  popMode;   
TagStartClose:  '>'  -> mode(ELEMENT_CONTENT);
TAG_QName:   QName  -> type(QName);
TAG_Equals:  '='  -> type(SymEquals);
AposAttr:   '\''      -> type(AposStart),pushMode(APOS_ATTRIBUTE_CONTENT);
QuotAttr:   '"'       -> type(QuotStart),pushMode(QUOT_ATTRIBUTE_CONTENT);

// element content
mode ELEMENT_CONTENT; 
EC_SPACE:  WS ->   type(WS),channel(HIDDEN);
EC_TagEndOpen:    '</'    -> type(TagEndOpen),mode(END_TAG);
EC_OpenStartTag:  '<' QName -> type(TagStartOpen),pushMode(START_TAG);
EC_CurlyOpen: '{' -> type(CurlyOpen),pushMode(DEFAULT_MODE); // pop back here
ElementContentChar :    ~[<&{}]+ ; // ElementContentChar

// element content
// When the end tag is terminated, the state is popped to the state 
// that was pushed at the start of the corresponding start tag.
mode END_TAG;
ET_SPACE:  WS  ->   type(WS),channel(HIDDEN);
ET_QName:   QName   -> type(QName);
ET_TagEndClose: '>' -> type(TagEndClose),popMode;

mode APOS_ATTRIBUTE_CONTENT;
AAC_EscapeApos : '\'\''-> type(EscapeApos) ;
AAC_DoubleCurlyOpen: '{{' -> type(DoubleCurlyOpen);
AAC_DoubleCurlyClose: '}}' -> type(DoubleCurlyClose);
AAC_PredefinedEntityRef: PredefinedEntityRef -> type(PredefinedEntityRef);
AAC_CharRef: CharRef -> type(CharRef);
AposAttrContentChar:   ~['&{}]+; //
AAC_CurlyOpen: '{' -> type(CurlyOpen),pushMode(DEFAULT_MODE); // push, we want to pop back
AAC_EndApos:  '\'' -> type(AposEnd),popMode;

mode QUOT_ATTRIBUTE_CONTENT;
QAC_EscapeQuot: '""' -> type(EscapeQuot);
QAC_DoubleCurlyOpen: '{{' -> type(DoubleCurlyOpen);
QAC_DoubleCurlyClose: '}}' -> type(DoubleCurlyOpen);
QAC_CharRef: CharRef -> type(CharRef);
QAC_PredefinedEntityRef: PredefinedEntityRef -> type(PredefinedEntityRef);
QuoteAttrContentChar:  ~["&{}]+ ; // last
QAC_CurlyOpen: '{' -> type(CurlyOpen),pushMode(DEFAULT_MODE); // push, we want to pop back
QAC_EndQuot: '"' -> type(QuotEnd),popMode;


// whitespace explicit PUSH POP CONSTRUCTORS
mode STRING_CONSTRUCTOR;  // TODO 
StringConstructorInterpolationOpen: '`{' ->  pushMode(DEFAULT_MODE);
SC_StringConstructorClose:          ']``'   -> type(StringConstructorClose),popMode ;
StringConstructorChars: ~[\]{`]+ ;  // TODO  only acknowledge doublebacktick


mode LOOKUP_KEYSPECIFIER; 
LOOKUP_IntegerLiteral: IntegerLiteral -> type(IntegerLiteral),popMode ;
LOOKUP_Popen:          '('            -> type(ParenOpen), popMode ;
LOOKUP_Wildcard:       '*'            -> type(Wildcard), popMode ;
LOOKUP_NCName:         NCName         -> type(NCName),popMode ;


mode ARROW_FUNCTION_SPECIFIER;
ARROW_Popen:          '('            -> type(ParenOpen), popMode ;
ARROW_VarName: VarPrefix QName -> type( VarName ) ;
ARROW_BracedURIOpen: 'Q{' ->  type(BracedURIOpen),pushMode( URI_QUALIFIED_NAME ) ;
ARROW_QName: QName -> type(QName);



