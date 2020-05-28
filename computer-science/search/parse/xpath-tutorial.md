# XPath 教程


wp_id: 467
Status: draft
Date: 2017-05-30 02:47:00
Modified: 2020-05-16 11:57:47


# 基本语法

|syntax|说明|
|:-----|:-----|
|`[.]/tag[PRED]/tag[x]/tag.../func()`|选择元素|
|`/@id` |选择属性|

其中，tag 可以使用 *，代表任意标签。

/ or // 是路径分隔符

[] 可以包含 @attr, 索引, 子元素标签

## 分隔符

分隔符|解释
:-----|:-----
/ |选择当前元素的直接子元素
//|选择当前元素的任意后代
.|current element, other wise starts from root

## 函数

函数|解释
:-----|:-----
not()| 非
last()| 最后 
count()| 计算元素个数
normalize-space| 
name()| 名字
position()| 返回位于某个位置的元素

## 轴

轴这种高级语法再实际中

轴|解释
:-----|:-----
/child::tag|default axis
/parent::tag|parent axis
/descendant(-or-self)::tag|equals to //
/ancestor::tag| 
/following-sibling::tag| 
/preceding-sibling::tag| 
/following::tag|all tag after the element
/preceding::tag| 
/self::tag| 

# 快速回忆

**xpath 从 1 开始数，而不是 0**

`/`: 的意思是下一步
`[]`: 的意思是预测
`::`: 轴表明了在检查条件之前选择哪组元素

## 例子

`/foo[bar]` 的意思是:

1. 从根节点开始
2. Then /foo: for each node, fetch its child nodes, check which ones are foo elements, and take those as the new set.
3. Then [bar]: for each node, fetch its child nodes, check if any are bar elements, and if you come up empty then discard that node.


## cookbook

**problem**|**recipe**
:-----:|:-----:
contains text|//*[text()[contains(.,'ABC')]]
has class|//*[contains(concat(' ', normalize-space(@class), ' '), ' className ')]

### 在 Chrome 调试工具中使用

$x(xpath_expr)

### 在 JavaScript 中使用

```
document.evaluate
```

参考：

1. http://ipointer.cnblogs.com/archive/2005/10/20/258305.html
2. http://plasmasturm.org/log/xpath101/