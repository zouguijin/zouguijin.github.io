title: leetcode27 Remove Element/leetcode283 Move Zeroes

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
- 只有发生元素赋值（非交换），才将边界指针移动。

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

##  leetcode#283 Move Zeroes

>Given an array `nums`, write a function to move all `0`'s to the end of it while maintaining the relative order of the non-zero elements.
>
>For example, given `nums = [0, 1, 0, 3, 12]`, after calling your function, `nums` should be `[1, 3, 12, 0, 0]`.
>
>**Note**:
>
>1. You must do this **in-place** without making a copy of the array.
>2. Minimize the total number of operations.

#### 解释

本题与leetcode27非常地相似，都是移动元素，只不过这里移动的是元素0，而且多了一点要求：

- 保持非零元素的原有前后顺序

#### 理解

leetcode27的大神解法中为了代码的简洁性，并没有考虑元素的交换，而是采用了直接覆盖，所以不能照抄用于本题。

只需要在其基础上添加元素交换的步骤即可。

#### 我的解法

```
class Solution {
    public void moveZeroes(int[] nums) {
        int end = 0;
        for(int i = 0; i < nums.length; i++) {
            if(nums[i] != 0) {
                int tmp = nums[end];
                nums[end++]  = nums[i];
                nums[i] = tmp;
            }
        }
    }
}
```

#### 大神解法

除了与我的解法相同的方法之外，还有下述方法：

先将非零元素都左移，然后将边界指针之后的数组空间全用0覆盖。

这种方法也是在leetcode27的基础上改进的，优点是保证了原有方法的模块完整性——在leetcode27方法完成之后，再补0。

```
// Shift non-zero values as far forward as possible
// Fill remaining space with zeros

public void moveZeroes(int[] nums) {
    if (nums == null || nums.length == 0) return;        
    
    int insertPos = 0;
    for (int num: nums) {
        if (num != 0) nums[insertPos++] = num;
    }        

    while (insertPos < nums.length) {
        nums[insertPos++] = 0;
    }
}
```

#### 总结

有关数组的算法真的是可以如此简洁。