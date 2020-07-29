# django templates

<!--
ID: 27650cae-5e98-4040-8ffe-96457f5dd84a
Status: publish
Date: 2017-11-13T11:34:00
Modified: 2017-11-13T11:34:00
wp_id: 702
-->

## marco
 
there is no marco in django template, you just have to use include with parameters

```
{% include "marco.html" with arg=parameter %}
```

## variable

```
{{ my_dict.key }}
{{ my_object.attribute }}
{{ my_list.0 }}
```

If a variable resolves to a callable, the template system will call it with no arguments and use its result instead of the callable.

# tags

# filters