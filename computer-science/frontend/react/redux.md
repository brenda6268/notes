# 无标题

<!--
ID: b0b68aad-e324-4463-b947-b08cec465488
Status: draft
Date: 2020-05-28T14:09:32
Modified: 2020-05-28T14:09:32
wp_id: 1193
-->

redux notes
======


```javascript
import { createStore } from "redux";

// state 必须提供默认参数
function productsReducer(state=[], action) {
  return state;
}

function cartReducer(state=[], action) {
  return state;
}


const allReducers = {
  products: productsReducer,
  shoppingCart: cartReducer
}

const rootReducer = combineReducers(allReducers);


const store = createStore(rootReducer);
```


让我解释一下上面的代码：

1. 首先，我们从 redux 包中引入 createStore() 方法。
2. 我们创建了一个名为 reducer 的方法。第一个参数 state 是当前保存在 store 中的数据，第二个参数 action 是一个容器，用于：
    type - 一个简单的字符串常量，例如 ADD, UPDATE, DELETE 等。
    payload - 用于更新状态的数据。
3. 我们创建一个 Redux 存储区，它只能使用 reducer 作为参数来构造。存储在 Redux 存储区中的数据可以被直接访问，但只能通过提供的 reducer 进行更新。

