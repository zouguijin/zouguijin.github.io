title: leetcode532 K-diff Pairs in an Array

date: 2017/09/10 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#532 K-diff Pairs in an Array

>Given an array of integers and an integer **k**, you need to find the number of **unique** k-diff pairs in the array. Here a **k-diff** pair is defined as an integer pair (i, j), where **i** and **j** are both numbers in the array and their **absolute difference** is **k**.
>
>**Example 1:**
>
>```
>Input: [3, 1, 4, 1, 5], k = 2
>Output: 2
>Explanation: There are two 2-diff pairs in the array, (1, 3) and (3, 5).
>Although we have two 1s in the input, we should only return the number of unique pairs.
>```
>
>**Example 2:**
>
>```
>Input:[1, 2, 3, 4, 5], k = 1
>Output: 4
>Explanation: There are four 1-diff pairs in the array, (1, 2), (2, 3), (3, 4) and (4, 5).
>```
>
>**Example 3:**
>
>```
>Input: [1, 3, 1, 5, 4], k = 0
>Output: 1
>Explanation: There is one 0-diff pair in the array, (1, 1).
>```
>
>**Note:**
>
>1. The pairs (i, j) and (j, i) count as the same pair.
>2. The length of the array won't exceed 10,000.
>3. All the integers in the given input belong to the range: [-1e7, 1e7].

#### 解释

给定一个整数数组（整数有正有负）和一个整数k，要求找出满足`k-diff` 条件的两个数组合的数量，`k-diff` 条件为：两个数之差的绝对值等于k。

两个数的组合不论先后顺序，数量都算作1。

#### 我的解法

先对数组进行排序，然后指定一前一后**两个索引**，依次遍历比较过去，如果有相同则计数值加1，由于数组已经是有序的，所以只需要利用`nums[end] - nums[begin]` 与`k` 比较即可。

其中有一个需要注意的点是，`k-diff` 条件要求相同的一对数只能算作一次，即之后再次出现相同的一对数满足条件，也不能计数，所以需要**多增加一个变量** `preKdiff`，保存之前满足`k-diff` 条件时的那对数中的其中一个，如果之后又遇到相同的一对数，就可以避开。

Runtime击败了98.54% 。

```
class Solution {
    public int findPairs(int[] nums, int k) {
        if(nums == null || nums.length < 2 || k < 0) return 0;
        
        int begin = 0;
        int end = 1;
        int kdiffNum = 0;
        Arrays.sort(nums);
        int preKdiff = nums[0] - 1;
        while(end < nums.length) {
            if(nums[end] - nums[begin] == k) {
                if(preKdiff != nums[begin]) {
                    kdiffNum++;
                    preKdiff = nums[begin];
                }
                begin++;
                end++;
            }
            else if(nums[end] - nums[begin] > k) {
                if(begin + 1 < end) begin++;
                else {
                    begin++;
                    end++;
                }
            }
            else end++;
        }
        return kdiffNum;
    }
}
```

#### 大神解法

解法一：HashSet或者HashMap

- 由于`k-diff` 条件中的一对数不论出现多少次都算作一次，所以可以使用**HashSet过滤数组元素**；
- 判断`nums[i] - k`和`nums[i] + k` ，有则添加到HashSet中（如果重复则自动不添加）；
- 最后统计HashSet中的元素数量。

```
public class Solution {
    public int findPairs(int[] nums, int k) {
        if (k < 0) { return 0; }

        Set<Integer> starters = new HashSet<Integer>();
        Set<Integer> uniqs = new HashSet<Integer>();
        for (int i = 0; i < nums.length; i++) {
            if (uniqs.contains(nums[i] - k)) starters.add(nums[i] - k);
            if (uniqs.contains(nums[i] + k)) starters.add(nums[i]);
            uniqs.add(nums[i]);
        }
        return starters.size();
    }
}
```

解法二：同样是使用两个索引值

