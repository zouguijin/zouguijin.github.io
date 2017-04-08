title: leetcode160 Intersection of Two Linked Lists

date: 2017/04/05 17:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#160 Intersection of Two Linked Lists   

>Write a program to find the node at which the intersection of two singly linked lists begins.
>
>For example, the following two linked lists:
>
>```
>A:          a1 → a2
>                   ↘
>                     c1 → c2 → c3
>                   ↗            
>B:     b1 → b2 → b3
>
>```
>
>begin to intersect at node c1.
>
>**Notes:**
>
>- If the two linked lists have no intersection at all, return `null`.
>- The linked lists must retain their original structure after the function returns.
>- You may assume there are no cycles anywhere in the entire linked structure.
>- Your code should preferably run in O(n) time and use only O(1) memory.

##### 解释：

找出两个单链表相交的节点（第一个相交的节点）。

注意：

- 如果两个单链表没有相交的节点，返回`null`
- 在返回之后，两个单链表必须保持原有的结构状态
- 本题可以假设没有环路
- 时间复杂度要求`O(n)`，空间复杂度要求`O(1)` 

##### 理解：

- 可能两条链表没有交点，所以必须遍历到链表的最后
- 返回后保持链表的原有结构，那么递归方式就不太好使用
- 没有环路，意味着可以一次遍历到链表的末尾
- 时间复杂度`O(n)`限制了循环最多是所有链表节点，不能有两层及以上的遍历链表出现；空间复杂度`O(1)`限制了不能构造另外的数据结构，用于暂存链表节点，只能在原有的链表结构上操作

要求越多，题目的解决方式就会更清晰。

根据上述情况的描述，可以从两条链表节点数的不同入手。在相交节点之后，两条链表的节点是相同的，所以节点数的不同只会出现在相交节点之前的部分。

如果两个链表都从距离相交节点相同路程的节点出发，以相同的遍历速度往前走，则一定会在相交节点相遇，此时返回当前节点即可。

至于如何确定两个链表遍历的起始位置，可以先分别遍历一次，得到两个链表各自的节点数目，比较，较多的一方先向前移动差值的路程，最后再开始一起向后遍历。

##### 我的解法：

```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
        ListNode tmpA = headA;
        ListNode tmpB = headB;
        int countA = 0;
        int countB = 0;
        
        if(headA == null || headB == null) { return null; }
        
        while(tmpA != null) {
            countA++;
            tmpA = tmpA.next;
        }
        while(tmpB != null) {
            countB++;
            tmpB = tmpB.next;
        }
        
        tmpA = headA;
        tmpB = headB;
        if(countA > countB) {
            for(int i = 0;i<(countA - countB);i++) { tmpA = tmpA.next; }
        }
        else {
            for(int i = 0;i<(countB - countA);i++) { tmpB = tmpB.next; }
        }
        
        while(tmpA != tmpB) {
            if(tmpA == null || tmpB == null) { return null; }
            else {
                tmpA = tmpA.next;
                tmpB = tmpB.next;
            }
        }
        return tmpA;
    }
}
```

##### 大神的解法：

很巧妙，考虑到了路程的关系。

假设`headA`到相交节点的距离是A，`headB`到相交节点的距离是B，从相交节点到末尾的距离是C，则可以不用事先判断两条链表的节点数之差，只需要走一圈肯定会相遇与相交节点，因为`A+B+C = B+A+C`，即分别从头开始分别遍历两条链表，遇到末尾时跳转到另外一条链表的首部继续遍历，如果存在相交节点，走完一圈肯定会相遇，否则肯定没有相交节点。

```
public ListNode getIntersectionNode(ListNode headA, ListNode headB) {
    if(headA == null || headB == null) return null;
    
    ListNode a = headA;
    ListNode b = headB;
 
    while( a != b){
    	//for the end of first iteration, we just reset the pointer to the head of another linkedlist
        a = a == null? headB : a.next;
        b = b == null? headA : b.next;    
    }
    return a;
}
```

### 总结：

好的算法都是精致的数学关系。

有时候你只考虑到了一个层面的数学关系，把眼界放宽，放远一点，也许就能看到下一层面的、更精致的数学关系。