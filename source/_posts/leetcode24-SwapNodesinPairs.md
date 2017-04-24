title: leetcode24 Swap Nodes in Pairs

date: 2017/04/24 12:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- reverse

---

## leetcode#24 Swap Nodes in Pairs

>Given a linked list, swap every two adjacent nodes and return its head.
>
>For example,
>Given `1->2->3->4`, you should return the list as `2->1->4->3`.
>
>Your algorithm should use only constant space. You may **not** modify the values in the list, only nodes itself can be changed.

##### 解释

给定一个单链表，每两个节点之间相互交换位置，最后返回处理之后的单链表。

例如：输入 `1->2->3->4->5`，输出应该为 `2->1->4->3->5`

注意，所编写的算法只能当前所给的空间（即不能创建新的一条链表），同时不能改变链表节点的值，只能改变节点本身的位置。

##### 理解

本题直观上是简单的，如果没有任何的限制条件，可以每隔两个元素交换一下节点的值即可，但是在限定的条件下，只能通过实际地移动节点完成本题。

由于是每两个节点之间进行位置的交换，可以将每两个节点视为一组，一组一组地进行考虑和移动，这样可以在解决本题的基础上，**最大程度地进行扩展**，以适应每k个节点之间的位置交换问题的解决。

##### 我的解法

先确定链表的**尾节点**，然后每两个节点为一组，在确定**后续还有节点**的基础上，将该组两个节点为一个单位**整个插入**到尾节点之后，以此类推，最后再将所得的链表进行一次**链表反转**操作即可。

- 解法一（使用递归的链表反转）

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
    public ListNode swapPairs(ListNode head) {
        if(head == null || head.next == null) { return head; }
        ListNode one = head;
        ListNode two = one.next;
        while(head.next != null) {
            head = head.next;
        }
        while(one != head && two != head) {
            ListNode nextNode = two.next;
            two.next = head.next;
            head.next = one;
            one = nextNode;
            two = one.next;
        }
        return reverseList(one,null);
    }
    public ListNode reverseList(ListNode head,ListNode newHead) {
        if(head == null) { return newHead; }
        ListNode next = head.next;
        head.next = newHead;
        return reverseList(next,head);
    }
}
```

- 解法二（使用非递归的链表反转，即constant space）

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
    public ListNode swapPairs(ListNode head) {
        if(head == null || head.next == null) { return head; }
        ListNode one = head;
        ListNode two = one.next;
        while(head.next != null) {
            head = head.next;
        }
        while(one != head && two != head) {
            ListNode nextNode = two.next;
            two.next = head.next;
            head.next = one;
            one = nextNode;
            two = one.next;
        }
        return reverseList(one);
    }
    public ListNode reverseList(ListNode head) {
        ListNode newHead = null;
        while(head != null) {
            ListNode next = head.next;
            head.next = newHead;
            newHead = head;
            head = next;
        }
        return newHead;
    }
}
```

##### 大神解法

解法一：

非常的简洁和巧妙，虽然使用了**递归（意味着空间复杂度不是constant space）**。

每一步的递归所做的事：在保证有两个节点的基础上，将递归的入口移动到下一组两个节点的第一个节点位置，同时将当前组的第一个节点的`next`指针对准下一步的返回节点，在递归返回的时候，当前组第二个节点的`next`指针指向第一个节点，然后将第二个节点作为返回值，返回给上一层的递归。

虽然有点绕，但是实现的效果确实异常地巧妙，令人惊叹。

```
public class Solution {
    public ListNode swapPairs(ListNode head) {
        if ((head == null)||(head.next == null))
            return head;
        ListNode n = head.next;
        head.next = swapPairs(head.next.next);
        n.next = head;
        return n;
    }
}
```

解法二：

> 在涉及到链表头结点变动的情况下，创建一个链表外的节点，指向链表的头结点

本解法很好的使用了上述的一个**准则**，之后每三个节点为一组进行考虑，`current`每次都指向两个即将交换位置的节点的上一个节点，`first`节点和`second`节点分别指向即将交换位置的两个节点。

可以说，本解法算是**最直观、最容易想到**的方法，但是其扩展性不是很好，特别是当一组节点的数量k增大的时候，`current.next.next`这种写法显然是不现实的。

```
public ListNode swapPairs(ListNode head) {
    ListNode dummy = new ListNode(0);
    dummy.next = head;
    ListNode current = dummy;
    while (current.next != null && current.next.next != null) {
        ListNode first = current.next;
        ListNode second = current.next.next;
        first.next = second.next;
        current.next = second;
        current.next.next = first;
        current = current.next.next;
    }
    return dummy.next;
}
```



### 总结

我的解法中，由于除了链表反转的部分，前面的处理代码都是相同的，因此我顺便**比较**了两种链表反转方法的性能：

- 递归方法：不仅不是constant space，而且在程序运行时间上为9ms，only beat 3%；
- 非递归方法：既是constant space，而且在程序运行时间上为5ms，beat 37%。

可见，在简单问题的解决上，非递归的解法性能要优于递归的方法，即在追求性能的前提下，递归不到万不得已最好不要使用，因为它既耗时又消耗空间——因为每一步的递归都需要存储上一步相应的值，等待下一步的递归返回。

此外，由于额外考虑到了**每k个节点的顺序调换的问题**，即leetcode#25 Reverse Nodes in k-Group，所以我的解法没有使用最直观的方法，而是考虑采取**扩展性**较高的“**先按组移动节点，最后链表反转**”的处理方法。