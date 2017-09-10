title: leetcode674 Longest Continuous Increasing Subsequence

date: 2017/09/10 22:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#674 Longest Continuous Increasing Subsequence

>Given an unsorted array of integers, find the length of longest `continuous` increasing subsequence.
>
>**Example 1:**
>
>```
>Input: [1,3,5,4,7]
>Output: 3
>Explanation: The longest continuous increasing subsequence is [1,3,5], its length is 3. 
>Even though [1,3,5,7] is also an increasing subsequence, it's not a continuous one where 5 and 7 are separated by 4. 
>
>```
>
>**Example 2:**
>
>```
>Input: [2,2,2,2,2]
>Output: 1
>Explanation: The longest continuous increasing subsequence is [2], its length is 1. 
>
>```
>
>**Note:** Length of the array will not exceed 10,000.

#### 解释

给定一个无序的整数数组，找到并返回其中**长度最长**的且**依次递增**的子序列。

#### 我的解法

从头到尾，依次比较每一对相邻元素，如果一直满足从大到小的关系，那么当前计数值就累加，否则就先判断当前计数值与全局计数值的大小关系，决定是否替换全局计数值，不论大小关系如何，都将当前计数值置为0，开始下次计数过程。

```
class Solution {
    public int findLengthOfLCIS(int[] nums) {
        if(nums.length == 0) return 0;
        
        int count = 1;
        int maxLength = 1;
        for(int i = 1; i < nums.length; i++) {
            if(nums[i-1] < nums[i]) count++;
            else {
                if(count > maxLength) {
                    maxLength = count;
                }
                count = 1;
            }
        }
        if(count > maxLength) maxLength = count;
        return maxLength;
    }
}
```

#### 大神解法

解法一：思路与我的解法类似。

```
    public int findLengthOfLCIS(int[] nums) {
        int res = 0, cnt = 0;
        for(int i = 0; i<nums.length; i++){
            if(i == 0 || nums[i-1] < nums[i])res = Math.max(res, ++cnt);
            else cnt = 1;
        }
        return res;
    }
```

解法二：动态规划。

虽然使用的DP，但是基本的思想也是类似的：创建一个与给定数组大小相同的数组，每一个位置保存目前位置的子序列长度（大小连续的长度计数），同样，如果不符合连续增长的大小关系，那么将该位置的值置为1，重新开始计数。

```
class Solution {
    public int findLengthOfLCIS(int[] nums) {
        if (nums == null || nums.length == 0) return 0;
        int n = nums.length;
        int[] dp = new int[n];
        
        int max = 1;
        dp[0] = 1;
        for (int i = 1; i < n; i++) {
            if (nums[i] > nums[i - 1]) {
                dp[i] = dp[i - 1] + 1;
            }
            else {
                dp[i] = 1;
            }
            max = Math.max(max, dp[i]);
        }
        
        return max;
    }
}
```

