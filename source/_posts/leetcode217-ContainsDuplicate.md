title: leetcode217 Contains Duplicate

date: 2017/09/05 16:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#217 Contains Duplicate

>Given an array of integers, find if the array contains any duplicates. Your function should return true if any value appears at least twice in the array, and it should return false if every element is distinct.

#### 解释

给定一个元素为整数的数组，要求判断该数组有没有重复的元素，如果有重复元素，则返回`true` ，否则返回`false` 。

#### 理解

简单的判断问题。以下是我最初想到的方法：

- 暴力解法：选取数组中的一个元素值，然后与后续元素进行比较，判断有没有相同的元素；没有则选择下一个元素，重复上述过程，时间复杂度为O(n2)，空间复杂度O(1)；
- 在`for` 循环中，使用一个HashMap数据结构依次保存数组元素，在保存键值对之前，判断HashMap中是否已经有该元素值，有则返回`true` 否则就一直保存数组元素直到遍历完数组元素，时间复杂度O(n)，空间复杂度约等于O(n)。

#### 我的解法

使用了HashMap的方法。

```
class Solution {
    public boolean containsDuplicate(int[] nums) {
        Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        for(int i = 0; i < nums.length; i++) {
            if(map.containsKey(nums[i])) return true;
            else
                map.put(nums[i], 1);
        }
        return false;
    }
}
```

#### 大神解法

解法一：使用**HashSet**——由于Set本身定义是不包含重复元素的，所以在添加元素的时候，Set会**自动判断**是否已经有该元素。复杂度与HashMap是一样的。

```
	public  boolean containsDuplicate(int[] nums) {
		 Set<Integer> set = new HashSet<Integer>();
		 for(int i : nums)
			 if(!set.add(i))// if there is same
				 return true; 
		 return false;
	 }
```

解法二：先对数组进行排序，然后相邻元素进行比较即可。使用数组自带的排序算法可以得到时间复杂度O(nlogn)，空间复杂度接近O(1)。

```
 	public boolean containsDuplicate(int[] nums) {
        Arrays.sort(nums);
        for(int ind = 1; ind < nums.length; ind++) {
            if(nums[ind] == nums[ind - 1]) return true;
        }
        return false;
    }
```

解法三：采用位运算Bit Manipulation的方法——本解法的**限制条件**是数组元素值的范围必须小于150000*8 = 1200000。时间复杂度为O(n)，空间复杂度是一个确定值。

```
public class Solution {
    public boolean containsDuplicate(int[] nums) {
        byte[] mark = new byte[150000];
        for (int i : nums) {
            int j = i/8;
            int k = i%8;
            int check = 1<<k;
            if ((mark[j] & check) != 0) {
                return true;
            }
            mark[j]|=check;
        }
        return false;
    }
}
```

#### 总结

本题是一个很简单的题，也可以很容易地想到至少两种解法。本题的意义在于，充分地体现出了时间复杂度与空间复杂度之间的**权衡**问题。