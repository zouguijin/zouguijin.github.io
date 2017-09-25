title: leetcode40 Combination Sum II

date: 2017/09/25 15:00:00

categories:

- Study

tags:

- leetcode
- array
- BacktrackingAlgorithm

---

## leetcode#40 Combination Sum II

>Given a collection of candidate numbers (**C**) and a target number (**T**), find all unique combinations in **C** where the candidate numbers sums to **T**.
>
>Each number in **C** may only be used **once** in the combination.
>
>**Note:**
>
>- All numbers (including target) will be positive integers.
>- The solution set must not contain duplicate combinations.
>
>For example, given candidate set `[10, 1, 2, 7, 6, 1, 5]` and target `8`, 
>A solution set is: 
>
>```
>[
>  [1, 7],
>  [1, 2, 5],
>  [2, 6],
>  [1, 1, 6]
>]
>```

#### 解释

给定一个候选数字的集合C和一个目标数字T，在C中找出所有加和的结果等于T的**数字组合**，相同的组合只需返回一个即可。

- 所有的数字都是正整数；
- 相同的组合只能返回一个。

#### 我的解法

最初的思路没有考虑到回溯算法：先将数组元素排序，然后将小于T的数组元素存储进HashMap（Key：数组元素值，Value：该元素的出现次数），然后依次查找——有一个直接的问题就是，组合可能包含大于两个的数组元素，所以第一次作差得到的结果不一定是HashMap的Key值，所以还需要后续多重比较，很是麻烦...

没有考虑到回溯算法，其实是因为对回溯算法的脑回路不是很理解，实现起来的套路也不是很懂...

#### 大神解法

**回溯算法（Backtracking）** 

同样需要先对数组元素进行排序，然后提供一个额外的**递归算法** ——对数组元素进行深度优先（DFS）遍历操作：

- 在遍历的过程中，每找到一个小于T的数组元素，都将其加入链表，然后作差，然后将差值作为新的T值，继续递归；
- 若刚好T为零，说明找到了一组数字组合（满足加和结果），将当前的链表作为一个结果添加到链表容器中；
- 若作差后新的T值小于零，则说明这个组合不正确，单纯返回；
- 若作差后，新的T值大于零，说明前几个数组元素的累加值还没有超过T，作差得到新的T值，继续将后续元素加入链表；
- 每完成一次递归（不论是成功找到一个组合，还是作差后新的T值小于零），都将往**后退一步**（即将前一个元素删除），然后循环变量加1，取下一个元素，以此类推。

```
 public List<List<Integer>> combinationSum2(int[] cand, int target) {
    Arrays.sort(cand);
    List<List<Integer>> res = new ArrayList<List<Integer>>();
    List<Integer> path = new ArrayList<Integer>();
    dfs_com(cand, 0, target, path, res);
    return res;
}
void dfs_com(int[] cand, int cur, int target, List<Integer> path, List<List<Integer>> res) {
    if (target == 0) {
        res.add(new ArrayList(path));
        return ;
    }
    if (target < 0) return;
    for (int i = cur; i < cand.length; i++){
        if (i > cur && cand[i] == cand[i-1]) continue;
        path.add(path.size(), cand[i]);
        dfs_com(cand, i+1, target - cand[i], path, res);
        // 在dfs_com()的某一层，如果遍历了数组中所有的元素：0~cand.length，且都不满足条件，最后dsf_com()将会“无功而返”——什么都不返回地结束这一层的递归操作，回到上一层
        path.remove(path.size()-1);
    }
}
```

#### 总结

总的来说，回溯算法求解过程，就类似于一个**贪婪“尝试”**的过程，当前尝试的结果满足条件，就接受，接着尝试下一个，否则就**后退一步**，尝试另外一个结果。

所以，**回溯的关键**有以下几点：

- 回溯边界条件的判定——什么时候回溯返回，也即什么时候“后退”尝试其他的情况；
- 回溯过程——回溯需要完成什么操作；
- 回溯的返回——回溯返回之后，接下来该做什么，需要处理什么，是更改变量接着回溯还是就此结束。