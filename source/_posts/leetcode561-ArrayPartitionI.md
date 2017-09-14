title: leetcode561 Array Partition I

date: 2017/09/14 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#561 Array Partition I

>Given an array of **2n** integers, your task is to group these integers into **n** pairs of integer, say (a1, b1), (a2, b2), ..., (an, bn) which makes sum of min(ai, bi) for all i from 1 to n as large as possible.
>
>**Example 1:**
>
>```
>Input: [1,4,3,2]
>Output: 4
>Explanation: n is 2, and the maximum sum of pairs is 4 = min(1, 2) + min(3, 4).
>```
>
>**Note:**
>
>1. **n** is a positive integer, which is in the range of [1, 10000].
>2. All the integers in the array will be in the range of [-10000, 10000].

#### 解释

给定一个具有2n个整数的数组，要求让数组元素每两个组成一对`(ai,bi)` ，一共n对，然后**每对中取较小的元素**，使得加和的值尽可能的大。

假设，n范围为：[1,10000]；数组中整数的范围为：[-10000,10000]。

#### 我的解法

- 由于是每一对中取较小元素用于累加，所以为了不让小元素拖累大元素，需要尽可能地让每一对的两个元素值相差得较小——相差越小越好，所以第一步应该是对数组元素进行排序，然后从0开始间隔取元素累加；
- 给定的范围，保证了n个数组元素相加肯定不会溢出；
- 数组至少有两个元素，满足一对。

```
class Solution {
    public int arrayPairSum(int[] nums) {
        Arrays.sort(nums);
        
        int res = 0;
        for(int i = 0; i < nums.length; i = i + 2) {
            res += nums[i];
        }
        return res;
    }
}
```

#### 大神解法

首先创建了一个O(2N)的新数组，然后将原数组的值全部+10000，即调整到非负数，然后新数组将使用调整后的值作为数组索引，索引值出现的频数作为新数组对应索引下的数组值——其实这一系列的操作等同于将原数组排序。

最后，将间隔着获取新数组的（索引-10000）累加，并返回。

```
class Solution {
    public int arrayPairSum(int[] nums) {
        
        int[] arr = new int[20002];
        
        for(int i = 0 ; i< nums.length ; i++){
            arr[nums[i]+10000]++;
        }
        
        int sum = 0;
        int count = 0;
        
        for(int i=0 ; i < arr.length ; i++){
            while(arr[i]!=0){
                if (count %2 == 0){
                    sum += (i-10000);
                }
                arr[i]--;
                count++;                    
            }
        }
        
        return sum;
    }
}
```
