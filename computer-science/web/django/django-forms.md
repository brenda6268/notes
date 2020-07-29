# django forms

<!--
ID: 44bd2df9-fda0-444d-8f4e-530f1e417a85
Status: publish
Date: 2018-05-01T04:52:00
Modified: 2018-05-01T04:52:00
wp_id: 696
-->

django 中的 form 和 model 的用法很像，都是定义一个类，然后指定一些字段就可以了

最简单的form

```py
from django import forms

class ContactForm(forms.Form):
    subject = forms.CharField(max_length=100)
    email = forms.EmailField(required=False)
    message = forms.CharField(widget=forms.Textarea)

    def clean_message(self):
        message = self.cleaned_data['message']
        num_words = len(message.split())
        if num_words < 4:
            raise forms.ValidationError("Not enough words!")
        return message
```

```py
def contact(request):
    if request.method == 'POST':
        form = ContactForm(request.POST)
        if form.is_valid():
            cd = form.cleaned_data
            send_mail(
                cd['subject'],
                cd['message'],
                cd.get('email', 'noreply@example.com'),
                ['siteowner@example.com'],
            )
            return HttpResponseRedirect('/contact/thanks/')
    else:
        form = ContactForm()
        return render(request, 'contact_form.html', {'form': form})
```

```jinja
<form action="" method="post">
    <table>
        {{ form.as_table }}
    </table>
    {% csrf_token %}
    <input type="submit" value="Submit">
</form>
```

方法 | 用法
------|------
`form.__str__()` | return table representation
form.as_p() | return p representation
form.as_li() | return li representation
`form.__getitem__()` | return element tag
`form.__init__(dict)` | fill values
form.is_bound | 
form.is_valid() | 
form.cleaned_data | 

Note not include table/ul/form tags, just the inside tags

## ajax

ajax 中如何指定 crsf token

axios 中：

```js
import axios from 'axios';
axios.defaults.xsrfHeaderName = "X-CSRFTOKEN";
axios.defaults.xsrfCookieName = "csrftoken";
```

settings.py 中

```
CSRF_COOKIE_NAME = "csrftoken"
```

## 参考

https://stackoverflow.com/questions/39254562/csrf-with-django-reactredux-using-axios