title: leetcode137 Single Number II

date: 2017/09/13 11:00:00

categories:

- Study

tags:

- leetcode
- array
- BitManipulation

---

## leetcode#137 Single Number II

>Given an array of integers, every element appears *three* times except for one, which appears exactly once. Find that single one.
>
>**Note:**
>Your algorithm should have a linear runtime complexity. Could you implement it without using extra memory?

#### 解释

给定一个整数数组，数组中只有一个元素出现了一次，其余元素都出现了三次，要求找出仅出现一次的元素。

时间复杂度要求O(N)，空间复杂度尽量O(1)。

#### 我的解法

如果不求空间复杂度O(1)，那么还是可以使用HashMap，Key存储数组元素值，Value存储元素出现的次数，最后判断元素出现次数为1的，返回其Key值。

```
class Solution {
    public int singleNumber(int[] nums) {
        Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        for(int i =0; i < nums.length; i++) {
            if(!map.containsKey(nums[i])) map.put(nums[i],1);
            else
                map.put(nums[i],(map.get(nums[i]))+1);
        }
        int res = 0;
        for(int k =0; k < nums.length; k++) {
            if(map.get(nums[k]) == 1) { 
                res = nums[k];
                break;
            }
        }
        return res;
    }
}
```

#### 大神解法

解法一：

神奇的方法......：`a = (a XOR x) & ~b` 且 `b = (b XOR x) & ~a` ，最后返回`a` 。

有人解释如下：

>First time number appear -> save it in "ones"
>
>Second time -> clear "ones" but save it in "twos" for later check
>
>Third time -> try to save in "ones" but value saved in "twos" clear it.

这么解释，那么就类似于leetcode136中，利用异或寻找仅出现一次元素的方法了：每个等式的前半部分`a XOR x` 用于确定`a` 中的元素是否与当前的数组元素相等，相等当然是置为0；后半部分的`~b` 用于保存之前是否出现过当前数组元素的状态，如果有，那么会置为1——之后再次调用`a = (a XOR x) & ~b` 的时候，就会使得`a = 0` 。 

```
public int singleNumber(int[] A) {
    int ones = 0, twos = 0;
    for(int i = 0; i < A.length; i++){
        ones = (ones ^ A[i]) & ~twos;
        twos = (twos ^ A[i]) & ~ones;
    }
    return ones;
}
```

解法二：

位运算

```
public int singleNumber(int[] nums) {
    int ans = 0;
    for(int i = 0; i < 32; i++) {
        int sum = 0;
        for(int j = 0; j < nums.length; j++) {
            if(((nums[j] >> i) & 1) == 1) {
                sum++;
                sum %= 3;
            }
        }
        if(sum != 0) {
            ans |= sum << i;
        }
    }
    return ans;
}
```

#### 总结

位运算真的是太难懂的......