# 创建应用

<!--
ID: 42aca8c8-f885-4052-9a55-e13cf1523606
Status: draft
Date: 2019-12-05T00:00:00
Modified: 2020-05-28T14:09:32
wp_id: 1195
-->

```bash
yarn create react-app my-app --template typescript
```

## commands

yarn start 打开浏览器
yarn test
yarn build


## 目录结构

```
my-app/
  README.md
  node_modules/
  package.json
  public/
    index.html
    favicon.ico
  src/
    App.css
    App.js
    App.test.js
    index.css
    index.js
    logo.svg
```

其中 public/index.html 是页面的入口，index.js 是 react app 的入口。所有的源文件需要放到 src 中，所有的静态资源文件需要放在 public 中。


# 样式

## 导入 CSS

```javascript
import './Button.css';

class Button extends Component {
  render() {
    // You can use them as regular CSS styles
    return <div className="Button" />;
  }
}
```

## 使用 CSS module

```javascript
// Button.module.css
.error {
  background-color: red;
}

// Button.js
import React, { Component } from 'react';
import styles from './Button.module.css'; // Import css modules stylesheet as styles
import './another-stylesheet.css'; // Import regular stylesheet
class Button extends Component {
  render() {
    // reference as a js object
    return <button className={styles.error}>Error Button</button>;
  }
}
```

## normalize

建议在 index.css

## 使用 bootstrap

安装 react-bootstrap

```bash
yarn add bootstrap react-bootstrap
```

导入 bootstrap 资源

```javascript
import 'bootstrap/dist/css/bootstrap.css';  // 在最上面导入
```

# 静态资源

## 使用 webpack 加载图片等静态资源

如果图片小于 10 KB 的话，会被直接转换成 data uri.

```javascript
import React from 'react';
import logo from './logo.png'; // Tell Webpack this JS file uses this image
console.log(logo); // /logo.84287d09.png
function Header() {
  // Import result is the URL of your image
  return <img src={logo} alt="Logo" />;
}
export default Header;
```

## 使用 public 目录



# 配置绝对路径导入


```javascript
// jsconfig.json 或者 tsconfig.json 文件
{
    "compilerOptions": {
        "baseUrl": "src"
    },
     "include": ["src"]
}

// 代码中，比如 app.tsx
import Button from 'components/Button';
```

# 测试

react 默认使用 jest 进行测试，所有以 `.test.js` 结尾的文件，或者所有在 `__tests__` 目录内部的 js 文件都会被当做测试文件。

默认情况下，jest 只会测试有更改的文件，没有更改的文件不会测试。

```javascript
import sum from './sum';
it('sums numbers', () => {
  expect(sum(1, 2)).toEqual(3);
  expect(sum(2, 2)).toEqual(4);
});
```

测试 react 组件

```javascript
import React from 'react';
import ReactDOM from 'react-dom';
import App from './App';
it('renders without crashing', () => {
  const div = document.createElement('div');
  ReactDOM.render(<App />, div);
});
```

代理后端服务

前端的服务还是需要调后端的接口的

```
// package.json 中
proxy: "http://locahost:4000"
```
