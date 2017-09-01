title: leetcode374 Guess Number Higher or Lower

date: 2017/09/01 11:00:00

categories:

- Study

tags:

- leetcode
- array
- BinarySearch

---

## leetcode#374 Guess Number Higher or Lower

>We are playing the Guess Game. The game is as follows:
>
>I pick a number from **1** to **n**. You have to guess which number I picked.
>
>Every time you guess wrong, I'll tell you whether the number is higher or lower.
>
>You call a pre-defined API `guess(int num)` which returns 3 possible results (`-1`, `1`, or `0`):
>
>```
>-1 : My number is lower
> 1 : My number is higher
> 0 : Congrats! You got it!
>```
>
>**Example:**
>
>```
>n = 10, I pick 6.
>
>Return 6.
>```

#### 解释

本题的情景是猜数字，给定1~n的数组，在猜的过程中，题目自带的API会提示数字是大了，还是小了，还是刚好猜中。

#### 理解

本题有歧义：我对`My number is lower` 的理解是：我猜的数字小了，可是实际上题目对这句话的解读是：题目的数字小于我猜测的数字......

所以，刚开始完成二分查找算法，检查了很多遍算法本身并没有什么问题，可是结果总是不对，原来是这个原因，晕......

#### 我的解法

```
/* The guess API is defined in the parent class GuessGame.
   @param num, your guess
   @return -1 if my number is lower, 1 if my number is higher, otherwise return 0
      int guess(int num); */

public class Solution extends GuessGame {
    public int guessNumber(int n) {
        int begin = 1;
        int end = n;
        while(begin < end) {
            int mid = begin + (end - begin)/2;
            int guess = guess(mid);
            if(guess == 0) return mid;
            else if(guess == -1) end = mid;
            else
                begin = mid + 1;
        }
        return begin;
    }
}
```

#### 大神解法

都是二分查找算法。