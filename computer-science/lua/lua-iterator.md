# Lua 中的迭代器


wp_id: 694
Status: publish
Date: 2017-05-30 13:42:00
Modified: 2020-05-16 12:03:08


Lua中有两种for语句，最基本的是

	for i = 1, 10 do
	    print i
	end
	
	
	
还有一种是for in语句

   for I in pairs(t) do
       print I
   end