title: leetcode27 Remove Element

date: 2017/08/31 12:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#27 Remove Element

>Given an array and a value, remove all instances of that value in place and return the new length.
>
>Do not allocate extra space for another array, you must do this in place with constant memory.
>
>The order of elements can be changed. It doesn't matter what you leave beyond the new length.
>
>**Example:**
>Given input array *nums* = `[3,2,2,3]`, *val* = `3`
>
>Your function should return length = 2, with the first two elements of *nums* being 2.

#### 解释

给定一个数组和一个值，要求从数组中删除与该值相同的元素，剩余的k个数组元素全部移动到数组前k个位置（顺序不做要求，也不管k之后的数组空间中有什么）。

要求不能使用给定数组之外的空间，即空间复杂度为O(1)。

#### 理解

本题是关于**数组元素的简单交换**，指定两个移动的数组指针，一个标志`end` 已选出的不同元素构成的结果数组的边界，另一个则为搜索指针`movPoint` ，搜索与给定值不相同的数组元素，若找到，则与`end` 所在位置的数组元素进行交换。以此类推，直到两个指针中的任何一个到达数组的末尾。

#### 我的解法

```
class Solution {
    public int removeElement(int[] nums, int val) {
        int end = 0;
        int movPoint = 0;
        while(movPoint < nums.length && end < nums.length) {
            if(nums[end] != val) {
                end++;
                movPoint = end;
            }
            else {
                //movPoint++;
                if(nums[movPoint] != val) {
                    int tmp = nums[end];
                    nums[end] = nums[movPoint];
                    nums[movPoint] = tmp;
                    end++;
                }
                movPoint++;
            }
        }
        return end;
    }
}
```

#### 大神解法

也许是年代久远，题目给的变量都跟现在不一样，不过真的是**简洁无比**！

- 一个`for` 循环，控制着搜索指针的移动，直到发现与给定值不同的数组元素；
- 只有发生元素交换，才将边界指针移动。

```
public int removeElement(int[] A, int elem) {
   int m = 0;    
   for(int i = 0; i < A.length; i++){
       if(A[i] != elem){
           A[m++] = A[i];
       }
   }
   return m;
}
```

#### 总结

有关数组的算法真的是可以如此简洁。