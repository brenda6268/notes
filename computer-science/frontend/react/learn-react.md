# 学习 React

<!--
ID: 2540d668-5922-41e0-a69f-ce82a68582de
Status: draft
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
)     ;
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

一个函数就可以是一个组件。

```jsx
function Welcome(props) {
  return <h1>Hello, {props.name}</h1>;
}

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

react 的事件和 HTML 的不同。首先属性是 camelCase 的；不能通过 return false 来组织事件，必须调用 e.preventDefault。

```html
<button onclick="activateLasers()">
  Activate Lasers
</button>

<button onClick={activateLasers}>
  Activate Lasers
</button>
```

一般情况下，在 React 中是不需要调用 addEventListener。

需要注意的是，如果把类的方法直接绑定给事件的话，会导致 this 错乱。因为 js 的事件会替换掉 this。所以最好还是用一个箭头函数。


## 条件渲染

可以 return null，但是生命周期函数还是会被调用

react 是 functional 的。

所有 React 组件都必须像纯函数一样保护它们的 props 不被更改。state 是组件内部的状态。

生命周期函数被 react 在组件的不同状态调用。

更改组件的 state 需要使用 setState

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



React 设计哲学：https://zh-hans.reactjs.org/docs/thinking-in-react.html

如果有一个层级很深的 react app 的话，管理 state 简直疯了。redux 就是一个用来管理全局状态的库，或者说，我更愿意称之为一种模式。

```jsx
class NameForm extends React.Component {
  constructor(props) {
    super(props);
    this.state = {value: ''};
this.handleChange = this.handleChange.bind(this);
    this.handleSubmit = this.handleSubmit.bind(this);
  }
handleChange(event) {
    this.setState({value: event.target.value});
  }
handleSubmit(event) {
    alert('A name was submitted: ' + this.state.value);
    event.preventDefault();
  }
render() {
    return (
      <form onSubmit={this.handleSubmit}>
        <label>
          Name:
          <input type="text" value={this.state.value} onChange={this.handleChange} />
        </label>
        <input type="submit" value="Submit" />
      </form>
    );
  }
}
```

## 数据单向流动

在 react 中，组件之间是不能互相通信的，数据只能自上而下流动。所以必须把状态放在最高层的组件中。

复杂一点的页面肯定会导致状态越提越高，所以最终还是需要一个单独的状态存储——redux。

```jsx
import { createStore } from 'redux'

/**
 * This is a reducer, a pure function with (state, action) => state signature.
 * It describes how an action transforms the state into the next state.
 *
 * The shape of the state is up to you: it can be a primitive, an array, an object,
 * or even an Immutable.js data structure. The only important part is that you should
 * not mutate the state object, but return a new object if the state changes.
 *
 * In this example, we use a `switch` statement and strings, but you can use a helper that
 * follows a different convention (such as function maps) if it makes sense for your
 * project.
 */
function counter(state = 0, action) {
  switch (action.type) {
    case 'INCREMENT':
      return state + 1
    case 'DECREMENT':
      return state - 1
    default:
      return state
  }
}

// Create a Redux store holding the state of your app.
// Its API is { subscribe, dispatch, getState }.
let store = createStore(counter)

// You can use subscribe() to update the UI in response to state changes.
// Normally you'd use a view binding library (e.g. React Redux) rather than subscribe() directly.
// However it can also be handy to persist the current state in the localStorage.

store.subscribe(() => console.log(store.getState()))

// The only way to mutate the internal state is to dispatch an action.
// The actions can be serialized, logged or stored and later replayed.
store.dispatch({ type: 'INCREMENT' })
// 1
store.dispatch({ type: 'INCREMENT' })
// 2
store.dispatch({ type: 'DECREMENT' })
// 1
```


## 组合

在 React 中不要使用继承来组织组件，而要使用组合，这也是近几年来面向对象领域的趋势。

在 React 中，可以通过读取 this.props.children 来获取传递进来的子组件。

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

Thinking in React

![](images/form.png)
![](images/wireframe.png)


- FilterableProductTable
	- SearchBar
	- ProductTable
		- ProductCategoryRow
		- ProductRow


## JSX

使用循环:

```jsx
<tbody>
  {[...Array(10)].map((x, i) =>
    <ObjectRow key={i} />
  )}
</tbody>
```


## 参考资料

1. https://medium.com/@Zwenza/functional-vs-class-components-in-react-231e3fbd7108
2. https://segmentfault.com/a/1190000011474522
3. https://stackoverflow.com/questions/22876978/loop-inside-react-jsx

