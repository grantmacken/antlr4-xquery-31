parser grammar XQueryParser;

options { tokenVocab=XQueryLexer;}

module: versionDecl? ( libraryModule | mainModule ) ;
versionDecl: XQuery ( Encoding | Version  ( stringLiteral Encoding )? ) stringLiteral  Separator ;
mainModule: prolog queryBody ;
libraryModule: moduleDecl prolog ;
moduleDecl : Module Namespace NCName SymEquals uriLiteral Separator;
prolog : 
    (( defaultNamespaceDecl
     | setter
     | namespaceDecl  
     | myImport 
     )* Separator
    )*
    ( ( 
        annotatedDecl 
        | optionDecl
        ) Separator)*
    ;

//TODO  contextItemDec   

defaultNamespaceDecl: 
    Declare Default ( Element | Function ) Namespace uriLiteral
    ;

setter : 
      boundarySpaceDecl
    | defaultCollationDecl
    | baseURIDecl
    | constructionDecl
    | orderingModeDecl
    | emptyOrderDecl
    | copyNamespacesDecl;
//    | decimalFormatDecl; TODO

boundarySpaceDecl: Declare BoundarySpace ( Preserve | Strip ) ;
defaultCollationDecl: Declare Default Collation uriLiteral ;
baseURIDecl:  Declare BaseURI uriLiteral ;
constructionDecl: Declare Construction ( Strip | Preserve ) ;
orderingModeDecl: Declare Ordering ( Ordered | Unordered ) ;
emptyOrderDecl:  Declare Default Order Empty ( Greatest | Least ) ;
copyNamespacesDecl: Declare CopyNamespaces preserveMode Comma inheritMode ;
preserveMode: ( Preserve | NoPreserve ) ;
inheritMode:  ( Inherit | NoInherit ) ;

// TODO
// decimalFormatDecl :
//         Declare (('decimal-format' eQName) | (Default 'decimal-format'))
//         (DfPropertyName SymEquals StringLiteral)* 
//         ;

namespaceDecl: Declare Namespace NCName SymEquals uriLiteral;   


// use myImport instead of antlr keyword import
myImport:
    schemaImport
    | moduleImport
    ;

schemaImport :
    Import Schema schemaPrefix? uriLiteral
    ( At uriLiteral (Comma uriLiteral)*)? 
    ;

schemaPrefix : 
    ( Namespace NCName SymEquals) 
    | (Default Element Namespace ) 
    ;

moduleImport :
    Import Module ( Namespace NCName SymEquals )? uriLiteral
    ( At uriLiteral (Comma uriLiteral)*)?
    ;

optionDecl:  Declare Option eQName stringLiteral;
// defaultNamespaceDecl:
//     Declare Default ('element' | Function) :w StringLiteral
//     ;


annotatedDecl: Declare annotation* ( varDecl | functionDecl ) ;
annotation : Anno eQName? ( ParenOpen literal (Comma literal)* ParenClose)? ;
varDecl: Variable VarPrefix varName typeDeclaration? ( SymBind exprSingle | External ( SymBind exprSingle )? );  // TODO
functionDecl: Function eQName ParenOpen paramList? ParenClose ( As sequenceType )? (functionBody | External ) ;
paramList: param (Comma param )*;
param: VarPrefix eQName typeDeclaration?;
functionBody: enclosedExpr;
enclosedExpr: CurlyOpen expr? CurlyClose;

queryBody : expr ;


/* 
EXPRESSIONS
-----------
*/ 

expr: exprSingle (Comma exprSingle)* ;
exprSingle: flworExpr | quantifiedExpr | switchExpr | typeswitchExpr | ifExpr | tryCatchExpr | orExpr ;
flworExpr : initialClause  (intermediateClause*) returnClause ;
// removed unsuppported existDB windowClause
initialClause : forClause | letClause ;
intermediateClause : initialClause | whereClause| groupByClause| orderByClause | countClause ;
// forClause: For forBinding ( Comma forBinding)* ;
// https://www.w3.org/TR/xquery-31/#doc-xquery31-LetClause
// Note: no comma repeat
// to let lexer have a 'in' closure for typeDeclaration
forClause: For forBinding ;
forBinding: VarPrefix varName typeDeclaration? allowingEmpty? positionalVar? In exprSingle ;
allowingEmpty: ( Allowing Empty) ;
positionalVar: ( At VarPrefix varName );
// letClause:  Let letBinding (Comma letBinding)* ;
// https://www.w3.org/TR/xquery-31/#doc-xquery31-LetClause
// Note: no comma repeat
// to let lexer have a ':=' closure for typeDeclaration
letClause:  Let letBinding ;
letBinding: VarPrefix varName typeDeclaration? SymBind exprSingle;
countClause: Count  VarPrefix varName ;
whereClause: Where exprSingle ;

// Grouping
groupByClause: Group By groupingSpecList ;
groupingSpecList: groupingSpec ( Comma groupingSpec)* ;
groupingSpec:
        groupingVariable (typeDeclaration? SymBind exprSingle)?
        ( Collation uriLiteral)? ;
groupingVariable: VarPrefix varName;

// ORDERING 
orderByClause : Stable? Order By orderSpecList ;
orderSpecList : orderSpec ( Comma orderSpec)* ;
orderSpec : exprSingle orderModifier ;

orderModifier :
    (Ascending | Descending)?
    (Empty (Greatest | Least))?
    (Collation uriLiteral)? ;

// return
returnClause: Return exprSingle;

/* 
quantifiedExpr :
        ( Some | Every ) VarPrefix varName typeDeclaration? In exprSingle
        ( Comma  VarPrefix varName typeDeclaration? In exprSingle)*
        Satisfies exprSingle ;
*/
// https://www.w3.org/TR/xquery-31/#doc-xquery31-QuantifiedExpr
// Note: no comma repeat
// to let lexer have a 'in' closure for typeDeclaration 
quantifiedExpr :
    ( Some | Every ) VarPrefix varName typeDeclaration? 
    In exprSingle
    Satisfies exprSingle ;


switchExpr : Switch ParenOpen expr ParenClose switchCaseClause+ Default Return exprSingle ; // exprSingle
switchCaseClause : ( Case switchCaseOperand)+  Return exprSingle ;
switchCaseOperand : exprSingle ;

typeswitchExpr :                                                                            
    Typeswitch ParenOpen expr ParenClose caseClause+ Default ( VarPrefix varName )?
    Return exprSingle ;                                                                     //  exprSingle
caseClause : Case (VarPrefix varName As )? sequenceTypeUnion Return exprSingle ;
sequenceTypeUnion : sequenceType ( VBar sequenceType)* ;

ifExpr : If ParenOpen expr ParenClose Then exprSingle Else exprSingle ;                     //  exprSingl

tryCatchExpr : tryClause catchClause+ ;
tryClause : Try enclosedTryTargetExpr ;
enclosedTryTargetExpr : enclosedExpr ;
catchClause : Catch catchErrorList enclosedExpr ;
catchErrorList : nameTest ( VBar  nameTest)* ;

orExpr: andExpr ( Or andExpr )* ;
andExpr: comparisonExpr ( And comparisonExpr )* ;
comparisonExpr:  stringConcatExpr  (( ValueComparison  | GeneralComparison  | NodeComparison ) stringConcatExpr )? ;
stringConcatExpr: rangeExpr ( StringConcat rangeExpr )* ;
rangeExpr :  additiveExpr  ( RangeTo additiveExpr )? ;
additiveExpr : multiplicativeExpr ( ( AdditivePlus | AdditiveMinus ) multiplicativeExpr )* ;
multiplicativeExpr : unionExpr ( ( MultiplicativeTimes | MultiplicativeDiv | MultiplicativeIdiv | MultiplicativeMod  ) unionExpr )* ;
unionExpr : intersectExceptExpr ( ( Union | VBar ) intersectExceptExpr )* ;
intersectExceptExpr : instanceofExpr ( ( Intersect | Except) instanceofExpr )* ;
instanceofExpr : treatExpr ( Instance Of  sequenceType )? ;
treatExpr : castableExpr ( Treat As sequenceType )? ;
castableExpr : castExpr ( Castable As singleType )? ;
castExpr : arrowExpr ( Cast As singleType )? ;
arrowExpr : unaryExpr ( Arrow arrowFunctionSpecifier argumentList )* ;
arrowFunctionSpecifier: eQName | varRef |  parenthesizedExpr;
unaryExpr : ( AdditivePlus | AdditiveMinus )* valueExpr ;
valueExpr :  validateExpr   |  simpleMapExpr /* | ExtensionExpr */; // TODO EXtension Expression
validateExpr : Validate ( validationMode | ( Type typeName))? enclosedExpr ;
validationMode : ( Lax | Strict );
// NOTE no ExtensionExpr: 
simpleMapExpr: pathExpr ( SymBang  pathExpr )* ;       // ValueExpr SimpleMapExpr

//  xpath related
pathExpr:   ( ForwardSlash | ForwardSlash relativePathExpr)
          | ( DoubleForwardSlash relativePathExpr) 
          |   relativePathExpr
          ;  // SimpleMapExpr
relativePathExpr:  stepExpr (( ForwardSlash | DoubleForwardSlash )  stepExpr)*  ; // stepExpr)* ; 
stepExpr :  ( postfixExpr | axisStep ) ; //  |  axisStep ;
axisStep :  ( reverseStep |   forwardStep)  predicateList ;
forwardStep :  ( forwardAxis nodeTest ) | abbrevForwardStep ; // StepExpr/ AxisStep
forwardAxis : 
    ( Child | Descendant | Attribute | Self | DescendantOrSelf | FollowingSibling | Following ) 
     DoubleColon ;

abbrevForwardStep : SymAt? nodeTest ;  // AxisStep/ ForwardStep
reverseStep : (reverseAxis nodeTest) /* | AbbrevReverseStep */ ; // StepExpr/ AxisStep
reverseAxis : ( Parent | Ancestor | PrecedingSibling | Preceding | AncestorOrSelf ) DoubleColon ;
nodeTest :  kindTest |  nameTest ; // AbbrevForwardStep ForwardStep ReverseStep
nameTest : eQName | wildcard ;    // CatchErrorList NodeTest
wildcard : 
      bracedURILiteral? Wildcard
    | NCNameWithLocalWildcard
    | NCNameWithPrefixWildcard
    ;

postfixExpr : primaryExpr (predicate | argumentList | lookup)* ;  // StepExpr

argumentList: ParenOpen ( argument ( Comma argument )* )?  ParenClose ; 
argument:     exprSingle | Ques ;

predicateList : predicate* ;
predicate : SquareOpen expr SquareClose ; // PostfixExpr
lookup : Ques keySpecifier ;   // PostfixExpr

keySpecifier : NCName | IntegerLiteral | parenthesizedExpr | Wildcard ; //Lookup UnaryLookup

// end xPath related

primaryExpr : 
      literal
     | varRef
     | parenthesizedExpr
     | contextItemExpr
     | functionCall
     | orderedExpr
     | unorderedExpr
     | nodeConstructor
     | functionItemExpr
     | mapConstructor
     | arrayConstructor
     | stringConstructor
     | unaryLookup ;


contextItemExpr: Dot; 
parenthesizedExpr: ParenOpen  expr?  ParenClose; 
orderedExpr:       Ordered enclosedExpr ;
unorderedExpr:     Unordered enclosedExpr ;
functionCall:      eQName argumentList;


/*
CONSTRUCTORS
*/ 
nodeConstructor: directConstructor | computedConstructor; 
directConstructor: dirElemConstructor; // TODO  | dirCommentConstructor | dirPIConstructor;

dirElemConstructor: 
   TagStartOpen dirAttributeList ( TagEmptyClose | ( TagStartClose dirElemContent* TagEndOpen  QName TagEndClose)); /* Note ignore  ws: explicit */ 
dirAttributeList: (QName  SymEquals  dirAttributeValue)* ; /* ignore ws: explicit */ 
dirAttributeValue: 
      ( QuotStart (EscapeQuot | quotAttrValueContent)* QuotEnd)
    | ( AposStart (EscapeApos | aposAttrValueContent)* AposEnd )  /* ws: explicit */ ;
quotAttrValueContent: QuoteAttrContentChar | commonContent ;
aposAttrValueContent: AposAttrContentChar | commonContent ;
dirElemContent : directConstructor|  commonContent | ElementContentChar ; // TODO cDataSection
commonContent:
    PredefinedEntityRef
    | CharRef
    | DoubleCurlyOpen
    | DoubleCurlyClose
    | enclosedExpr;

computedConstructor:
	  compDocConstructor
	| compElemConstructor
	| compAttrConstructor
	| compNamespaceConstructor
	| compTextConstructor
	| compCommentConstructor
	| compPIConstructor; 
 
compDocConstructor: Document enclosedExpr;  
compElemConstructor: Element ( eQName | CurlyOpen expr  CurlyClose ) enclosedContentExpr;
enclosedContentExpr: enclosedExpr;
compAttrConstructor: Attribute ( eQName | CurlyOpen expr CurlyClose ) enclosedExpr;
compNamespaceConstructor: Namespace ( prefix | enclosedPrefixExpr ) enclosedURIExpr;
prefix : NCName;
enclosedPrefixExpr : enclosedExpr ;
enclosedURIExpr : enclosedExpr ;
compTextConstructor : Text enclosedExpr ;
compCommentConstructor : Comment enclosedExpr;
compPIConstructor : ProcessingInstruction (NCName | ( CurlyOpen expr CurlyClose )) enclosedExpr ;
functionItemExpr : namedFunctionRef | inlineFunctionExpr ;
namedFunctionRef:  eQName Hash IntegerLiteral;
inlineFunctionExpr : annotation* Function ParenOpen paramList? ParenClose ( As sequenceType)? functionBody ;
// MAP And Array constructors
mapConstructor : Map CurlyOpen (mapConstructorEntry ( Comma mapConstructorEntry)*)? CurlyClose ;
mapConstructorEntry : mapKeyExpr Colon mapValueExpr ;
mapKeyExpr : exprSingle ;
mapValueExpr : exprSingle ;
arrayConstructor : squareArrayConstructor | curlyArrayConstructor ;
squareArrayConstructor : SquareOpen  (exprSingle ( Comma exprSingle)*)? SquareClose ;
curlyArrayConstructor : Array CurlyOpen  expr? CurlyClose  ; 
stringConstructor : StringConstructorOpen stringConstructorContent StringConstructorClose  /* ws: explicit */ ;
stringConstructorContent : 
        stringConstructorChars
        ( stringConstructorInterpolation stringConstructorChars)*
        ;
stringConstructorChars : StringConstructorChars; /* ws: explicit */
stringConstructorInterpolation : StringConstructorInterpolationOpen  expr? StringConstructorInterpolationClose ;

// End Of Primary Expressions

unaryLookup : Ques keySpecifier;  // PrimaryExpr


// Types

singleType : simpleTypeName Ques? ; // CastExpr CastableExpr
typeDeclaration: As sequenceType;
sequenceType: EmptySequenceTest | ( itemType  OccurrenceIndicator?);

itemType: 
      kindTest 
    | Item // Item ParenOpen ParenClose
    | functionTest 
    | mapTest 
    | arrayTest
    | atomicOrUnionType
    | parenthesizedItemType;

atomicOrUnionType : eQName ;

kindTest: 
      AnyKindTest 
    | CommentTest
    | NamespaceNodeTest
    | TextTest
    | attributeTest
    | documentTest
    | elementTest
    | piTest
    | schemaAttributeTest
    | schemaElementTest
    ;

documentTest:     DocumentNode ParenOpen 
    (elementTest | schemaElementTest)? 
    ParenClose ;                                        // KindTest  
piTest:            ProcessingInstruction ParenOpen 
    (NCName | stringLiteral)? 
    ParenClose ;                                         // KindTest
attributeTest:    Attribute ParenOpen 
    (attribNameOrWildcard (Comma typeName)?)?
     ParenClose ;                                       // KindTest
attribNameOrWildcard: attributeName | Wildcard ;
schemaAttributeTest:  SchemaAttribute ParenOpen 
     attributeDeclaration 
     ParenClose ;                                         // KindTest
                                       
attributeDeclaration: attributeName;  
elementTest: Element ParenOpen 
    elementNameOrWildcard
    ( Comma typeName  Ques? )?
    ParenClose ;                                      // KindTest DocumentTest

elementNameOrWildcard: elementName | Wildcard ;
schemaElementTest: SchemaElement ParenOpen 
    elementDeclaration 
    ParenClose ;                                     // KindTest DocumentTest

elementDeclaration: elementName ;   // SchemaElementTest           
attributeName:      eQName ;        // AttribNameOrWildcard AttributeDeclaration
elementName:        eQName ;        // ElementDeclaration  ElementNameOrWildcard
simpleTypeName:     typeName ;      // SingleType
typeName:           eQName ;        // AttributeTest ElementTest SimpleTypeName ValidateExpr

functionTest: annotation* 
    ( AnyFunctionTest | typedFunctionTest ) ;   // ItemType
 
typedFunctionTest: Function ParenOpen
    (sequenceType (Comma sequenceType)*)? 
     ParenClose As sequenceType ; // FunctionTest  

mapTest: AnyMapTest | typedMapTest ;           // ItemType  
typedMapTest: Map ParenOpen 
    atomicOrUnionType Comma sequenceType 
    ParenClose ;

arrayTest: AnyArrayTest | typedArrayTest ;   // ItemType
typedArrayTest: Array ParenOpen sequenceType ParenClose ;

parenthesizedItemType: ParenOpen itemType ParenClose ;  // ItemType

uriLiteral: stringLiteral;
varName : eQName ;
eQName: ( QName | uRIQualifiedName );
literal: numericLiteral | stringLiteral;
stringLiteral: 
      QuotStart ( CharRef | EscapeQuot | PredefinedEntityRef | QuoteContentChar | Apos )* QuotEnd
    | AposStart ( CharRef | EscapeApos | PredefinedEntityRef | AposContentChar  | Quot )* AposEnd
    ;

uRIQualifiedName: bracedURILiteral NCName;
bracedURILiteral: BracedURIOpen ( PredefinedEntityRef | BracedURIContent | CharRef )* CurlyClose ;

numericLiteral: IntegerLiteral | DecimalLiteral| DoubleLiteral;	
varRef: VarPrefix varName;

// currentItem : eQName ;
// nextItem : eQName ;
// previousItem : eQName ;
