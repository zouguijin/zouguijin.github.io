title: leetcode35 Search Insert Position

date: 2017/08/31 15:00:00

categories:

- Study

tags:

- leetcode
- array
- BinarySearch

---

## leetcode#35 Search Insert Position 

>Given a sorted array and a target value, return the index if the target is found. If not, return the index where it would be if it were inserted in order.
>
>You may assume no duplicates in the array.
>
>Here are few examples.
>[1,3,5,6], 5 → 2
>[1,3,5,6], 2 → 1
>[1,3,5,6], 7 → 4
>[1,3,5,6], 0 → 0
>

#### 解释

给定一个有序数组和一个目标值，对数组进行查找，如果有目标值，则返回其索引；如果没有找到目标值，则返回目标值应该插入的位置索引。（假设数组中没有重复值）

#### 理解

本题关于数组的查找问题，第一感觉是使用**二分法**进行查找。

#### 我的解法

二分法对数组进行搜索和查找。

中间位置的节点计算使用的是：`midPos = (end - begin)/2 + begin` 

在边界判断的时候遇到了一点小麻烦，最后写成的方法虽然完成了功能，但是语句上有点冗余。

```
class Solution {
    public int searchInsert(int[] nums, int target) {
        int end = nums.length;
        int begin = 0;
        int midPos = 0;
        
        while(true) {
            midPos = (end - begin)/2 + begin;
            if(nums[midPos] == target) return midPos;
            else if(nums[midPos] > target) {
                if((midPos - begin)/2 == 0) {
                    if(nums[begin] < target) return midPos;
                    else
                        return begin;
                }
                end = midPos;
            }
            else {
                if((end - midPos)/2 == 0) return end;
                begin = midPos;
            }
        }
    }
}
```

#### 大神解法

学习一下大神们简洁的二分查找算法：

- 中间位置的计算使用的是**加法** && `high = A.length-1` —— 加法在对于索引值较大的情况下，可能会**溢出**OVERFLOW；
- 循环判定条件是`low <= high` ，也即两个节点分别向对方移动；
- 如果一直没找到，那么直到循环判定条件失效时，返回`low` 所指位置索引。

```
 public int searchInsert(int[] A, int target) {
        int low = 0, high = A.length-1;
        while(low<=high){
            int mid = (low+high)/2;
            if(A[mid] == target) return mid;
            else if(A[mid] > target) high = mid-1;
            else low = mid+1;
        }
        return low;
    }
```

- 中间位置的计算使用的是**减法** && `high = nums.length` ；
- 循环判定条件是`low < high` ，也即两个节点分别向对方移动，但与上述方式有细微的差别；
- 如果一直没找到，那么直到循环判定条件失效时，返回`low` 所指位置索引；
- `low + (high - low) / 2` ，可以让`low` 不断增加，也可以让`high` 不断下降，关键是在`low/high` 两个指针相邻的时候，`(high - low)/2 = 0` 能够让`high` 再次下降使得`high = low` ，从而跳出循环，返回`low` 所指位置的索引。

```
public class Solution {
public int searchInsert(int[] nums, int target) {
    int low = 0, high = nums.length;
    while(low < high) {
        int mid = low + (high - low) / 2;
        if(nums[mid] < target)
            low = mid + 1;
        else
            high = mid;
    }
    return low;
}
```

#### 总结

- 边界问题真的是有关数组算法中的麻烦事儿！解决边界问题相当于解决了一大半的数组算法问题！
- 使用数组索引二分法查找的时候，尽量使用**减法**，即`midPos = (end - begin)/2 + begin` ，从而避免可能的溢出OVERFLOW。