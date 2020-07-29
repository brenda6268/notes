# C++ 中的 &

<!--
ID: 38338be4-202a-4d25-8fbb-cce457a64cf5
Status: draft
Date: 2017-07-16T01:29:00
Modified: 2020-05-16T11:46:04
wp_id: 399
-->

For the first time I'm working with a C++ program, I'm surprised by so many `&`s in there, after about one year of learning, I got a summary here.

## Starting from C

C language has only one way to pass variable to function calls -- pass value. And there are 2 situations where passing value is not perfect.

    int add (int a, int b) {
        return a + b;
    }

and use it by calling:

    int a = 1, b = 2, c;
    c = add(1, 2);

when you need to modify you variable inside the function you are calling, or pass-by-value is too expensive, you will need to use pointers.

    void swap (int * a, int * b) {
        int temp = *a;
        *a = *b;1
        *b = temp;
    }

and use it by calling:

    int a = 1, b = 2;
    swap(&a, &b);


For some huge struct:

    void do_something (BigStruct * big_struct) {
        // do something on big_struct
    }

and use it by calling:

    BigStruct big;
    BigStruct * big_ptr = &big;
    do_something(big_ptr); // or do_something(&big)

We can see the usages are:

* prefix a `&` before a variable is to get the address of it
  use when assigning a pointer or in a function call
* and prefix a `*` before a pointer is to dereference it
* use `type *` to declare a pointer to `type`

Pointers are sharp knives, use it well or you may cut yourself. Pass by reference to the rescue!