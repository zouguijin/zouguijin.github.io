title: leetcode485 Max Consecutive Ones

date: 2017/09/22 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#485 Max Consecutive Ones

>Given a binary array, find the maximum number of consecutive 1s in this array.
>
>**Example 1:**
>
>```
>Input: [1,1,0,1,1,1]
>Output: 3
>Explanation: The first two digits or the last three digits are consecutive 1s.
>    The maximum number of consecutive 1s is 3.
>
>```
>
>**Note:**
>
>- The input array will only contain `0` and `1`.
>- The length of input array is a positive integer and will not exceed 10,000

#### 解释

给定一个二进制数组（即只有0和1两种元素），要求找到数组中1连续出现的最大长度。

- 数组的长度范围为：[1,10000]

#### 我的解法

使用一个指针对元素进行遍历，在遍历的过程中，遇到元素为1则计数值累加，遇到元素为0则计数中断，将之前累加值与全局累加值进行比较，将较大的赋值给全局累加值，计数值置为0，重新再来，以此类推。

本解法虽然不够简洁，但是优点在于：只有在遇到0中断累加时，才会让计数值与全局最大值进行比较和赋值，即减少无谓的比较操作。

```
class Solution {
    public int findMaxConsecutiveOnes(int[] nums) {
        int point = 0;
        int maxLength = 0;
        int tmpCount = 0;
        for(int i = 0; i < nums.length; i++) {
            if(nums[i] == 1) tmpCount++;
            else if(tmpCount != 0) {
                maxLength = Math.max(maxLength,tmpCount);
                tmpCount = 0;
            }
            else
                continue;
        }
        maxLength = Math.max(maxLength,tmpCount);
        return maxLength;
    }
}
```

#### 大神解法

该解法中，每一步的累加都会直接与全局最大值进行比较——即每一步都需要比较，即使出现了很多的0。

每一步都比较，带来的好处就是实现的简洁性。

```
    public int findMaxConsecutiveOnes(int[] nums) {
        int maxHere = 0, max = 0;
        for (int n : nums)
            max = Math.max(max, maxHere = n == 0 ? 0 : maxHere + 1);
        return max; 
    } 
```

