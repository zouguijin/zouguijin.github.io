title: leetcode328 Odd Even Linked List

date: 2017/08/31 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#328 Odd Even Linked List 

>Given a singly linked list, group all odd nodes together followed by the even nodes. Please note here we are talking about the node number and not the value in the nodes.
>
>You should try to do it in place. The program should run in O(1) space complexity and O(nodes) time complexity.
>
>**Example:**
>Given `1->2->3->4->5->NULL`,
>return `1->3->5->2->4->NULL`.
>
>**Note:**
>The relative order inside both the even and odd groups should remain as it was in the input. 

#### 解释

给定一条单链表，要求将位置为奇数的节点和位置为偶数的节点各自分成一堆（是**位置的奇偶**，而不是节点值的奇偶），奇数部分和偶数部分需要保持原链表中的前后顺序。

#### 理解

本题其实还是比较好想通的，于是我不明白为什么它的难度是Medium......

位置上奇数与偶数的节点互相**间隔、交替**，因此只需要间隔着将节点的`next` 指针关系重新分配即可（奇数连接奇数，偶数连接偶数，依次往后），最后将偶数节点组的头部接到奇数节点组的尾部即可。

#### 我的解法

```
/**
 * Definition for singly-linked list.
 * public class ListNode {
 *     int val;
 *     ListNode next;
 *     ListNode(int x) { val = x; }
 * }
 */
class Solution {
    public ListNode oddEvenList(ListNode head) {
        if(head == null || head.next == null) return head;
        
        ListNode OHead = head;
        ListNode EHead = head.next;
        
        ListNode OMov = OHead;
        ListNode OTmp = OHead;
        ListNode EMov = EHead;
        ListNode ETmp = EHead;
        
        while(EMov != null && OMov != null && EMov.next != null && OMov.next != null) {
            EMov = EMov.next.next;
            OMov = OMov.next.next;
            ETmp.next = EMov;
            OTmp.next = OMov;
            ETmp = EMov;
            OTmp = OMov;
        }
        OTmp.next = EHead;
        return OHead;
    }
}
```

#### 大神解法

其实，`ETmp`和`OTmp` 这两个变量根本不需要......

```
public class Solution {
public ListNode oddEvenList(ListNode head) {
    if (head != null) {
    
        ListNode odd = head, even = head.next, evenHead = even; 
    
        while (even != null && even.next != null) {
            odd.next = odd.next.next; 
            even.next = even.next.next; 
            odd = odd.next;
            even = even.next;
        }
        odd.next = evenHead; 
    }
    return head;
}}
```



