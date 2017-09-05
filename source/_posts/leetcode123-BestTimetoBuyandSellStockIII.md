title: leetcode123 Best Time to Buy and Sell Stock III

date: 2017/09/05 10:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#123 Best Time to Buy and Sell Stock III  

>Say you have an array for which the *i*th element is the price of a given stock on day *i*.
>
>Design an algorithm to find the maximum profit. You may complete at most *two* transactions.
>
>**Note:**
>You may not engage in multiple transactions at the same time (ie, you must sell the stock before you buy again).

#### 解释

给定一个数组，数组元素第i位表示的是：第i天的股票价格。要求设计一个算法，找到最大的利润，允许**最多进行两次**股票买进卖出操作。

与leetcode122一样，买进操作必须在前一次卖出操作之后。

#### 理解

个人理解是，将数组划分成两个部分，两个部分分别利用Kadane's Algorithm求解Max Subarray问题，然后再将结果加和到一起，即为本题答案。

#### 我的解法

遵循了我的理解，但是该方法遇到了TLE限制，说明虽然答案正确，但是过于复杂而超时了......

```
class Solution {
    public int maxProfit(int[] prices) {
        int maxPro = 0;
        int[] maxCur = new int[2];
        for(int i = 1; i < prices.length; i++) {
            maxCur[0] = maxPreProfit(prices,i);
            maxCur[1] = maxLatProfit(prices,i);
            if(maxPro < maxCur[0] + maxCur[1]) 
                maxPro = maxCur[0] + maxCur[1];
        }
        return maxPro;
    }
    
    public int maxPreProfit(int[] prices, int end) {
        int maxPro = 0;
        int maxCur = 0;
        for(int i = 1; i < end + 1; i++) {
            maxCur = Math.max(0, maxCur += prices[i] - prices[i-1]);
            maxPro = Math.max(maxPro, maxCur);
        }
        return maxPro;
    }
    
    public int maxLatProfit(int[] prices, int begin) {
        int maxPro = 0;
        int maxCur = 0;
        for(int i = begin + 1; i < prices.length; i++) {
            maxCur = Math.max(0, maxCur += prices[i] - prices[i-1]);
            maxPro = Math.max(maxPro, maxCur);
        }
        return maxPro;
    }
}
```

#### 大神解法

该解法考虑四个边界值的最大值：

- 买入第一支股票`buy1` ，由于刚开始是没有钱的，所以需要将`buy1` **初始化为负整数的最小值**，然后将当前股票价格的负数赋值给`buy1` —— 相当于借钱买股票，借最少的钱买，后续才能赚更多；
- 卖出第一支股票，由于`buy1` 是负数，所以`buy1 + prices[i]` 表示按照当前股票价格将股票卖出所获取的利润；
- 买入第二支股票，第一次卖出股票之后的结余是`sell1` ，所以第二次买进股票希望剩下的钱最多，即`sell1 - prices[i]` 最大；
- 卖出第二支股票，同样，买入剩余的钱为`buy2` ，那么再次卖出股票所获取的利润为`buy2 + prices[i]` 。

整个过程**只有一个`for` 循环**，四个边界值从头往后逐步推进，在推进的过程中，由`buy1` 确定整个数组的最小值，也即第一次买入股票的价格；在后续元素值大于前一个元素值的情况下，`sell1` 会进行累加，否则不变；如果`sell1` 增加，同样的`sell2` 也会增加；在遇到前一个元素大于后一个元素的时候，`buy2` 将会增加，因为相较于购买前一个价格较高的股票，可以通过购买后一个价格较低的股票，使得买入第二支股票后，剩余的钱`buy2` 增加。

```
public int maxProfit(int[] prices) {
		int sell1 = 0, sell2 = 0, buy1 = Integer.MIN_VALUE, buy2 = Integer.MIN_VALUE;
		for (int i = 0; i < prices.length; i++) {
			buy1 = Math.max(buy1, -prices[i]);
			sell1 = Math.max(sell1, buy1 + prices[i]);
			buy2 = Math.max(buy2, sell1 - prices[i]);
			sell2 = Math.max(sell2, buy2 + prices[i]);
		}
		return sell2;
	}
```

#### 总结

虽然本题也算作是动态规划的分类，**每个小步骤都是计算买入卖出股票所获取利润的最大值**，但是附上了应用数学的味道之后，有点让我难以分析——我总是在想，怎么将数组分成两部分，使得各自部分有最大的利润......

从本题可以看出，我的DP问题划分还是不够仔细、不够小，从而导致我后续的计算量过大，受到了TLE限制。