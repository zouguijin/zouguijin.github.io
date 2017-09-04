title: leetcode53 Maximum Subarray

date: 2017/09/04 11:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#53 Maximum Subarray

>Find the contiguous subarray within an array (containing at least one number) which has the largest sum.
>
>For example, given the array `[-2,1,-3,4,-1,2,1,-5,4]`,
>the contiguous subarray `[4,-1,2,1]` has the largest sum = `6`.

#### 解释

给定一个数组，要求找到该数组的一个连续子集，使得该子集元素之和最大。

#### 理解

最简单最容易想到的方式就是，依次遍历，依次累加，依次比较，将这个过程中最大的和存储下来。——毫无疑问，这样的方式虽然可行，但是将会是一个O(n2)时间复杂度的算法。

#### 我的解法

时间复杂度O(n2)。

```
class Solution {
    public int maxSubArray(int[] nums) {
        int maxSum = nums[0];
        for(int i = 0; i < nums.length; i++) {
            int maxTmp = nums[i];
            if(maxTmp > maxSum) maxSum = maxTmp;
            for(int j = i + 1; j < nums.length; j++) {
                maxTmp = maxTmp + nums[j];
                if(maxTmp > maxSum) maxSum = maxTmp;
            }
        }
        return maxSum;
    }
}
```

#### 大神解法

解法一：No DP

`maxSoFar` 存储全局最大的值，`maxEndingHere` 存储着累加到当前位置的最大值，因为移动累加的过程中，不一定是从头开始依次累加的，有可能中间由于某个值大于前面所有累加的值，这时候就需要将`maxEndingHere` 替换成当前的单个值（丢弃前面的累加结果），并从当前位置开始往后累加。

这里面的想法为：**如果 i位置的数 < i位置前的加和 + i位置的数，说明i位置前的加和是负数**，将会“拖累”后续的和，所以必须将其丢弃，而重新从i位置开始计算加和。

```
public static int maxSubArray(int[] A) {
    int maxSoFar=A[0], maxEndingHere=A[0];
    for (int i=1;i<A.length;++i){
    	maxEndingHere= Math.max(maxEndingHere+A[i],A[i]);
    	maxSoFar=Math.max(maxSoFar, maxEndingHere);	
    }
    return maxSoFar;
}
```

解法二：**DP(Dynamic Programming)动态规划**

用DP思想来看本题，本题就是一个优化问题——找出一个最优值（最大值）。

DP算法的本质，就是将原问题划分成多个容易解决的子问题，然后将各个子问题各个击破，并将结果汇总得到原问题的答案。

所以，DP算法的第一步，就是要找出子问题的表达形式（状态），子问题表达的好，构建出算法代码也就简单。——大神最后给出的子问题表达形式为：`maxSubArray(int A[], int i)` 而不是`maxSubArray(int A[], int i, int j)` ，因为后者有i/j两个变量，过于灵活多变，不利于构建一个简单的解法。于是最后的整体表达式为：

```
maxSubArray(A, i) = maxSubArray(A, i - 1) > 0 ? maxSubArray(A, i - 1) : 0 + A[i]; 
```

```
public int maxSubArray(int[] A) {
        int n = A.length;
        int[] dp = new int[n];//dp[i] means the maximum subarray ending with A[i];
        dp[0] = A[0];
        int max = dp[0];
        
        for(int i = 1; i < n; i++){
            dp[i] = A[i] + (dp[i - 1] > 0 ? dp[i - 1] : 0);
            max = Math.max(max, dp[i]);
        }
        
        return max;
}
```

其中，`dp[i]` 存储的是`A[0:i] `的所有子集中加和的最大值，对应着`maxSubArray(A, i)` 。

#### 总结

本题归类为一个Easy题，还是可以接受的，至少暴力解法能很容易地想到，但是如果没有DP经验，那么很难想到其他的解法。上述的两个大神解法，其实是很类似的，由于本题较为简单，所以DP解法中也没有使用**递归**，只是简单地将DP的思路用一个新的数组表达了一下，具有普适性；NO DP解法则更为简洁一点。