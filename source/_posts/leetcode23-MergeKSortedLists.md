title: leetcode23 Merge K Sorted Lists

date: 2017/05/04 12:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- Recursion

---

## leetcode#23 Merge K Sorted Lists

>Merge *k* sorted linked lists and return it as one sorted list. Analyze and describe its complexity.

##### 解释

给定K条有序的单链表，要求将它们合并成一条有序的单链表。

分析一下算法的复杂度。

##### 理解

在之前的**leetcode#21**中，已经给出了两条单链表合并的方法，所以本题可以**借鉴**之前的解法作为最基本的合并方法，在此基础上，有两种考虑：

（1）一条一条的单链表进行合并，并将上一次合并的结果作为新链表参与下一次的合并；

（2）将合并看成是**二叉树**的节点从叶子节点不断收敛合并到根节点的过程，或者理解成**二分法归并**，即将给定的K条链表按照二分法分成两部分，最终每两条链表合并之后将结果递归返回给上一层，进行下一步更长链表的合并。

##### 我的解法

采用了第一种方法，时间复杂度为`O(n^2)`，因为设`lists.length = n`且每一条链表都有n个节点，则该算法的`for`循环有(n-1)次循环，每次`for`循环中最多有2n次递归操作，即至多`O(2*n^2)`；空间复杂度为`O(n)`，因为用到了递归方法，至少为`O(n)`。

可是，该解法在提交的时候遇到了运行时间的限制`Time Limit Exceeded`，可能leetcode对于本题的运行时间要求需要在`O(nlogn)`的级别吧，所以应该考虑使用第二种方法。

```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
public class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        if(lists.length == 0) { return null; }
        if(lists.length == 1) { return lists[0]; }  
        ListNode list1 = lists[0];
        ListNode mergeList = new ListNode(0);;
        for(int i = 1 ; i < lists.length ; i++) {
            ListNode list2 = lists[i];
            mergeList = mergeTwoLists(list1,list2);
            list1 = mergeList;
        }
        return mergeList;
    }
    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {
        if(list1 == null) { return list2; }
        if(list2 == null) { return list1; }
        ListNode mergeList;
        if(list1.val < list2.val) {
            mergeList = list1;
            mergeList.next = mergeTwoLists(list1.next,list2);
        }
        else {
            mergeList = list2;
            mergeList.next = mergeTwoLists(list1,list2.next);
        }
        return mergeList;
    }
}
```

借鉴了**递归+二叉树**的思路：

```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
public class Solution {
    public ListNode mergeKLists(ListNode[] lists) {
        return binaryTreeMerge(lists,0,lists.length - 1);
    }
    
    public static ListNode binaryTreeMerge(ListNode[] subLists, int begin, int end) {
        if(begin == end) return subLists[begin];
        if(begin < end) {
            int mid = begin + (end - begin) / 2;
            ListNode list1 = binaryTreeMerge(subLists,begin,mid);
            ListNode list2 = binaryTreeMerge(subLists,mid + 1,end);
            return mergeTwoLists(list1,list2);
        }
        else {
            return null;
        }
        
    }
    
    public static ListNode mergeTwoLists(ListNode list1, ListNode list2) {
        if(list1 == null) { return list2; }
        if(list2 == null) { return list1; }
        ListNode mergeList;
        if(list1.val < list2.val) {
            mergeList = list1;
            mergeList.next = mergeTwoLists(list1.next,list2);
        }
        else {
            mergeList = list2;
            mergeList.next = mergeTwoLists(list1,list2.next);
        }
        return mergeList;
    }
}
```

##### 大神解法

解法一：**递归+二叉树**的思路

将整个的合并过程看成是一个二叉树从叶子到根部的汇聚过程，由于二叉树的每一层都有n个节点（设`lists[]`数组所有链表的所有元素加和起来是n），且每一层遍历所有链表节点之和n的时候都不会重复遍历，所以每一层合并的复杂度是`O(n)`；根据二叉树的建树规则，令`K = 2^X`，则K条链表建成的树的高度是`X`，也即`logK`，所以深度方向上的合并复杂度是`O(logK)`。

综上，该算法合并的时间复杂度是`O(nlogK)`，由于使用到了递归，所以空间复杂度至少是`O(n)`。

```
public class Solution {
    public ListNode mergeTwoLists(ListNode l1, ListNode l2) {
        if (l1 == null) return l2;
        if (l2 == null) return l1;

        ListNode head=null;
        ListNode former=null;
        while (l1!=null&&l2!=null) {
            if (l1.val>l2.val) {
                if (former==null) former=l2; else former.next=l2;
                if (head==null) head=former; else former=former.next;
                l2=l2.next;
            } else {
                if (former==null) former=l1; else former.next=l1;
                if (head==null) head=former; else former=former.next;
                l1=l1.next;
            }
        }
        if (l2!=null) l1=l2;
        former.next=l1;
        return head;
        
    }
    
    public ListNode mergeKLists(List<ListNode> lists) {
        if (lists.size()==0) return null;
        if (lists.size()==1) return lists.get(0);
        if (lists.size()==2) return mergeTwoLists(lists.get(0), lists.get(1));
        return mergeTwoLists(mergeKLists(lists.subList(0, lists.size()/2)), 
            mergeKLists(lists.subList(lists.size()/2, lists.size())));
    }
}
```

```
public static ListNode mergeKLists(ListNode[] lists){
    return partion(lists,0,lists.length-1);
}

public static ListNode partion(ListNode[] lists,int s,int e){
    if(s==e)  return lists[s];
    if(s<e){
        int q=(s+e)/2; // to avoid integer overflow, use q = s + (e -s) / 2 instead
        ListNode l1=partion(lists,s,q);
        ListNode l2=partion(lists,q+1,e);
        return merge(l1,l2);
    }else
        return null;
}

//This function is from Merge Two Sorted Lists.
public static ListNode merge(ListNode l1,ListNode l2){
    if(l1==null) return l2;
    if(l2==null) return l1;
    if(l1.val<l2.val){
        l1.next=merge(l1.next,l2);
        return l1;
    }else{
        l2.next=merge(l1,l2.next);
        return l2;
    }
}
```

解法二：**优先级队列PriorityQueue**方法

采用PriorityQueue优先级队列，优先级队列只需要自定义重写一个`compare()`方法，之后添加进该队列中的元素就会自动按照顺序进行排列，之后所需要做的工作只是单纯将元素添加进去和从队列的头部读出元素即可。

时间复杂度也是`O(nlogK)`

```
public class Solution {
    public ListNode mergeKLists(List<ListNode> lists) {
        if (lists==null||lists.size()==0) return null;
        PriorityQueue<ListNode> queue= new PriorityQueue<ListNode>(lists.size(),new Comparator<ListNode>(){
            @Override
            public int compare(ListNode o1,ListNode o2){
                if (o1.val<o2.val)
                    return -1;
                else if (o1.val==o2.val)
                    return 0;
                else 
                    return 1;
            }
        });
        ListNode dummy = new ListNode(0);
        ListNode tail=dummy;
        for (ListNode node:lists)
            if (node!=null)
                queue.add(node); 
        while (!queue.isEmpty()){
            tail.next=queue.poll();
            tail=tail.next;
            if (tail.next!=null)
                queue.add(tail.next);
        }
        return dummy.next;
    }
}
```

### 总结

- 在复杂问题的解法上，需要在尽可能复用简单解法的基础上，借鉴丰富多样的**数据结构**，比如树、队列、堆、栈等；
- 尽管解法是正确的，但是leetcode还是会利用超长超多的输入来限制算法的运行时间。