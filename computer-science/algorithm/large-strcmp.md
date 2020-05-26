# 大规模字符串的匹配


ID: 486
Status: publish
Date: 2018-07-20 02:35:00
Modified: 2020-05-16 11:20:28


问题：假设我们有一组比较长的文本，每一个文本都有几十k左右，还有一些敏感关键词需要删除，大概有几千，然后需要在这些文本中把关键词找出来。

# 方法1：暴力搜索

```
import re

compiled_words = [re.compile(r&#039;\b&#039; + word + r&#039;\b&#039;) for word in my20000words]

for sentence in sentences:
  for word in compiled_words:
    print(re.sub(word, &quot;***&quot;, sentence))

```

# 改进1：把正则组合起来

```
pattern = &quot;\b(word1|word2|word3)\b&quot;

for sentence in sentences:
  print(re.sub(pattern, &quot;***&quot;, sentence))
```

# 改进2：使用 Trie 优化正则

对于数组：['foobar', 'foobah', 'fooxar', 'foozap', 'fooza']，使用上面的方法，我们可能会写出正则：

```
&quot;\b(foobar|foobah|fooxar|foozap|fooza)\b&quot;
```

但是这并不是最优的正则，应该使用前缀树的思想来合并单词，形成下面的正则：

```
r&quot;\bfoo(?:ba[hr]|xar|zap?)\b&quot;
```

具体的方法可以看这里：https://stackoverflow.com/a/42789508/1061155

# 改进3：基于集合的搜索

```
import re

def delete_banned_words(matchobj):
    word = matchobj.group(0)
    if word.lower() in banned_words:
        return &quot;&quot;
    else:
        return word

word_pattern = re.compile(&#039;\w+&#039;)

for sentence in sentences:
    sentence = word_pattern.sub(delete_banned_words, sentence)
```




参考：

https://stackoverflow.com/questions/42742810/speed-up-millions-of-regex-replacements-in-python-3/42789508

https://medium.freecodecamp.org/regex-was-taking-5-days-flashtext-does-it-in-15-minutes-55f04411025f