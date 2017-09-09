title: leetcode88 Merge Sorted Array

date: 2017/09/07 17:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#88 Merge Sorted Array

>Given two sorted integer arrays *nums1* and *nums2*, merge *nums2* into *nums1* as one sorted array.
>
>**Note:**
>You may assume that *nums1* has enough space (size that is greater or equal to *m* + *n*) to hold additional elements from *nums2*. The number of elements initialized in *nums1* and *nums2* are *m* and *n* respectively.

#### 解释

给定两个有序数组，要求将两个数组合成一个有序数组。

假设数组1具有足够的空间，能够容纳数组1加上数组2的所有元素。

#### 我的解法

最初的想法：将两个数组的元素都存入优先级队列PriorityQueue中，然后再依次取出来。但是效率肯定会很差......

```
class Solution {
    public void merge(int[] nums1, int m, int[] nums2, int n) {
        PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
        for(int i = 0; i < m; i++) {
            queue.offer(nums1[i]);
        }
        for(int i = 0; i < n; i++) {
            queue.offer(nums2[i]);
        }
        for(int k = 0; k < (m+n); k++) {
            nums1[k] = queue.poll();
        }
    }
}
```

后来尝试了一下，用两个指针分别指向两个数组的起始位置，然后往后比较、交换元素，情况过于复杂......

没有想到从后往前......

#### 大神解法

**从后往前**对两个数组的元素进行比较和交换——避免了数组前半部分的较小元素需要**后移**的操作。

```
public void merge(int A[], int m, int B[], int n) {
    int i=m-1, j=n-1, k=m+n-1;
    while (i>-1 && j>-1) A[k--]= (A[i]>B[j]) ? A[i--] : B[j--];
    // 如果B数组长于A数组，且剩下的是较小的数，那么将剩余的B数组中较小的数赋值到A数组的前半部即可
    while (j>-1)         A[k--]=B[j--];
}
```

#### 总结

数组适合查找，不适合插入，所以如果空间足够，从后往前插入将会是一个**避免元素后移操作**的好办法。