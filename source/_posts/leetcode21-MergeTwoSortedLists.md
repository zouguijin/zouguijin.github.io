title: leetcode21 Merge Two Sorted Lists

date: 2017/05/03 12:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- Recursion

---

## leetcode#21 Merge Two Sorted Lists

>Merge two sorted linked lists and return it as a new list. The new list should be made by splicing together the nodes of the first two lists.

##### 解释

给定两条有序的单链表，要求将它们合并成一条有序的单链表，新链表由原来的两条单链表的节点组合而成。

##### 理解

由于新链表的节点需要由原来两条单链表的节点组合而成，即不能创建新的链表节点。

那么就需要通过比较，依次将两条链表的节点进行重新组合。

##### 我的解法

采用了**递归**的方法，从头到尾分别依次遍历两条链表，一直递归到一条链表的末尾，递归的过程都是将遍历到的两条链表节点中值较小的那一个节点附加到新链表之后（实际上这时候还没有附加上去，只是保留了这个关系，需要等到最后递归返回的时候才会真正的附加上去），所以，递归返回的时候，实际上是依次返回节点值大的那些节点。

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
    public ListNode mergeTwoLists(ListNode list1, ListNode list2) {
        if(list1 == null){return list2;}
        if(list2 == null){return list1;}

        ListNode mergeList;
        if(list1.val < list2.val){
            mergeList = list1;
            mergeList.next = mergeTwoLists(list1.next,list2);
        }
        else{
            mergeList = list2;
            mergeList.next = mergeTwoLists(list1,list2.next);
        }
        return mergeList;
    }
}
```

##### 大神解法

上述的解法就是大神们的解法之一，嗯。

### 总结

递归方法，虽然会提高算法的空间复杂度，但是对于无法确定循环条件以及循环中条件很复杂的情况，递归往往一句话很简单就可以搞定。