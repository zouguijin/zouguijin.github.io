title: leetcode66 Plus One

date: 2017/09/07 15:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#66 Plus One

>Given a non-negative integer represented as a **non-empty** array of digits, plus one to the integer.
>
>You may assume the integer do not contain any leading zero, except the number 0 itself.
>
>The digits are stored such that the most significant digit is at the head of the list.

#### 解释

给定一个非空数组，用该数组表示一个非负整数，即**数组的第0位元素值表示非负整数的最高位**，以此类推。现在要求计算该非负整数**加1**的结果，返回一个新数组。

假设该数组的第一位不是0，除非数组就表示0本身。

#### 理解

- 数组的每一位元素都是0~9之间的数字；
- 从后往前计算会比较好处理进位问题。

#### 我的解法

既然数组的第0位元素值表示非负整数的最高位，那么这个加法需要从数组的最后一位元素开始往前计算。如果任何一位元素加1或者加上进位的1，所得的值超过了9，那么该位元素值等于加和结果减去10，并往前进1；否则若不超过9，那么往前遍历的操作停止，返回当前的数组。

有一种特殊情况，也就是一直进位，最后得到新的高位元素，比如`9999+1` ，像这种情况，同样需要先将结果减去10，然后需要新申请一个数组空间（Length + 1），在数组的第一个元素上放置元素1，并将原数组的计算结果放在后续位上。

```
class Solution {
    public int[] plusOne(int[] digits) {
        int carry = 1;
        for(int i = digits.length - 1; i >= 0; i--) {
            int sum = digits[i] + carry;
            if(sum > 9) {
                carry = 1;
                sum = sum - 10;
                digits[i] = sum;
            }
            else {
                carry = 0;
                digits[i] = sum;
                break;
            }  
        }
        if(carry == 0) {
            return digits;
        }
        else {
            int[] newDigits = new int[digits.length + 1];
            newDigits[0] = 1;
            for(int k = 0; k < digits.length; k++) {
                newDigits[k+1] = digits[k];
            }
            return newDigits;
        }
        
    }
}
```

#### 大神解法

由于只是加1，所以最坏的情况也只是类似`999+1` ，如果出现这样的情况，直接返回一个**首元素为1、后续元素为0**的数组长度加1的新数组即可。其余的情况都可以通过**判断数组元素是否为9**，来决定将该元素值置为0还是简单加1。

该解法充分使用了题目所给条件，很好地抽象了问题的本质，极具针对性，没有使用`carry` 。

```
public int[] plusOne(int[] digits) {
    int n = digits.length;
    for(int i=n-1; i>=0; i--) {
        if(digits[i] < 9) {
            digits[i]++;
            return digits;
        }
        digits[i] = 0;
    }
    int[] newNumber = new int [n+1];
    newNumber[0] = 1;
    return newNumber;
}
```

