# numpy 入门


ID: 476
Status: draft
Date: 2018-06-23 02:44:00
Modified: 2020-05-16 11:14:25


From Python to Numpy

http://www.labri.fr/perso/nrougier/from-python-to-numpy/


可视化的 numpy 教程：https://jalammar.github.io/visual-numpy/

Write comments

Numpy is a very powerful library and you can make wonders with it but, most of the time, this comes at the price of readability. If you don't comment your code at the time of writing, you won't be able to tell what a function is doing after a few weeks (or possibly days).

np.array

np.array is the basic structure is numpy. It's a n-dimension array

directly from a python list or lists

```
print(type(a))            # Prints &quot;&lt;class &#039;numpy.ndarray&#039;&gt;&quot;
print(a.shape)            # Prints &quot;(3,)&quot;
print(a[0], a[1], a[2])   # Prints &quot;1 2 3&quot;
a[0] = 5                  # Change an element of the array
print(a)                  # Prints &quot;[5, 2, 3]&quot;
b = np.array([[1,2,3],[4,5,6]])    # Create a rank 2 array
print(b.shape)                     # Prints &quot;(2, 3)&quot;
print(b[0, 0], b[0, 1], b[1, 0])   # Prints &quot;1 2 4&quot;

# Numpy also provides many functions to create arrays:
import numpy as np
a = np.zeros((2,2))   # Create an array of all zeros
print(a)              # Prints &quot;[[ 0.  0.]
                      #          [ 0.  0.]]&quot;
b = np.ones((1,2))    # Create an array of all ones
print(b)              # Prints &quot;[[ 1.  1.]]&quot;
c = np.full((2,2), 7)  # Create a constant array
print(c)               # Prints &quot;[[ 7.  7.]
                       #          [ 7.  7.]]&quot;
d = np.eye(2)         # Create a 2x2 identity matrix
print(d)              # Prints &quot;[[ 1.  0.]
                      #          [ 0.  1.]]&quot;
e = np.random.random((2,2))  # Create an array filled with random values
print(e)                     # Might print &quot;[[ 0.91940167  0.08143941]
                             #               [ 0.68744134  0.87236687]]&quot;
```