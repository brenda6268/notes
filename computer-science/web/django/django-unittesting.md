# django 单元测试

<!--
ID: 59cc9a87-2838-4e31-bf96-00808b3ed43b
Status: publish
Date: 2018-06-17T23:39:00
Modified: 2020-05-16T11:41:19
wp_id: 703
-->

和普通的单元测试不同的是，django 单独提供了一个测试模块，所有的 TestCase 需要继承 `django.test.TestCase`。

## 简单的测试

```python
from django.test import TestCase
from myapp.models import Animal


class AnimalTestCase(TestCase):
    def setUp(self):
        Animal.objects.create(name="lion", sound="roar")
        Animal.objects.create(name="cat", sound="meow")

    def test_animals_can_speak(self):
        """Animals that can speak are correctly identified"""
        lion = Animal.objects.get(name="lion")
        cat = Animal.objects.get(name="cat")
        self.assertEqual(lion.speak(), "The lion says "roar"")
        self.assertEqual(cat.speak(), "The cat says "meow"")
```

对于需要测试服务器的测试用例，可以使用 `django.test.Client` 类

```python
from django.test import TestCase
 
class SimpleTest(TestCase):
    def test_details(self):
        response = self.client.get("/customer/details/")
        self.assertEqual(response.status_code, 200)

    def test_index(self):
        response = self.client.get("/customer/index/")
        self.assertEqual(response.status_code, 200)

```