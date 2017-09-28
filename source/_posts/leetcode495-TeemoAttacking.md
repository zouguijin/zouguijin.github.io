title: leetcode495 Teemo Attacking

date: 2017/09/28 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#495 Teemo Attacking

>In LOL world, there is a hero called Teemo and his attacking can make his enemy Ashe be in poisoned condition. Now, given the Teemo's attacking **ascending** time series towards Ashe and the poisoning time duration per Teemo's attacking, you need to output the total time that Ashe is in poisoned condition.
>
>You may assume that Teemo attacks at the very beginning of a specific time point, and makes Ashe be in poisoned condition immediately.
>
>**Example 1:**
>
>```
>Input: [1,4], 2
>Output: 4
>Explanation: At time point 1, Teemo starts attacking Ashe and makes Ashe be poisoned immediately. 
>This poisoned status will last 2 seconds until the end of time point 2. 
>And at time point 4, Teemo attacks Ashe again, and causes Ashe to be in poisoned status for another 2 seconds. 
>So you finally need to output 4.
>
>```
>
>**Example 2:**
>
>```
>Input: [1,2], 2
>Output: 3
>Explanation: At time point 1, Teemo starts attacking Ashe and makes Ashe be poisoned. 
>This poisoned status will last 2 seconds until the end of time point 2. 
>However, at the beginning of time point 2, Teemo attacks Ashe again who is already in poisoned status. 
>Since the poisoned status won't add up together, though the second poisoning attack will still work at time point 2, it will stop at the end of time point 3. 
>So you finally need to output 3.
>
>```
>
>**Note:**
>
>1. You may assume the length of given time series array won't exceed 10000.
>2. You may assume the numbers in the Teemo's attacking time series and his poisoning time duration per attacking are non-negative integers, which won't exceed 10,000,000.

#### 解释

应用题，关于LOL中提莫普攻有毒的问题。

提莫普攻带毒，毒性是有持续时间的，所以现在要求的是：在给定一个**普攻时间间隔的集合**和毒性持续时间两个参数的前提下，计算**在时间间隔内发起的普攻** 会造成敌方中毒的持续时间。

- 时间间隔的集合大小不超过10000；
- 时间间隔中的元素和毒性持续时间是非负数。

#### 我的解法

本题根据普攻时间间隔与毒性持续时间两个参数的大小关系，可以分为以下两种情况：

- 普攻的时间间隔大于等于毒性持续时间——那么普攻之后将会造成完整的毒性持续时间：
- 普攻的时间间隔小于毒性持续时间——由于毒性时间不会叠加，下一次普攻发生时，将会刷新毒性的持续时间，所以本次普攻之后毒性的持续时间也就是普攻的时间间隔。

综上，问题转化为普攻时间间隔与毒性持续时间之间的大小关系：**每次取普攻时间间隔与毒性持续时间的较小值**，累加入全局毒性持续时间中，在最后的最后，由于还有一次普攻，所以再加上一个毒性持续时间即可。

此外，有两种特殊情况：

- 从没攻击，即普攻时间间隔数组为空，那么就没有中毒，返回0；
- 只攻击了一次，即普攻时间间隔数组中只有一个元素，那么就只中毒一次，返回一个毒性持续时间。

```
class Solution {
    public int findPoisonedDuration(int[] timeSeries, int duration) {
        if(timeSeries.length == 0) return 0;
        if(timeSeries.length == 1) return duration;
        
        int res = 0;
        for(int i = 1; i < timeSeries.length; i++) {
            int interval = timeSeries[i] - timeSeries[i-1];
            if(interval < duration) res += interval;
            else
                res += duration;
        }
        res += duration;
        return res;
    }
}
```

#### 大神解法

解法一：与我的解法类似——每一步获取二者的最小值进行累加。

```
 public int findPoisonedDuration(int[] timeSeries, int duration) {
        if (timeSeries.length == 0) return 0;
        int begin = timeSeries[0], total = 0;
        for (int t : timeSeries) {
            total = total + (t < begin + duration ? t - begin : duration);
            begin = t;
        }   
        return total + duration;
    } 
```

解法二：全局考虑

- 如果时间间隔小于持续时间（发生重叠），那么就暂时不管，放到后续处理；
- 如果时间间隔大于持续时间，那么就将持续时间整体累加入结果中，同时将前面所有的小于持续时间的时间间隔一并累加入结果中；
- 在上述过程中，需要维持两个指针，用于标识起始位与结束位：上述第一种情况，只移动结束位；第二种情况移动两个标识符。

```
public class Solution {
    public int findPosisonedDuration(int[] timeSeries, int duration) {
        if (timeSeries == null || timeSeries.length == 0 || duration == 0) return 0;
        
        int result = 0, start = timeSeries[0], end = timeSeries[0] + duration;
        for (int i = 1; i < timeSeries.length; i++) {
            if (timeSeries[i] > end) {
                result += end - start;
                start = timeSeries[i];
            }
            end = timeSeries[i] + duration;
        }
        result += end - start;
        
        return result;
    }
}
```

