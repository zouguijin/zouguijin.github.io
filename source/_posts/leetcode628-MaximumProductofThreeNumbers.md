title: leetcode628 Maximum Product of Three Numbers

date: 2017/09/22 15:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#628 Maximum Product of Three Numbers

>Given an integer array, find three numbers whose product is maximum and output the maximum product.
>
>**Example 1:**
>
>```
>Input: [1,2,3]
>Output: 6
>
>```
>
>**Example 2:**
>
>```
>Input: [1,2,3,4]
>Output: 24
>
>```
>
>**Note:**
>
>1. The length of the given array will be in range [3,104] and all elements are in the range [-1000, 1000].
>2. Multiplication of any three numbers in the input won't exceed the range of 32-bit signed integer.

#### 解释

给定一个整数数组，要求找到三个元素，使得这三个元素的乘积最大，输出最大的乘积值。

- 给定数组的大小范围为：[3,104]，元素的范围为：[-1000,1000]；
- 上述给定的范围保证了任意三个元素的乘积不会溢出32位的整型范围。

#### 我的解法

意思不就是...找出数组中最大的三个数么？找到之后，让他们三个相乘，输出结果即可。

使用一个自带排序的数据结构，比如PriorityQueue（不能用Set，可能会有重复的元素），维持三个元素的大小，遍历所有元素，不断利用大的替换队列中小的元素，最终剩下的三个元素就是数组中最大的三个元素。

需要注意一点的是，可能会有负数，如果有偶数个负数相乘，就不能单纯让三个最大的元素相乘得结果了。

那么可以这么做：先对数组进行**排序**，从小到大，绝对值最大的两个负数（如果有的话），就会存在数组的头部两位，数组中最大的三个数，会存在数组的尾部三位，所以需要**比较两个乘积**：数组后三位的乘积，数组前两位与数组最后一位的乘积。

解法一：没有考虑数组中存在负数，单纯取数组中最大的三个数进行相乘。

```
class Solution {
    public int maximumProduct(int[] nums) {
        int res = 1;
        if(nums.length == 3) {
            for(int num : nums) {
                res *= num;
            }
        }
        else {
            PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
            for(int num : nums) {
                queue.add(num);
                if(queue.size() == 4) queue.poll();
            }
            for(int i = 0; i < 3; i++) {
               res *= queue.poll(); 
            }
        }
        return res;
    }
}
```

解法二：先排序，后获取两个乘积值。

```
class Solution {
    public int maximumProduct(int[] nums) {
        int res = 1;
        if(nums.length == 3) {
            for(int num : nums) {
                res *= num;
            }
        }
        else {
            Arrays.sort(nums);
            int tmp1 = nums[0]*nums[1]*nums[nums.length-1];
            int tmp2 = nums[nums.length-1]*nums[nums.length-2]*nums[nums.length-3];
            res = tmp1 > tmp2 ? tmp1 : tmp2;
        }
        return res;
    }
}
```

#### 大神解法

解法一：先排序，后获取两个乘积值。

```
    public int maximumProduct(int[] nums) {
        
         Arrays.sort(nums);
         //One of the Three Numbers is the maximum value in the array.
         int a = nums[nums.length - 1] * nums[nums.length - 2] * nums[nums.length - 3];
         int b = nums[0] * nums[1] * nums[nums.length - 1];
         return a > b ? a : b;
    }
```

解法二：声势浩大的插入排序，只不过这个排序维持的只有最小的两个数和最大的三个数——所以思想是一样的：找到最小的两个数（考虑到有负数的情况，且可能绝对值较大）和最大三个数，再比较这两种乘积的大小。

```
    public int maximumProduct(int[] nums) {
        int max1 = Integer.MIN_VALUE, max2 = Integer.MIN_VALUE, max3 = Integer.MIN_VALUE, min1 = Integer.MAX_VALUE, min2 = Integer.MAX_VALUE;
        for (int n : nums) {
            if (n > max1) {
                max3 = max2;
                max2 = max1;
                max1 = n;
            } else if (n > max2) {
                max3 = max2;
                max2 = n;
            } else if (n > max3) {
                max3 = n;
            }

            if (n < min1) {
                min2 = min1;
                min1 = n;
            } else if (n < min2) {
                min2 = n;
            }
        }
        return Math.max(max1*max2*max3, max1*min1*min2);
    }
```