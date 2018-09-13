grammar MP;

@lexer::header {
from lexererr import *
}

options{
	language=Python3;
	//language=Java;
}

program: declaration* main? declaration* EOF;

declaration: var_declaration | function_declaration | procedure_declaration;

main: PROCEDURE MAIN LB RB SEMI var_declaration? compound_stmt;

var_declaration: VAR var_declaration_more ;
var_declaration_more: idlist COLON (var_type | array) SEMI (var_declaration_more | var_declaration)
					| idlist COLON (var_type | array) SEMI;
// Define list of identifiers
idlist: ID COMA idlist | ID;
// Define all possible types
var_type: INTTYPE | REALTYPE | BOOLTYPE | STRINGTYPE;

array: ARRAY LSB exp_index_1 DOT_DOT exp_index_1 RSB OF var_type;

procedure_declaration: PROCEDURE ID LB param_list? RB SEMI var_declaration? compound_stmt;


function_declaration: FUNCTION ID LB param_list? RB COLON return_type SEMI var_declaration? compound_stmt;
param_list:  parameter param_list_more |;
param_list_more: SEMI  parameter param_list_more |;

parameter: idlist COLON var_type | idlist COLON array;

return_type: var_type | array;

compound_stmt: BEGIN statement* END;

// Statement
statement: 	assign_stmt | if_stmt | while_stmt | for_stmt
		 | with_stmt | call_stmt | compound_stmt | return_stmt | break_stmt | continue_stmt;

// Assignment statement
//assign_stmt:  <assoc=right> (scalar_variable ASSIGN)+ expression SEMI;
assign_stmt: assignment SEMI;
assignment: scalar_variable ASSIGN assignment | scalar_variable ASSIGN expression;

// If statement
if_stmt: IF expression THEN statement (ELSE statement)?;
/*
if_stmt: open_statement | closed_statement;
open_statement: IF expression THEN if_stmt
	 | IF expression THEN closed_statement ELSE open_statement
	 | statement;
closed_statement: IF expression THEN */

// While statement
while_stmt: WHILE expression DO statement;

// For statement
for_stmt: FOR ID ASSIGN expression (TO | DOWNTO) expression DO statement;

// Break statement
break_stmt: BREAK SEMI;

// Continue statement
continue_stmt: CONTINUE SEMI;

// Return statement
return_stmt: RETURN expression? SEMI;


// With statement
with_stmt: WITH var_declaration_more DO statement ;

// Call statement
call_stmt: ID LB call_expression_list? RB SEMI;
call_expression_list: expression call_expression_list_more;
call_expression_list_more: COMA expression call_expression_list_more |;

invocation_stmt: invocation_expression SEMI;
invocation_expression: ID LB expression_list? RB;
expression_list: expression expression_more;
expression_more: COMA expression expression_more | ;

expression: expression_1 | index_expression;

expression_1: expression_1 AND THEN expression_2
			| expression_1 OR ELSE expression_2
			| expression_2;
expression_2: expression_3 EQUAL expression_3
			| expression_3 DIFF expression_3
			| expression_3 LESS expression_3
			| expression_3 LESS_EQ expression_3
			| expression_3 LARGE expression_3
			| expression_3 LARGE_EQ expression_3
			| expression_3;
expression_3: expression_3 ADDITION expression_4
			| expression_3 SUBSTRACT expression_4
			| expression_3 OR expression_4
			| expression_4;
expression_4: expression_4 DIVIDE expression_5
			| expression_4 MULTI expression_5
			| expression_4 DIV expression_5
			| expression_4 MOD expression_5
			| expression_4 AND expression_5
			| expression_5;
expression_5: SUBSTRACT expression_5 | NOT expression_5 | expression_6;
expression_6: LB expression_1 RB | scalar_variable | INTLIT | REAL_LIT | ID | TRUE | FALSE | STRING_LIT | invocation_expression;

scalar_variable: ID (LB expression_1? RB)? (LSB exp_index_1? RSB)?;


/* ------------------------ FOR INDEX -------------------------- */
index_expression: ID (LB expression? RB)? LSB exp_index_1? RSB;

exp_index_1: exp_index_1 (ADDITION | SUBSTRACT) exp_index_2
			| exp_index_2;
exp_index_2: exp_index_2 (MULTI | DIVIDE | DIV | MOD) exp_index_3
			| exp_index_3;
exp_index_3: '-' exp_index_3
			| exp_index_4;
exp_index_4: LB exp_index_1 RB
			| INTLIT
			| ID
			| scalar_variable
			| invocation_expression;

/* ------------------------------------------------------------- */

/* ============================================================ */



/* ASSIGNMENT 1 */


/*----------------------------------- THIS IS KEYWORD -------------------------------------- */


INTTYPE: INTEGER ;

REALTYPE: REAL;

BOOLTYPE: BOOLEAN;

STRINGTYPE: STRING;

REAL: R E A L;
BOOLEAN: B O O L E A N;
INTEGER: I N T E G E R;
STRING: S T R I N G;
NOT: N O T;
MOD: M O D;
OR: O R;
AND: A N D;
DIV: D I V;
TRUE: T R U E;
FALSE: F A L S E;
BREAK: B R E A K;
CONTINUE: C O N T I N U E;
FOR: F O R;
TO: T O;
DOWNTO: D O W N T O;
DO: D O;
IF: I F;
THEN: T H E N;
ELSE: E L S E;
RETURN: R E T U R N;
WHILE: W H I L E;
BEGIN: B E G I N;
END: E N D;
FUNCTION: F U N C T I O N;
PROCEDURE: P R O C E D U R E;
VAR: V A R;
ARRAY: A R R A Y;
OF: O F;
WITH: W I T H;


/*
fragment DATA_TYPE : REAL |  BOOLEAN | INTEGER | STRING;
fragment OPERATION : NOT | MOD | OR | AND | DIV;
fragment BOOL : TRUE | FALSE;


OPERATOR: '+' | '-' | '*' | '/' |
		  '<>'| '=' | '<' | '>' | '<=' | '>=' | OPERATION;
*/
ADDITION: '+';
SUBSTRACT: '-';
MULTI: '*';
DIVIDE: '/';

DIFF: '<>';
EQUAL: '=';
LESS: '<';
LARGE: '>';
LESS_EQ: '<=';
LARGE_EQ: '>=';

/* -------------------------------------------------------------------------- */

//ID: ('_'+[a-zA-Z0-9] | [a-zA-Z])('_' | [a-zA-Z0-9])*;



/* ------------------- SEPARATOR ------------------- */
LB: '(' ;
RB: ')' ;
LP: '{';
RP: '}';
LSB: '[';
RSB: ']';
SEMI: ';' ;
COMA: ',';
COLON: ':';
ASSIGN: ':=';
DOT_DOT: '..';

//SEPARATOR: LSB | RSB | COLON | LB | RB | SEMI | DOT_DOT | COMA;

/* --------------- SKIP ---------------------- */
COMMENT: (COMMENT_1 | COMMENT_2 | COMMENT_LINE) -> skip;

COMMENT_1: '(*'.*?'*)' ;
COMMENT_2: '{'.*?'}' ;
COMMENT_LINE: '//' ~[\t\n]* ;


WS : [ \t\r\n]+ -> skip ; // skip spaces, tabs, newlines




INTLIT: [0-9]+;

fragment EXPONENT: ('e' | 'E') ('-')? [0-9]+;
fragment AFTER: [0-9]+'.'[0-9]*; 						// 1.
fragment BEFORE: ('.')[0-9]+EXPONENT?;				// .1 , .1e12
fragment BOTH_D_E: [0-9]+('.')[0-9]*EXPONENT;			// 1.1e12
fragment ONLY_E: [0-9]+EXPONENT;						// 1e12

REAL_LIT: '-'?(AFTER | BEFORE | BOTH_D_E | ONLY_E);

STRING_LIT: '"'('\\' ('t' | 'b' | 'f' | 'r' | 'n' | '\'' | '"' | '\\' ) | ~('\b' | '\f' | '\r' | '\n' | '\t' | '\'' | '"' | '\\'))* '"'
				{self.text = self.text[1:-1]};



fragment A: ('a'|'A');
fragment B: ('b'|'B');
fragment C: ('c'|'C');
fragment D: ('d'|'D');
fragment E: ('e'|'E');
fragment F: ('f'|'F');
fragment G: ('g'|'G');
fragment H: ('h'|'H');
fragment I: ('i'|'I');
fragment J: ('j'|'J');
fragment K: ('k'|'K');
fragment L: ('l'|'L');
fragment M: ('m'|'M');
fragment N: ('n'|'N');
fragment O: ('o'|'O');
fragment P: ('p'|'P');
fragment Q: ('q'|'Q');
fragment R: ('r'|'R');
fragment S: ('s'|'S');
fragment T: ('t'|'T');
fragment U: ('u'|'U');
fragment V: ('v'|'V');
fragment W: ('w'|'W');
fragment X: ('x'|'X');
fragment Y: ('y'|'Y');
fragment Z: ('z'|'Z');

ID: ('_' | [a-zA-Z])+('_' | [a-zA-Z0-9])*;

MAIN: M A I N;
/* ============ */


UNCLOSE_STRING: '"'('\\' ('t' | 'b' | 'f' | 'r' | 'n' | '\'' | '"' | '\\' ) | ~('\b' | '\f' | '\r' | '\n' | '\t' | '\'' | '"' | '\\'))*
						{raise UncloseString(self.text);};
ILLEGAL_ESCAPE: '"'('\\' ('t' | 'b' | 'f' | 'r' | 'n' | '\'' | '"' | '\\' ) | ~('\b' | '\f' | '\r' | '\n' | '\t' | '\'' | '"' | '\\')) '\\' ~('t' | 'b' | 'f' | 'r' | 'n' | '\'' | '"' | '\\' )
						{raise IllegalEscape(self.text[1:])};
ERROR_CHAR: . {raise ErrorToken(self.text);};
