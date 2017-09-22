title: leetcode665 Non-decreasing Array

date: 2017/09/22 16:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#665 Non-decreasing Array

>Given an array with `n` integers, your task is to check if it could become non-decreasing by modifying **at most** `1`element.
>
>We define an array is non-decreasing if `array[i] <= array[i + 1]` holds for every `i` (1 <= i < n).
>
>**Example 1:**
>
>```
>Input: [4,2,3]
>Output: True
>Explanation: You could modify the first 4 to 1 to get a non-decreasing array.
>
>```
>
>**Example 2:**
>
>```
>Input: [4,2,1]
>Output: False
>Explanation: You can't get a non-decreasing array by modify at most one element.
>
>```
>
>**Note:** The `n` belongs to [1, 10,000].

#### 解释

给定一个具有n个整数的数组，判断数组是否是**不减**的数组或者**改变一个元素**之后是否是不减的数组。

所谓“不减”，就是后一个元素大于或者等于前一个元素。

n的范围为：[1,10000]。

#### 我的解法

最简单的方法就是，依次遍历数组元素，比较相邻元素的大小关系，如果最多只出现一次前一个元素大于后一个元素的情况，那么可以说数组是一个”不减“的数组，否则返回`false` 。

```
class Solution {
    public boolean checkPossibility(int[] nums) {
        int chance = 1;
        int length = nums.length - 1;
        while(chance >= 0 && length >= 1) {
            if(nums[length] >= nums[length-1]) {
                length--;
                continue;
            }
            else {
                length--;
                chance--;
            }
        }
        return chance >= 0 ? true : false;
    }
}
```

但是上书解法会出现一个**错误**：就是相邻元素的关系满足“不减”，但是相距一定距离的两个元素不满足“不减”，所以不能单纯地比较相邻元素。

于是，需要全局考虑，那就先将数组元素的一个拷贝进行排序，然后将排序后数组与原数组的**每一位依次进行比较**，如果排序后的数组的每一位都大于等于原数组的相应位置元素，那么满足“不减”，或至多有一位小于原数组的对应位置元素，也可以是“不减”的。

```
class Solution {
    public boolean checkPossibility(int[] nums) {
        PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
        for(int num : nums) {
            queue.offer(num);
        }
        int chance = 1;
        int index = 0;
        while(chance >=0 && index < nums.length) {
            if(queue.poll() < nums[index]) {
                chance--;
                index++;
            }
            else {
                index++;
                continue;
            }
        }
        return chance >=0 ? true : false;
    }
}
```

上述解法也存在一个问题：连续的、对称的大小反转情况，将判断不出来，比如`[1 2 4] -> [4 2 1]` 。 

那么，还可以使用一个标记值`mark` ，用于**标记已遍历过的数组元素中的最大值**，如果后续元素有大于该标记值的元素，则替换该标记值，如果后续元素中有元素小于该标记值，且出现这种情况的次数大于1次，则该数组不满足“不减”的条件。

该解法仍旧存在**问题**：也许后续的元素都比某一个元素小，该解法会判断出`false` ，但是实际上将该元素改成比后续元素小即可，也满足“只修改一次”的条件。

```
class Solution {
    public boolean checkPossibility(int[] nums) {
        int mark = nums[0];
        int chance = 1;
        int index = 0;
        while(chance >= 0 && index < nums.length) {
            if(mark > nums[index]) {
                chance--;
                index++;
            }
            else {
                mark = nums[index];
                index++;
            }
        }
        return chance >= 0 ? true : false;
    }
}
```

#### 大神解法

Greedy

考虑到如果出现不满足“不减”的情况，**肯定首先出现一个相邻两个元素下降的位置** ，从这个相邻位置出发，每遇到一个下降的位置就修改一次——即**不断局部的检测和修改**，就可以将该位置的元素大小信息**扩散**到后续位置上，从而可以避免上述前两种不完全的错误解法。

```
 public boolean checkPossibility(int[] nums) {
        int cnt = 0; //the number of changes
        for(int i = 1; i < nums.length && cnt<=1 ; i++){
            if(nums[i-1] > nums[i]){
                cnt++;
                //modify nums[i-1] of a priority
                // 比较相邻的三个数，选取其中最大的数，赋值给 i-1 或者 i 位置
                // 从而将“当前最大的数”这个信息，逐渐往后续的元素位置上扩散
                if(i-2<0 || nums[i-2] <= nums[i])nums[i-1] = nums[i];  
                else nums[i] = nums[i-1]; //have to modify nums[i]
            }
        }
        return cnt<=1; 
    }
```

#### 总结

看似简单的问题......换了三种方式都没有做出来，真是惭愧，不过示例解法确实...想不到，GREEDY算法，还需要多多看看啊。