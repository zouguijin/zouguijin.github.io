title: leetcode448 Find All Numbers Disappeared in an Array

date: 2017/09/10 11:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#448 Find All Numbers Disappeared in an Array

>Given an array of integers where 1 ≤ a[i] ≤ *n* (*n* = size of array), some elements appear twice and others appear once.
>
>Find all the elements of [1, *n*] inclusive that do not appear in this array.
>
>Could you do it without extra space and in O(*n*) runtime? You may assume the returned list does not count as extra space.
>
>**Example:**
>
>```
>Input:
>[4,3,2,7,8,2,3,1]
>
>Output:
>[5,6]
>```

#### 解释

给定一个整数数组，无序，数组大小为`n` ，数组元素的范围为` 1 ≤ a[i] ≤ n` ，数组中有的元素有重复，要求找出1~n中没出现的数字（有几个找几个）。

假设返回的链表不算入空间复杂度，可否在时间复杂度O(N)和空间复杂度O(1)的限制下，解决问题？

#### 我的解法

从头开始遍历元素，每访问一个元素值，判断元素值是否等于索引值加1，是则继续访问下一个元素，否则，将该元素值与元素值减1作为索引的另一个元素值进行交换，**循环判断**，直到当前元素值等于索引值加1或者当前元素值与将要交换的元素值相等，此时继续访问下一个元素。

```
public class Solution {
    public List<Integer> findDisappearedNumbers(int[] nums) {
        for (int i = 0; i < nums.length; i++) {
            while (nums[i] != i + 1 && nums[i] != nums[nums[i] - 1]) {
                int tmp = nums[i];
                nums[i] = nums[tmp - 1];
                nums[tmp - 1] = tmp;
            }
        }
        List<Integer> res = new ArrayList<Integer>();
        for (int i = 0; i < nums.length; i++) {
            if (nums[i] != i + 1) {
                res.add(i + 1);
            }
        }
        return res;
    }
}
```

#### 大神解法

解法一：**交换法**

见上述解法。

解法二：**标记法**

对已出现元素对应索引的值进行标记（标记方法有很多，有置为负数的，有置为n或大于n的，反正置为不属于1~n范围的就可以），然后再次遍历数组，将未标记的索引值加1，添加到链表中并返回。

```
    public List<Integer> findDisappearedNumbers(int[] nums) {
        List<Integer> ret = new ArrayList<Integer>();
        
        for(int i = 0; i < nums.length; i++) {
            int val = Math.abs(nums[i]) - 1;
            if(nums[val] > 0) {
                nums[val] = -nums[val];
            }
        }
        
        for(int i = 0; i < nums.length; i++) {
            if(nums[i] > 0) {
                ret.add(i+1);
            }
        }
        return ret;
    }
```

这里需要**注意一点**，为了避免有的值被覆盖，需要这么做：`nums[(nums[i]-1) % n] += n` 。

```
public List<Integer> findDisappearedNumbers(int[] nums) {        
    List<Integer> res = new ArrayList<>();        
    int n = nums.length;        
    for (int i = 0; i < nums.length; i ++) nums[(nums[i]-1) % n] += n;        
    for (int i = 0; i < nums.length; i ++) if (nums[i] <= n) res.add(i+1);        
    return res;    
}
```



