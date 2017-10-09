title: leetcode611 Valid Triangle Number

date: 2017/10/09 17:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#611 Valid Triangle Number

>Given an array consists of non-negative integers, your task is to count the number of triplets chosen from the array that can make triangles if we take them as side lengths of a triangle.
>
>**Example 1:**
>
>```
>Input: [2,2,3,4]
>Output: 3
>Explanation:
>Valid combinations are: 
>2,3,4 (using the first 2)
>2,3,4 (using the second 2)
>2,2,3
>
>```
>
>**Note:**
>
>1. The length of the given array won't exceed 1000.
>2. The integers in the given array are in the range of [0, 1000].

#### 解释

给定一个元素为非负整数的数组，要求找出一种组合——组合中有三个元素，三个元素可以**满足构成三角形三边的条件**，返回该组合的数量。

- 所给数组的长度不超过1000；
- 数组中整数的范围为：[0,1000]。

#### 我的解法

三角形三条边所需要满足的条件为：`a+b>c && b+c>a && a+c>b` ，三个条件看上去有点多，而且实现三个比较既耗时又耗资源。

思考一下是不是可以简化？那么先将数组元素进行**排序**吧！可以看到，如果有序：`a<=b<=c` ，那么只需要`a+b>c` 即可。 这么一来需要先后取三个元素，用前两个元素相加的值与第三个元素值进行比较，那么需要排除两个情况：

- 零元素的情况，只有除去零元素，`a<=b<=c && a+b>c` 的条件才可以成立；
- 除去零元素之后，数组元素不足3个。

接下来，就是依次取三个元素，进行比较的过程了。

```
class Solution {
    public int triangleNumber(int[] nums) {
        if(nums.length == 0) return 0;
        Arrays.sort(nums);
        int begin = 0;
        while(nums[begin] == 0 && begin < nums.length - 1) {
            begin++;
        }
        if(nums.length - begin < 2) return 0;
        
        int count = 0;
        while(begin < nums.length - 2) {
            int mid = begin + 1;
            while(mid < nums.length - 1) {
                int end = mid + 1;
                while(end < nums.length) {
                    if(nums[begin] + nums[mid] > nums[end]) {
                        count++;
                        end++;
                    }
                    else
                        break;
                }
                mid++;
            }
            begin++;
        }
        return count;
    }
}
```

#### 大神解法

解法一：取一个最小的和两个最大的

先排序，然后三个值分别位于数组开头（最小的数）A和数组的末尾两个（两个最大的数）B、C，每次比较的时候，判断：A+B>C?，如果是的，**说明A到B之间的任意一个数与B相加都会满足A+B>C**，即可以组成三角形（因为A到B之间的任何一个数都大于A），所以计数值累加(B-A)；如果不是，那么A往后移动一位，继续上述比较（此时，B和C位置不动），直到A的位置到达B的位置之后，B和C需要同时往前移动一位，继续上述比较。

```
public static int triangleNumber(int[] A) {
    Arrays.sort(A);
    int count = 0, n = A.length;
    for (int i=n-1;i>=2;i--) {
        int l = 0, r = i-1;
        while (l < r) {
            if (A[l] + A[r] > A[i]) {
                count += r-l;
                r--;
            }
            else l++;
        }
    }
    return count;
}
```

解法二：类似的方法

```
public class Solution {
    public int triangleNumber(int[] nums) {
        int result = 0;
        if (nums.length < 3) return result;
        
        Arrays.sort(nums);

        for (int i = 2; i < nums.length; i++) {
            int left = 0, right = i - 1;
            while (left < right) {
                if (nums[left] + nums[right] > nums[i]) {
                    result += (right - left);
                    right--;
                }
                else {
                    left++;
                }
            }
        }
        
        return result;
    }
}
```

#### 总结

不仔细分析会以为要有三层循环，最里层的循环还要有三次比较，但是**结合三角形的性质和排序分析**之后，可以仅用一次比较和两层循环把问题解决。