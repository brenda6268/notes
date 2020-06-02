Honestly, skip all of the courses. Pick a problem to solve, start googling for common models that are used to solve the problem, then go on github, find code that solves that problem or a similar one. Download the code and start working with it, change it, experiment. All of the theory and such is mostly worthless, its too much to learn from scratch and you will probably use very little of it. There is so much ml code on github to learn from, its really the best way. When you encounter a concept you need to understand, google the concept and learn the background info. This will give you a highly applied and intuitive understanding of solving ml problems, but you will have large gaps. Which is fine, unless you are going in for job interviews.
Also bear in mind that courses like fast.ai (as you see plastered on here), aggresively market themselves by answering questions all over the internet. Its a form of SEO.

EDIT (Adding this here to explain my point better):

My opinion is that the theory starts to make sense after you know how to use the models and have seen different models produce different results.

Very few people can read about bias variance trade off and in the course of using a model, understand how to take that concept and directly apply it to the problem they are solving. In retrospect, they can look back and understand the outcomes. Also, most theory is useless in the application of ML, and only useful in the active research of new machine learning methods and paradigms. Courses make the mistake of mixing in that useless information.

The same thing is true of the million different optimizers for neural networks. Why different ones work better in different cases is something you would learn when trying to squeeze out performance on a neural network. Who here is intelligent enough to read a bunch about SGD and optimization theory (Adam etc), understand the implications, and then use different optimizers in different situations? No one.

I'm much better off having a mediocre NN, googling, "How to improve my VGG image model accuracy", and then finding out that I should tweak learning rates. Then I google learning rate, read a bit, try it on my model. Rinse and repeat.

Also, I will throw in my consiracy theory that most ML researchers and such push the theory/deep stats requirement as a form of gatekeeping. Modern deep learning results are extremely thin when it comes to theoretical backing.