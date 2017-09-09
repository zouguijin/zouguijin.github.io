title: leetcode167 Two Sum II - Input array is sorted

date: 2017/09/08 19:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#167 Two Sum II - Input array is sorted

>Given an array of integers that is already **sorted in ascending order**, find two numbers such that they add up to a specific target number.
>
>The function twoSum should return indices of the two numbers such that they add up to the target, where index1 must be less than index2. Please note that your returned answers (both index1 and index2) are not zero-based.
>
>You may assume that each input would have *exactly* one solution and you may not use the *same* element twice.
>
>**Input:** numbers={2, 7, 11, 15}, target=9
>**Output:** index1=1, index2=2

#### 解释

给定一个整数数组，数组**按照升序排序**，要求找到两个数字，这两个数字加起来刚好得到一个特定的数字，然后返回这两个数字的数组索引，且索引按照从小到大排序。

注意，返回的索引值，是从1开始计数的，即数组的索引为0，那么返回的索引值要为1。

#### 我的解法

最初的想法过于复杂：想着先用二分查找缩小范围，然后再一个一个地依次相加与`target` 比较。大部分情况下可行，但是边界不是很好把握，特别是本题的数组不一定是正数，所以在遇到`0` 的时候会出现问题。

后来使用的方法是，从数组的头尾两端依次取元素相加并与`target` 比较，不断地往中间靠拢。

时间复杂度O(N)。

```
class Solution {
    public int[] twoSum(int[] numbers, int target) {
        int[] res = new int[2];
        if(numbers.length < 2 || numbers == null) return res;
        int begin = 0;
        int end = numbers.length - 1;
        while(begin < end) {
            int tmp = numbers[begin] + numbers[end];
            if(tmp == target) {
                res[0] = begin + 1;
                res[1] = end + 1;
                break;
            } 
            else if(tmp > target) {
                end--;
            }
            else
                begin++;
        }
        return res;
    }
}
```

#### 大神解法

大部分也都是第二种思路。