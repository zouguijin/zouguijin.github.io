title: leetcode136 Single Number

date: 2017/09/13 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#136 Single Number

>Given an array of integers, every element appears *twice* except for one. Find that single one.
>
>**Note:**
>Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

#### 解释

给定一个整数数组，数组中只有一个元素出现一次，其余的元素都出现两次，找到并返回仅出现一次的元素。

时间复杂度要求O(N)，空间复杂度要求O(1)。

#### 我的解法

既然只有一个元素仅出现一次，其他元素均出现两次，那么可以将数组中**各不相同**的元素全部加起来，然后2倍，再减去数组中所有元素的加和，最后的结果即为所求元素。

如果没有空间复杂度的限制（题目也没有强行限制），那么就可以利用Set过滤一遍数组元素：可以添加进Set中的，说明事没有重复的，可以累加进`sum` 中（`sum` 就代表着所有不重复元素之和），然后将`sum` 2倍，最后减去原数组所有元素之和`arraySum` 。

```
class Solution {
    public int singleNumber(int[] nums) {
        Set<Integer> set = new HashSet<Integer>();
        int sum = 0;
        for(int i = 0; i < nums.length; i++) {
            boolean status = set.add(nums[i]);
            if(status) sum += nums[i];
        }
        int arraySum = 0;
        for(int k = 0; k < nums.length; k++) {
            arraySum += nums[k];
        }
        return sum*2 - arraySum;
    }
}
```

#### 大神解法

**XOR（异或）**

因为数组中只有一个出现一次的元素，所以可以通过异或求出最终出现一次的元素：因为两个相同的元素异或将等于0，且异或操作满足交换和结合律。

>N1 ^ N1 ^ N2 ^ N2 ^..............^ Nx ^ Nx ^ N
>
>= (N1^N1) ^ (N2^N2) ^..............^ (Nx^Nx) ^ N
>
>= 0 ^ 0 ^ ..........^ 0 ^ N
>
>= N

```
public int singleNumber(int[] nums) {
    int result = 0;
    for(int i : nums) {
        result ^= i;
    }
    return result;
}
```

#### 总结

之前做过的“找数组中重复的元素”，利用的是HashSet/HashMap/TreeSet等数据结构的辅助，此外还用到了一个位运算的方法（原理不懂......）