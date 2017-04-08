title: leetcode141 Linked List Cycle

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#141 Linked List Cycle 

>Given a linked list, determine if it has a cycle in it.
>
>solve it without using extra space.

##### 解释：

给定一个链表，判断链表是否有环。（最好不使用额外的存储空间）

##### 理解：

本题的链表中的每一个节点只有一个`next` ，即每一个节点连接的下一个节点是为唯一的，不会出现分支。只是不知道如果出现环路，环路的起止点是哪一个节点。

##### 我的解法：

既然是**单链表**，那么就设置两个指针`slow`和`fast` ，都用于遍历链表的所有节点，其中`slow` 每次移动一个节点的位置，`fast` 每次移动两个节点的位置，如果不存在环路，则`fast` 将在之后的遍历中永远不会与`slow` 相遇，并最后到达链表的末尾；如果存在环路，则两个不同遍历速度的指针肯定会在某一个时间相遇，即`slow = fast` 。

```
/**
 * Definition for singly-linked list.
 * class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) {
 *         val = x;
 *         next = null;
 *     }
 * }
 */
public class Solution {
    public boolean hasCycle(ListNode head) {
        ListNode slow = head;
        ListNode fast = head;
        
        while(fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if(slow == fast) {
                break;
            }
        }
        return (fast == null || fast.next == null)? false : true;
    }
}
```

##### 大神解法：

基本思路都是相同的。

```
public boolean hasCycle(ListNode head) {
    if(head==null) return false;
    ListNode walker = head;
    ListNode runner = head;
    while(runner.next!=null && runner.next.next!=null) {
        walker = walker.next;
        runner = runner.next.next;
        if(walker==runner) return true;
    }
    return false;
}
```

### 总结：

本题可以形象地用**赛跑**来描述：如果跑直线，那么跑得慢的人将永远追不上跑得快的人，两人也就永远不会相遇；如果跑圈，那么跑的快的人将在某一时间追上跑得慢的人，两人将在未来的某一个时间点相遇。

