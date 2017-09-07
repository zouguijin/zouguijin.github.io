title: leetcode215 Kth Largest Element in an Array

date: 2017/09/07 10:00:00

categories:

- Study

tags:

- leetcode
- array
- heap
- DivideConquerAlgorithm

---

## leetcode#215 Kth Largest Element in an Array

>Find the **k**th largest element in an unsorted array. Note that it is the kth largest element in the sorted order, not the kth distinct element.
>
>For example,
>Given `[3,2,1,5,6,4]` and k = 2, return 5.
>
>**Note: **
>You may assume k is always valid, 1 ≤ k ≤ array's length.

#### 解释

给定一个无序数组，找出这个数组中按照从大到小顺序，第k顺位的数组元素（而不是第k个不同的元素）。

可以假设`1 ≤ k ≤ array's length` 。

#### 理解

从假设可以看出：数组非空，且`k >= 1` 。那么只要将数组排序，且剔除重复元素，那么依次取出剩余元素，取到第k个即为所求结果。

有一个问题，如果数组中有多个重复元素，且k值比较大的情况，如果剔除重复元素，那么剩余元素数量可能会小于k，怎么解决？—— 如果考虑到这个问题，那么就不能使用TreeSet等Set数据结构了，因为会剔除重复元素，应该直接使用优先级队列PriorityQueue。

#### 我的解法

优先级队列PriorityQueue——对整数自动排序，尾进头出，默认头部的元素值最小，所以需要做一个差值：`j <= nums.length - k` 。

时间复杂度O(NlgN)，空间复杂度O(N)。

```
class Solution {
    public int findKthLargest(int[] nums, int k) {
        PriorityQueue<Integer> queue = new PriorityQueue<Integer>();
        for(int i = 0; i < nums.length; i++) {
            queue.offer(nums[i]);
        }
        int kthMax = 0;
        for(int j = 0; j <= nums.length - k; j++) {
            kthMax = queue.poll();
        }
        return kthMax;
    }
}
```

#### 大神解法

解法一：时间复杂度O(NlgN)，空间复杂度O(1)

先对数组进行排序（排序结果是从小到大），然后挑出`nums[N - k]` 。

```
public int findKthLargest(int[] nums, int k) {
        final int N = nums.length;
        Arrays.sort(nums);
        return nums[N - k];
}
```

解法二：时间复杂度O(NlgN)，空间复杂度O(K)。

使用PriorityQueue，保持队列大小不超过k，空间复杂度略小于我的解法。

```
public int findKthLargest(int[] nums, int k) {
    final PriorityQueue<Integer> pq = new PriorityQueue<>();
    for(int val : nums) {
        pq.offer(val);
		// 保证队列元素不超过k个，带来的开销则是每次都要进行的比较操作
        if(pq.size() > k) {
            pq.poll();
        }
    }
    return pq.peek();
}
```

解法三：时间复杂度O(N)，空间复杂度O(1)。

**Quick Select**，快速查找算法，基本思想是：

选取其中一个元素作为**标杆**（本题中这个值可以随机选取），然后将小于标杆值的元素放在标杆的左侧，大于标杆值的元素放在标杆的右侧（所以是从小到大的排序），最后判断标杆值的索引与k的大小关系，如果标杆索引刚好等于k，则返回k所指的元素；如果标杆索引大于k，则继续检查和判断标杆索引右侧部分的值；否则，继续检查判断标杆索引左侧部分的值，直到标杆索引等于k。

构建了一个**递归算法** ，空间复杂度应该不会是O(1)，而且时间复杂度的最坏情况应该是O(N2)。

```
public int findKthLargest(int[] nums, int k) {
	if (nums == null || nums.length == 0) return Integer.MAX_VALUE;
    return findKthLargest(nums, 0, nums.length - 1, nums.length - k);
}    

public int findKthLargest(int[] nums, int start, int end, int k) { // quick select: kth smallest
	if (start > end) return Integer.MAX_VALUE;
	
	int pivot = nums[end]; // Take A[end] as the pivot 随机选一个值作为标杆值，由于中间需要交换，所以选最后一个元素比较好，避免标杆值不停交换
	int left = start;
	for (int i = start; i < end; i++) {
		if (nums[i] <= pivot) // Put numbers < pivot to pivot's left
			swap(nums, left++, i);			
	}
	swap(nums, left, end);// Finally, swap A[end] with A[left] left停的位置，所对应的元素值大于标杆值，所以需要交换一下，保证标杆值左侧小，右侧大
	
	if (left == k)// Found kth smallest number
		return nums[left];
	else if (left < k)// Check right part
		return findKthLargest(nums, left + 1, end, k);
	else // Check left part
		return findKthLargest(nums, start, left - 1, k);
} 

void swap(int[] A, int i, int j) {
	int tmp = A[i];
	A[i] = A[j];
	A[j] = tmp;				
}
```

对于时间复杂度的最坏情况，有人提出**随机定界**的方式，即对于`swap(int[] A, int i, int j)` 中的上界`j` ，使用随机数初始化。

#### 总结

QuickSelect算法也算作是**分治法思想**的一个体现：将整体依照一个标杆值，分成不同的块，然后不断递归迭代，直到在某一块中找到所需的元素。

#### 扩展阅读

>Blum-Floyd-Pratt-Rivest-Tarjan algorithm

