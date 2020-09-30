# thinking in vue

<!--
ID: 94f516a6-7fa2-4046-a787-ae47cc0f0765
Status: publish
Date: 2017-06-10T04:03:00
Modified: 2017-06-10T04:03:00
wp_id: 509
-->

# basic usage

The created vue instance will proxy its data member

```html
<div id="app">
  <ol>
    <li v-for="company in companies">
      <a v-bind:href="company.link">{{ company.text }}</a>  // bind 更新参数
            <button v-on:click="reverseText">逆转消息</button>
    </li>
  </ol>
</div>

let vm = new Vue({
    el: '#app',
    data: {
        companies: [
                {text: 'Google', link: 'http://google.com'},
                    {text: 'fackbook', link: 'http://facebook.com'},
                    {text: 'apple', link: 'http://apple.com'}
            ]
    },
    methods: {
        reverseText: function() {
        // 注意 this 绑定到了触发这个事件的元素内部
                this.company.text = this.company.text.split('').reverse.join('');
            }
    }
});

vm.companies.push({text: 'Amazon', link: 'http://amazon.com'});
```


```js
// computed 属性可以绑定一个虚拟的属性到几个不同的属性上，有点类似 python 的 @property
// ...
computed: {
  fullName: {
    // getter
    get: function () {
      return this.firstName + ' ' + this.lastName
    },
    // setter
    set: function (newValue) {
      var names = newValue.split(' ')
      this.firstName = names[0]
      this.lastName = names[names.length - 1]
    }
  }
}
// ...
```

```js
# 适合用来做自动保存文档等工作
<script>
var watchExampleVM = new Vue({
  el: '#watch-example',
  data: {
    question: '',
    answer: 'I cannot give you an answer until you ask a question!'
  },
  watch: {
    // 如果 question 发生改变，这个函数就会运行
    question: function (newQuestion) {
      this.answer = 'Waiting for you to stop typing...'
      this.getAnswer()
    }
  },
  methods: {
    // _.debounce 是一个通过 lodash 限制操作频率的函数。
    // 在这个例子中，我们希望限制访问 yesno.wtf/api 的频率
    // ajax 请求直到用户输入完毕才会发出
    // 学习更多关于 _.debounce function (and its cousin
    // _.throttle)，参考：https://lodash.com/docs#debounce
    getAnswer: _.debounce(
      function () {
        if (this.question.indexOf('?') === -1) {
          this.answer = 'Questions usually contain a question mark. ;-)'
          return
        }
        this.answer = 'Thinking...'
        var vm = this
        axios.get('https://yesno.wtf/api')
          .then(function (response) {
            vm.answer = _.capitalize(response.data.answer)
          })
          .catch(function (error) {
            vm.answer = 'Error! Could not reach the API. ' + error
          })
      },
      // 这是我们为用户停止输入等待的毫秒数
      500
    )
  }
})
</script>
```

## flow control

### v-if

v-else 元素必须紧跟在 v-if 或者 v-else-if 元素的后面——否则它将不会被识别。v-else-if 也是。

可以使用 template 来包装多个元素：


```
<template v-if="ok">
  <h1>Title</h1>
  <p>Paragraph 1</p>
  <p>Paragraph 2</p>
</template>
```




### v-for

v-for 的基本语法如前所述，另外还可以采用可选参数 key. `<li v-for="(item, index) in items">`.

v-for 还可以遍历对象，`<li v-for="value in obj">`

v-for 还可以直接遍历 range, `<li v-for="n in 10">`

## 事件

在 vue 中，绑定的事件如果需要参数，可以使用

```
<button v-on:click="warn('Form cannot be submitted yet.', $event)">
  Submit
</button>
```

的形式，其中 $event 指的是原声事件。

### 修饰符

vue 中的事件绑定函数可以使用一些修饰符来指定一些附加的效果。常用的有 `.prevent`, `.stop`, `.self`, `.once` 等。

像这样：`<a v-on:click.stop="doThis"></a>`

对于键盘时间，还可以使用修饰符来指定键值：`<input v-on:keyup.enter="submit">`


## mustache vs `v-bind`
mustache can only be used in textContent of an element, `v-bind` is used for attribute.

```
<a v-bind:href="url">{{ link_text }}</a>
```

## shortcut

```
<!-- 完整语法 -->
<a v-bind:href="url"></a>
<!-- 缩写 -->
<a :href="url"></a>
```

```
<!-- 完整语法 -->
<a v-on:click="doSomething"></a>
<!-- 缩写 -->
<a @click="doSomething"></a>
```

## v-model 做双向绑定

use v-model to double bind data between input and js.
```
<div id="app-6">
  <p>{{ message }}</p>
  <input v-model="message">
</div>

var app6 = new Vue({
  el: '#app-6',
  data: {
    message: 'Hello Vue!'
  }
})
```

值得注意的是，v-model 本质上只是一个语法糖。
`<input v-model="something">` is just a syntax sugar to `<input v-bind:value="something" v-on:input="something = $event.target.value">`

### text area

需要注意的是，textarea 时间上相当于一个 input 组件，不能在 testarea 内部使用 {{value}} 的语法，而应该使用 `v-model`

```
<span>Multiline message is:</span>
<p style="white-space: pre-line;">{{ message }}</p>
<br>
<textarea v-model="message" placeholder="add multiple lines"></textarea>
```

### 修饰符

就像事件一样，也可以指定一些修饰符给 v-model, 常用的有 `.trim`

# vue-component
<img src="https://cn.vuejs.org/images/components.png" width=360 />

vue 的 component 中三个重要的概念：props, events, slots.

其中 props 向下传递，用于 parent 组件向 child 组件传递值。child 组件对于 props 的访问只能是只读的。在 child 组件中使用`v-bind:var="var"`来访问定义的 props. 注意在组件中不能更改 props, 如果需要更改他，请把他赋值给其他变量，或者使用 computed 属性。

如果把模板直接放到 dom 中会有一些标签渲染不出来，建议放到 <script type="text/x-template"></script> 中



```
// 在 vue 中注册一个组件，大多数传递给 vue 实例的参数都可以使用，除了 data 必须是一个函数

Vue.component('todo-item', {
  // todo-item 组件现在接受一个"prop"，类似于一个自定义属性。这个属性名为 todo。
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>',
  data: function() {},
})

<div id="app-7">
  <ol>
    <!-- 现在我们为每个 todo-item 提供待办项对象    -->
    <!-- 待办项对象是变量，即其内容可以是动态的 -->
    <todo-item v-for="item in groceryList" v-bind:todo="item"></todo-item>
  </ol>
</div>

Vue.component('todo-item', {
  props: ['todo'],
  template: '<li>{{ todo.text }}</li>'
})
var app7 = new Vue({
  el: '#app-7',
  data: {
    groceryList: [
      { text: '蔬菜' },
      { text: '奶酪' },
      { text: '随便其他什么人吃的东西' }
    ]
  }
})
```

### 事件

parent 组件可以监听子组件的事件，从而实现通信：

这个例子中，子组件通过 $emit() 函数发送 increment 事件。parent 组件通过监听子组件的 increment 事件，从而获得子组件的消息。
```
<div id="counter-event-example">
  <p>{{ total }}</p>
  <button-counter v-on:increment="incrementTotal"></button-counter>
  <button-counter v-on:increment="incrementTotal"></button-counter>
</div>
Vue.component('button-counter', {
  template: '<button v-on:click="incrementCounter">{{ counter }}</button>',
  data: function () {
    return {
      counter: 0
    }
  },
  methods: {
    incrementCounter: function () {
      this.counter += 1
      this.$emit('increment')
    }
  },
})
new Vue({
  el: '#counter-event-example',
  data: {
    total: 0
  },
  methods: {
    incrementTotal: function () {
      this.total += 1
    }
  }
})
```

### slots

slots vs props: slots 用于显示一大片的包含 html 代码的替换块，而 props 用于显示值，有点类似 v-bind 和 {{}} 的区别。

Props 允许外部环境传递数据给组件
Events 允许从外部环境在组件内触发副作用
Slots 允许外部环境将额外的内容组合在组件中。

# vue router
basic: 将组件 (components) 映射到路由 (routes)，然后告诉 vue-router 在哪里渲染它们。

```
<div id="app">
  <p>
    <router-link to="/user/foo">/user/foo</router-link>
    <router-link to="/user/bar">/user/bar</router-link>
  </p>
  <router-view></router-view>
</div>

<script>
const User = {
  template: `<div>User {{ $route.params.id }}</div>`
}

const router = new VueRouter({
  mode: 'history',  // 这样才能使用 html5 的 history api
  routes: [
    { path: '/user/:id', component: User }
  ]
})

const app = new Vue({ router }).$mount('#app')
</script>
```

# vue lifecycle

<img src="https://cn.vuejs.org/images/lifecycle.png" width=640 />

# using in chrome extension

chrome does not allow `eval` and `new Function()` in extensions, vue relies on it. you need to use CSP version of vue or relax the restriction by chrome.

See also:

* https://developer.chrome.com/extensions/contentSecurityPolicy#relaxing-eval
* https://stackoverflow.com/questions/34615503/vue-js-in-chrome-extension
* https://vuejs.org/v2/guide/installation.html#CSP-environments
