title: leetcode219 Contains Duplicate II

date: 2017/09/05 16:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#219 Contains Duplicate II

>Given an array of integers and an integer *k*, find out whether there are two distinct indices *i* and *j* in the array such that **nums[i] = nums[j]** and the **absolute** difference between *i* and *j* is at most *k*.

#### 解释

给定一个元素为整数的数组和一个整数k，判断是否有相同的数组元素，且两个相同的数组元素的**索引值之差**小于等于k。

#### 理解

本题可以分为两个两个步骤：（1）找出相同的元素和其索引；（2）判断相同元素的索引值之差是否小于等于k。

可以使用**HashMap**：Key值使用数组值，Value值使用数组索引，当遇到相同的数组值时，将该数组值对应的Value值——索引值提取出来，与当前的索引值作差，判断差值是否小于等于给定整数k，如果小于等于k，返回`true` ，否则说明两个相同值的索引相差超过k，则将当前值的索引通过`map.put()` 覆盖之前的索引值，用于后续的判断。

#### 我的解法

```
class Solution {
    public boolean containsNearbyDuplicate(int[] nums, int k) {
        Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        for(int i = 0; i < nums.length; i++) {
            if(map.containsKey(nums[i])) {
                if(i - map.get(nums[i]) <= k) return true;
                else
                    map.put(nums[i], i);
            }
            else
                map.put(nums[i], i);
        }
        return false;
    }
}
```

#### 大神解法

都是使用HashMap或者HashSet的方式解决。

可以将`map.put()` 提取到`if` 条件语句之外，简化过程。

```
public boolean containsNearbyDuplicate(int[] nums, int k) {
    Map<Integer, Integer> map = new HashMap<Integer, Integer>();
    for (int i = 0; i < nums.length; i++) {
        if (map.containsKey(nums[i])) {
            if (i - map.get(nums[i]) <= k) return true;
        }
        map.put(nums[i], i);
    }
    return false;
}
```

