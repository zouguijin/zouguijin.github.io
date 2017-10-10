title: leetcode15 3Sum

date: 2017/10/10 21:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#15 3Sum

>Given an array *S* of *n* integers, are there elements *a*, *b*, *c* in *S* such that *a* + *b* + *c* = 0? Find all unique triplets in the array which gives the sum of zero.
>
>**Note:** The solution set must not contain duplicate triplets.
>
>```
>For example, given array S = [-1, 0, 1, 2, -1, -4],
>
>A solution set is:
>[
>  [-1, 0, 1],
>  [-1, -1, 2]
>]
>```

#### 解释

给定一个包含n个整数的数组S，找出其中所有的**和值为0**的三个数的组合。注：给出的答案中，**不能有重复的组合**。

#### 我的解法

先对数组元素进行排序，然后使用三个指针，其中两个指针分别指向数组中较大的两个数，一个指针指向数组中较小的一个数，判断三个指针所指元素的和值与0的大小关系：如果和值小于0，那么指向较小的数的指针后移；如果和值大于零，那么中间的指针前移。当上述两个指针相遇之后，开启下一次循环：最后一个指针前移一位，重复上述的操作。

结果本解法是**TLE**......

```
class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> res = new ArrayList<>();
        if(nums.length < 3) return res;
        Arrays.sort(nums);
        for(int end = nums.length - 1; end >=2; end--) {
            int begin = 0;
            int mid = end - 1;
            while(begin < mid) {
                int sum = nums[begin] + nums[mid] + nums[end];
                if(sum == 0) {
                    List<Integer> list = new ArrayList<Integer>();
                    list.add(nums[begin]);
                    list.add(nums[mid]);
                    list.add(nums[end]);
                    if(!res.contains(list)) res.add(list);
                    begin++;
                }
                else if(sum < 0) {
                    begin++;
                }
                else {
                    mid--;
                }
            }
        }
        return res;
    }
}
```

#### 大神解法

解法一：

先对数组元素进行排序，同样取三个指针，其中两个指针指向较小的两个数，一个指针指向较大的一个数，同样有类似有序双端队列的指针移动操作，但是在内循环外添加了一个准入条件：`i == 0 || (i > 0 && num[i] != num[i-1])` ，意思就是，如果有重复的数组元素，那么就跳过，不进行加和与比较，同理，在内循环中也有这一个判断： `while (lo < hi && num[lo] == num[lo+1]) lo++; while (lo < hi && num[hi] == num[hi-1]) hi--;` ，这样**相同的元素就会直接跳过**，既节省了时间（加和与比较操作，耗时），同时也保证了结果中不会出现重复的结果。

```
public List<List<Integer>> threeSum(int[] num) {
    Arrays.sort(num);
    List<List<Integer>> res = new LinkedList<>(); 
    for (int i = 0; i < num.length-2; i++) {
        if (i == 0 || (i > 0 && num[i] != num[i-1])) {
            int lo = i+1, hi = num.length-1, sum = 0 - num[i];
            while (lo < hi) {
                if (num[lo] + num[hi] == sum) {
                    res.add(Arrays.asList(num[i], num[lo], num[hi]));
                    while (lo < hi && num[lo] == num[lo+1]) lo++;
                    while (lo < hi && num[hi] == num[hi-1]) hi--;
                    lo++; hi--;
                } else if (num[lo] + num[hi] < sum) lo++;
                else hi--;
           }
        }
    }
    return res;
}
```

解法二：

比较类似于我的解法，看了该解法之后，我觉得**我的解法出现TLE问题的根源应该就是没有在遍历的时候过滤掉相邻的相同数组元素**。

```
public class Solution {
    public List<List<Integer>> threeSum(int[] nums) {
        List<List<Integer>> result = new ArrayList<>();
        if(nums.length < 3) return result;
        Arrays.sort(nums);
        int i = 0;
        while(i < nums.length - 2) {
            if(nums[i] > 0) break;
            int j = i + 1;
            int k = nums.length - 1;
            while(j < k) {
                int sum = nums[i] + nums[j] + nums[k];
                if(sum == 0) result.add(Arrays.asList(nums[i], nums[j], nums[k]));
                if(sum <= 0) while(nums[j] == nums[++j] && j < k);
                if(sum >= 0) while(nums[k--] == nums[k] && j < k);
            }
            while(nums[i] == nums[++i] && i < nums.length - 2);
        }
        return result;
    }
}
```

