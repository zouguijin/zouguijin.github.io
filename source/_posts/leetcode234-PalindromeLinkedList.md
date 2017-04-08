title: leetcode234 PalindromeLinkedList

date: 2017/04/08 12:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- palindrome

---

## leetcode#234 Palindrome Linked List  

>Given a singly linked list, determine if it is a palindrome.
>
>Could you do it in O(n) time and O(1) space?

##### 解释：

给定一条单链表，判断是否有回文。

是否能在`O(n)`时间复杂度和`O(1)`空间复杂度的限制下解决该问题？

##### 理解：

先解释一下“回文”的意思：不论正反来看，都是一样的。

对于单链表，也即不论正序读还是逆序读，都是一样的。

直观上的解法，就是分别从两头开始向中间遍历链表节点，判断节点的值是否相等，但是对于单链表来说，逆序获得下一个节点比较困难。同样，想从中间往两头分别遍历的思路也会遇到上述困难。

所以，可以考虑先**将后半部分的链表反转**，这样就可以构造出一个从两头开始，分别指向中间的链表结构，然后分别从两头开始向中间遍历链表节点，并判断即可。

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
    public boolean isPalindrome(ListNode head) {
    	/* Boundary judgement */
        if(head == null || head.next == null) { return true; }
        /* Count the nodes in the list */
        ListNode tmp = head;
        int count = 1;
        while(tmp.next != null) {
            tmp = tmp.next;
            count++;
        }
        int mid = count/2;
        tmp = head;
        for(int i = 0 ; i < mid ; i++) {
            tmp = tmp.next;
        }
        /* Reverse the list from the mid to the end of the list */
        ListNode newHead = null;
        while(tmp != null) {
            ListNode next = tmp.next;
            tmp.next = newHead;
            newHead = tmp;
            tmp = next;
        }
        /* Judge one by one */
        while(newHead != null) {
            if(head.val != newHead.val) {
                return false;
            }
            else {
                head = head.next;
                newHead = newHead.next;
            }
        }
        return true;
    }
}
```

##### 大神解法：

本解法是投票数最多的一个。

本质的思路是一样的，只不过它在确定链表中点的时候，采用的是一快一慢两个指针，快指针一次移动两个节点位置，慢指针一次移动一个节点位置，当快指针到达链表末尾的时候，慢指针到达`list.length/2`的位置。

```
public boolean isPalindrome(ListNode head) {
    ListNode fast = head, slow = head;
    while (fast != null && fast.next != null) {
        fast = fast.next.next;
        slow = slow.next;
    }
    if (fast != null) { // odd nodes: let right half smaller
        slow = slow.next;
    }
    slow = reverse(slow);
    fast = head;
    
    while (slow != null) {
        if (fast.val != slow.val) {
            return false;
        }
        fast = fast.next;
        slow = slow.next;
    }
    return true;
}

public ListNode reverse(ListNode head) {
    ListNode prev = null;
    while (head != null) {
        ListNode next = head.next;
        head.next = prev;
        prev = head;
        head = next;
    }
    return prev;
}
```

### 总结：

本题实际上是建立在**链表反转**的基础上（即leetcode#206），只要确定链表的中间节点并从中间节点开始反转后续的节点，之后的遍历比较就比较简单了。

### 来自最高票数的声音：

>It is a common misunderstanding that the space complexity of a program is just how much the size of additional memory space being used besides input. An important prerequisite is neglected the above definition: [the input has to be read-only](https://en.wikipedia.org/wiki/DSPACE#Machine_models). By definition, changing the input and change it back is not allowed (or the input size should be counted when doing so). Another way of determining the space complexity of a program is to simply look at how much space it has written to. Reversing a singly linked list requires writing to O(n) memory space, thus the space complexities for all "reverse-the-list"-based approaches are O(n), not O(1).
>
>Solving this problem in O(1) space is theoretically impossible due to two simple facts: (1) a program using O(1) space is computationally equivalent to a finite automata, or a regular expression checker; (2) [the pumping lemma](https://en.wikipedia.org/wiki/Pumping_lemma_for_regular_languages) states that the set of palindrome strings does not form a regular set.

简单来说就是，我们常常误解了一个程序的空间复杂度只是除了输入之外的额外占用空间，上述说法成立的前提是忽略了以下定义：输入只能是只读的。这个定义的意思是，任何对输入进行修改的操作都是不被允许的。

而另一种对空间复杂度的理解则是，简单看有多少空间被占用。

将一个单链表反转是需要对链表本身进行修改的（违反了第一条定义），同时需要占用`O(n)`的空间（违反了第二条定义）。

（后面的自动机和@#￥%就看不懂了）

总之，本条评论认为，在`O(1)`的空间复杂度的限制条件下，本题是不可能通过反转链表的方式来解决的（尽管该方法也通过了，速度也很快）。