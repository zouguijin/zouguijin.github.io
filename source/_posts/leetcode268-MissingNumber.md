title: leetcode268 Missing Number

date: 2017/09/06 15:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#268 Missing Number

>Given an array containing *n* distinct numbers taken from `0, 1, 2, ..., n`, find the one that is missing from the array.
>
>For example,
>Given *nums* = `[0, 1, 3]` return `2`.
>
>**Note**:
>Your algorithm should run in linear runtime complexity. Could you implement it using only constant extra space complexity?

#### 解释

给定一个包含n个**不同**元素值（0,1,2,...,n）的数组，找出该数组中缺少的一个元素，并返回它。

要求时间复杂度O(n)，空间复杂度O(1)。

#### 理解

如果数组元素是有序的，那不就是依次比较数组元素值和当前索引值么？

如果数组元素可能是无序的，那么就需要假设没有缺失，计算一个和：`n(n+1)/2` ，然后再计算实际的和：`sum` ，两者作差即为缺失的元素。

#### 我的解法

```
class Solution {
    public int missingNumber(int[] nums) {
        int length = nums.length;
        int sum = 0;
        for(int i = 0; i < nums.length; i++) {
            sum += nums[i];                          
        }
        return length*(length+1)/2 - sum;
    }
}
```

#### 大神解法

除了利用加和作差的方法，还有以下解法：

解法一：XOR（异或操作）

**很神奇**，只要是从0开始的连续一串数字中缺少了哪一个（或者缺少最大的那个数字），不论是有序的还是无序的，都可以通过不断地、依次与索引值和元素值进行XOR操作，找出缺少的那个数字。

```
public int missingNumber(int[] nums) { //xor
    int res = nums.length;
    for(int i=0; i<nums.length; i++){
        res ^= i;
        res ^= nums[i];
    }
    return res;
}
```

解法二：Binary Search（二分查找）

先将数组排序（数组内置排序算法O(logN)），然后二分查找（O(logN)~O(N)）。

其实如果排序完成后，可以使用**线性查找方式**，即将索引值和元素值进行比较，同则返回索引值即可。

```
public int missingNumber(int[] nums) { //binary search
    Arrays.sort(nums);
    int left = 0, right = nums.length, mid= (left + right)/2;
    while(left<right){
        mid = (left + right)/2;
        if(nums[mid]>mid) right = mid;
        else left = mid+1;
    }
    return left;
}
```

#### 总结

>If the array is in order, I prefer `Binary Search` method. Otherwise, the `XOR` method is better.

XOR操作计算速度快，特别是当数组很大，即数组元素很大的时候，使用加和的方式可能会出现溢出的情况，即使不溢出计算速度也不如XOR快。

当然，如果已经有序，直接二分查找将会获得更优的时间复杂度。