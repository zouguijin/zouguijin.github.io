title: leetcode643 Maximum Average Subarray I

date: 2017/09/12 11:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#643 Maximum Average Subarray I

>Given an array consisting of `n` integers, find the contiguous subarray of given length `k` that has the maximum average value. And you need to output the maximum average value.
>
>**Example 1:**
>
>```
>Input: [1,12,-5,-6,50,3], k = 4
>Output: 12.75
>Explanation: Maximum average is (12-5-6+50)/4 = 51/4 = 12.75
>
>```
>
>**Note:**
>
>1. 1 <= `k` <= `n` <= 30,000.
>2. Elements of the given array will be in the range [-10,000, 10,000].

#### 解释

给定一个包含n个元素的数组，给定一个整数k，找出具有最大均值的、长度为k的连续子序列，并返回该均值。

- `1<= k <= n <= 30000` ； 
- 数组值的范围为：`[-10,000, 10,000]` 。

#### 我的解法

由题设可知，数组不为空，至少有1个元素；如果k=1，那么就相当于求数组中的最大的元素值；给定数组值的范围和数组长度的上限，说明即使是30000个10000相加，也达不到Java`int` 类型范围的上限：2147483647，相加不会导致溢出。

所以，最简单的思路就是依次遍历、相加、比较，从而找出k个值相加的最大值，最后再求均值。

可是......又一次TLE，分析一下可以知道，时间复杂度最高可能会是O(N/2*N/2)=O(N2)。

于是，看了大神的滑动窗口解法。

```
class Solution {
    public double findMaxAverage(int[] nums, int k) {
        if(k == 1) {
            Arrays.sort(nums);
            return nums[nums.length-1];
        }
        int begin = 0;
        double maxSum = - Double.MAX_VALUE;
        while(begin + k <= nums.length) {
            double maxTmp = 0;
            for(int i = begin; i < begin + k; i++) {
                maxTmp += nums[i];
            } 
            if(maxSum < maxTmp) maxSum = maxTmp;
            begin++;
        }
        return maxSum/k;
    }
}
```

#### 大神解法

**Sliding Window（滑动窗口）**。

首先，将数组中的前k个元素加起来（肯定不会溢出）；然后确定一个上界一个下界，一起移动，去掉一个上界值的同时加入一个下界值，比较前后值的大小关系，从而更新全局的加和最大值；最后取最大值的均值。

```
public class Solution {
    public double findMaxAverage(int[] nums, int k) {
        int sum = 0;
        for(int i = 0; i < k; i++) {
            sum += nums[i];
        }
        
        int maxSum = sum;
        for(int i = 0, j = k; j < nums.length; i++, j++) {
            sum = sum - nums[i] + nums[j];
            maxSum = Math.max(sum, maxSum);
        }
        
        return ((double) maxSum) / ((double) k);
    }
}
```
