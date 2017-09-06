title: leetcode414 Third Maximum Number

date: 2017/09/06 16:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#414 Third Maximum Number

>Given a **non-empty** array of integers, return the **third** maximum number in this array. If it does not exist, return the maximum number. The time complexity must be in O(n).
>
>**Example 1:**
>
>```
>Input: [3, 2, 1]
>
>Output: 1
>
>Explanation: The third maximum is 1.
>
>```
>
>**Example 2:**
>
>```
>Input: [1, 2]
>
>Output: 2
>
>Explanation: The third maximum does not exist, so the maximum (2) is returned instead.
>
>```
>
>**Example 3:**
>
>```
>Input: [2, 2, 3, 1]
>
>Output: 1
>
>Explanation: Note that the third maximum here means the third maximum distinct number.
>Both numbers with value 2 are both considered as second maximum.
>```

#### 解释

给定一个非空整数数组，要求返回数组中从大到小排序，**位于第三**的数值，如果没有，则返回数组中最大的数值。

注意，**相同的数值在大小排序上并列**，即`[2,2,1]` 就没有第三大的数值，两个`2` 算排名第一的数值。

要求时间复杂度O(N)。

#### 理解

考虑使用TreeSet数据结构，因为TreeSet中元素不重复（解决了重复元素并列的问题）且会对元素进行自动排序（不需要手动排序）。

#### 我的解法

使用TreeSet对数组元素进行存储，自动剔除重复元素，由于TreeSet的自动排序，于是可以从大到小依次取出元素，如果有第三顺位的元素，则返回它，否则返回最大的元素。时间复杂度O(N)，空间复杂度O(N)。

此外可以看出，TreeSet对于整型数的排序是：大的数位于树的高层（highest）。

```
class Solution {
    public int thirdMax(int[] nums) {
        TreeSet<Integer> tree = new TreeSet<Integer>();
        for(int i = 0; i < nums.length; i++) {
            tree.add(nums[i]);
        }
        int max = tree.last();
        int thirdMax = 0;
        for(int k = 0; k < 3; k++) {
            if(tree.isEmpty()) {
                thirdMax = max;
                break;
            }
            else
                thirdMax = tree.pollLast();
        }
        return thirdMax;
    }
}
```

#### 大神解法

解法一：简单的顺序比较，时间复杂度O(N)，空间复杂度O(1)。

其中，三个变量的大小关系为：`max1>max2>max3` 

```
 public int thirdMax(int[] nums) {
        // 由于数组元素可能不足3个，所以要想用null表示，就需要利用整形对象Integer
        Integer max1 = null;
        Integer max2 = null;
        Integer max3 = null;
        for (Integer n : nums) {
        	// 如果有相同的，则跳过本次循环
            if (n.equals(max1) || n.equals(max2) || n.equals(max3)) continue;
            // 条件语句，依次比较和赋值
            if (max1 == null || n > max1) {
                max3 = max2;
                max2 = max1;
                max1 = n;
            } else if (max2 == null || n > max2) {
                max3 = max2;
                max2 = n;
            } else if (max3 == null || n > max3) {
                max3 = n;
            }
        }
        return max3 == null ? max1 : max3;
    }
```

解法二：Set+PriorityQueue数据结构。

Set用于去除数组中的重复元素，PriorityQueue用于对剩余不重复的数组元素进行排序。

感觉效果与直接使用TreeSet数据结构的效果是一样的。（于是我不明白为什么leetcode上说这个算法的空间复杂度为O(1)？）

此外，可以看出PriorityQueue对整型数的排序是：小的数位于队列头部。

```
public class Solution {
    public int thirdMax(int[] nums) {
       PriorityQueue<Integer> pq = new PriorityQueue<>();
       Set<Integer> set = new HashSet<>();
       for(int n : nums) {
           if(set.add(n)) {
               pq.offer(n);
               if(pq.size() > 3 ) pq.poll();
           }
       }
       if(pq.size() == 2) pq.poll();
       return pq.peek();
    }
}
```

#### 总结

从本题可以看出，**熟悉基本数据结构**对于解题的重要性——基本数据结构封装了十分便利好用的方法，而且这些方法大部分都进行过优化，在大部分场景下可以直接使用或者修改使用，且满足复杂度要求。