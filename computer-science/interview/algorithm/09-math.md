# 数学知识
 
Date: 2019-10-30

数学类问题一定要记得进位 v = v1 + v2 + carry

## 最大公约数和最小公倍数

辗转相除法(欧几里得算法).原理在于 gcd(a, b) == gcd(b, a % b)

```Python
def gcd(a, b):
    if b == 0:
        return a
    return gcd(b, a % b)
```

## 排列组合

卡特兰数，为什么除以 n+1

牛顿迭代法

格雷码

## 二进制

- 判断一个数是不是 2 的正整数次幂：`n > 0 && (n & (n - 1)) == 0`
- 对 2 的非负整数次幂取模：`x & (mod - 1)`
- 判断符号是否相同：`(x ^ y) >= 0`
- 获取某一位：`(a >> b) & 1`
- 遍历某个集合的子集: `for (int s = u; s; s = (s - 1) & u)`
- 一的个数：`while (n) {n = n & (n-1); count++}`

### 求幂

```C++
long long binpow(long long a, long long b) {
  long long res = 1;
  while (b > 0) {
    if (b & 1) res = res * a;
    a = a * a;
    b >>= 1;
  }
  return res;
}
```

## 全排列

## 几何

有时候几何题也会出现在面试中。不过，毕竟是 coding interview 而不是 math interview，这部分复习的优先级不高。

## 参考

- https://oi-wiki.org/math/