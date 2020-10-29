# 学习 React

<!--
ID: 2540d668-5922-41e0-a69f-ce82a68582de
Status: publish
Date: 2019-03-13T00:00:00
Modified: 2020-05-28T14:09:32
wp_id: 1196
-->

当我第一次接触前端的时候，那时候流行的是后端 MVC 模式。过去写界面的方法是，把所有的结构 (html)，动作 (js)，样式 (css) 分开，好处是非侵入，离了谁都能工作，缺点是无法模块化，在 js 无足轻重，甚至有 noscript 这种插件的过去显然是最佳实践，但是到了 js 大行其道的今天显然模块化又被提出来了。

react 中也没有模板中的  {% block xxx %} 这个概念，直接使用 props。 

## Hello World

```jsx
ReactDOM.render(
  <h1>Hello, world!</h1>,
  document.getElementById('root')
);
```

Jsx 中可以使用大括号插值。对于 html 中不能自闭合的标签，都可以闭合

```jsx
const element = (
  <h1 className="greeting">
    Hello, world!
  </h1>
);
const element = React.createElement(
  'h1',
  {className: 'greeting'},
  'Hello, world!'
);
```

一个函数就可以是一个组件。在 React 16 是时代，就不要再用 class 了，统一用函数式组件就好了。

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

// 相当于
class Welcome extends React.Component {
  render() {
    return <h1>Hello, {this.props.name}</h1>;
  }
}

const element = <Welcome name="Sara" />;
ReactDOM.render(
  element,
  document.getElementById('root')
);
```

props 只有向下传递一种方式。所有的函数都必须是纯函数。使用函数作为组件的一个不好就是没有办法保存状态。另一个缺点就是不方便使用生命周期函数。

使用 setState 更新状态。setState 是异步的，因此不能使用 += 类似的操作符，而要传递回调函数。

## 事件

react 的事件和 HTML 的不同。首先属性是 camelCase 的；不能通过 return false 来阻止事件，必须调用 e.preventDefault。

```html
<button onClick={activateLasers}>
  Activate Lasers
</button>
```

一般情况下，在 React 中是不需要调用 addEventListener。

需要注意的是，如果把类的方法直接绑定给事件的话，会导致 this 错乱。因为 js 的事件会替换掉 this。所以最好还是用一个箭头函数。

## 条件渲染

React 是 functional 的。所有 React 组件都必须像纯函数一样保护它们的 props 不被更改。state 是组件内部的状态。

key 是一个很关键的概念，有点像是 html 中的 ID， 用来唯一标示一个元素，因为 react 会尽可能复用元素。但是 key 不需要是全局唯一的，只需要在兄弟元素之间唯一即可。

```jsx
function NumberList(props) {
  const numbers = props.numbers;
  const listItems = numbers.map((number) =>
    <li key={number.toString()}>
      {number}
    </li>
  );
  return (
    <ul>{listItems}</ul>
  );
}

const numbers = [1, 2, 3, 4, 5];

ReactDOM.render(
  <NumberList numbers={numbers} />,
  document.getElementById('root')
);
```

## 组合

在 React 中不要使用继承来组织组件，而要使用组合，这也是近几年来面向对象领域的趋势。在 React 中，可以通过读取 props.children 来获取传递进来的子组件。

```jsx
function FancyBorder(props) {
  return (
    <div className={'FancyBorder FancyBorder-' + props.color}>
      {props.children}
    </div>
  );
}

function WelcomeDialog() {
  return (
    <FancyBorder color="blue">
      <h1 className="Dialog-title">
        Welcome
      </h1>
      <p className="Dialog-message">
        Thank you for visiting our spacecraft!
      </p>
    </FancyBorder>
  );
}
```

如果需要对子组件布局的话，可以使用命名的方式：

```jsx
function SplitPane(props) {
  return (
    <div className="SplitPane">
      <div className="SplitPane-left">
        {props.left}
      </div>
      <div className="SplitPane-right">
        {props.right}
      </div>
    </div>
  );
}
function App() {
  return (
    <SplitPane
      left={
        <Contacts />
      }
      right={
        <Chat />
      } />
  );
}
```

另一种方式是特化，也就是类似函数的 partial

## Thinking in React

React 设计哲学：https://zh-hans.reactjs.org/docs/thinking-in-react.html

![](images/form.png)
![](images/wireframe.png)

- FilterableProductTable
	- SearchBar
	- ProductTable
		- ProductCategoryRow
		- ProductRow

## 已经过期的一些知识

由于 JS 的 this 的坑，需要使用 public class fields。如果要向回调函数中使用参数需要这样：onClick={(e) => this.deleteRow(id, e)}

```jsx
class LoggingButton extends React.Component {
  // This syntax ensures `this` is bound within handleClick.
  // Warning: this is *experimental* syntax.
  handleClick = () => {
    console.log('this is:', this);
  }
render() {
    return (
      <button onClick={this.handleClick}>
        Click me
      </button>
    );
  }
}
```

如果需要传递参数的话：

```jsx
<button onClick={(e) => this.deleteRow(id, e)}>Delete Row</button>
```

## 参考资料

1. https://medium.com/@Zwenza/functional-vs-class-components-in-react-231e3fbd7108
2. https://segmentfault.com/a/1190000011474522
3. https://stackoverflow.com/questions/22876978/loop-inside-react-jsx
