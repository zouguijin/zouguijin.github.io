title: leetcode237 Delete Node in a Linked List

date: 2017/04/08 16:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#237 Delete Node in a Linked List 

>Write a function to delete a node (except the tail) in a singly linked list, given only access to that node.
>
>Supposed the linked list is `1 -> 2 -> 3 -> 4` and you are given the third node with value `3`, the linked list should become `1 -> 2 -> 4`after calling your function.

##### 解释：

删除指定的链表节点。除了给定的指向待删除节点的指针，没有其他任何指向链表节点的指针。

##### 理解：

即没有头结点，无法从待删除节点之前的一个节点改变`next`，使之指向待删除节点之后的节点（即跨过待删除节点）。

所以，考虑将待删除节点之后的节点的值转移**覆盖待删除节点的值**，然后改变待删除节点`next`的指向，使之指向待删除节点的`next.next`所指的节点。

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
    public void deleteNode(ListNode node) {
        node.val = node.next.val;
        node.next = node.next.next;
    }
}
```

##### 大神解法：

本题比较简单，上述已经是最简洁最快速的方法了。

### 总结：

当没有方法退后时，可以考虑向前寻找可以替代的东西。