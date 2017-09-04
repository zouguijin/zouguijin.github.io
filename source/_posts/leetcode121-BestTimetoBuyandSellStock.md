title: leetcode121 Best Time to Buy and Sell Stock

date: 2017/09/04 15:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#121 Best Time to Buy and Sell Stock

>Say you have an array for which the *i*th element is the price of a given stock on day *i*.
>
>If you were only permitted to complete at most one transaction (ie, buy one and sell one share of the stock), design an algorithm to find the maximum profit.
>
>**Example 1:**
>
>```
>Input: [7, 1, 5, 3, 6, 4]
>Output: 5
>
>max. difference = 6-1 = 5 (not 7-1 = 6, as selling price needs to be larger than buying price)
>
>```
>
>**Example 2:**
>
>```
>Input: [7, 6, 4, 3, 1]
>Output: 0
>
>In this case, no transaction is done, i.e. max profit = 0.
>```

#### 解释

这是一个应用问题，关于股票买卖。

给定一个数组，数组元素第i位表示的是：第i天的股票价格。现在允许进行的股票买卖操作是：

- 只能进行一次买和一次卖——获得利润为卖出价格减去买进价格；
- 不买不卖——利润为0。

现在需要找到最大的利润（如果不买不卖，返回利润为0）.

#### 理解

这是一道可能可以使用暴力解法解决的问题（看限制条件，有可能暴力解法会遇到TLE的限制），所以更优的解法应该倾向于动态规划算法——将原问题划分成多个子问题，然后各个击破，最终汇总结果。

#### 我的解法

解法一：暴力解法（遇到TLE限制）

```
class Solution {
    public int maxProfit(int[] prices) {
        int maxPro = 0;
        for(int i = 0; i < prices.length; i++) {
            int maxTmp = 0;
            for(int j = i + 1; j < prices.length; j++) {
                maxTmp = prices[j] - prices[i];
                if(maxPro < maxTmp) maxPro = maxTmp;
            }
        }
        return maxPro;
    }
}
```

解法二：动态规划

动态规划算法，需要先定义子问题的表达式——定义得好，有利于后续构建整体的DP算法。思路如下：

利用`maxProfit(int[] A, int i)` 表示`A[0:i]` 前i个元素中，所有`A[j] - A[i],(j > i)` 结果的最大值——即子问题的定义，所以可以得到递归表达式：`maxProfit(A, i) = maxProfit(A, i-1) > (A[i] - minVal) ? maxProfit(A, i -1) : (A[i] - minVal)` 。之后，就可以对递归表达式进行细化（根据问题的大小）：是用全局变量存储，还是实实在在地使用递归方式求解。

其中，变量的含义是：

- `maxPro` ，全局最优值，即全局的最大利润值；
- `minVal` 存储遍历过程中的最小值，因为是“先买后卖”，所以只需要将后续获取第i个数组元素减去`minVal` ，就可以得到第i天卖出股票所获得的利润，再与`maxPro` 相比较即可得到全局最优值。

```
class Solution {
    public int maxProfit(int[] prices) {
        if(prices.length == 0) return 0;
        
        int minVal = prices[0];
        int maxPro = 0;
        for(int i = 0; i < prices.length; i++) {
            if(minVal > prices[i]) minVal = prices[i];
            maxPro = maxPro >= (prices[i] - minVal) ? maxPro : (prices[i] - minVal);
        }
        return maxPro;
    }
}
```

解法二改进版：

之前一个版本中，不论`minVal`与`prices[i]` 的大小关系如何，都会进行一长串的三元操作符比较过程，相当消耗资源。于是，改进版中将三元操作符装进了条件语句中，RunTimeBeat从9%提升到了44%。

```
class Solution {
    public int maxProfit(int[] prices) {
        if(prices.length == 0) return 0;
        
        int minVal = prices[0];
        int maxPro = 0;
        for(int i = 0; i < prices.length; i++) {
            if(minVal > prices[i]) minVal = prices[i];
            else {
                maxPro = maxPro >= (prices[i] - minVal) ? maxPro : (prices[i] - minVal);
            }
        }
        return maxPro;
    }
}
```

#### 大神解法

解法一：思路基本相同。

```
 public int maxProfit(int[] prices) {
		 if (prices.length == 0) {
			 return 0 ;
		 }		
		 int max = 0 ;
		 int sofarMin = prices[0] ;
	     for (int i = 0 ; i < prices.length ; ++i) {
	    	 if (prices[i] > sofarMin) {
	    		 max = Math.max(max, prices[i] - sofarMin) ;
	    	 } else{
	    		sofarMin = prices[i];  
	    	 }
	     }	     
	    return  max ;
}
```

解法二：

该解法中提到了一个算法——**Kadane's Algorithm**。

上述解法都是针对数组值大于等于0的情况（因为股价不可能为负数），如果对于任意场景，特别是数组元素为负数时，上述解法将会出现问题。

而Kadane's Algorithm提供了一种针对Max Subarray问题的普适性解决方法：

- `maxCur` ，将**当前的`maxCur` 值与数组相邻两个元素之间的差值** 进行相加，注意，这里的**加和值需要大于0**才能作为新的`maxCur` 值保存，否则归零——**原因**为：假设`[...,x,y,z,...]` 有三个相邻元素，如果`(y-x)+(z-y)<0` 即`y-x <y-z` ，说明`z<x` ，所以`z` 是当前遍历到的最小值，如果后续有较大的数`W` ，那么也会满足`W-z>W-x` ；
- `maxSoFar` ，保存全局最优值。

如此一来，即使数组元素有负数，也可以完成Max Subarray问题的求解。

```
public int maxProfit(int[] prices) {
        int maxCur = 0, maxSoFar = 0;
        for(int i = 1; i < prices.length; i++) {
            maxCur = Math.max(0, maxCur += prices[i] - prices[i-1]);
            maxSoFar = Math.max(maxCur, maxSoFar);
        }
        return maxSoFar;
}
```

#### 总结

- 关于动态规划的问题，暴力解法一般也都可以使用，所以这种题型一般都会对暴力解法设置限制条件，比如TLE；
- 了解动态规划的思想是很有必要的，除了解决算法问题，动态规划可以为解决其他复杂问题提供一种简化和切入的思路，尝试定义子问题的表达式，不断简化子问题的表达式，也许就可以从中发现一些规律，从而推广到整体问题；
- 关于**Max Subarray问题**，**Kadane's Algorithm**（也属于动态规划算法）已经将其完美解决。