# numpy 入门

<!--
ID: 6e043d0b-a6ed-45d5-9181-7f15df715955
Status: draft
Date: 2018-06-23T02:44:00
Modified: 2020-05-16T11:14:25
wp_id: 476
-->

可视化的 numpy 教程：https://jalammar.github.io/visual-numpy/

Numpy is a very powerful library and you can make wonders with it but, most of the time, this comes at the price of readability. If you don't comment your code at the time of writing, you won't be able to tell what a function is doing after a few weeks (or possibly days).

## np.array

np.array is the basic structure is numpy. It's a n-dimension array

directly from a python list or lists

```py
print(type(a))            # Prints "<class "numpy.ndarray">"
print(a.shape)            # Prints "(3,)"
print(a[0], a[1], a[2])   # Prints "1 2 3"
a[0] = 5                  # Change an element of the array
print(a)                  # Prints "[5, 2, 3]"
b = np.array([[1,2,3],[4,5,6]])    # Create a rank 2 array
print(b.shape)                     # Prints "(2, 3)"
print(b[0, 0], b[0, 1], b[1, 0])   # Prints "1 2 4"

# Numpy also provides many functions to create arrays:
import numpy as np
a = np.zeros((2,2))   # Create an array of all zeros
print(a)              # Prints "[[ 0.  0.]
                      #          [ 0.  0.]]"
b = np.ones((1,2))    # Create an array of all ones
print(b)              # Prints "[[ 1.  1.]]"
c = np.full((2,2), 7)  # Create a constant array
print(c)               # Prints "[[ 7.  7.]
                       #          [ 7.  7.]]"
d = np.eye(2)         # Create a 2x2 identity matrix
print(d)              # Prints "[[ 1.  0.]
                      #          [ 0.  1.]]"
e = np.random.random((2,2))  # Create an array filled with random values
print(e)                     # Might print "[[ 0.91940167  0.08143941]
                             #               [ 0.68744134  0.87236687]]"
```

## 参考

1. http://www.labri.fr/perso/nrougier/from-python-to-numpy/