# AI is still just curve fitting

<!--
ID: 1a140199-e0cf-4b5c-bcdb-7512cdd72219
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1749
-->

When will people wake up and realize that AI today is just capable of "curve fitting"?

Yes, that is a bit of a simplification. But not far off.

Neural networks depend on back propagation. They are really just another type of optimizer for maximum likelihood, using gradient descent. They work better on high dimensional, non linear data than other methods before.

But if the function you are attempting to model is non differentiable, neural networks won't help you.

They certainly aren't capable of performing magic tricks like writing an app for you.
