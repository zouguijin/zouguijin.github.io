title: leetcode152 Maximum Product Subarray

date: 2017/09/26 16:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#152 Maximum Product Subarray

>Find the contiguous subarray within an array (containing at least one number) which has the largest product.
>
>For example, given the array `[2,3,-2,4]`,
>the contiguous subarray `[2,3]` has the largest product = `6`.

#### 解释

给定一个数组，要求找出数组的一个连续子集（子集中至少包括一个元素），该子集中元素之积最大。

#### 我的解法

leetcode53是关于数组的最大加和子集的问题，在加和的问题中，如果遇到负数使得整体的和值小于0，那么前面的和值都可以不要，而从当前位置的值开始计算加和——毕竟加一个负数会使得最后的和值更小。

但是在本题中，由于**负负得正**，所以尽管之前的乘积值为负值，也可能会在最后遇到一个新的负值，使得整体的乘积转为正数。

#### 大神解法

解法一：非DP

既然存在负负得正的情况，那么就索性保留当前乘积值的最小值（如果有负数的话，就选取最小的负数，负负得正就是最大的），同时保留当前乘积值的最大值——**保留一大一小的乘积值**，一直遍历到最后，整个过程都在判断两个值的大小关系。

```
public int maxProduct(int[] A) {
    if (A.length == 0) {
        return 0;
    }
    
    int maxherepre = A[0];
    int minherepre = A[0];
    int maxsofar = A[0];
    int maxhere, minhere;
    
    for (int i = 1; i < A.length; i++) {
        maxhere = Math.max(Math.max(maxherepre * A[i], minherepre * A[i]), A[i]);
        minhere = Math.min(Math.min(maxherepre * A[i], minherepre * A[i]), A[i]);
        maxsofar = Math.max(maxhere, maxsofar);
        maxherepre = maxhere;
        minherepre = minhere;
    }
    return maxsofar;
}
```

解法二：DP

其实DP的思路与非DP的思路是一样的——都是保留一大一小两个值，只不过DP用了一个数据结构来保存乘积值，好处在于如果想知道在哪个位置的乘积值达到最大，可以通过保存乘积值的数组获悉。

```
public class Solution {
  public int maxProduct(int[] A) {
    if (A == null || A.length == 0) {
        return 0;
    }
    int[] f = new int[A.length];
    int[] g = new int[A.length];
    f[0] = A[0];
    g[0] = A[0];
    int res = A[0];
    for (int i = 1; i < A.length; i++) {
        f[i] = Math.max(Math.max(f[i - 1] * A[i], g[i - 1] * A[i]), A[i]);
        g[i] = Math.min(Math.min(f[i - 1] * A[i], g[i - 1] * A[i]), A[i]);
        res = Math.max(res, f[i]);
    }
    return res;
  }
}
```