title: leetcode92 Reverse Linked List II

date: 2017/04/13 14:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#92 Reverse Linked List II 

>Reverse a linked list from position *m* to *n*. Do it in-place and in one-pass.
>
>For example:
>Given `1->2->3->4->5->NULL`, *m* = 2 and *n* = 4,
>
>return `1->4->3->2->5->NULL`.
>
>**Note:**
>Given *m*, *n* satisfy the following condition:
>1 ≤ *m* ≤ *n* ≤ length of list.

##### 解释：

给定一条单链表，要求反转第m个节点到第n个节点之间链表节点顺序。

注意，限定输入的关系为：`1 <= m <= length of list` 

##### 理解：

之前已经写过单链表的反转，本题可以理解为从节点m到节点n，这一段的单链表反转，即可以继续使用之前的单链表反转代码对这一段的链表进行操作。但是，由于这不是链表所有节点都参与反转，所以还需要根据实际情况分别考虑：

- `m = 1` ，这时候在改变中间链表节点的顺序之后，原链表的头结点指针`head`需要指向节点n的位置，而原来的头结点将会成为原来节点n的下一个节点的前向节点；
- `m != 1` ，这时候情况就相对简单一点，在改变中间一段链表的顺序之后，只需要将原m节点的指针指向原n节点的下一个节点，再将原m节点的前向节点的指针指向原n节点，即可。

根据上述理解，在原有链表反转代码的基础上，需要增加条件判断，以及指向节点m前向节点的`pfix`指针和用于遍历链表节点的`pmove`指针和`next`指针，以及用于计数并与`(n - m)`进行比较的计数变量`count`。

##### 我的解法：

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
    public ListNode reverseBetween(ListNode head, int m, int n) {
        if(head == null || head.next == null || (n - m) == 0) { return head; }

        ListNode pfix = head;
        for(int i = 1;i < (m - 1);i++) {
            pfix = pfix.next;
        }
        ListNode pmove = pfix.next;
        ListNode tail = null;
        int count = 0;
        while(pmove != null && count < (n - m)) {
            ListNode next = pmove.next;
            pmove.next = tail;
            tail = pmove;
            pmove = next;
            count++;
        }
        if(m == 1) {
            head = tail;
            pfix.next.next = pfix;
            pfix.next = pmove;
        }
        else{
            pfix.next.next = pmove.next;
            pfix.next = pmove;
            pmove.next = tail;
        }
        return head;
    }
}
```

##### 大神解法：

很简洁的方法！

巧妙之处在于，该解法在**链表之外创建了一个新的节点**`dummy`，指向链表的头结点，并令指针`pre`为始终指向节点m的上一个节点，如此一来就可以避免判断`m == 1`以及相应的不同情况的不同处理方式了。

同时，本解法中对于链表节点的位置调换方式也很特别，举个例子：

对于`0->1->2->3->4->5->null && m=1,n=4`来说，调换的结果依次为：

**1->0** ->**2**->3->4->5->null

**2->1->0** ->**3**->4->5->null

**3->2->1->0** ->4->5->null

可见，下一次的顺序调换，都会基于上一次调换的结果，**将上一次顺序调换的结果作为一个整体**，与下一个节点进行调换。

```
public ListNode reverseBetween(ListNode head, int m, int n) {
    if(head == null) return null;
    ListNode dummy = new ListNode(0); // create a dummy node to mark the head of this list
    dummy.next = head;
    ListNode pre = dummy; // make a pointer pre as a marker for the node before reversing
    for(int i = 0; i<m-1; i++) pre = pre.next;
    
    ListNode start = pre.next; // a pointer to the beginning of a sub-list that will be reversed
    ListNode then = start.next; // a pointer to a node that will be reversed
    
    // 1 - 2 -3 - 4 - 5 ; m=2; n =4 ---> pre = 1, start = 2, then = 3
    // dummy-> 1 -> 2 -> 3 -> 4 -> 5
    
    for(int i=0; i<n-m; i++)
    {
        start.next = then.next;
        then.next = pre.next;
        pre.next = then;
        then = start.next;
    }
    
    // first reversing : dummy->1 - 3 - 2 - 4 - 5; pre = 1, start = 2, then = 4
    // second reversing: dummy->1 - 4 - 3 - 2 - 5; pre = 1, start = 2, then = 5 (finish)

    return dummy.next; 
}
```

### 总结：

- 当链表的头结点不好处理的时候，可以在链表之外创建一个新的节点，指向链表的头结点；
- 每次操作都基于前一次结果的方法，学习学习；
- 熟练掌握基础方法，是解决复杂问题的根本。