# PEP8 中需要注意的地方


wp_id: 666
Status: publish
Date: 2017-07-27 01:04:00
Modified: 2020-05-16 11:46:21


# spaces

If operators with different priorities are used, consider adding whitespace around the operators with the lowest priority(ies). Use your own judgment; however, never use more than one space, and always have the same amount of whitespace on both sides of a binary operator.

```
Yes:
i = i + 1
submitted += 1
x = x*2 - 1
hypot2 = x*x + y*y
c = (a+b) * (a-b)
No:
i=i+1
submitted +=1
x = x * 2 - 1
hypot2 = x * x + y * y
c = (a + b) * (a - b)
```

# comments

Compound statements (multiple statements on the same line) are generally discouraged.

Comments that contradict the code are worse than no comments. Always make a priority of keeping the comments up-to-date when the code changes!

Comments should be complete sentences. If a comment is a phrase or sentence, its first word should be capitalized, unless it is an identifier that begins with a lower case letter (never alter the case of identifiers!).

If a comment is short, the period at the end can be omitted. Block comments generally consist of one or more paragraphs built out of complete sentences, and each sentence should end in a period.
You should use two spaces after a sentence-ending period.
When writing English, follow Strunk and White.
Python coders from non-English speaking countries: please write your comments in English, unless you are 120% sure that the code will never be read by people who don't speak your language.

Conventions for writing good documentation strings (a.k.a. "docstrings") are immortalized in PEP 257 .
* Write docstrings for all public modules, functions, classes, and methods. Docstrings are not necessary for non-public methods, but you should have a comment that describes what the method does. This comment should appear after thedef line.
* PEP 257 describes good docstring conventions. Note that most importantly, the """ that ends a multiline docstring should be on a line by itself, e.g.:
```
"""Return a foobang

Optional plotz says to frobnicate the bizbaz first.
"""
```
For one liner docstrings, please keep the closing """ on the same line.


# Nameing Conventions

Overriding Principle
Names that are visible to the user as public parts of the API should follow conventions that reflect usage rather than implementation.

Names to Avoid
Never use the characters 'l' (lowercase letter el), 'O' (uppercase letter oh), or 'I' (uppercase letter eye) as single character variable names.
In some fonts, these characters are indistinguishable from the numerals one and zero. When tempted to use 'l', use 'L' instead.

Exception Names
Because exceptions should be classes, the class naming convention applies here. However, you should use the suffix "Error" on your exception names (if the exception actually is an error).

When implementing ordering operations with rich comparisons, it is best to implement all six operations ( __eq__ ,__ne__ , __lt__ , __le__ , __gt__ , __ge__ ) rather than relying on other code to only exercise a particular comparison.
To minimize the effort involved, the functools.total_ordering() decorator provides a tool to generate missing comparison methods.
PEP 207 indicates that reflexivity rules are assumed by Python. Thus, the interpreter may swap y > x with x < y , y >= xwith x <= y , and may swap the arguments of x == y and x != y . The sort() and min() operations are guaranteed to use the < operator and the max() function uses the > operator. However, it is best to implement all six operations so that confusion doesn't arise in other contexts.


# lambda

Always use a def statement instead of an assignment statement that binds a lambda expression directly to an identifier.
Yes:
def f(x): return 2*x
No:
f = lambda x: 2*x
The first form means that the name of the resulting function object is specifically 'f' instead of the generic `'<lambda>'`. This is more useful for tracebacks and string representations in general. The use of the assignment statement eliminates the sole benefit a lambda expression can offer over an explicit def statement (i.e. that it can be embedded inside a larger expression)


# exceptions

Design exception hierarchies based on the distinctions that code catching the exceptions is likely to need, rather than the locations where the exceptions are raised. Aim to answer the question "What went wrong?" programmatically, rather than only stating that "A problem occurred" (see PEP 3151 for an example of this lesson being learned for the builtin exception hierarchy)

Class naming conventions apply here, although you should add the suffix "Error" to your exception classes if the exception is an error. Non-error exceptions that are used for non-local flow control or other forms of signaling need no special suffix.

Use exception chaining appropriately. In Python 3, "raise X from Y" should be used to indicate explicit replacement without losing the original traceback.

When deliberately replacing an inner exception (using "raise X" in Python 2 or "raise X from None" in Python 3.3+), ensure that relevant details are transferred to the new exception (such as preserving the attribute name when converting KeyError to AttributeError, or embedding the text of the original exception in the new exception message).