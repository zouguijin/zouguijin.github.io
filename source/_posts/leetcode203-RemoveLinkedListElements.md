title: leetcode203 Remove Linked List Elements

date: 2017/04/07 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#203 Remove Linked List Elements 

>Remove all elements from a linked list of integers that have value **val**.
>
>**Example**
>**Given:** 1 --> 2 --> 6 --> 3 --> 4 --> 5 --> 6, **val** = 6
>**Return:** 1 --> 2 --> 3 --> 4 --> 5

##### 解释：

给定一个单链表和一个值，若链表节点的值等于给定值，则将该节点删除。

##### 理解：

这道题可以递归也可以非递归。

递归，除了边界判断，就直接遍历到链表的最末尾，然后依次往前返回，每一次返回的时候都比较一下当前节点值是否与给定值相同，若相同，则**返回当前节点的后一个节点**，即跳过当前节点；若不同，则返回当前节点。

非递归，除了边界判断，则另外需要两个指针`tmp1`和`tmp2`，`tmp2`作为走在前面的探索指针，将会比较当前所指节点的值是否与给定值相同，若相同，则移动到下一个节点，若不同，则`tmp1`将会把所指节点的`next`指向`tmp2`所在的节点，然后`tmp1`将会移动到`tmp2`的位置。

##### 我的解法：

非递归方法：

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
    public ListNode removeElements(ListNode head, int val) {
        if(head == null) return null;
        while(head.val == val) {
            head = head.next;
            if(head == null) return null;
        }
        ListNode tmp1 = head;
        ListNode tmp2 = tmp1.next;
        while(tmp2 != null) {
            if(tmp2.val == val) { tmp2 = tmp2.next; }
            else {
                tmp1.next = tmp2;
                tmp1 = tmp2;
                tmp2 = tmp2.next;
            }
        }
        tmp1.next = null;
        return head;
    }
}
```

##### 大神解法：

非递归方法：

只用了额外的一个指针`curr`，在循环的时候，每次都让`curr`下一个节点的值与给定值比较，**若相同，则改变`curr`所指节点`next`的指向**，指向后续的节点，这样一来循环条件就可以保持不变，变化的只是`curr.next`所指的节点。

```
public class Solution {
    public ListNode removeElements(ListNode head, int val) {
        while (head != null && head.val == val) head = head.next;
        ListNode curr = head;
        while (curr != null && curr.next != null)
            if (curr.next.val == val) curr.next = curr.next.next;
            else curr = curr.next;
        return head;
    }
}
```

递归方法：

```
public ListNode removeElements(ListNode head, int val) {
        if (head == null) return null;
        head.next = removeElements(head.next, val);
        return head.val == val ? head.next : head;
}
```

### 总结：

本题比较简单，基本的单链表`next`指针指向的改变，注意改变的顺序就可以了。