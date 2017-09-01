title: leetcode278 First Bad Version

date: 2017/09/01 10:00:00

categories:

- Study

tags:

- leetcode
- array
- BinarySearch

---

## leeetcode#278 First Bad Version

>You are a product manager and currently leading a team to develop a new product. Unfortunately, the latest version of your product fails the quality check. Since each version is developed based on the previous version, all the versions after a bad version are also bad.
>
>Suppose you have `n` versions `[1, 2, ..., n]` and you want to find out the first bad one, which causes all the following ones to be bad.
>
>You are given an API `bool isBadVersion(version)` which will return whether `version` is bad. Implement a function to find the first bad version. You should minimize the number of calls to the API.

#### 解释

本题题干很长，但是仔细分析就可以知道，这是一个**有序数组的查找问题**，要想尽可能的减少调用`isBadVersion()` API的关键在于**二分查找算法** 的使用。

#### 理解

由于`isBadVersion()` 已经给定了，所以只需要将注意力放在二分查找算法即可。

#### 我的解法

- 之前写二分查找的时候，虽然一开始用的是减法模式`mid = begin + (end - begin)/2` ，但是看到有部分解法的加法模式`mid = (begin + end)/2` 也挺好用的，所以本题一开始使用的是加法模式的二分查找；
- 但是，在提交的时候会出现TLE——截止程序停止时，所匹配的答案都是正确的，但是运行超时了；
- 后来查阅了一下资料，发现这其中隐藏着可能的问题：`mid = (begin + end)/2` 中的加法，可能会导致计算结果**溢出OVERFLOW** ，相较而言，减法模式则不会溢出，所以后来改写成了减法模式。

```
/* The isBadVersion API is defined in the parent class VersionControl.
      boolean isBadVersion(int version); */
public class Solution extends VersionControl {
    public int firstBadVersion(int n) {
        int begin = 1;
        int end = n;
        while(begin < end) {
            int mid = begin + (end - begin)/2;
            if(isBadVersion(mid)) end = mid;
            else
                begin = mid + 1;
        }
        return begin;
    }
}
```

#### 大神解法

其他高评答案也都是采用时间复杂度O(logN)的二分查找算法。

```
public int firstBadVersion(int n) {
    int start = 1, end = n;
    while (start < end) {
        int mid = start + (end-start) / 2;
        if (!isBadVersion(mid)) start = mid + 1;
        else end = mid;            
    }        
    return start;
}
```

#### 总结

- 提高程序运行效率，算法是关键；
- 要想程序不出错误，算法只是其中的一个方面，除此之外还需要考虑很多其他的因素。

