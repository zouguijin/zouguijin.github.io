title: leetcode229 Majority Element II

date: 2017/09/09 15:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#229 Majority Element II

>Given an integer array of size *n*, find all elements that appear more than `⌊ n/3 ⌋` times. The algorithm should run in linear time and in O(1) space.

#### 解释

给定一个整数数组，大小为`n` ，找出出现频数大于`n/3` 的数组元素。

要求算法时间复杂度O(N)之内，空间复杂度为O(1)。

#### 我的解法

- 时间复杂度O(N)，那么就不能先排序，再找元素了（数组自带排序算法O(NlgN)）；
- 空间复杂度O(1)，那么就不能使用额外的数据结构**完整存储**数组元素了，比如HashMap；
- 大于`n/3` 的元素，数组中最多有两个。

综上，可以使用**额外的、大小有限的数据结构**存储数量有限的元素，比如存储两个待选的元素——这样也算O(1)的空间复杂度。

于是，可以基于leetcode169的投票算法，加以改进：使用大小为2的数组`tmp` 存储两个待定的元素，另外一个大小为2的数组`count` 存储对应的得票数。最后，获得两个得票最多的元素值之后，再判断他们各自的总票数是不是大于`n/2` 。

```
class Solution {
    public List<Integer> majorityElement(int[] nums) {
        List<Integer> res = new ArrayList<Integer>();
        if(nums == null) return res;
        
        int[] tmp = new int[]{0,1};
        int[] count = new int[2];
        for(int i = 0; i < nums.length; i++) {
            if(tmp[0] == nums[i]) count[0]++;
            else if(tmp[1] == nums[i]) count[1]++;
            else if(count[0] == 0) {
                tmp[0] = nums[i];
                count[0]++;
            }
            else if(count[1] == 0) {
                tmp[1] = nums[i];
                count[1]++;
            }
            else {
                count[0]--;
                count[1]--;
            }
        }
        count[0] = 0;
        count[1] = 0;
        for(int i = 0; i < nums.length; i++) {
            if(tmp[0] == nums[i]) count[0]++;
            else if(tmp[1] == nums[i]) count[1]++;
        }
        if(count[0] > nums.length/3) res.add(tmp[0]);
        if(count[1] > nums.length/3) res.add(tmp[1]);
        return res;
    }
}
```

#### 大神解法

大部分都是基于投票算法的改进。