title: leetcode142 Linked List Cycle II

date: 2017/04/02 17:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#142 Linked List Cycle II 

>Given a linked list, return the node where the cycle begins. If there is no cycle, return `null`.
>
>Solve it without using extra space.

##### 解释：

给定一个**单链表**，如果单链表中存在环路，则返回**环路起始的节点**；如果没有环路，则返回`null`。

##### 理解：

这个题可以借鉴leetcode#141的思路，并接着扩展代码即可。在leetcode#141判断的基础上，如果存在环路，则判断`head`和`slow`是否相同，若相同，则`head`所指的节点就是环路起始的节点，若不同，则将`head`移动到下一个节点，同时让`slow`在环路中跑一圈，看看`head`会不会与`slow`相遇。

##### 我的解法：

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
    public ListNode detectCycle(ListNode head) {
        ListNode slow = head;
        ListNode fast = head;
        
        while(fast != null && fast.next != null) {
            slow = slow.next;
            fast = fast.next.next;
            if(slow == fast) {
                break;
            }
        }
        if(fast == null || fast.next == null) { return null; }
        else {
            while(head != slow) {
                if(head != slow && slow != fast) { slow = slow.next; }
                else if(head != slow && slow == fast) {
                    slow = slow.next;
                    head = head.next;
                }
                else { break; }
            }
            return head;
        }
    }
}
```

##### 大神解法：

这道题中蕴含着一个**数学关系**，即`fast`走过的路程是`slow`的两倍。

设`head`距离环路起始节点的路程是A，`slow`在走过路程A之前是不会与`fast`相遇的；`slow`离开环路起始节点B路程时，与走完一圈环路的`fast` 相遇；环路的总长度是N。

所以：

`slow`走过的路程是：A+B

`fast`走过的路程是：2(A+B)

环路总长度是：N = 2(A+B)-(A+B) = A+B

此时，做出一张**距离关系图**之后就会发现，从当前`slow`和`fast`相遇的节点开始，再走A路程，就可以到达环路起始节点位置，而从`head`节点到环路起始位置的路程正好是A。所以，只需要再用一个指针`slow2`从`head`出发，与`slow`同步行走同样的路程，必然会在环路起始的节点相遇。

```
public class Solution {
            public ListNode detectCycle(ListNode head) {
                ListNode slow = head;
                ListNode fast = head;

                while (fast!=null && fast.next!=null){
                    fast = fast.next.next;
                    slow = slow.next;
                    
                    if (fast == slow){
                        ListNode slow2 = head; 
                        while (slow2 != slow){
                            slow = slow.next;
                            slow2 = slow2.next;
                        }
                        return slow;
                    }
                }
                return null;
            }
        }
```

### 总结

两种方法都是在leetcode#141原有的基础上进行扩展，但是我的解法没有发现其中蕴含的简单数学关系，而是采取了暴力解法，实在是不应该。

复杂的问题十有八九都会蕴含一定的数学关系或者数学规律，找出这些关系和规律，解题方法将大幅度优化。

