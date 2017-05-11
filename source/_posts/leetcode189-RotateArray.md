title: leetcode189 Rotate Array

date: 2017/05/11 17:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#189 Rotate Array

>Rotate an array of *n* elements to the right by *k* steps.
>
>For example, with *n* = 7 and *k* = 3, the array `[1,2,3,4,5,6,7]` is rotated to `[5,6,7,1,2,3,4]`.
>
>**Note:**
>Try to come up as many solutions as you can, there are at least 3 different ways to solve this problem.

#### 解释

将数组中的元素向右**循环移动**K位。

例如，给定数组`[1,2,3,4,5,6,7]`&&`k=3`，最后的结果是：`[5,6,7,1,2,3,4]`

注意：本题至少有3种解法

#### 理解

我是由**leetcode#61**做到该题的，所以首先考虑的是“能不能成环，然后循环移动”，显然是不能的，毕竟这是数组，不是链表。

但是可以根据`k % nums.length`的值，将原数组分成两个部分，将原数组的后半部分移动到新创建的数组的前半部分，原数组的前半部分移动到新数组的后半部分，即可。（但是本题不返回，即它只会检测原数组的状态，必须对原数组`nums`进行修改，那么只能在最后将新数组的值一个一个地赋值给原数组了...）

后来的想法：

不妨先考虑**数组的特点**：每个元素都有下标指示，可以迅速确定数组的长度，并根据下标找到某一个位置的数组元素。

那么就可以考虑**根据下标将两个元素的值进行交换**的操作，结合在《编程之法》上看过的“将一个字符串以单词为单位进行逆序操作”，即可以得到类似于大神的解法一。

#### 我的解法

理解起来很直观，但是步骤很繁琐是真的，关键是还创建了一个新的数组并进行数组赋值，时间复杂度和空间复杂度妥妥的`O(n)`。

```
public class Solution {
    public void rotate(int[] nums, int k) {
        if(k == 0 || nums.length < 2) { return; }
        else {
            int[] newArr = new int[nums.length];
            int steps = k % nums.length;
            int index = 0;
            for(int i = nums.length - steps ; i <= nums.length - 1 ; i++) {
                newArr[index++] = nums[i]; 
            }
            for(int j = index; j <= nums.length - 1; j++) {
                newArr[j] = nums[j - index];
            }
            for(int m = 0 ; m <= nums.length - 1 ; m++) {
                nums[m] = newArr[m];
            }
        }
    }
}
```

#### 大神解法

解法一：**分块反转算法**（即字符串以单词为单位逆序的算法）

取余，将数组分为两块：经过移动后，移到数组前半部分的一块和移到数组后半部分的一块，然后先对数组整体进行逆序，然后分别对两块部分进行逆序，即可。

当然，也可以先分别对两块部分逆序，最后对数组整体进行逆序。

```
public void rotate(int[] nums, int k) {
    k %= nums.length;
    reverse(nums, 0, nums.length - 1);
    reverse(nums, 0, k - 1);
    reverse(nums, k, nums.length - 1);
}

public void reverse(int[] nums, int start, int end) {
    while (start < end) {
        int temp = nums[start];
        nums[start] = nums[end];
        nums[end] = temp;
        start++;
        end--;
    }
}
```

解法二：有关最大公约数的算法

没看懂里面的数学关系是怎么来的...但是大概意思了解：

方法`findGcd()`用于查找`k % nums.length`和`nums.length`之间的最大公约数——在该算法里代表了遍历的次数；`count = nums.length / gcd - 1`即每一次遍历中需要交换的次数。

该算法大致就是在多次遍历中包含多次交换，从而得出最后的结果。

```
public class Solution {
    public void rotate(int[] nums, int k) {
        if(nums.length <= 1){
            return;
        }
        //step each time to move
        int step = k % nums.length;
        //find GCD between nums length and step
        int gcd = findGcd(nums.length, step);
        int position, count;
        
        //gcd path to finish movie
        for(int i = 0; i < gcd; i++){
            //beginning position of each path
            position = i;
            //count is the number we need swap each path
            count = nums.length / gcd - 1;
            for(int j = 0; j < count; j++){
                position = (position + step) % nums.length;
                //swap index value in index i and position
                nums[i] ^= nums[position];
                nums[position] ^= nums[i];
                nums[i] ^= nums[position];
            }
        }
    } 
    public int findGcd(int a, int b){
        return (a == 0 || b == 0) ? a + b : findGcd(b, a % b);
    }
}
```

### 总结

- 本题很简单，一眼就可以看出解法，不过越简单的题包含的解法往往更多，而且一眼看出来的解法往往属于暴力解法；
- 链表的算法题，套路一般都比较浅，基本的方法也就是那几种，数组的题就不一样了，结合不同的数据结构，其解法往往变化多端，一句话：**好好学习数据结构，数据结构是实现复杂算法的基石**！