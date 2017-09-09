title: leetcode169 Majority Element

date: 2017/09/09 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#169 Majority Element

>Given an array of size *n*, find the majority element. The majority element is the element that appears **more than**`⌊ n/2 ⌋` times.
>
>You may assume that the array is non-empty and the majority element always exist in the array.

#### 解释

给定一个大小为`n` 的数组，要求找出其中出现次数大于`n/2` 的元素。

假设数组非空，且所要找的元素一定存在。

#### 我的解法

出现次数大于`n/2` 的元素在数组中如果有，则一定只有一个。

可以使用HashMap，Key值为数组元素值，Value值为元素值出现的次数，如果Value值大于`n/2` ，那么返回对应的Key值。

```
class Solution {
    public int majorityElement(int[] nums) {
        if(nums == null) return -123;
        
        Map<Integer,Integer> map = new HashMap<Integer,Integer>();
        for(int i = 0; i < nums.length; i++) {
            int value = map.containsKey(nums[i]) ? map.get(nums[i])+1 : 1;
            map.put(nums[i], value);
        }
        
        int majorityNum = -123;
        Set<Integer> keySet = map.keySet();
        Iterator<Integer> iter = keySet.iterator();
        while(iter.hasNext()) {
            Integer key = iter.next();
            if(map.get(key) > nums.length/2) {
                majorityNum = key;
                break;
            }
        }
        return majorityNum;
    }
}
```

#### 大神解法

解法一：先排序，然后返回第`nums[nums.length/2]` 个元素——由于`majorityNum` 即使从头尾算起也会包括中间位置。

```
// Sorting
public int majorityElement1(int[] nums) {
    Arrays.sort(nums);
    return nums[nums.length/2];
}
```

解法二：HashMap

不同的是，该解法在每次往Map中插入元素的时候，都对相应的Value值进行判断和比较——可能会消耗大量的比较时间。

```
// Hashtable 
public int majorityElement2(int[] nums) {
    Map<Integer, Integer> myMap = new HashMap<Integer, Integer>();
    //Hashtable<Integer, Integer> myMap = new Hashtable<Integer, Integer>();
    int ret=0;
    for (int num: nums) {
        if (!myMap.containsKey(num))
            myMap.put(num, 1);
        else
            myMap.put(num, myMap.get(num)+1);
        if (myMap.get(num)>nums.length/2) {
            ret = num;
            break;
        }
    }
    return ret;
}
```

解法三：一个很精巧的方法，我认为是本题最佳！

类似于**投票**，从第一个元素开始，表示投该元素值1票，如果后面有不同的元素值，则减1票——由于`majorityNum` 拥有半数以上的数量，所以最后剩下的、还有票的肯定是所找的元素值。

```
// Moore voting algorithm
public int majorityElement3(int[] nums) {
    int count=0, ret = 0;
    for (int num: nums) {
        if (count==0)
            ret = num;
        if (num!=ret)
            count--;
        else
            count++;
    }
    return ret;
}
```

解法四：二进制移位计算——一直弄不懂......

```
// Bit manipulation 
public int majorityElement(int[] nums) {
    int[] bit = new int[32];
    for (int num: nums)
        for (int i=0; i<32; i++) 
            if ((num>>(31-i) & 1) == 1)
                bit[i]++;
    int ret=0;
    for (int i=0; i<32; i++) {
        bit[i]=bit[i]>nums.length/2?1:0;
        ret += bit[i]*(1<<(31-i));
    }
    return ret;
}
```