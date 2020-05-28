# openresty


wp_id: 692
Status: publish
Date: 2017-05-30 13:44:00
Modified: 2017-05-30 13:44:00


1. The *by_lua modules that tweak the nginx behaviour (for ex the rewrite_by_lua that is the lua equivalent of nginx http rewrite) module are always run after the standard nginx modules.
2. The choice of *by_lua module to use largely depends upon the problem that you are trying to solve. For example the init_by_lua module is used for initialization operations where as access_by_lua may be used to implement access policies for a location block. Personally among the various directives I find most use for content_by_lua. 

From <http://www.staticshin.com/programming/definitely-an-open-resty-guide/> 


http://www.londonlua.org/scripting_nginx_with_lua/slides.html

Lua can access nginx at different phase, the most important directives are:

Rewrite_by_lua	
Access_by_lua	
Content_by_lua	
Init_by_lua	
Set_by_lua	
	

Rememeber to set lua_code_cache when developing

Use `ngx.location.capture` to issue a sub-request to other locations in nginx 

`ngx.ctx` is a lua table to store data with a lifetime