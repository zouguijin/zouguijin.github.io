title: leetcode86 Partition List

date: 2017/05/12 18:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#86 Partition List

>Given a linked list and a value *x*, partition it such that all nodes less than *x* come before nodes greater than or equal to *x*.
>
>You should preserve the original relative order of the nodes in each of the two partitions.
>
>For example,
>Given `1->4->3->2->5->2` and *x* = 3,
>return `1->2->2->4->3->5`.

#### 解释

给定一条单链表和一个值`x`，现要求将该链表的节点按照以下规则进行划分：节点值小于`x`的节点移动到节点值大于或者等于`x`的节点之前，要保证两个划分部分的顺序与原来的顺序一样。

例如：

输入 `1->4->3->2->5->2` &&  *x* = 3,
返回 `1->2->2->4->3->5`.

#### 理解

可以看到，本题要求的**并不是简单的大小排序**，而是以一个值为边界，将链表的节点分成两个部分：小于该值和大于该值，每个部分都需要**保持原来的先后顺序不变**。

最初的考虑：

设立两个指针，`small`和`big` ，`big`指针从头到尾依次遍历链表的每一个节点，将节点值小于`x`的节点移动到`small`所指的节点之后，然后`small`向后移动一位，以此类推。但是在实现的时候，相当于将某一个节点从前后包围的其他两个节点中抽取出来，移动到前方，涉及到其原前后两个节点连接关系的重新建立，需要临时创建额外的两个节点，不好把握边界关系，容易出现`TLE`和`RunTimeError`。

后来的想法：

**复杂问题可以不局限于一定要`O(1)`的空间复杂度**，何况题目也没有要求，所以是不是可以创建两个新的节点，将节点值小于`x`的节点都连接到其中一个节点上，原链表的其余节点连接到另外一个节点上，最后再将两条短链表合二为一？

#### 我的解法

即新建两个新节点，分别连接节点值小于`x`的节点和其余节点，最后再将两条链表**合二为一**。

需要注意的是，节点值大于`x`的节点组成的链表，在合成之前，需要将**最后一个节点**的`next`置为`null`，以免出现`TLE`的错误。

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
    public ListNode partition(ListNode head, int x) {
        if(head == null || head.next == null) return head;
        
        ListNode small = new ListNode(0);
        ListNode big = new ListNode(0);
        ListNode s = small;
        ListNode b = big;
        
        while(head != null) {
            if(head.val < x) {
                s.next = head;
                s = head;
            }
            else {
                b.next = head;
                b = head;
            }
            head = head.next;
        }
        b.next = null;
        s.next = big.next;
        return small.next;
    }
}
```

#### 大神解法

与上述解法相同。

### 总结

- **复杂问题可以不局限于一定要`O(1)`的空间复杂度**，可以申请更多的资源来解决问题