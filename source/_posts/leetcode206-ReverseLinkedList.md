title: leetcode206 Reverse Linked List

date: 2017/04/06 22:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#206 Reverse Linked List 

>Reverse a singly linked list.
>
>A linked list can be reversed either iteratively or recursively. 

##### 解释：

单链表反转。

可以使用递归和非递归方法。

##### 理解：

单链表反转，需要在头指针`head`的基础上，多使用两个指针实现链表`next`指向的变更，`head`指针用于向后探索以及链表`next`指向变化之后将临时指针切换到`head`位置。

##### 我的解法（非递归）：

除了边界判断之外，如果头指针`head`的下一个节点不为空，则在中间部分`tmp1`、`tmp2`和`head`三个指针将依次从前往后排序，这时首先将中间节点的`next`指针反向，指向之前的节点，然后将前一个节点的指针`tmp1`移动到中间的节点，最后将中间节点的指针`tmp2`移动到`head`位置。一直重复直到`head`之后没有节点，这时只需要改变`head`所指节点的`next`指针，指向之前的节点即可。

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
    public ListNode reverseList(ListNode head) {
        if(head == null || head.next == null) { return head; }
        ListNode tmp1 = head;
        head = head.next;
        ListNode tmp2 = head;
        tmp1.next = null;
        
        while(head.next != null) {
            head = head.next;
            tmp2.next = tmp1;
            tmp1 = tmp2;
            tmp2 = head;
        }
        head.next = tmp1;
        return head;
    }
}
```

##### 大神的解法：

- 非递归方法：思路一致，不过他的解法更为简洁，直接让循环从两个指针开始，在循环内部再**动态生成**第三个指针；
- 递归方法：由于leetcode中给的方法只有一个形参，所以另写了一个含有两个形参的私有方法，该方法**每次传入两个相邻的节点**，在方法内动态生成一个指向后续第三个节点的指针，然后中间的节点改变`next`的指向，指向前一个节点，然后再将中间和第三个节点的指针当做参数进行后续的递归。

```
public ListNode reverseList(ListNode head) {
    /* iterative solution && non-recursive solution */
    ListNode newHead = null;
    while (head != null) {
        ListNode next = head.next;
        head.next = newHead;
        newHead = head;
        head = next;
    }
    return newHead;
}


public ListNode reverseList(ListNode head) {
    /* recursive solution */
    return reverseListInt(head, null);
}
private ListNode reverseListInt(ListNode head, ListNode newHead) {
    if (head == null)
        return newHead;
    ListNode next = head.next;
    head.next = newHead;
    return reverseListInt(next, head);
}
```

### 总结：

递归一般来说是遍历到末尾，再依次从末尾返回到起始位置，但是在本题的递归解法中，**递归是从头往后解题**——每一步递归其实都已经在构造最后的反向链表，最后返回的只是构造完成之后的新链表的头结点。

