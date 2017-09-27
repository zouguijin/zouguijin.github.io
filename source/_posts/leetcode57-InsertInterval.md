title: leetcode57 Insert Interval

date: 2017/09/27 11:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#57 Insert Interval

>Given a set of *non-overlapping* intervals, insert a new interval into the intervals (merge if necessary).
>
>You may assume that the intervals were initially sorted according to their start times.
>
>**Example 1:**
>Given intervals `[1,3],[6,9]`, insert and merge `[2,5]` in as `[1,5],[6,9]`.
>
>**Example 2:**
>Given `[1,2],[3,5],[6,7],[8,10],[12,16]`, insert and merge `[4,9]` in as `[1,2],[3,10],[12,16]`.
>
>This is because the new interval `[4,9]` overlaps with `[3,5],[6,7],[8,10]`.

#### 解释

给定一个**不重叠** 、**按照间隔起始时间先后排序**的时间间隔的集合，现在插入一个新的时间间隔，要求进行适当的合并，并返回最终新的时间间隔。

所谓“合并”，就是因为新插入的时间间隔可能会跨越之前的好几个间隔，对于“跨越”的情况，就可以合并成一个时间间隔。

#### 我的解法

最初的想法：这不就是一个简单的边界比较问题么？因为给定的时间间隔集合已经是有序的了，只需要拿着待插入间隔的`newStart`从头开始与每一个间隔的`end`比较——若`newStart > end` ，则与后一个间隔比较；若`newStart < end` 则与当前间隔的`start` 比较，若`newStart > start` 则当前间隔的起始时间不变，若`newStart < start` 则将当前间隔的起始时间改为`newStart` ；接着，拿着待插入间隔的`newEnd` 从尾部开始，与每一个间隔的`start` 比较——同理，不再赘述。最后，将遍历过程记下的`newStart` 位置到`newEnd` 位置之间的所有间隔从链表中删去（包括`newEnd` 所在间隔），然后将`newStart` 所在间隔的`end` 改为`newEnd` 。

实现的结果还是有点bug，虽然可以输出，但是边界的判断还是会时不时有点误差...

```
/**
 * Definition for an interval.
 * public class Interval {
 *     int start;
 *     int end;
 *     Interval() { start = 0; end = 0; }
 *     Interval(int s, int e) { start = s; end = e; }
 * }
 */
class Solution {
    public List<Interval> insert(List<Interval> intervals, Interval newInterval) {
        if(intervals.isEmpty()) return null;
        
        int newStart = newInterval.start;
        int newEnd = newInterval.end;
        int startPos = 0;
        int endPos = intervals.size()-1;
        
        for(int i = 0; i < intervals.size(); i++) {
            Interval curInter = intervals.get(i);
            if(newStart > curInter.end) continue;
            else if(newStart < curInter.start) {
                curInter.start = newStart;
                startPos = i;
                break;
            }
            else {
                startPos = i;
                break;
            }
        }
        
        for(int k = intervals.size() - 1; k >= startPos; k--) {
            Interval curInter = intervals.get(k);
            if(newEnd < curInter.start) continue;
            else if(newEnd > curInter.end) {
                curInter.end = newEnd;
                endPos = k;
                break;
            }
            else {
                endPos = k;
                newEnd = curInter.end;
                break;
            }
        }
        
        for(int i = startPos; i <= endPos-1; i++) {
            intervals.remove(i);
        }
        intervals.get(startPos).end = newEnd;
        return intervals;
    }
}
```

#### 大神解法

直接求解，思路类似，更加简洁：

- 创建新链表；
- 将集合中所有`end < newStart` 的时间间隔先放入新链表——这些是肯定保留不动的；
- 将`start <= newEnd` 的部分进行合并，具体的合并方式是：将该范围内间隔的首尾两端与`newInterval` 的首尾进行比较，不断返回新的`newInterval` ，然后继续比较；
- 最后是`newEnd < start` 的时间间隔肯定也是不动的，全部放入链表；
- 将链表返回。

```
public List<Interval> insert(List<Interval> intervals, Interval newInterval) {
    List<Interval> result = new LinkedList<>();
    int i = 0;
    // add all the intervals ending before newInterval starts
    while (i < intervals.size() && intervals.get(i).end < newInterval.start)
        result.add(intervals.get(i++));
    // merge all overlapping intervals to one considering newInterval
    while (i < intervals.size() && intervals.get(i).start <= newInterval.end) {
        newInterval = new Interval( // we could mutate newInterval here also
                Math.min(newInterval.start, intervals.get(i).start),
                Math.max(newInterval.end, intervals.get(i).end));
        i++;
    }
    result.add(newInterval); // add the union of intervals we got
    // add all the rest
    while (i < intervals.size()) result.add(intervals.get(i++)); 
    return result;
}
```

#### 总结

虽然已经想到了，与范例思路是一样的，但是实现的方式还是不给力——还是边界的把握不够好......