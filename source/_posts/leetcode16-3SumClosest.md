title: leetcode16 3Sum Closest

date: 2017/10/10 17:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#16 3Sum Closest

>Given an array *S* of *n* integers, find three integers in *S* such that the sum is closest to a given number, target. Return the sum of the three integers. You may assume that each input would have exactly one solution.
>
>```
>    For example, given array S = {-1 2 1 -4}, and target = 1.
>
>    The sum that is closest to the target is 2. (-1 + 2 + 1 = 2).
>```

#### 解释

给定一个包含n个整数的数组S，以及一个目标值target，要求从数组中找出三个元素，这三个元素之和**最接近**目标值target，并将该和值返回。

假设每一次的输入有且只有一个答案。

#### 我的解法

最简单的想法是：先排序，然后从头开始每次取三个元素相加，相加的得到的临时和值与目标值作差取绝对值，作为临时差值，比较临时差值与当前差值，用小的差值更新当前的差值，与此同时用临时和值更新当前和值，以此类推。

上述解法的问题在于，如果从头开始遍历，那么需要三层循环，时间复杂度为O(n3)，而且会出现很大程度的冗余比较步骤。

后来的想法，就类似leetcode611，先对数组元素进行排序，然后同样使用三个指针：`begin` 指向数组的最小元素，`mid` 和`end` 指向数组的两个最大元素，`mid < end` ，其中`end` 只在外层循环修改，而`begin` 和`mid` 在内层循环移动：当和值小于目标值的时候，`begin++` ，向后移动；当和值大于目标值的时候，`mid--` ，向前移动。

```
class Solution {
    public int threeSumClosest(int[] nums, int target) {
        Arrays.sort(nums);
        int difference = Integer.MAX_VALUE;
        int sum = target;
        int length = nums.length;
        for(int end = length - 1; end >= 2; end--) {
            int begin = 0;
            int mid = end - 1;
            while(begin < mid) {
                int tmpSum = nums[begin] + nums[mid] + nums[end];
                int tmpDifference = Math.abs(tmpSum - target);
                if(tmpDifference == 0) return target;
                if(tmpDifference < difference) {
                    difference = tmpDifference;
                    sum = tmpSum;
                }
                if(tmpSum < target) begin++;
                else
                    mid--;
            }
        }
        return sum;
    }
}
```

#### 大神解法

解法一：

借鉴了leetcode15的思想，同样先排序，然后利用三个指针，初始时，两个指针指向最小的两个数，一个指针指向最大的一个数，三个数相加，判断和值与目标值的大小关系：如果和值小于目标值，那么中间的指针后移；如果和值大于目标值，最后一个指针前移。与此同时，要判断之前与当前的和值与目标值的两个差值的大小关系，对于更小的差值需要更新。

其实类似于上述解法，只不过中间的指针所指的位置刚好相反而已。

```
public class Solution {
    public int threeSumClosest(int[] num, int target) {
        int result = num[0] + num[1] + num[num.length - 1];
        Arrays.sort(num);
        for (int i = 0; i < num.length - 2; i++) {
            int start = i + 1, end = num.length - 1;
            while (start < end) {
                int sum = num[i] + num[start] + num[end];
                if (sum > target) {
                    end--;
                } else {
                    start++;
                }
                if (Math.abs(sum - target) < Math.abs(result - target)) {
                    result = sum;
                }
            }
        }
        return result;
    }
}
```

解法二：

只比较需要比较之处，从而节省时间。

与解法一类似，都是两个指针指向较小的两个数，一个指针指向较大的一个数。

与解法一不同的是，本解法分为两个部分：和值大于目标值的部分与和值小于目标值的部分——在和值大于目标值的部分，并不是每一个和值都要与目标值作差，而是直至找到临界位置，才利用和值与目标值作差，同理。所以，每一次在两个部分只会各自作差一次，**作差的位置就在和值临近目标值的附近** ，如此一来就可以缩减作差的次数，从而缩减程序时间。

```
public class Solution {
public int threeSumClosest(int[] nums, int target) {
    Arrays.sort(nums);
    int closest=nums[0]+nums[1]+nums[2];
    int low,high;
    for(int i=0;i<nums.length-1;i++){
        low=i+1;
        high=nums.length-1;
        while(low<high){
            if(nums[low]+nums[high]==target-nums[i]) return target;
            else if(nums[low]+nums[high]>target-nums[i]){
                while(low<high&&nums[low]+nums[high]>target-nums[i]) high--;
                if(Math.abs(nums[i]+nums[low]+nums[high+1]-target)<Math.abs(closest-target))
                    closest=nums[i]+nums[low]+nums[high+1];
            }
            else{
                while(low<high&&nums[low]+nums[high]<target-nums[i]) low++;
                if(Math.abs(nums[i]+nums[low-1]+nums[high]-target)<Math.abs(closest-target))
                    closest=nums[i]+nums[low-1]+nums[high];
            }
        }
    }
    return closest;
}
```

#### 总结

其实这类型的题，有点类似有序双端队列：往队首移动取值可以减小和值，往队尾移动取值可以增加和值。