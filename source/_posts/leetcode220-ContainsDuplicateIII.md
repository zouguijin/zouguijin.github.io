title: leetcode220 Contains Duplicate III

date: 2017/09/06 11:00:00

categories:

- Study

tags:

- leetcode
- array
- Bucket
- BinaySearchTree

---

## leetcode#220 Contains Duplicate III

>Given an array of integers, find out whether there are two distinct indices *i* and *j* in the array such that the **absolute** difference between **nums[i]** and **nums[j]** is at most *t* and the **absolute** difference between *i* and *j* is at most *k*.

#### 解释

给定一个整数数组，以及两个整数k和t，要求判断是否存在两个不同索引对应的数组元素，索引值相差**不超过**k，且对应的值相差**不超过**t。

#### 理解

本题应该还是会使用HashSet或者HashMap这两种数据结构辅助求解。

此外，本题还有一点需要注意，即题目强调的两个“**不超过**”，数组值“不超过”可以很好判断，但是索引值的“不超过”，就需要添加一层额外的循环——如果以索引值作为HashMap的Key值的话。

#### 我的解法

上述理解构造的解法会存在两个主要问题：

- 整型数的溢出问题，由于所给出的整型数组没有限制必须是正数，所以会出现负数减去一个大正数，导致结果溢出整数范围：-2147483648~2147483647——可以使用`HashMap<Integer,Long>` 的泛型解决；
- TLE限制，本解法的时间复杂度为O(kn)，还是遇到了TLE限制......

```
class Solution {
    public boolean containsNearbyAlmostDuplicate(int[] nums, int k, int t) {
        if(k == 0) return false;
        long w = (long)t;
        Map<Integer,Long> map = new HashMap<Integer,Long>();
        for(int i = 0; i < nums.length; i++) {
            map.put(i, (long)nums[i]);
        }
        for(int i = 0; i < nums.length; i++) {
            for(int j = 1; j <= k; j++) {
                if(j + i < nums.length) {
                    if(Math.abs(map.get(i) - map.get(j+i)) <= w) return true;
                }
                else
                    break;
            }
        }
        return false;
    }
}
```

#### 大神解法

解法一：使用**HashMap**数据结构，结合重新映射操作，构建了一个**Bucket**数据结构。

本解法首先对数组元素进行了重新映射：对整型数的最小值进行作差，这样所有的数组元素值肯定是正数了；其次，将映射的新值对`(t+1)` 取商值，一是防了一手`t=0` ，二是为了将值进行缩放，从而放进**数量有限的Bucket**内；然后，由于对`t+1` 取商值毕竟会有误差，所以需要判断当前映射新值与(bucket-1)、bucket、(bucket+1)这三个桶内的值的差值是否不超过t，若确实不超过则返回`true` ；最后，需要**保证桶的数量不超过k**：如果map的大小（通过`map.entrySet().size()` 获取）已经不小于k，则需要定位并移除往前数第k个Bucket。

```
 public class Solution {
    public boolean containsNearbyAlmostDuplicate(int[] nums, int k, int t) {
        if (k < 1 || t < 0) return false;
        // Long 防止整型数溢出
        Map<Long, Long> map = new HashMap<>();
        for (int i = 0; i < nums.length; i++) {
        	// 将数组元素进行重新映射操作
            long remappedNum = (long) nums[i] - Integer.MIN_VALUE;
            // 对(t+1)取商值，是为了防止t=0
            long bucket = remappedNum / ((long) t + 1);
            // 对(t+1)取商值，肯定会有些许误差，相对于对t取商，可能会让结果落在(bucket-1)、bucket、(bucket+1)这三个值内，所以需要对这三个桶内的值进行比较
            if (map.containsKey(bucket)
                    || (map.containsKey(bucket - 1) && remappedNum - map.get(bucket - 1) <= t)
                        || (map.containsKey(bucket + 1) && map.get(bucket + 1) - remappedNum <= t))
                            return true;
            // 保证map的大小在k的范围内，满足“索引值不超过k”的条件
            if (map.entrySet().size() >= k) {
                long lastBucket = ((long) nums[i - k] - Integer.MIN_VALUE) / ((long) t + 1);
                map.remove(lastBucket);
            }
            map.put(bucket, remappedNum);
        }
        return false;
    }
}
```

解法二：使用**TreeSet**数据结构，构建**二叉查找树（Binay Search Tree）**。

该解法将问题抽象为：维持一个**连续的大小为k**的二叉树（时间复杂度为O(NlogK)），然后在这个范围之内对值进行比较，判断是否存在差值不超过t的数组元素（时间复杂度为O(logK)）。

```
public class Solution {
    public boolean containsNearbyAlmostDuplicate(int[] nums, int k, int t) {
        if (nums == null || nums.length == 0 || k <= 0) {
            return false;
        }
        // TreeSet 将对添加的元素自动排序
        final TreeSet<Integer> values = new TreeSet<>();
        for (int ind = 0; ind < nums.length; ind++) {
        	// 返回二叉树中小于等于(nums[ind] + t)的最大值
            final Integer floor = values.floor(nums[ind] + t);
            // 返回二叉树中大于等于(nums[ind] - t)的最小值
            final Integer ceil = values.ceiling(nums[ind] - t);
            // 如果两个边界值floor&ceil，都在[nums[ind] - t, nums[ind] + t]范围中，则返回true
            if ((floor != null && floor >= nums[ind])
                    || (ceil != null && ceil <= nums[ind])) {
                return true;
            }
			// 同样，需要维持二叉树的大小不超过k
            values.add(nums[ind]);
            if (ind >= k) {
                values.remove(nums[ind - k]);
            }
        }
        return false;
    }
}
```

#### 总结

随着问题复杂度的提高，简单的HashMap数据结构本身已经不能直接解决问题，需要**利用HashMap等基本数据结构进一步地构造**出新的或精巧或复杂的数据结构。

例如本题的Bucket（通过特征缩放减少了桶的数量，从而能够维持不超过k的桶数量，而不需要额外的k循环，最终降低了时间复杂度），以及基于TreeSet构建的二叉查找树（TreeSet自动排序且无重复元素，从而减少了很多工作量，通过自带的方法可以简单地确认出边界，从而完成值的比较，索引值也可以通过添加元素的同时删去超过k的元素，保证二叉树的元素数量不超过k）。