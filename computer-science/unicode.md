# Unicode


wp_id: 337
Status: publish
Date: 2017-06-08 07:17:00
Modified: 2017-06-08 07:17:00


http://lucumr.pocoo.org/2014/1/9/ucs-vs-utf8/

# Plane（平面）

from wikipedia

> In the Unicode standard, a plane is a continuous group of 65536 code points. There are 17 planes, identified by the numbers 0 to 16, which corresponds with the possible values 00–10 hexadecimal of the first two positions in six position format (hhhhhh). 

> Plane 0 is the Basic Multilingual Plane (BMP), which contains most commonly-used characters. The higher planes 1 through 16 are called "supplementary planes", As of Unicode version 9.0, six of the planes have assigned code points (characters), and four are named.

> The limit of 17 (which is not a power of 2) is due to the design of UTF-16, which can encode a maximum value of 0x10FFFF,[2] the last code point in plane 16. The encoding scheme used by UTF-8 was designed with a much larger limit of 231 code points (32,768 planes), and can encode 221 code points (32 planes) even if limited to 4 bytes. Since Unicode limits the code points to the 17 planes that can be encoded by UTF-16, **code points above 0x10FFFF are invalid in UTF-8 and UTF-32**.

> The 17 planes can accommodate 1,114,112 code points. Of these, 2,048 are surrogates, 66 are non-characters, and 137,468 are reserved for private use, leaving 974,530 for public assignment.

> Planes are further subdivided into *Unicode blocks*, which, unlike planes, do not have a fixed size. The 273 blocks defined in Unicode 9.0 cover 24% of the possible code point space, and range in size from a minimum of 16 code points (twelve blocks) to a maximum of 65,536 code points (Supplementary Private Use Area-A and -B, which constitute the entirety of planes 15 and 16). For future usage, ranges of characters have been tentatively mapped out for most known current and ancient writing systems.

# Plane 0(BMP)

```
0000-007F	ASCII		
0080-1FFF	各种鸟语		
2000-206F	常用标点	General Punctuation	包含双引号
2070-209F	上下标		
20A0-20CF	货币符号		
20D0-214F	各种物理符号		
2150-218f	罗马数字		
2190-21ff	箭头 https://en.wikipedia.org/wiki/Arrows_(Unicode_block)  有emoji
2220-22FF	数学符号		
2300-23ff	符号	Miscellaneous Technical	有emoji
2400-245f	符号		
2460-24ff	圆圈	Enclosed Alphanumerics	
2500-257f	画方块字符	Box Drawing	好多人用做竖线
2580-259f	方块字符	Box Elements	
25A0-2e7f	各种奇怪的字符，包含部分表情 emoji
3000-303f	中文符号和标点，包含了中括号等，竟然有双字节宽的引号
3040-33ff	各种中文符号，3190也是竖线
4DC0-4DFF	八卦符号		
4e00-9fff	CJK统一表意文字		
A000-D7af	各种鸟语		
D7B0-D7FF	UTF-16高半区，实际使用D800-DBFF
DC00-DFFF	低半区		
E000-F8FF	私用区, 其中 F8FF 表示 
F900-FAFF	CJK统一表意文字		
FB00-FE0F	各种鸟语		
FE10-FE1F	竖排符号		
FE30-FE4F	CJK兼容标点		
FE50-FE6F	小标点		
FE70-FEFF	鸟语		
FF00-FFEF	全角与半角		
FFF0-FFFF	奇葩		
```

# Plane 1 (SMP)

需要注意的区域

1F000-1FFFF	各种表情 emoji

# emoji
## text vs emoji style
Emoji 有text和emoji-style两种形式，每个emoji 有一个默认的形式，可以添加字符来强制指定形式：`\ufe0e` `\ufe0f`

## skin colors
Emoji可以表示不同的肤色，`\u1F3FB–\u1F3FF`

## emoji combination
组合，Emoji 还可以组合成新的 emoji，这样来拟补不足，使用`\u200d` http://www.unicode.org/emoji/charts/emoji-zwj-sequences.html

更多 emoji 表情参见：http://www.unicode.org/Public/emoji/1.0/emoji-data.txt

# Surrogate

Surrogate to Non-Surrogate:

N = 0x10000 + (H - 0xd800) * 0x400 + (L - 0xDC00)

Non-Surrogate to Surrogate

H = (N - 0x10000) / 0x400 + 0xD800
L = (N - 0x10000) % 0x400 + 0xdc00

Python

narrow build python does not support SMP, python on mac are all narrow build.if you got narrow build, you will have to use to unicode char to represent.

常见问题

菊花文

https://zh.wikipedia.org/wiki/%E8%8F%8A%E8%8A%B1%E6%96%87


Unicode character orders

Left-to-Right Mark/Right-to-Left Mark

not very useful, fix puncutation positions

https://en.wikipedia.org/wiki/Right-to-left_mark


Left-to-right Order/Right-to-Left Order

This is very powerful, override normal character directions

U+202d	 LEFT-TO-RIGHT OVERRIDE			The following text will be left-to-right. Additionally, the directionality of characters is changed to left-to-right. Used alone in an English text, this will only affect characters that are right-to-left by default, like Arabic letters.
U+202e	 RIGHT-TO-LEFT OVERRIDE	The following text will be right-to-left. Additionally, the directionality of characters is changed to right-to-left. Use this character to completely screw up an English text.

see
https://www.explainxkcd.com/wiki/index.php/1137:_RTL
https://www.zhihu.com/question/43621727/answer/96178474

white spaces

https://en.wikipedia.org/wiki/Whitespace_character



# reference

* https://zh.wikibooks.org/wiki/Unicode
* https://en.wikipedia.org/wiki/Emoji
* https://zh.wikipedia.org/zh-cn/Unicode%E5%AD%97%E7%AC%A6%E5%B9%B3%E9%9D%A2%E6%98%A0%E5%B0%84
