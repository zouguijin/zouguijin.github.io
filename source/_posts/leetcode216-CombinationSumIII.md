title: leetcode216 Combination Sum III

date: 2017/09/26 10:00:00

categories:

- Study

tags:

- leetcode
- array
- BacktrackingAlgorithm

---

## leetcode#216 Combination Sum III

>Find all possible combinations of ***k*** numbers that add up to a number ***n***, given that only numbers from 1 to 9 can be used and each combination should be a unique set of numbers.
>
>**Example 1:**
>
>Input: ***k*** = 3, ***n*** = 7
>
>Output:
>
>```
>[[1,2,4]]
>```
>
>**Example 2:**
>
>Input: ***k*** = 3, ***n*** = 9
>
>Output:
>
>```
>[[1,2,6], [1,3,5], [2,3,4]]
>```

#### 解释

找出所有可能的**k个数字**组合，这k个数字之和等于n。

- 所有数字的范围，包括n的范围为：1~9；
- 组合不允许重复，数字本身在一个组合里也不能重复（测试发现的）。

#### 我的解法

在解决本题之前，已经做过leetcode39/40，沿用了之前两题的思路和回溯算法，只是多增加了几个判断条件而已。

总的来说有几点不同：

- 数字的范围在1~9内——其实这个条件简化了本题，如果没有这个条件且数组无序，则需要先对数组进行排序；
- 不仅有和的限制，还多了一个组合数目k的限制——如果使用回溯算法，那么**k需要作为回溯算法的参数**参与回溯的整个过程，并在其中作为判断条件；
- 不允许有重复的组合，同一个组合中不允许有重复的数字——由于数组有序了，所以既要判断即将加入链表的元素与链表最后一个元素是否相同（leetcode40），又要让回溯过程往后推进（leetcode39），其实这两个判断都可以通过`i+1` 这一个参数递增解决。

```
class Solution {
    public List<List<Integer>> combinationSum3(int k, int n) {
        int[] array = {1,2,3,4,5,6,7,8,9};
        List<Integer> list = new ArrayList<Integer>();
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        dfsFind(array, n, 0, k, list, res);
        return res;
    }
    
    public void dfsFind(int[] array, int target, int curPos, int kNums, List<Integer> list, List<List<Integer>> res) {
        if(kNums == 0) {
            if(target == 0) {
                res.add(new ArrayList(list));
                return;
            }
            else {
                return;
            }
        }
        else { // k > 0
            if(target > 0) {
                for(int i = curPos; i < array.length; i++) {
                    // if(list.size() > 0 && list.get(list.size()-1) == array[i]) continue;
                    list.add(list.size(), array[i]);
                    dfsFind(array, target-array[i], i+1, kNums-1, list, res);
                    list.remove(list.size() - 1);
                }
            }
            else {
                return;
            }
        }
    }
}
```

#### 大神解法

由于给定的数字范围是1~9，所以可以舍弃一个参数：数组，直接在遍历的过程中体现即可。

本解法之所以简洁，是因为它只需要判断一个条件：凑满k个数且刚好这k个数之和为n，并在这个时候将链表放入结果中即可，其余的时候任由遍历过程进行直至结束——反正也只有9个数字，不会带来很大的开销。

```
 public List<List<Integer>> combinationSum3(int k, int n) {
    List<List<Integer>> ans = new ArrayList<>();
    combination(ans, new ArrayList<Integer>(), k, 1, n);
    return ans;
}

private void combination(List<List<Integer>> ans, List<Integer> comb, int k,  int start, int n) {
	if (comb.size() == k && n == 0) {
		List<Integer> li = new ArrayList<Integer>(comb);
		ans.add(li);
		return;
	}
	for (int i = start; i <= 9; i++) {
		comb.add(i);
		combination(ans, comb, k, i+1, n-i);
		comb.remove(comb.size() - 1);
	}
}
```

#### 总结

leetcode39/40/216，这三道题都是关于回溯算法的题，解决的思路是一样的：

- 一种尝试，可以回退；
- 递归方法——递归过程的定义、递归终止条件、递归迭代参数的定义。