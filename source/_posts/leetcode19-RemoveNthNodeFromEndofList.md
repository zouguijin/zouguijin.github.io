title: leetcode19 Remove Nth Node From End of List

date: 2017/04/20 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- Recursion

---

## leetcode#19 Remove Nth Node From End of List

>Given a linked list, remove the nth node from the end of list and return its head.
>
>For example,
>
>```
>Given linked list: 1->2->3->4->5, and n = 2.
>After removing the second node from the end, the linked list becomes 1->2->3->5.
>```
>
>Note:
>
>Given n will always be valid.
>
>Try to do this in one pass.

##### 解释：

给定一条单链表，要求将从链表**末尾数起第n个节点**移除链表，并返回处理之后的链表。限制只能遍历一次链表。

例如：

输入为： 1->2->3->4->5 && n = 2

则返回结果为： 1->2->3->5

假设给出的n是有效的，即小于链表的节点数量。

##### 理解：

单链表，即只能从头到尾一个方向访问链表中的节点，要求**移除从链表末尾数起的第n个节点**，结合之前`leetcode#203 Remove Linked List Elements`移除链表节点的方法，考虑用**递归**的方式遍历链表的所有节点，在递归返回的过程中，用一个计数器`count`**计数**，从而判断是否到达了所要求移除的节点位置，若是，则将一个指针`nthNode`指向该节点。遍历结束之后，判断`nthNode`的边界情况，并根据`leetcode#203`的方法进行相应的移除节点操作。

##### 我的解法：

具体实现的时候，在原有`public`方法的基础上，新添加了一个`private`方法，用于链表节点的遍历以及在遍历过程中计数和提取所要删除的节点。

由于**方法内的变量只能存在于该方法内部**，若要让`private`方法也能用到`public`方法传进来的变量`n`，就需要创建一个**公有成员变量**`count`，该变量用于递归返回的过程中计数，判断何时到需要被删除的节点位置；同时，为了在`private`方法中提取的待删除节点信息能为`public`方法所用，创建了一个公有成员变量`nthNode`，用于指向待删除节点。

编写的过程中，还是得注意**边界**的处理。

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
    public int count;
    public ListNode nthNode = new ListNode(0);
    public ListNode removeNthFromEnd(ListNode head, int n) {
        if(head == null || head.next == null) { return null; }
        count = n;
        nthNode = head;
        findNthNode(head);
        if(nthNode.next == null) { nthNode = null; }
        else if(nthNode == head) {
            head = head.next;
        }
        else{
            nthNode.val = nthNode.next.val;
            nthNode.next = nthNode.next.next;
        }
        return head;
    }
    
    private ListNode findNthNode(ListNode head) {
        if(head == null || head.next == null) {
            count--;
            if(count == 0) {
                nthNode = head;
                return null;
            }
            else{
                return head;
            }
        }
        head.next = findNthNode(head.next);
        count--;
        if(count == 0) { nthNode = head; }
        return head;
    }
}
```

##### 大神解法：

考虑到了**路程上的关系**：

要求删除距离链表末尾n的节点，那么可以设置两个指针，一快一慢，快指针先行n，然后两个指针同速前进，即**保持两个指针的距离是n**，这样一来，当快指针到达链表末尾时，慢指针所指的位置即为待删除节点的位置，利用`leetcode#203`的方法就可以删除该节点。

需要注意的是，可能待删除节点时头结点，所以需要在**链表之外新创建一个节点**`start`，作为一快一慢两个节点的起始，最后不论删除哪一个节点都可以返回`start.next`。

```
public ListNode removeNthFromEnd(ListNode head, int n) {
    ListNode start = new ListNode(0);
    ListNode slow = start, fast = start;
    slow.next = head;
    
    //Move fast in front so that the gap between slow and fast becomes n
    for(int i=1; i<=n+1; i++)   {
        fast = fast.next;
    }
    //Move fast to the end, maintaining the gap
    while(fast != null) {
        slow = slow.next;
        fast = fast.next;
    }
    //Skip the desired node
    slow.next = slow.next.next;
    return start.next;
}
```

### 总结

- 关于链表的问题，已经出现了多次**两个指针之间的路程关系**的解决方案，今后要善于往这方面思考；
- 同时，也多次出现在链表之外新创建一个节点，指向链表的头结点，以此来解决**链表头结点可能出现变化**的情况；
- 当然，通过自己的思考解决问题，是首选方案！锻炼思维，也**多尝试JAVA的更多概念**。