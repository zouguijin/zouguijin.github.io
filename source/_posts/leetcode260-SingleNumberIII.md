title: leetcode260 Single Number III

date: 2017/09/13 15:00:00

categories:

- Study

tags:

- leetcode
- array
- BitManipulation

---

## leetcode#260 Single Number III

>Given an array of numbers `nums`, in which exactly two elements appear only once and all the other elements appear exactly twice. Find the two elements that appear only once.
>
>For example:
>
>Given `nums = [1, 2, 1, 3, 2, 5]`, return `[3, 5]`.
>
>**Note**:
>
>1. The order of the result is not important. So in the above example, `[5, 3]` is also correct.
>2. Your algorithm should run in linear runtime complexity. Could you implement it using only constant space complexity?

#### 解释

给定一个数组，其中只有两个元素仅出现一次，其余元素均出现两次，要求找出仅出现一次的两个元素。

返回结果中，两个元素的顺序没有要求；要求时间复杂度O(N)，空间复杂度尽量O(1)。

#### 我的解法

如果对空间复杂度不苛求，那么同样可以使用HashMap，Key保存数组元素，Value保存对应的出现次数，最后通过判断Value，返回仅出现一次的元素。

```
class Solution {
    public int[] singleNumber(int[] nums) {
        Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        for(int i = 0; i < nums.length; i++) {
            if(!map.containsKey(nums[i])) map.put(nums[i],1);
            else
                map.put(nums[i],(map.get(nums[i]))+1);
        }
        int[] res = new int[2];
        int count = 0;
        for(int k = 0; k < nums.length; k++) {
            if(map.get(nums[k]) == 1) res[count++] = nums[k];
        }
        return res;
    }
}
```

#### 大神解法

**位运算**

由于数组中有两个元素仅出现一次（设为A与B），其余元素均会出现两次，所以该算法将分成两步：

- 将数组中的所有元素进行异或XOR。由于相同元素的异或等于零，所以最终的结果本质上就等于**两个仅出现一次的元素的异或**，又由于异或操作的本质——相同则为0，不同则为1，所以结果中某i位（字节位，bit）为1，即表示A的i位为1，B的i位为0（或者反过来），即，可以将数组元素分为两部分：与上述结果与操作为0，或与上述结果与操作不等于0；
- 根据分类的特点，可以将两类的元素分别异或在一起——**分类的目的就是为了将两个仅出现一次的元素分到不同的类别中**，如此一来不同的类别中分别异或，最后剩下的肯定就是仅出现一次的元素了。

```
public class Solution {
    public int[] singleNumber(int[] nums) {
        // Pass 1 : 
        // Get the XOR of the two numbers we need to find
        int diff = 0;
        for (int num : nums) {
            diff ^= num;
        }
        // Get its last set bit
        diff &= -diff;
        
        // Pass 2 :
        int[] rets = {0, 0}; // this array stores the two numbers we will return
        for (int num : nums)
        {
            if ((num & diff) == 0) // the bit is not set
            {
                rets[0] ^= num;
            }
            else // the bit is set
            {
                rets[1] ^= num;
            }
        }
        return rets;
    }
}
```

#### 总结

位运算真是一种精巧的计算和解决问题的方式，让人摸不着头脑......