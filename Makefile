SHELL=/bin/bash

LIB_PATH := $(CURDIR)/lib
JAR := antlr-4.7.1-complete.jar
CP := $(LIB_PATH)/$(JAR):$$CLASSPATH
GRUN   := java -Xmx500M -cp "$(CP)" org.antlr.v4.runtime.misc.TestRig
TOKENS := XQuery module -tokens -trace ../fixtures/
TREE   := XQuery module -tree ../fixtures/
GUI    := XQuery module -gui ../fixtures/
TRACE := XQuery module -trace ../fixtures/
DIAGNOSTICS := XQuery module -diagnostics ../fixtures/


# Tests from https://www.w3.org/R/xquery-31
# test names derived from hash 
# https://www.w3.org/TR/xquery-31/#doc-xquery31-VersionDecl
# -> fixture test name VersionDecl

test-tokens =  $(GRUN) $(TOKENS)$1.xq 2>&1 | grep -qP '^line (.+)$$'  && $(GRUN) $(TOKENS)$1.xq 2>&1 | \
  ( echo ' - ERROR LEXER TOKENS: fixtures/$1.xq' ; grep -oP '^line (.+)$$' )  || echo ' - OK! : fixtures/$1.xq'

show-tokens-output =  $(GRUN) $(TOKENS)$1.xq
show-tree-output =  $(GRUN) $(TREE)$1.xq
show-gui-output =  $(GRUN) $(GUI)$1.xq
show-trace-output =  $(GRUN) $(TRACE)$1.xq
show-diag-output =  $(GRUN) $(DIAGNOSTICS)$1.xq

.PHONY: default
default: 
	@mkdir -p build
	@rm -f build/*
	@cd src && java -jar $(LIB_PATH)/$(JAR) XQueryLexer.g4 -o ../build
	@cd src && java -jar $(LIB_PATH)/$(JAR) XQueryParser.g4 -o ../build
	@cd build && javac -classpath $(LIB_PATH)/$(JAR) XQuery*.java

.PHONY: before
before: 
	@mkdir -p  $(LIB_PATH)
	@cd lib && wget https://www.antlr.org/download/$(JAR)

.PHONY: test
test:
	@echo '4 Modules and Prologs'
	@cd build; $(call test-tokens,VersionDecl) 
	@cd build; $(call test-tokens,ModuleDecl)
	@cd build; $(call test-tokens,DefaultNamespaceDecl)
	@cd build; $(call test-tokens,BoundarySpaceDecl)  
	@cd build; $(call test-tokens,DefaultCollationDecl) 
	@cd build; $(call test-tokens,BaseURIDecl) 
	@cd build; $(call test-tokens,ConstructionDecl) 
	@cd build; $(call test-tokens,OrderingModeDecl) 
	@cd build; $(call test-tokens,EmptyOrderDecl) 
	@cd build; $(call test-tokens,CopyNamespacesDecl) 
	@echo ' - TODO! DecimalFormatDecl'
	@cd build; $(call test-tokens,SchemaImport) 
	@cd build; $(call test-tokens,ModuleImport) 
	@cd build; $(call test-tokens,NamespaceDecl) 
	@cd build; $(call test-tokens,OptionDecl) 
	@cd build; $(call test-tokens,VarDecl) 
	@cd build; $(call test-tokens,FunctionDecl) 
	@echo '2.5 Types'
	@cd build; $(call test-tokens,SequenceType) 
	@cd build; $(call test-tokens,ElementTest) 
	@cd build; $(call test-tokens,SchemaElementTest) 
	@cd build; $(call test-tokens,AttributeTest) 
	@cd build; $(call test-tokens,SchemaAttributeTest) 
	@echo 'TODO: incomplete - AnyFunctionTest, TypedFunctionTest'
	@cd build; $(call test-tokens,AnyFunctionTest) 
	@cd build; $(call test-tokens,TypedFunctionTest) 
	@cd build; $(call test-tokens,AnyMapTest) 
	@cd build; $(call test-tokens,AnyArrayTest) 
	@cd build; $(call test-tokens,TypedArrayTest) 
	@cd build; $(call test-tokens,xsError) 
	@# cd build; $(call test-tokens,PITest) 
	@echo '2.6 Comments'
	@cd build; $(call test-tokens,Comments) 
	@echo '3.1 Primary Expressions'
	@cd build; $(call test-tokens,StringLiteral) 
	@cd build; $(call test-tokens,NumericLiteral) 
	@cd build; $(call test-tokens,VarRef) 
	@cd build; $(call test-tokens,ParenthesizedExpr) 
	@# '3.1.4 Context Item Expression' 
	@cd build; $(call test-tokens,ContextItemExpr) 
	@cd build; $(call test-tokens,FunctionCall) 
	@cd build; $(call test-tokens,NamedFunctionRef) 
	@cd build; $(call test-tokens,InlineFunctionExpr) 
	@cd build; $(call test-tokens,EnclosedExpr) 
	@echo '3.11 Maps and Arrays'
	@cd build; $(call test-tokens,MapConstructor1) 
	@cd build; $(call test-tokens,MapConstructor2) 
	@cd build; $(call test-tokens,SquareArrayConstructor) 
	@cd build; $(call test-tokens,CurlyArrayConstructor) 
	@cd build; $(call test-tokens,UnaryLookup) 
	@echo '3.12 FLWOR Expressions'
	@cd build; $(call test-tokens,ForClause) 
	@cd build; $(call test-tokens,LetClause) 
	@cd build; $(call test-tokens,WhereClause) 
	@cd build; $(call test-tokens,CountClause) 
	@cd build; $(call test-tokens,GroupByClause) 
	@cd build; $(call test-tokens,OrderByClause) 
	@cd build; $(call test-tokens,ReturnClause) 
	@echo '3.13 Ordered and Unordered Expressions'
	@cd build; $(call test-tokens,UnorderedExpr) 
	@echo '3.14 Conditional Expressions'
	@cd build; $(call test-tokens,IfExpr) 
	@echo '3.15 Switch Expression'
	@# TODO cd build; $(call test-tokens,SwitchExpr) 
	@echo '3.16 Quantified Expressions'
	@cd build; $(call test-tokens,QuantifiedExpr) 
	@echo '3.17 Try/Catch Expressions '
	@cd build; $(call test-tokens,TryCatchExpr) 
	@echo '3.18 Expressions on SequenceTypes'
	@cd build; $(call test-tokens,InstanceofExpr) 
	@#cd build; $(call test-tokens,TypeswitchExpr) 
	@echo '3.2 Postfix Expressions'
	@cd build; $(call test-tokens,PostfixFilterExpressions) 
	@cd build; $(call test-tokens,PostfixDynamicFunctionCalls) 
	@echo '3.3 Path Expressions TODO'
	@echo '3.4 Sequence Expressions'
	@cd build; $(call test-tokens,ConstructingSequences) 
	@cd build; $(call test-tokens,RangeExpr) 
	@cd build; $(call test-tokens,UnionExpr) 
	@echo '3.5 Arithmetic Expressions'
	@cd build; $(call test-tokens,AdditiveExpr) 
	@cd build; $(call test-tokens,MultiplicativeExpr) 
	@cd build; $(call test-tokens,UnaryExpr) 
	@echo '3.6 String Concatenation Expressions'
	@cd build; $(call test-tokens,StringConcatExpr) 
	@echo '3.7 Comparison Expressions '
	@cd build; $(call test-tokens,ComparisonExpr) 
	@cd build; $(call test-tokens,GeneralComparisons) 
	@cd build; $(call test-tokens,NodeComparisons) 
	@echo '3.8 Logical Expressions'
	@cd build; $(call test-tokens,OrExpr) 
	@cd build; $(call test-tokens,AndExpr) 
	@echo '3.9 Node Constructors'
	@cd build; $(call test-tokens,DirElemConstructor) 
	@cd build; $(call test-tokens,CompDocConstructor) 
	@cd build; $(call test-tokens,CompTextConstructor) 
	@echo '3.10 String Constructors'
	@cd build; $(call test-tokens,StringConstructor) 


# ` make show-tokens TEST=VersionDecl '

.PHONY: show-tokens
show-tokens:
	@cd build; $(call show-tokens-output,$(TEST))

.PHONY: show-tree
show-tree:
	@cd build; $(call show-tree-output,$(TEST))

.PHONY: show-gui
show-gui:
	@cd build; $(call show-gui-output,$(TEST))

.PHONY: show-trace
show-trace:
	@cd build; $(call show-trace-output,$(TEST))

.PHONY: show-diag
show-diag:
	@cd build; $(call show-diag-output,$(TEST))

.PHONY: grun
grun: 
	@$(GRUN)

