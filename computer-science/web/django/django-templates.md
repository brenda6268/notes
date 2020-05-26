# django templates


ID: 702
Status: publish
Date: 2017-11-13 11:34:00
Modified: 2017-11-13 11:34:00


# marco
 
there is no marco in django template, you just have to use include with parameters

```
{% include "marco.html" with arg=parameter %}
```

# variable

```
{{ my_dict.key }}
{{ my_object.attribute }}
{{ my_list.0 }}
```

If a variable resolves to a callable, the template system will call it with no arguments and use its result instead of the callable.

# tags

# filters