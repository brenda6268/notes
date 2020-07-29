# 无标题

<!--
ID: c7029d7f-9c44-40d7-a30e-f9318b2fe4d5
Status: draft
Date: 2020-07-29T23:37:30
Modified: 2020-07-29T23:37:30
wp_id: 1756
-->

As someone who has implemented a complex system in C++ in this decade, I’d say he’s not wrong, but you need to carefully weight the pros and cons.
In our case latency and real time demands mattered a lot (NASDAQ feed parser), to the point of the (potential) slowdown of a garbage collector kicking in was enough to rule out Java and .NET. It runs entirely in memory and on 64+ cores.

We implemented our own reference counting system to keep some of our sanity, and to at least try to avoid the worst memory leaks.

This was an edge case, and for almost everything else you’re probably better off implementing it in something that handles memory for you. If performance is an issue, least try it in Go or Rust with a quick PoC before jumping the C++ wagon.


The push for the need of scaling out started with Ruby and Python's lack of performance. The reason being pushed at the time was, "developer time was more expensive than hardware." Well, that didn't count the amortization of developer time over the lifetime of the product once the product was developed.


My good friend built whole career doing exactly the same. "Replace a cluster of 10 Elasticsearch servers with 1 running a custom built C app and in-memory database". Of course, it won't work out to replace 1000 Elasticsearch servers - that's where the advantage of a true "big data" tool will show - but none of the clients really have data "that big".


Currently using Restbed (https://github.com/Corvusoft/restbed) as the server core, wxWidgets as a server side gui, with Boost, Curl, SQLite and Standard Lib. It's not that complex, beyond using lambdas in a few places. It has extremely high performance, and can run on an Intel Compute Stick, but I tend to use an Intel Nuc at minimum, with clients typically using whatever they have, gaining over redundancy and an ability to pair down. The memory management in a C++ application is just another resource one manages with whatever level of algorithm support you feel comfortable. There are ref-counting systems and complete garbage collectors available one can integrate into their business logic, unlike in a high level language that "transparently" manages memory outside application control. Have you ever thought about how much processing a typical 3D video game performs every frame? What if that caliber of optimized algorithm logic were handling a rich media, non-3D game server hosted business application? It would have pretty amazing performance and scale very economically. That's what I do. Before doing this, I wrote 3D video games and their production environments.