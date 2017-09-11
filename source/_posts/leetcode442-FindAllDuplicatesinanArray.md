title: leetcode442 Find All Duplicates in an Array

date: 2017/09/11 15:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#442 Find All Duplicates in an Array

>Given an array of integers, 1 ≤ a[i] ≤ *n* (*n* = size of array), some elements appear **twice** and others appear **once**.
>
>Find all the elements that appear **twice** in this array.
>
>Could you do it without extra space and in O(*n*) runtime?
>
>**Example:**
>
>```
>Input:
>[4,3,2,7,8,2,3,1]
>
>Output:
>[2,3]
>```

#### 解释

给定一个整数数组，无序，数组大小为n，数组元素的大小范围为：1~n，要求找出数组中出现**两次**的数组元素，并返回。（数组中**只会有出现两次和出现一次的元素**，即没有出现两次以上的元素）

时间复杂度O(N)，空间复杂度O(1)。

#### 我的解法

可以基于leetcode448的解法进行思考：

- 标记法，通过标记，可以知道那个位置上的元素缺失，相应的，该位置上的实际元素就是在数组中出现两次的元素；
- 交换法，通过交换，最后得到的数组中元素值减1不等于索引值位置上的元素值，就是在数组中出现两次的元素。

由于标记法会更改原数组中的元素值，所以这里还是使用了交换法。

```
class Solution {
    public List<Integer> findDuplicates(int[] nums) {
        List<Integer> list = new LinkedList<Integer>();
        if(nums.length <2) return list;
        
        for(int i = 0; i < nums.length; i++) {
            while(nums[i] != (i+1) && nums[i] != nums[nums[i]-1]) {
                int tmp = nums[i];
                nums[i] = nums[tmp - 1];
                nums[tmp - 1] = tmp;
            }
        }
        for(int i = 0; i < nums.length; i++) {
            if(nums[i] != (i+1)) {
                // leetocode448 使用的是： list.add(i+1)
                list.add(nums[i]);
            }
        }
        return list;
    }
}
```

#### 大神解法

**标记法** ，同leetcode448的标记法一样，找到元素值i，就将索引值为(i-1)的元素值置为负数，前提是，索引值(i-1)的元素是非负数（之前已经被标记过，如果还需要标记，说明索引值(i-1)对应的元素值i已经重复出现了），否则，将元素值i添加入链表，等待最后的返回。

```
public class Solution {
    // when find a number i, flip the number at position i-1 to negative. 
    // if the number at position i-1 is already negative, i is the number that occurs twice.
    
    public List<Integer> findDuplicates(int[] nums) {
        List<Integer> res = new ArrayList<>();
        for (int i = 0; i < nums.length; ++i) {
            int index = Math.abs(nums[i])-1;
            if (nums[index] < 0)
                res.add(Math.abs(index+1));
            nums[index] = -nums[index];
        }
        return res;
    }
}
```

#### 总结

leetcode448和本题的思路是一样的，可以使用相同的标记法或者交换法解决，区别在于前者关注的是索引值，后者关注的是元素值——给我们提供了同一解决思路下，举一反三提问的真实案例。