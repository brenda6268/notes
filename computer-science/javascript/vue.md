# 前端框架 Vue 学习笔记


ID: 497
Status: publish
Date: 2017-09-22 04:30:00
Modified: 2020-05-16 11:51:11


之前在网页里小范围的用了vue, 感觉用起来非常爽, 现在打算做自己的笔记应用. 这次打算做成SPA的形式, 前端全部用vue来写. 需要node的一些东西, 记录下学习过程. 迈向全栈，哈哈 ^_^

# 安装
首先, 全局安装vue: 

```bash
npm install --global @vue/cli
```

# data 属性

只有在创建时提供的 data 属性才是响应式的，在创建之后在添加新元素就不管用了。

当然还可以使用 app.$watch 方法显式创建一些监听器

```js
// $watch 是一个实例方法
vm.$watch(&#039;a&#039;, function (newValue, oldValue) {
  // 这个回调将在 &#x60;vm.a&#x60; 改变后调用
})
```

# methods 和 computed

methods 定义了一些可以调用的方法，他的值也可以用来插值。但是最好使用 computed，因为 computed 是有缓存的。

computed 属性也可以设置 setter，所以实际上，computed 属性相当于对现有属性的一种映射和变化。

# v-bind 和 v-model

- v-bind 用于单项绑定：在 HTML 属性中使用 v-bind 绑定, 标签中使用 `{{ }}`。只能使用表达式，而不能使用语句。
- v-model 用于双向绑定：在 input 这类用户可以输入的组件中，需要双向绑定，使用 v-model.

v-bind 类似的指令还有 v-once 和 v-html

v-model 实际上等价于

```html
&lt;input v-model=&quot;searchText&quot;&gt;
```

```html
&lt;input
  v-bind:value=&quot;searchText&quot;
  v-on:input=&quot;searchText = $event.target.value&quot;
&gt;
```

要想在自定义输入组件中支持 v-model 的话，就需要使用 v-bind 和 v-on 两个方法了，而不能直接使用 v-model。

# v-if 和 v-for

这两个就和所有模板系统中的 if 和 for 一样。vue 中提供的额外方便之处是，可以使用 template 标签，这样就不会多一个标签了

vue 是懒渲染的，因此会尽可能地复用组件，可以使用 key 来区分

v-if 是真正的条件式渲染，v-show 则只是在切换 display 属性

vue 没有代理数组的赋值方法，所以需要使用 app.$set 方法

# @

如果只是指定一个事件处理函数的话，那么参数就是 event。如果自己指定了参数的话，可以使用 $event 来代表 event

还可以使用 .prevent 和 .stop 等修饰符


# component

vue 中最终要的概念就是组件了。使用组件来模块式得构建应用。需要通过 props 属性来定义组件中的属性

```html
&lt;div id=&quot;app-7&quot;&gt;
  &lt;ol&gt;
    &lt;!--
      现在我们为每个 todo-item 提供 todo 对象
      todo 对象是变量，即其内容可以是动态的。
      我们也需要为每个组件提供一个“key”，稍后再
      作详细解释。
    --&gt;
    &lt;todo-item
      v-for=&quot;item in groceryList&quot;
      v-bind:todo=&quot;item&quot;
      v-bind:key=&quot;item.id&quot;&gt;
    &lt;/todo-item&gt;
  &lt;/ol&gt;
&lt;/div&gt;

Vue.component(&#039;todo-item&#039;, {
  // todo-item 组件现在接受一个
  // &quot;prop&quot;，类似于一个自定义特性。
  // 这个 prop 名为 todo。
  props: [&#039;todo&#039;],
  template: &#039;&lt;li&gt;{{ todo.text }}&lt;/li&gt;&#039;
})
```

props 是一个数组，用来声明组建的属性。然后通过属性来传递。

组件还可以通过 $emit 来发送事件，这些事件可以被所有的组件监听到，就像普通的 DOM 事件一样。

# 声明周期函数

在固定的周期，vue 会调用的一些函数 created, mounted 等。需要注意的是，不要使用胖箭头函数。

```html
new Vue({
  data: {
    a: 1
  },
  created: function () {
    // &#x60;this&#x60; 指向 vm 实例
    console.log(&#039;a is: &#039; + this.a)
  }
})
// =&gt; &quot;a is: 1&quot;
```

# 创建vue应用

因为我们会直接通过`*.vue`文件来编写vue的组件, 因此需要使用webpack打包编译. 另外我们需要使用官方的vue-router来

```bash
vue init webpack notelet
```

这条命令基于 webpack 这个模板创建了notelet这个应用, 也就是我们的笔记应用.

打开 `src/router/index.js` 可以看到 vue 创建的router的代码, 其中`@`是`src`目录的缩写.

```html
import Vue from &#039;vue&#039;
  import Router from &#039;vue-router&#039;
import Hello from &#039;@/components/Hello&#039;

Vue.use(Router)

export default new Router({
  routes: [
    {
    ¦ path: &#039;/&#039;,
    ¦ name: &#039;Hello&#039;,
    ¦ component: Hello
    }
  ]
})
```

然后打开 `src/main.js`, 可以看到在里面使用了 `App` 来作为我们的跟组件

```js
// The Vue build version to load with the &#x60;import&#x60; command
// (runtime-only or standalone) has been set in webpack.base.conf with an alias.
import Vue from &#039;vue&#039;
import App from &#039;./App&#039;
import router from &#039;./router&#039;

Vue.config.productionTip = false

/* eslint-disable no-new */
new Vue({
  el: &#039;#app&#039;,
  router,
  template: &#039;&lt;App/&gt;&#039;,
  components: { App }
})
```

执行 `npm run dev`, 然后打开 http://localhost:8080/ 就可以看到我们的vue应用了. 注意, 在写这篇文章的时候 node 8.x 下似乎有bug, 导致 app.js 加载不出来, 安装 6.x 就好了. 该死的node.

打开 `App.vue`, 也就是我们的根组件, 可以看到下面的内容

```html
&lt;template&gt;
  &lt;div id=&quot;app&quot;&gt;
  ¦ &lt;router-view&gt;&lt;/router-view&gt;
  &lt;/div&gt;
&lt;/template&gt;

&lt;script&gt;
export default {
  name: &#039;app&#039;
}
&lt;/script&gt;

&lt;style&gt;
#app {
  font-family: &#039;Avenir&#039;, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
&lt;/style&gt;
```

注意其中的 router-view 便签, 意思就是路由的内容都在 router-view 中显示.

# 添加一个新的组件和路由
接下来我们添加一个"关于"页面. 打开`src/router/index.js`, 改成下面这样:

```js
export default new Router({
  routes: [
  ¦ {
  ¦ ¦ path: &#039;/&#039;,
  ¦ ¦ name: &#039;Hello&#039;,
  ¦ ¦ component: Hello
  ¦ },
  ¦ {
  ¦ ¦ path: &#039;/about&#039;,
  ¦ ¦ name: &#039;About&#039;,
  ¦ ¦ component: About
  ¦ }
  ]
})
```

然后添加 `src/components/About.vue` 文件

```html
&lt;template&gt;
  &lt;div class=&quot;hello&quot;&gt;
  ¦ &lt;h1&gt;About Notelet&lt;/h1&gt;
  ¦ &lt;p&gt;This is a simple note app&lt;/p&gt;
  &lt;/div&gt;
&lt;/template&gt;

&lt;script&gt;
export default {
  name: &#039;About&#039;,
  data () {
  ¦ return {
  ¦ ¦ msg: &#039;Hello Vue&#039;
  ¦ }
  }
}
&lt;/script&gt;
```

然后更改 `App.vue` 文件

```html
&lt;template&gt;
  &lt;div id=&quot;app&quot;&gt;
  ¦ &lt;router-link :to=&quot;{name: &#039;Hello&#039;}&quot;&gt;Home&lt;/router-link&gt;
  ¦ &lt;router-link to=&quot;/about&quot;&gt;About&lt;/router-link&gt;
  ¦ &lt;router-view&gt;&lt;/router-view&gt;
  &lt;/div&gt;
&lt;/template&gt;
```

注意, 我们使用about指向了 About 这个组件, 而使用 hello 指向了 Hello 这个组件, 注意其中还动态传递了参数.



[1] https://scotch.io/tutorials/getting-started-with-vue-router