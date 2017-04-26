title: leetcode263 Ugly Number

date: 2017/04/26 21:00:00

categories:

- Study

tags:

- leetcode
- math

---

## leetcode#263 Ugly Number

>Write a program to check whether a given number is an ugly number.
>
>Ugly numbers are positive numbers whose prime factors only include `2, 3, 5`. For example, `6, 8` are ugly while `14` is not ugly since it includes another prime factor `7`.
>
>Note that `1` is typically treated as an ugly number.

##### 解释

给定一个数字，判断其是不是**Ugly Number**。

Ugly Number，即只包含因子2、3和5的数，也即用2、3和5一定能将其约分。

注意，一般都认为`1`是Ugly Number。

##### 理解

简单问题，一般都直接使用暴力解法，即直接2、3、5三个因子一个一个试一试，一直取商直到不能再进行，判断最后的结构是不是等于`1`，若是，则返回`true`，若否，则返回`false`。

##### 我的解法

但是，在解决的时候，还需要稍微考虑一下性能问题：当输入的数很大的时候，一般刚开始会包含所有的这三个因子，所以可以将三个因子或者两个因子的乘积作为一个被除数，尽快地进行约分，减小被除数。

```
public class Solution {
    public boolean isUgly(int num) {
        if(num == 1) { return true; }
        if(num <= 0) { return false; }
        while(num != 1) {
            if(num % 30 == 0) { num = num / 30; }
            else if(num % 15 == 0) { num = num / 15; }
            else if(num % 10 == 0) { num = num / 10; }
            else if(num % 6 == 0) { num = num / 6; }
            else if(num % 5 == 0) { num = num / 5; }
            else if(num % 3 == 0) { num = num / 3; }
            else if(num % 2 == 0) { num = num / 2; }
            else { return false; }
        }
        return true;
    }
}
```

##### 大神解法

最简洁的方法：考虑到因子是2、3、5，同时4也是一个Ugly Number，所以可以在2~5之间建立一个循环，在这个循环中，依次将因子2、3、4、5作为约数，对原输入进行约分，如果最后的最后，结果等于1说明原输入是Ugly Number。

该解法非常的暴力，甚至不考虑将三个因子的乘积作为约数进行约分，如此一来如果输入很大时，一个一个小因子地约分，将会十分地耗时。

```
public class Solution {
    public boolean isUgly(int num) {
		for (int i=2; i<6 && num>0; i++)
    		while (num % i == 0)
        		num /= i;
		return num == 1;
	}
}
```

### 总结

- 简单的题，尽量暴力解法，性能上差不了多少；
- 简单的题，也不能随便应付，边界条件要考虑周全，所有的情况都需要考虑进来。

