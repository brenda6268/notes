# django 单元测试


ID: 703
Status: publish
Date: 2018-06-17 23:39:00
Modified: 2020-05-16 11:41:19


和普通的单元测试不同的是，django 单独提供了一个测试模块，所有的 TestCase 需要继承 `django.test.TestCase`。

# 简单的测试

```python
from django.test import TestCase
from myapp.models import Animal


class AnimalTestCase(TestCase):
    def setUp(self):
        Animal.objects.create(name=&quot;lion&quot;, sound=&quot;roar&quot;)
        Animal.objects.create(name=&quot;cat&quot;, sound=&quot;meow&quot;)

    def test_animals_can_speak(self):
        &quot;&quot;&quot;Animals that can speak are correctly identified&quot;&quot;&quot;
        lion = Animal.objects.get(name=&quot;lion&quot;)
        cat = Animal.objects.get(name=&quot;cat&quot;)
        self.assertEqual(lion.speak(), &#039;The lion says &quot;roar&quot;&#039;)
        self.assertEqual(cat.speak(), &#039;The cat says &quot;meow&quot;&#039;)
```

对于需要测试服务器的测试用例，可以使用 `django.test.Client` 类

```python
from django.test import TestCase
 
class SimpleTest(TestCase):
    def test_details(self):
        response = self.client.get(&#039;/customer/details/&#039;)
        self.assertEqual(response.status_code, 200)

    def test_index(self):
        response = self.client.get(&#039;/customer/index/&#039;)
        self.assertEqual(response.status_code, 200)

```