# 使用 react router 实现前端路由

<!--
ID: 42353524-3502-4946-8ccf-e7efab874310
Status: draft
Date: 2020-10-29T17:08:08
Modified: 2020-10-29T17:08:08
wp_id: 2126
-->

首先安装

```
yarn add react-router-dom
```

## 使用

- 根元素是 `<Router>` 必须包含住所有元素，然后在 `<Switch />` 中定义所有的路由路径 `<Route path="/" />`.
- 在其他组件中可以使用 `<Link to="path">` 跳转到对应的组件。
- route 中的路径只匹配前缀

## 手工跳转

```js
import { useHistory } from 'react-router-dom'

const MyComponent = (props) => {
  const history = useHistory();

  handleOnSubmit = () => {
    history.push(`/dashboard`);
  };
};
```