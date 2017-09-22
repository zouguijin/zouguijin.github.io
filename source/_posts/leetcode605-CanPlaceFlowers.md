title: leetcode605 Can Place Flowers

date: 2017/09/22 10:00:00

categories:

- Study

tags:

- leetcode
- array
- GreedyAlgorithm

---

## leetcode#605 Can Place Flowers

>Suppose you have a long flowerbed in which some of the plots are planted and some are not. However, flowers cannot be planted in adjacent plots - they would compete for water and both would die.
>
>Given a flowerbed (represented as an array containing 0 and 1, where 0 means empty and 1 means not empty), and a number **n**, return if **n** new flowers can be planted in it without violating the no-adjacent-flowers rule.
>
>**Example 1:**
>
>```
>Input: flowerbed = [1,0,0,0,1], n = 1
>Output: True
>
>```
>
>**Example 2:**
>
>```
>Input: flowerbed = [1,0,0,0,1], n = 2
>Output: False
>
>```
>
>**Note:**
>
>1. The input array won't violate no-adjacent-flowers rule.
>2. The input array size is in the range of [1, 20000].
>3. **n** is a non-negative integer which won't exceed the input array size.

#### 解释

应用题，抽象成数学问题为：给定一个二进制数组（0/1），要求数组中**1必须间隔至少一个0**，现在又给出n个1，要求判断能不能将1按照间隔的规则插入给定的数组中。

- 最初给定的数组本身不会违反规则；
- 数组大小范围为：[1,10000]；
- n的大小范围为：[0,数组长度-1]。

#### 我的解法

基本思路是，依次遍历数组元素，判断当前元素以及其前后两个元素是否都为0，若是则将1插入当前位置，计数值累加，向后移动两位，否则后移一位继续比较。

由于连续的0的位置不同，可插入的1的数目也会有微小的不同（比如连续的两个0在首尾和在两个1之间的情况就不一样），所以需要对**边界情况单挑出来单独处理**。

```
class Solution {
    public boolean canPlaceFlowers(int[] flowerbed, int n) {
        int count = 0;
        
        if(flowerbed.length == 1 && flowerbed[0] == 0) count = 1;
        else if(flowerbed.length == 2 && flowerbed[0] == 0 && flowerbed[1] == 0) {
            count = 1;
        }
        else {
            if(flowerbed[0] == 0 && flowerbed[1] == 0) {
                flowerbed[0] = 1;
                count++;
            }
            for(int i = 1; i < flowerbed.length-2; i++) {
                if(flowerbed[i] == 0 && flowerbed[i-1] == 0 && flowerbed[i+1] == 0) {
                    flowerbed[i] = 1;
                    count++;
                    i++;
                }
            }
            if(flowerbed[flowerbed.length - 1] == 0 && flowerbed[flowerbed.length - 2] == 0) {
                flowerbed[flowerbed.length - 1] = 1;
                count++;
            }
        }
        return count >= n ? true : false;
    }
}
```

#### 大神解法

解法一：**Greedy**

思路是相同的，巧妙之处在于该解法给出了我所没有想到的边界解决方法——通过**判断当前索引i的位置，来决定前后两个索引的取值**（避免数组越界）。

也可以说这种解法是**Greedy算法**——不顾全局，每次都是判断当前的情况，满足条件就采用。

```
public class Solution {
    public boolean canPlaceFlowers(int[] flowerbed, int n) {
        int count = 0;
        for(int i = 0; i < flowerbed.length && count < n; i++) {
            if(flowerbed[i] == 0) {
	     //get next and prev flower bed slot values. If i lies at the ends the next and prev are considered as 0. 
               int next = (i == flowerbed.length - 1) ? 0 : flowerbed[i + 1]; 
               int prev = (i == 0) ? 0 : flowerbed[i - 1];
               if(next == 0 && prev == 0) {
                   flowerbed[i] = 1;
                   count++;
               }
            }
        }
        
        return count == n;
    }
}
```

解法二：

通过观察可以知道，连续0的长度`n`与可插入1的个数`k`是有关系的：

- 如果两端有1：那么`k = (n-1)/2` ；
- 否则：`k = n/2` 。

但这里就存在边界的判断，如果处理不好，会显得方法过于冗杂，甚至会错误（我就错过...）

本解法的一个点在于：` int count = 1;` 将计数值初始化为1，这样整个方法只需要考虑“数组的最后一个元素是否为0”这一个边界情况即可。

```
public boolean canPlaceFlowers(int[] flowerbed, int n) {
    int count = 1;
    int result = 0;
    for(int i=0; i<flowerbed.length; i++) {
        if(flowerbed[i] == 0) {
            count++;
        }else {
            result += (count-1)/2;
            count = 0;
        }
    }
    if(count != 0) result += count/2;
    return result>=n;
}
```

