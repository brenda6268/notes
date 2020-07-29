# 如何实现一门语言或者 DSL

<!--
ID: 1caa235e-e478-4790-a24c-1c094fe3afd6
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1497
-->

## 图灵完备的语言

对于一门完整的普通语言来说，编译器读取源文件，并生成机器可以执行的汇编语言或者机器码。对于脚本语言来说，同样是读取源文件解析，但是没有生成机器码，而是由解释器在线解析执行。

一般来说，编译器或者解析器分为三个部分。

1. 前端。主要是语法解析。输入是源文件，输出可能是抽象语法树（AST）或者一种
2. 中端。优化前端生成的代码。比如 gcc 中 `-O1`, `-O2` 这些优化就是在这里进行的，比如说展开一些
3. 后端。从中端优化生成的中间代码（IR）翻译到目标机器的机器代码或者汇编

当然，对于一些偷懒的编译器或者解析器来说，可能不需要优化，或者直接就遍历 AST 解析执行了。对于一些「语言到语言」也就是以其他语言为目标的编译器，可能最后一步是把中间代码转化到目标语言的语法。

## DSL

除了这些完备的编程语言外，我们在开发中还经常使用一些「小语言」，他们可能连 for 循环都没有，但是可能有加减乘除，可能有数组等。比如 json、CSS、Excel 中的公式等都可以理解为特定领域的小语言。更加学术化的名字是 DSL - Domain Specific Language。和完备的编程语言不同的是，DSL 往往是寄生在其他环境中的。

要实现一门 DSL，上面的三个步骤中，前端还是不可或缺的，毕竟我们总得解析用户输入吧。中端和后端可能就和完整的编译器不一样了。对一个 DSL 来说，可能不怎么需要优化，至于后端，我们可能不需要生成机器码，而是直接调用对应的目标 API。

# 语法定义和解析算法

语法需要是上下文无关的形式。

什么是上下文无关的语法？也就是语法的解析不需要考虑上下文的语法。常见的编程语言，比如 Java、Python 都可以近似理解为上下文无关的语法，因为每一个语句的意思不管出现在哪里都是确定的。而自然语言，比如汉语、英语等，他们的解析是和上下文有关的，比如说「我吃草」这句话，在不同的语境中是有不同含义的。

要定义一门语言，我们首先需要语法定义文件和解析算法。BNF 是定义语法的常见标准格式，EBNF 相比于 BNF 来说增加了一些通配符，使得语法定义文件更加简单。

还有一种语法定义格式，叫做 PEG，他是伴随 PEG 这种解析算法一起提出的，但是本质上和 EBNF 差别不大，一些使用 PEG 算法的解析器实际上也支持 EBNF 的语法，所以一般提到 PEG 的时候，多指这种算法。

除了 PEG 以外，常用的解析算法有 LL(k), LALR, Earley 等，这里就不展开了。 其中 LL 是自顶向下的一个解析算法。LALR 是自底向上的解析算法。

# 语法解析工具

一般来说，我们可以通过手写来实现一个语法解析工具，但是这项工作是比较繁琐和易错的，所以有一些工具可以用来生成语法解析器。比如：lex, yacc, bison, Lark, Antlr 等。语法解析工具通过读取我们定义的 EBNF 或者其他规则，生成对应语言的一个 Parser，我们调用 Parser 读取源文件，生成一颗 AST。

在这里我们选用 Antlr 作为我们的语法解析工具。Antlr 的好处在于，他可以生成多种语言的 Parser，比如 Java，Python，JavaScript 等，这样我们就可以在多种语言中使用了。

下面我们来构造一个简单的数学计算器，支持加减乘除和内置的三角函数。比如：

```
1 + 1
2 * 5
1 + sin(1)
```

## 安装 Antlr

Mac 上安装很简单，直接 brew install

```
brew install antlr
```

## EBNF 语法定义

关于 EBNF 的语法这里就不展开了。

```ebnf
grammar simple_calculator;

expression
    : function_call
    | addtive_expression
    ;

addtive_expression
    : 

// function definition
function_call: function_name '(' argument_list ')';
function_name: CNAME;
argument_list: expression? (',' expression)*;

// math expressions
addtive_expression: multiplicative_expression
                  | addtive_expression addtive_operator multiplicative_expression;

addtive_operator: '+'
                | '-';

multiplicative_expression: unary_expression
                         | unary_expression multiplicative_operator multiplicative_expression;

multiplicative_operator: '*'
                       | '/'
                       | '%';

unary_expression: unary_operator? primary_expression;

unary_operator: '+'
              | '-'
              | '!';

primary_expression: literal
                  | field
                  | '(' expression ')'
                  | function_call;

literal: string
       | number;

number: SIGNED_NUMBER;
string: ESCAPED_STRING;

field: '[' FIELD_NAME ']';
FIELD_NAME: FIELD_CHAR+;
FIELD_CHAR: ALPHANUM | SPACE;

// common definitions

DIGIT: '0'..'9';
LCASE_LETTER: 'a'..'z';
UCASE_LETTER: 'A'..'Z';
SPACE: ' ';

INT: DIGIT+;
SIGNED_INT: ['+'|'-'] INT;
DECIMAL: INT '.' INT? | '.' INT;

_EXP: ('e'|'E') SIGNED_INT;
FLOAT: INT _EXP | DECIMAL _EXP?;
SIGNED_FLOAT: ['+'|'-'] FLOAT;

NUMBER: FLOAT | INT;
SIGNED_NUMBER: ['+'|'-'] NUMBER;

LETTER: UCASE_LETTER | LCASE_LETTER;
CNAME: ('_'|LETTER) ('_'|LETTER|DIGIT)*;
ALPHANUM: DIGIT | LETTER;

_STRING_INNER: /.*?/;
_STRING_ESC_INNER: _STRING_INNER /(?<!\\)(\\\\)*?/ ;

ESCAPED_STRING : '\'' _STRING_ESC_INNER '\'';
```


# 后端实现


# 前端

1. 语法高亮
2. 自动提示
3. 验证表达式是否合法

# 符号类型

1. 数字字面量
2. 字符串字面量
3. 字段
4. 函数

函数拥有类型

# 执行

全部使用 pandas 执行还是一部分指令发送到 druid 执行。metabase 是如何实现的呢？superset 是如何实现的呢？

pandas.eval 

# EBNF

如果实现一个简单的通用的 BNF，那么每个函数的自动补全可能就需要知道函数的签名。如果把内置函数都写到 BNF 里面，那么这个 BNF 也太长了。

本质上这个表达式其实就是 Lisp 加上加减乘除的中缀表达式。

控制语句也都使用函数表示

普通语言：源代码 -> AST -> 汇编代码
SB：源代码 -> AST -> 解析执行（调用 pandas）
              +---> 编译成 druid query

```ebnf
expression: funciton_call
          | math_expression
          | literal 
          | field

// function definition
function_call: function_name "(" argument_list ")"
function_name: CNAME
argument_list: expression (, expression)*

// math expressions
math_expression: addtive_expression

addtive_expression: multiplicative_expression
                  | addtive_expression + multiplicative_expression
                  | addtive_expression - multiplicative_expression

multiplicative_expression: unary_expression
                         | multiplicative_expression * unary_expression
                         | multiplicative_expression / unary_expression
                         | multiplicative_expression % unary_expression

unary_expression: expression
                | unary_operator expression

unary_operator: + 
              | - 
              | !

literal: string
       | number

number: SIGNED_NUMBER
string: ESCAPED_STRING

field: "[" (ALPHANUM|SPACE)+ "]"

// common definitions

DIGIT: "0".."9"
LCASE_LETTER: "a".."z"
UCASE_LETTER: "A".."Z"

INT: DIGIT+
SIGNED_INT: ["+"|"-"] INT
DECIMAL: INT "." INT? | "." INT

_EXP: ("e"|"E") SIGNED_INT
FLOAT: INT _EXP | DECIMAL _EXP?
SIGNED_FLOAT: ["+"|"-"] FLOAT

NUMBER: FLOAT | INT
SIGNED_NUMBER: ["+"|"-"] NUMBER

LETTER: UCASE_LETTER | LCASE_LETTER
CNAME: ("_"|LETTER) ("_"|LETTER|DIGIT)*
ALPHANUM: DIGIT | LETTER

_STRING_INNER: /.*?/
_STRING_ESC_INNER: _STRING_INNER /(?<!\\)(\\\\)*?/ 

ESCAPED_STRING : "\"" _STRING_ESC_INNER "\""
```

tableau funtions: https://help.tableau.com/current/pro/desktop/en-us/functions_all_alphabetical.htm

# 参考资料

## BNF Syntax

- [BNF vs EBNF](https://condor.depaul.edu/ichu/csc447/notes/wk3/BNF.pdf)
- [EBNF: How to Describe the Grammar of a Language](https://tomassetti.me/ebnf/)

## BNF examples

- [C BNF](https://cs.wmich.edu/~gupta/teaching/cs4850/sumII06/The%20syntax%20of%20C%20in%20Backus-Naur%20form.htm)
- [C grammar in ANTLR](https://github.com/antlr/grammars-v4/blob/master/c/C.g4)
- [Python grammar in Lark](https://github.com/lark-parser/lark/blob/master/examples/python3.lark)
- [Excel Formula](https://formulas.readthedocs.io/en/stable/doc.html)
- [Python grammar](https://docs.python.org/3/reference/grammar.html)
- [BNF for simple arithmetic expression](https://stackoverflow.com/questions/34603011/grammar-rule-for-math-expressions-no-left-recursion)
- [Excel formulas](https://docs.microsoft.com/en-us/openspecs/office_standards/ms-oe376/bcd72180-31a3-423b-8f83-d224b2286da3)

## Prasers

- [Let's build a compiler](https://compilers.iecc.com/crenshaw/)
- [List of Parser Generators](https://en.wikipedia.org/wiki/Comparison_of_parser_generators)
- [PEG: Ambiguity, precision and confusion](https://jeffreykegler.github.io/Ocean-of-Awareness-blog/individual/2015/03/peg.html)
- [Difference between LL and Recursive Descent parser](https://stackoverflow.com/questions/1044600/difference-between-an-ll-and-recursive-descent-parser)
- [LALR parser vs LL Parser](https://stackoverflow.com/questions/12170869/lalr-vs-ll-parser)
- [LL parser advantage over LR parser](https://stackoverflow.com/questions/4092280/what-advantages-do-ll-parsers-have-over-lr-parsers)]
- https://www.reddit.com/r/ProgrammingLanguages/comments/mpnqf/are_tools_like_flexyaccantlrbison_etc_used_when/
- https://www.reddit.com/r/ProgrammingLanguages/comments/eaxgu2/llvm_backend_with_antlr_frontend/

### Lark
- [Lark](https://lark-parser.readthedocs.io/en/latest/visitors/)
- [Write a DSL With Lark](http://blog.erezsh.com/how-to-write-a-dsl-in-python-with-lark/)

### ANTLR

- [ANTLR](https://github.com/antlr/antlr4/blob/master/doc/getting-started.md)
- [The Antlr Mega Tutorial](https://tomassetti.me/antlr-mega-tutorial/)

## Compiler backend
- [What is LLVM](https://www.infoworld.com/article/3247799/what-is-llvm-the-power-behind-swift-rust-clang-and-more.html)
- [Mapping high level structs to LLVM](https://mapping-high-level-constructs-to-llvm-ir.readthedocs.io/en/latest/basic-constructs/index.html)

## Code editor
- [Writing a browser based editor using Monaco and ANTLR](https://tomassetti.me/writing-a-browser-based-editor-using-monaco-and-antlr/)
- [Monarch API for monaco editor](https://microsoft.github.io/monaco-editor/monarch.html)
- [Antlr and the Web](https://tomassetti.me/antlr-and-the-web/)
- [Create a custom web editor using Typescript, React, ANTLR and Monaco-Editor](https://medium.com/@amazzal.elhabib/create-a-custom-web-editor-using-typescript-react-antlr-and-monaco-editor-part-1-2f710c69c18c)

## Others

- [手把手教你构建 C 语言编译器](https://lotabout.me/2016/write-a-C-interpreter-9/)
- [What are the parts of the compiler](https://www.quora.com/What-are-the-parts-of-the-compiler)
- [Compiler middle end](https://en.wikipedia.org/wiki/Compiler)
