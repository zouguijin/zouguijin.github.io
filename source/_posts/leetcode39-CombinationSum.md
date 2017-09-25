title: leetcode39 Combination Sum

date: 2017/09/25 16:00:00

categories:

- Study

tags:

- leetcode
- array
- BacktrackingAlgorithm

---

## leetcode#39 Combination Sum

>Given a **set** of candidate numbers (**C**) **(without duplicates)** and a target number (**T**), find all unique combinations in **C** where the candidate numbers sums to **T**.
>
>The **same** repeated number may be chosen from **C** unlimited number of times.
>
>**Note:**
>
>- All numbers (including target) will be positive integers.
>- The solution set must not contain duplicate combinations.
>
>For example, given candidate set `[2, 3, 6, 7]` and target `7`, 
>A solution set is: 
>
>```
>[
>  [7],
>  [2, 2, 3]
>]
>```

#### 解释

给定一个**无重复**的数字集合C，以及一个目标数字T，找出其中所有的数字组合，要求组合中数字之和等于T。

- **同一个数字可以在组合中使用多次**；
- 所有的数字都是正整数；
- 最后的结果不包括相同的组合。

#### 我的解法

其实在解答本题之前，我是先看了leetcode40，两题的思想是一致的，唯一的不同在于：leetcode40所给数组的元素是可以重复的，所以就会涉及到最后结果中组合可能相同的情况，而本题由于数组元素没有重复的，所以自然不会涉及结果中有相同组合的情况。

但是直接套用leetcode40的解法，是没有办法解决本题的，因为本题中，同一个数组元素可以在一个组合中重复地使用——所以，回溯算法的递归过程，需要**在同一个元素位置递归多次**，从而判断一个组合需要多少个该重复元素。

```
class Solution {
    public List<List<Integer>> combinationSum(int[] candidates, int target) {
        List<Integer> list = new ArrayList<Integer>();
        List<List<Integer>> res = new ArrayList<List<Integer>>();
        Arrays.sort(candidates);
        dsfFind(candidates, 0, target, list, res);
        return res;
    }
    
    public void dsfFind(int[] candArray, int curPos, int curTarget, List<Integer> list, List<List<Integer>> res) {
        if(curTarget == 0) {
            res.add(new ArrayList(list));
            return;
        }
        if(curTarget < 0) return;
        for(int i = curPos; i < candArray.length; i++) {
            list.add(list.size(), candArray[i]);
            dsfFind(candArray, i, curTarget-candArray[i], list, res);
            // 在dsfFind()的某一层，如果遍历了数组中所有的元素：0~cand.length，且都不满足条件，最后dsfFind()将会“无功而返”——什么都不返回地结束这一层的递归操作，回到上一层
            list.remove(list.size()-1);
            // 所以，每层的递归只需要对链表进行一次元素移除即可，如果该层不满足条件，在结束本层的遍历后，它将回溯到上一层，由上一层对链表进行元素的进一步移除
            // list.remove(list.size()-1);
        }
    }
}
```

#### 大神解法

有使用DP算法的（但是对于本题来说，较为复杂），使用回溯算法的要数上述算法的实现最为简洁清晰了。

```
public List<List<Integer>> combinationSum(int[] nums, int target) {
    List<List<Integer>> list = new ArrayList<>();
    Arrays.sort(nums);
    backtrack(list, new ArrayList<>(), nums, target, 0);
    return list;
}

private void backtrack(List<List<Integer>> list, List<Integer> tempList, int [] nums, int remain, int start){
    if(remain < 0) return;
    else if(remain == 0) list.add(new ArrayList<>(tempList));
    else{ 
        for(int i = start; i < nums.length; i++){
            tempList.add(nums[i]);
            backtrack(list, tempList, nums, remain - nums[i], i); // not i + 1 because we can reuse same elements
            tempList.remove(tempList.size() - 1);
        }
    }
}
```

