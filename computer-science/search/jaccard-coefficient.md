# Jaccard coefficient(杰拉德距离)

<!--
ID: c4144bb3-6e3c-4142-957d-143dc965c952
Status: publish
Date: 2017-05-30T09:45:00
Modified: 2020-05-16T12:01:04
wp_id: 485
-->

the jaccard index is a simple measure of how similiar two sets are.
it's simply the ratio of the size of the intersection of the sets and the size of the union of the sets.


eg.
```
if J(A,B) is jaccard index between sets A and B
and A = {1,2,3}, B = {2,3,4}, C = {4,5,6},
then J(A,B) = 2/4 = 0.5,
and J(A,C) = 0/6 = 0,
and J(B,C) = 1/5 = 0.2
so the most "similiar" sets are A and B and the least similiar are A and C
(note also J(A,A) = J(B,B) = J(C,C) = 1)
```

we have to consider what the values(jaccard coefficient) would be in real world. how are the distributed.

Jeccard coeffi is not transtive, so, for a set of n sentences, we have to calculate O(n2) times. There is a way to do it in O(n) time

map N-grams to a set of numbers, then use bit to express whether the N-gram exists in one word/sententce.

```
A = mat -> {ma, at} \                              / 101 \    
					--> {ma(2), ca(1), at(0)} ->         --> &amp;(001), |(111)
B = cat -> {ca, at} /                              \ 011 /

```

J(A, B) = and(A, B)/or(A, B)

let X = card(A ^ B), let U = card(A U B)
let J(A, B) = X / (X + U)
