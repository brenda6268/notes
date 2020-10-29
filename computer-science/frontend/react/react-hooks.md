# React Hooks

<!--
ID: aa9d534d-ac3f-4bc9-97da-940d1107d1ad
Status: draft
Date: 2020-09-25T15:34:05
Modified: 2020-09-25T15:34:05
wp_id: 2046
-->

## 使用 useState hook

最简单的一个例子：

```js
import React, {useState} from 'react';
 
function Counter() {
  const [count, setCount] = useState(0);
 
  return (
    <div>
      <p>You clicked {count} times</p>
      <button onClick={() => setCount(count + 1)}>
        Click me
      </button>
    </div>
  );
}
 
export default Counter;
```

useState hook 一般用来管理本地状态。

## 使用 useEffect hook

useEffect hook 用来实现一些副作用：

```js
import React, {useEffect} from 'react';
 
function App() {
  const [isOn, setIsOn] = React.useState(false);
 
  useEffect(() => {
    let interval;
    if (isOn) {
      interval = setInterval(() => console.log('tick'), 1000);
    }
    return () => clearInterval(interval);
  }, [isOn]);
  ...
}
 
export default App;
```

在 useEffect 中返回的函数会被用来做垃圾清理。

默认情况下，每次 state 有改变的时候，都会调用 useEffect 函数。如果需要更改触发的时机，那么需要使用 useEffect 的第二个参数来指定监听的事件或者说状态。当第二个参数只使用一个空数组 `[]` 的时候就只会在组件加载和写在的时候调用。数组中有哪些变量，就会在这些变量变化的时候调用。

## 自定义钩子

通过灵活组合 useState, 和 useEffect, 我们完全可以创建自己的钩子。

```js
import React from 'react';
 
function useOffline() {
  const [isOffline, setIsOffline] = React.useState(false);
 
  function onOffline() {
    setIsOffline(true);
  }
 
  function onOnline() {
    setIsOffline(false);
  }
 
  React.useEffect(() => {
    window.addEventListener('offline', onOffline);
    window.addEventListener('online', onOnline);
 
    return () => {
      window.removeEventListener('offline', onOffline);
      window.removeEventListener('online', onOnline);
    };
  }, []);
 
  return isOffline;
}
 
function App() {
  const isOffline = useOffline();
 
  if (isOffline) {
    return <div>Sorry, you are offline ...</div>;
  }
 
  return <div>You are online!</div>;
}
 
export default App;
```

## 参考

1. https://www.robinwieruch.de/react-hooks
2. https://www.robinwieruch.de/react-hooks-fetch-data