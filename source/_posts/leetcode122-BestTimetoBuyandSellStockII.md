title: leetcode122 Best Time to Buy and Sell Stock II 

date: 2017/09/04 15:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#122 Best Time to Buy and Sell Stock II

>Say you have an array for which the *i*th element is the price of a given stock on day *i*.
>
>Design an algorithm to find the maximum profit. You may complete as many transactions as you like (ie, buy one and sell one share of the stock multiple times). However, you may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

#### 解释

题目很绕......简单来说，可以将买卖股票看成一个单线程操作，股票看成一个具有时间线的任务，所以一次只能买进一支股票，经历股票的时间线后，再卖出。之后，可以再次买进另一支股票（**买进的时间点必须在上一次卖出的时间点之后**），然后经历当前股票的时间线后，再卖出，以此类推。

#### 理解

基于Kadane's Algorithm，稍微改动一下算法的实现即可——将**相邻元素不为0的差值累加**即可。

#### 我的解法

```
class Solution {
    public int maxProfit(int[] prices) {
        int maxPro = 0;
        for(int i = 1; i < prices.length; i++) {
            maxPro += Math.max(0, prices[i] - prices[i-1]);
        }
        return maxPro;
    }
}
```

#### 大神解法

简洁的解法都应用了Kadane's Algorithm的思想，进行差值和累加。

#### 总结

Kadane's Algorithm算法的思想对于Max Subarray问题以及相应的延伸问题的解答，可谓是立竿见影！