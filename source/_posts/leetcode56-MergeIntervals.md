title: leetcode56 Merge Intervals

date: 2017/09/28 16:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#56 Merge Intervals

>Given a collection of intervals, merge all overlapping intervals.
>
>For example,
>Given `[1,3],[2,6],[8,10],[15,18]`,
>return `[1,6],[8,10],[15,18]`.

#### 解释

给定一个时间间隔的集合，要求将所有**重叠的时间间隔合并**。

#### 我的解法

由于不确定给定的时间间隔集合是不是有序的，所以考虑新创建一个链表保存合并之后的时间间隔，将时间间隔插入新链表的过程中对链表进行比较和排序，以及合并操作。其中有六种边界情况需要考虑：

- 新插入的间隔的`begin` 大于当前间隔的`end` ；
- 新插入的间隔的`end` 小于当前间隔的`begin` ；
- 新插入的间隔的`end` 在当前间隔内，`begin` 小于当前间隔的`begin` ；
- 新插入的间隔的`begin` 在当前间隔内，`end` 大于当前间隔的`end` ；
- 新插入的间隔在当前间隔内；
- 新插入的间隔的两个边界都大于等于当前间隔的边界。

经过上述的重新插入操作之后，得到的结果链表中的间隔都是按照`begin` 从小到大排序的，本来到这里就应该结束了，但是由于本解法的不完善，会出现部分应该合并的间隔没有被合并，所以需要再次进行一轮比较与合并——只比较`end` 即可。

虽然不完善且麻烦，但是本解法还是很容易理解的，性能也有——Runtime Beats 92% 。

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
    public List<Interval> merge(List<Interval> intervals) {        
        if(intervals == null ||intervals.size() == 0 || intervals.size() == 1) return intervals;
        
        List<Interval> res = new ArrayList<>();
        res.add(0, intervals.get(0));
        for(int i = 1; i < intervals.size(); i++) {
            Interval inter = intervals.get(i);
            boolean mergeFlag = false;
            for(int k = 0; k < res.size(); k++) {
                if(inter.start > res.get(k).end) continue;
                else if(inter.end < res.get(k).start) {
                    res.add(k, inter);
                    mergeFlag = true;
                    break;
                }
                else if(inter.start < res.get(k).start && inter.end <= res.get(k).end) {
                    res.get(k).start = inter.start;
                    mergeFlag = true;
                    break;
                }
                else if(inter.start >= res.get(k).start && inter.end > res.get(k).end) {
                    res.get(k).end = inter.end;
                    mergeFlag = true;
                    break;
                }
                else if(inter.start <= res.get(k).start && inter.end >= res.get(k).end) {
                    res.get(k).start = inter.start;
                    res.get(k).end = inter.end;
                    mergeFlag = true;
                    break;
                }
                else {
                    mergeFlag = true;
                    break;
                }
                    
            }
            if(mergeFlag == true) continue;
            else {
                res.add(res.size(), inter);
            }
        }
        // 至此，链表res中所有的时间间隔都是按照start从小到大排序的
        // 只需要判断 end 之间的大小关系，合并即可
        int beginPos = 0;
        //int resSize = res.size();
        int index = 1;
        while(index < res.size()) {
            Interval inter = res.get(beginPos);
            int end = inter.end;
            if(end >= res.get(index).end) res.remove(index);
            else if(end >= res.get(index).start) {
                res.get(beginPos).end = res.get(index).end;
                res.remove(index);
            }
            else {
                beginPos = index;
                index++;
            }
        }
        
        return res;
    }
}
```

#### 大神解法

解法一：

一个时间间隔中存在两个变量`start`和`end` ，将它们取出分别存放在两个数组中，对应的索引是相同的，然后对两个数组进行排序——这样就是有序的了。

判断`start` 与`end` 之间的关系——由于将这两个参数从间隔中提取出来放在数组中，遍历与比较过程就显得更为容易了，比较过程在遇到`starts[i + 1] > ends[i]` ，即**不重叠**的情况时，才利用当前的`start` 和`end` 创建一个新的间隔放入结果链表中。

```
public List<Interval> merge(List<Interval> intervals) {
	// sort start&end
	int n = intervals.size();
	int[] starts = new int[n];
	int[] ends = new int[n];
	for (int i = 0; i < n; i++) {
		starts[i] = intervals.get(i).start;
		ends[i] = intervals.get(i).end;
	}
	Arrays.sort(starts);
	Arrays.sort(ends);
	// loop through
	List<Interval> res = new ArrayList<Interval>();
	for (int i = 0, j = 0; i < n; i++) { // j is start of interval.
		if (i == n - 1 || starts[i + 1] > ends[i]) {
			res.add(new Interval(starts[j], ends[i]));
			j = i + 1;
		}
	}
	return res;
}
```

解法二：

**自定义了一个排序方法**。

剩下的工作就是对有序的时间间隔进行合并——**合并的方法挺不错的，只需两步比较**。

```
public class Solution {
    public List<Interval> merge(List<Interval> intervals) {
        Collections.sort(intervals, new Comparator<Interval>(){
            @Override
            public int compare(Interval obj0, Interval obj1) {
                return obj0.start - obj1.start;
            }
        });

        List<Interval> ret = new ArrayList<>();
        Interval prev = null;
        for (Interval inter : intervals) {
            if (  prev==null || inter.start>prev.end ) {
                ret.add(inter);
                prev = inter;
            } else if (inter.end>prev.end) {
                // Modify the element already in list
                prev.end = inter.end;
            }
        }
        return ret;
    }
}
```