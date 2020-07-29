# 无标题

<!--
ID: e5452b67-39b7-4c60-9652-7d78a208ae1d
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1754
-->

From: https://news.ycombinator.com/item?id=21927427

Main idea: backpressure is important and async does not solve it.

---
IMHO all the rage on async comes from an era when interpreted languages where the main trend as they demonstrably increased developer productivity --I'm looking at you, Rails, Django. Those platforms were not designed for runtime speed, so it made sense to push the bottleneck to the most inmediate backend system in the chain (i.e.: your trusty database, which is much faster than your agile framework of choice, remember the discussions of ORMs versus pure SQL?)
Then there came async frameworks a la Node, Twisted et al. and changed everything. Again in my opinion, async code is harder to reason about versus synchronous code.

Things to keep in mind:

- Are you really working at scale? Does the arguably added complexity of async benefit your particular use case? Specially when SPA technologies allow to build simpler backend for frontend systems (pure API, no HTML rendering). And not only regarding pure operational performance, Rails is still impossibly hard to beat when it comes to productivity.

- New players like Go, Rust have async capabilities but you dont necessarily need to use them to perform closer to native speed, hence becoming simpler solutions than Node, Ruby, or Python. Guess that also applies to old dogs with new tricks in the JVM (Micronaut, Quarkus...)

---
FWIW, having climbed Twisted's learning curve long ago the current async-all-the-things fad looks so childish to me. I remember when Tornado came out and I was like, why would you use a go-kart when there's a free Maserati right there?
https://twistedmatrix.com/trac/


---

I really wish we had more control over the scheduling of async tasks.
For a javascript example I ran into recently, say I am firing off a fetch for each image that comes into view in a large gallery. If I suddenly scroll down to the 1000th image, a naive implementation might fire off 1000 fetches for all the images we scrolled past. Then you'll be waiting a long time before the images in your current viewport is loaded.

Backpressure can save you a little bit here. Say you do the semaphore trick mentioned in the article and only allow a max of say 10 fetches in flight at once. Then if you quickly scroll through, all the subsequent fetches after the initial should fail, including the ones at the viewport you stop at. But since the queue is short, when the images in your current viewport retries it should now succeed.

This works but it isn't ideal. Ideally I would be able to just reprioritize the newer fetches to be LIFO instead of FIFO. Or maybe inspect what's currently queued up (and how big the queue is) so I can cancel everything that I don't need.

The backpressure solutions might just be a symptom of async tasks not being controllable in any way once started which is why you're forced to commit to it or not from the start even if that might not be the best point in time to make that decision.