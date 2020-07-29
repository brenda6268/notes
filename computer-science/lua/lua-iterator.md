# Lua 中的迭代器

<!--
ID: 6f526313-3d20-48e3-b018-81b53f0b51e3
Status: publish
Date: 2017-05-30T13:42:00
Modified: 2020-05-16T12:03:08
wp_id: 694
-->

Lua中有两种for语句，最基本的是

	for i = 1, 10 do
	    print i
	end
	
	
	
还有一种是for in语句

   for I in pairs(t) do
       print I
   end