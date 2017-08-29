title: leetcode143 Reorder List

date: 2017/08/29 15:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- reverse

---

##leetcode#143 Reorder List

>Given a singly linked list L: *L0 L1 … Ln-1 Ln*,
>reorder it to: *L0 Ln L1 Ln-1 L2 Ln-2*…
>
>You must do this in-place without altering the nodes' values.

####解释

给定单链表，要求对链表进行重新排序，例如：

输入：1,2,3,4,5,6,7

返回：1,7,2,6,3,5,4

要求：不能改变节点的值，只能通过移动节点本身实现重新排序。

#### 理解

第一反应是：如果这是一条双向链表，那么问题就非常简单了——只需要分别从两端出发，依次将尾端的节点插入到头端两个节点之间即可。

尽管本题给定的是一条单链表，但是可以通过反转链表后半部分达到上述效果。

综上，可以看出，本题其实思想很简单，算作是对基本链表操作和变换的考察吧，大致可以分成4个步骤，每个步骤可以封装成单独的模块：

1. 计算链表的长度；
2. 找出链表中间位置的节点；
3. 对链表后半部分的指针关系进行反转；
4. 将链表后半部分的节点插入前半部分，形成交替的分布效果。

####我的解法

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
    public void reorderList(ListNode head) {
        int length = iterateList(head);
        if(length < 3) return;
        
        ListNode midNode = findMidNode(head,length);
        ListNode tailNode = invertList(midNode);
        // No.4 Step
        ListNode mov = head;
        while(tailNode.next != null) {
            ListNode movNext = mov.next;
            ListNode tailPre = tailNode.next;
            mov.next = tailNode;
            tailNode.next = movNext;
            mov = movNext;
            tailNode = tailPre;
        }
        return;
    }
    // No.1 Step
    public static int iterateList(ListNode head) {
        int count = 0;
        ListNode mov = head;
        while(mov != null) {
            count++;
            mov = mov.next;
        }
        return count;
    }
    // No.2 Step
    public static ListNode findMidNode(ListNode head, int totalNum) {
        int midNum = totalNum/2 + 1;
        ListNode midNode = head;
        while(midNum-- > 1) {
            midNode = midNode.next;
        }
        return midNode;
    }
    // No.3 Step
    public static ListNode invertList(ListNode begin) {
        ListNode pre = begin;
        ListNode mid = begin.next;
        while(mid.next != null) {
            ListNode beh = mid.next;
            mid.next = pre;
            pre = mid;
            mid = beh;
        }
        mid.next = pre;
        begin.next = null;
        return mid;
    }
}
```

#### 大神解法

基本思想是一样的。

不过在找链表中间位置节点的问题上，可以使用**“一快一慢”两个指针**：快指针一次走两步，慢指针一次走一步。

```
public void reorderList(ListNode head) {
            if(head==null||head.next==null) return;
            
            //Find the middle of the list
            ListNode p1=head;
            ListNode p2=head;
            while(p2.next!=null&&p2.next.next!=null){ 
                p1=p1.next;
                p2=p2.next.next;
            }
            
            //Reverse the half after middle  1->2->3->4->5->6 to 1->2->3->6->5->4
            ListNode preMiddle=p1;
            ListNode preCurrent=p1.next;
            while(preCurrent.next!=null){
                ListNode current=preCurrent.next;
                preCurrent.next=current.next;
                current.next=preMiddle.next;
                preMiddle.next=current;
            }
            
            //Start reorder one by one  1->2->3->6->5->4 to 1->6->2->5->3->4
            p1=head;
            p2=preMiddle.next;
            while(p1!=preMiddle){
                preMiddle.next=p2.next;
                p2.next=p1.next;
                p1.next=p2;
                p1=p2.next;
                p2=preMiddle.next;
            }
        }
```

####总结

本题充分说明了基础的重要性，只要基础扎实，善于分解问题，多么复杂的问题都可以抽象成多个基础模块，然后各个击破。