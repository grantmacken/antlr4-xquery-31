SHELL=/bin/bash

CP := /usr/local/lib/antlr-4.7.1-complete.jar:$$CLASSPATH
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
	@cd ./src && java -Xmx500M -cp "$(CP)" org.antlr.v4.Tool XQueryLexer.g4 -o ../build
	@cd ./src && java -Xmx500M -cp "$(CP)" org.antlr.v4.Tool XQueryParser.g4 -o ../build
	@cd build && javac XQuery*.java

.PHONY: test
test:	
	@cd build; $(call test-tokens,VersionDecl) 
	@#cd build; $(call test-tokens,ModuleDecl)
	@#cd build; $(call test-tokens,BoundarySpaceDecl)  
	@#cd build; $(call test-tokens,DefaultCollationDecl) 
	@#cd build; $(call test-tokens,BaseURIDecl) 
	@#cd build; $(call test-tokens,ConstructionDecl) 
	@#cd build; $(call test-tokens,OrderingModeDecl) 
	@#cd build; $(call test-tokens,EmptyOrderDecl) 
	@#cd build; $(call test-tokens,CopyNamespacesDecl) 
	@echo ' - TODO! DecimalFormatDecl'
	@cd build; $(call test-tokens,SchemaImport) 
	@cd build; $(call test-tokens,ModuleImport) 
	@cd build; $(call test-tokens,NamespaceDecl) 
	@echo ' - TODO! FunctionDecl ' 
	@echo ' - TODO! OptionDecl  '
	@# cd build; $(call test-tokens,OptionDecl) 
	@echo ' - TODO! VarDecl ) ' 
	@# cd build; $(call test-tokens,VarDecl) 
	@# cd build; $(call test-tokens,FunctionDecl) 
	@# cd build; $(call test-tokens,SchemaElementTest) 
	@# cd build; $(call test-tokens,ElementTest) 
	@# cd build; $(call test-tokens,PITest) 
	@# cd build; $(call test-tokens,FunctionTest) 
	@# cd build; $(call test-tokens,TypedFunctionTest) 
	@# cd build; $(call test-tokens,AnyMapTest) 
	@# cd build; $(call test-tokens,AnyArrayTest) 
	@echo 'Expressions'
	@# cd build; $(call test-tokens,StringLiteral) 
	@# cd build; $(call test-tokens,NumericLiteral) 
	@# cd build; $(call test-tokens,VarRef) 
	@# cd build; $(call test-tokens,ParenthesizedExpr) 
	@# cd build; $(call test-tokens,ContextItemExpr) 
	@# cd build; $(call test-tokens,FunctionCall) 
	@# cd build; $(call test-tokens,NamedFunctionRef) 
	@# cd build; $(call test-tokens,InlineFunctionExpr) 


# ` make show-token TEST=VersionDecl '

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

