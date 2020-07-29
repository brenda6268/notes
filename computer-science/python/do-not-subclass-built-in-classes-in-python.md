# do not subclass built-in classes in python

<!--
ID: b6f2706a-866c-4284-95b2-5d3ec931f112
Status: publish
Date: 2017-05-30T13:17:00
Modified: 2017-05-30T13:17:00
wp_id: 660
-->

In short, they will not behave what you think they will. you think dict.get in implemented in python, like:

```
def get(self, key, default=None):
    try:
        return self[key]
    except KeyError:
        return default
```

However, they dict.get do not call __getitem__, and they are implemented in c separately, and do not call each other.

so, when you implement __geitem__, get is not automatically altered! which is very dangerous.

What you need do, subclass collections.abc.Mapping

source:

[1] http://www.kr41.net/2016/03-23-dont_inherit_python_builtin_dict_type.html