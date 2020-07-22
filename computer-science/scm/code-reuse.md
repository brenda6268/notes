# Code Reuse

Date: 2019-10-31

Code reuse sounds good in theory, because people don't want to reinvent the wheel. The modern line of thought is that it is always a Bad Thing to write a custom implementation of a component that is supposedly available as a ready-made product. However, writing your own implementation has big advantages over reusing a ready made third party module:

The features match your need exactly.

You have full control over the roadmap. Bugfixes and extensions can be done immediately if necessary.

Evaluating a ready made module is very time consuming. Furthermore, some shortcomings will surface only after extensive use, when it is too late to switch to another product.

There is as little code to understand as possible, as the implementation matches your case exactly. This is a large benefit when you need to write an extension, as there is less code to understand and to modify.

Extending a ready made module causes a big communication overhead (discussions with the developers maintaining the ready made module). On the other hand, branching the code is untempting because you won't be able to reap benefits from bugfixes and extensions.

All previous remarks assume the ready made module is open source. In most cases, when using a closed source module there is far too little documentation available. This is especially true with frameworks.

Also in the case of closed source, you are fully dependent on the third party supplier. If the manufacturer goes bankrupt, or simply stops support and updates, you'll be forced to find another component, probably breaking backward compatibility.

The license agreement may be too strict.

There certainly are situations in which code reuse is the best option, but it is not always the best choice. Reuse in software development is certainly different from the reuse of bricks when building a wall, for example; or from reinventing the wheel when designing a car.
