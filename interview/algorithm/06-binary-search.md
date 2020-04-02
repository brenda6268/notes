# 二分搜索

经典的二分查找也分为了三个问题：

1. 在没有重复元素的数组中找到对应元素
2. 在有重复元素的数组中找到上界
3. 在有重复元素的数组中找到上界

## 例题

### LeetCode33 搜索旋转排序数组  

### LeetCode34 在排序数组中查找元素的第一个和最后一个位置

### Rotated Sorted Array

### Mountain Sequence

### OOXX 问题

### Search Sorted Matrix

## 值得注意的细节

使用 `left + (right - left) / 2` 而不要使用 `(left + right) / 2`, 避免溢出。