title: leetcode581 Shortest Unsorted Continuous Subarray

date: 2017/09/14 11:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#581 Shortest Unsorted Continuous Subarray

>Given an integer array, you need to find one **continuous subarray** that if you only sort this subarray in ascending order, then the whole array will be sorted in ascending order, too.
>
>You need to find the **shortest** such subarray and output its length.
>
>**Example 1:**
>
>```
>Input: [2, 6, 4, 8, 10, 9, 15]
>Output: 5
>Explanation: You need to sort [6, 4, 8, 10, 9] in ascending order to make the whole array sorted in ascending order.
>
>```
>
>**Note:**
>
>1. Then length of the input array is in range [1, 10,000].
>2. The input array may contain duplicates, so ascending order here means **<=**.

#### 解释

给定一个整数数组，找出其中一个连续的子序列，当**完成对该子序列的升序排序之后，整个数组也呈现升序排序**。要求找出满足条件的子序列中的最短的一个子序列。

假设，数组长度范围为：[1,10000]；数组可能包含重复元素，所以升序包含`<=` 。

#### 我的解法

- 说明整个数组除了所需要找的子序列部分之外，都是按照升序排列的；
- 由于需要找的子序列只有一个，所以只需要从头到尾遍历一次，标记出无序的起始与结尾处，即可；
- 于是，可以先保存数组的一个有序版本，然后分别从头和从尾往中间遍历，直到分别找到元素不等的位置，记为`start` 和`end` ，最后返回`end - start + 1` 。
- 时间复杂度O(NlgN)，空间复杂度O(N)。

```
public class Solution {
    public int findUnsortedSubarray(int[] nums) {
        int n = nums.length;
        int[] temp = nums.clone();
        Arrays.sort(temp);
        
        int start = 0;
        while (start < n  && nums[start] == temp[start]) start++;
        
        int end = n - 1;
        while (end > start  && nums[end] == temp[end]) end--;
        
        return end - start + 1;
    }
}
```

#### 大神解法

解法一：

首先，**假设只有中部`[l,r]` 部分是无序的**，所以`[0,l]`和`[r,nums.length-1]` 都是局部有序的，因此将范围缩小到`[l,r]` 部分；然后在`[l,r]` 这部分中，寻找最小值`min`和最大值`max`，如果`min` 比`[0,l]` 中的值还小，那么就将下边界往`[0,l]` 部分移动，如果`max` 比`[r,nums.length-1]` 中的值还大，则将上边界往后半部分移动。

```
public int findUnsortedSubarray(int[] nums) {
    int l = 0, r = nums.length - 1, max = Integer.MIN_VALUE, min = Integer.MAX_VALUE;
        
    while (l < r && nums[l] <= nums[l + 1]) l++;
        
    if (l >= r) return 0;
        
    while (nums[r] >= nums[r - 1]) r--;
    
    for (int k = l; k <= r; k++) {
        max = Math.max(max, nums[k]);
        min = Math.min(min, nums[k]);
    }
    
    while (l >= 0 && min < nums[l]) l--;
    while (r < nums.length && nums[r] < max) r++;
        
    return (r - l - 1);
}
```

解法二：

同样也是利用上下界，不同的是，该解法中的上界将从头部向尾部移动，下界则从尾部向头部移动，在这个过程中，下界如果发现左侧元素值大于右侧元素值，则将下界移动到该位置；同理，若上界发现右侧元素值小于左侧元素值，则将上界移动到该位置。

```
public int findUnsortedSubarray(int[] nums) {
    int i = 0, j = -1, max = Integer.MIN_VALUE, min = Integer.MAX_VALUE;
    
    for (int l = 0, r = nums.length - 1; r >= 0; l++, r--) {
        max = Math.max(max, nums[l]);
        if (nums[l] != max) j = l;
        
        min = Math.min(min, nums[r]);
        if (nums[r] != min) i = r;
    }
    
    return (j - i + 1);
}
```

#### 总结

在最初的解法中，虽然也明确了两个边界，但是可能是由于着眼点不是很全局，写出来的方法在找到无序部分`[l,r]`之后，对前后两个部分有序的部分中，出现有的元素导致全局无序，无法将边界移动到该位置......