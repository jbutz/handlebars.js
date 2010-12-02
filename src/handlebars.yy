%start root

%%

root
  : program { return $1 }
  ;

program
  : statements simpleInverse statements { $$ = new yy.ProgramNode($1, $3) }
  | statements { $$ = new yy.ProgramNode($1) }
  | "" { $$ = new yy.ProgramNode([]) }
  ;

statements
  : statement { $$ = [$1] }
  | statements statement { $1.push($2); $$ = $1 }
  ;

statement
  : openBlock program closeBlock { $$ = new yy.BlockNode($1, $2) }
  | mustache { $$ = $1 }
  | partial { $$ = $1 }
  | CONTENT { $$ = new yy.ContentNode($1) }
  | COMMENT { $$ = new yy.CommentNode($1) }
  ;

openBlock
  : OPEN_BLOCK inMustache CLOSE { $$ = new yy.MustacheNode($2) }
  ;

closeBlock
  : OPEN_ENDBLOCK path CLOSE { }
  ;

mustache
  : OPEN inMustache CLOSE { $$ = new yy.MustacheNode($2) }
  | OPEN_UNESCAPED inMustache CLOSE { $$ = new yy.MustacheNode($2, true) }
  ;


partial
  : OPEN_PARTIAL path CLOSE { $$ = new yy.PartialNode($2) }
  | OPEN_PARTIAL path path CLOSE { $$ = new yy.PartialNode($2, $3) }
  ;

simpleInverse
  : OPEN_INVERSE CLOSE { }
  ;

inMustache
  : path params { $$ = [$1].concat($2) }
  | path { $$ = [$1] }
  ;

params
  : params param { $1.push($2); $$ = $1; }
  | param { $$ = [$1] }
  ;

param
  : path { $$ = $1 }
  | STRING { $$ = new yy.StringNode($1) }
  ;

path
  : pathSegments { $$ = new yy.IdNode($1) }
  ;

pathSegments
  : pathSegments SEP ID { $1.push($3); $$ = $1; }
  | ID { $$ = [$1] }
  ;

