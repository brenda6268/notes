# Rails 学习笔记

<!--
ID: bfae1ea6-49f7-4bc3-960c-1e2f549a531a
Status: draft
Date: 2020-08-18T11:11:50
Modified: 2020-08-18T11:11:50
wp_id: 1872
-->

因为工作的关系，需要接受一个 RoR 的项目，花一下午时间学习一下 Ruby 和 Rails. 还好在大学的时候读过关于 Ruby 的一本书，语法基本还是知道一些的。

Rails 是一个典型的 MVC 的 web 框架。

Controller 需要继承 ApplicationController 基类。对于每一个路径 `http://xxx.com/my-controller/action` 都对应了 `app/controllers/my_controller.rb` 下的 MyController 类的 action 方法，然后会渲染 `app/views/my-contoller/action.html.erb` 文件。即使方法是空的，也会渲染对应的 erb/haml 模板。

rails 会把 controller 中所有的类变量都传递到模板中，所以如果有需要渲染的变量，直接使用类变量就行了，而不用显式传递。

可以使用 before_action 来增加一些钩子函数，比如要求登录之类的。

## 目录结构

- app/ 目录是主要的代码目录。
  - app/controllers/ 存放 controllers
  - app/views/ 存放 views, 也就是 erb 或者 haml 的模板代码
- `lib/tasks/*.rake` 中存放的是可以通过 rake 调用的任务。
- 路由表位于 `config/routes.rb` 文件
- `config/schedule.rb` 文件存放 whenever 管理的 cron 任务。

## 路由

在 `config/routes.rb` 中的 DSL 可以使用不同的方法定义路由：

- `resources` 定义一个典型的 REST 资源。

## Ruby 语法基础

Ruby 的 Slice 和 Python 是不同的，有以下两点：

- Ruby 使用 `..` 而不是 `:`. `string[0..8]`
- Ruby 的 slice 表示的是闭区间，而不是其他语言的前开后闭区间。

一般语言中会使用 `is_valid` 来表示一个布尔值，而 ruby 中习惯使用 `valid?`, 其中的 `?` 就是一个普通的字符。

### 字符串的方法

`len(s)` -> `s.length`
`s.replace()` -> `s.sub()` or `s.gsub()`
`f"hello {name}"` -> `hell #{name}`

### 符号

我实在不知道符号这个东西有什么用处，string 本身不就应该是 internized 的么

### 块

ruby 算是比较有创新精神，可以使用 `n.times` 来表示一个循环。

```ruby
5.times do
  puts "Hello, World!"
end
```

块还可以接收参数，使用  `|`

```ruby
5.times do |i|
  puts "#{i}: Hello, World!"
end
```

在 Python 中如果你输入 `import braces` 那么会得到 `not a chance` 错误，但是在 ruby 中，我们是可以使用大括号的。😂

### 数组和字典

`<<` 可以用来 append
`.sort` 不会改变原数组。
还可以使用 `.each` + 块来遍历数组。

字典

使用字符串作为 key
 
```ruby
prices = {"apples" => 3, "oranges" => 1, "carrots" => 12}
```

使用符号作为 key

```ruby
{apples: 3, oranges: 1, carrots: 12}
```

ruby 中使用 if/elsif/else 语句，注意其中多了一个 s.

ruby 中使用 `&&` 和 `||` 来表示 `and` 和 `or`.

`nil` 表示 `None`.

Ruby 中字符串是可变的

Ruby 中除了 false, nil 以外都是真的，也就是 `0` `""` 也是真的

### 面向对象

class 中使用 `attr_accessor` 来设置属性。方法签名中不需要使用 self 参数，函数体中也不需要使用 self 来访问属性。使用 `attr_accessor` 定义的属性可以认为是 `public` 的，而如果想要 `private` 的属性的话，可以使用 `@var` 语法，`@variable` 不需要声明，直接使用就行。

创建实例的话需要使用 `.new` 方法。`MyClass.new`. Ruby 中的构造函数是 `initialize`, 相比 `__init__` 来说，太难拼写了。

```ruby
class Student
  attr_accessor :first_name, :last_name, :primary_phone_number

  def introduction  # 这里没有 self
    puts "Hi, I'm #{first_name}!"  # 这里不用 self
  end
end

frank = Student.new
puts frank.first_name
frank.first_name = "Max"
frank.introduction  # 函数调用不用括号
```

Ruby 中的 `require` 使用来实现其他语言的 `inlcude` 或者 `import` 操作的，而 `include` 关键字是用来实现 `mixin` 的。

### 捕获异常

Ruby 中使用 begin/rescue/ensure 来表示 try/except/finally 的逻辑。有个语法糖，如果在函数中的话，可以直接以 def 未开始，而不用显式地 begin 了。

```ruby
begin
  # ...
rescue
  # ...
ensure
  # this always runs
end
```

## 参考资料

1. https://www.jianshu.com/p/99b4552b512f
2. https://stackoverflow.com/questions/12924080/difference-between-instance-variable-and-attr-accessor
3. https://www.ruby-lang.org/en/documentation/quickstart/
4. https://guides.rubyonrails.org/getting_started.html
5. https://docs.ruby-lang.org/en/2.4.0/syntax/exceptions_rdoc.html
6. https://www.rubyguides.com/2019/02/ruby-rake/