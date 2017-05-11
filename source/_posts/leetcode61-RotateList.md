title: leetcode61 Rotate List

date: 2017/05/11 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#61 Rotate List

>Given a list, rotate the list to the right by *k* places, where *k* is non-negative.
>
>For example:
>Given `1->2->3->4->5->NULL` and *k* = `2`,
>return `4->5->1->2->3->NULL`.

#### 解释

给定一条单链表，将该链表向右**循环移动（Rotate）**K次，K为非负数。

例如：

给定 `1->2->3->4->5->NULL` && *k* = `2`,
返回 `4->5->1->2->3->NULL`.

#### 理解

最初的想法：以为只是单纯地将前（lists.length - K）个链表节点搬移到链表末尾，没有意识到“循环移动”，所以所写的代码虽然可以解决`K <= lists.length`的情况，但是由于没有考虑到当`K > lists.length`的情况，所以是不完善的。

后来的想法：既然在`K <= lists.length`的情况下，是OK的，那么对于`K > lists.length`的情况，只要对链表节点的总数**取余**，不就可以将取余的结果限制在`lists.length`之中了么？OK，那就这么干！

#### 我的解法

若循环移动的次数正好是链表节点数量的倍数，那么链表的结构是不变的，所以考虑在`steps <= lists.length`的情况下对链表进行循环移动：

首先需要遍历所有的链表节点，获得节点的总数`count`，然后**取余**`steps = k % count`，获得需要循环移动的次数，接着使用**一快一慢**两个指针，当快指针`fast`到达末尾的时候，直接将从`head`到`slow`的一段链表**整体搬移**到`fast`之后即可。

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
    public ListNode rotateRight(ListNode head, int k) {
        if(k == 0 || head == null || head.next == null) return head;
        
        ListNode fast = head;
        int count = 1;
        while(fast.next != null) {
            fast = fast.next;
            count++;
        }
        int steps = k % count;
        if(steps == 0) return head; 
        
        fast = head;
        ListNode slow = head;
        while(steps != 0 && fast != null) {
            fast = fast.next;
            steps--;
        }
        if(fast == null) return head;
        else {
            while(fast.next != null) {
                slow = slow.next;
                fast = fast.next;
            }
            ListNode next = slow.next;
            slow.next = fast.next;
            fast.next = head;
            head = next;
            return head;
        }
    }
}
```

#### 大神解法

解法一：**链表外节点+快慢指针+整体搬移**

- 由于需要循环移动，头节点也是需要变化的，所以最好在链表之外新建一个节点`dummy`（但我在新建的时候，运行报错`Memory Limit Exceed`...），最后`dummy`的下一个节点即为新链表的头节点；
- 通过取余，使得移动的步数小于链表节点数之内，一快一慢两个指针确定整体搬移的起止位置，最后一次搬移成功

大体来说，我的解法与该解法思路一样，差别在于，我没有新建额外的节点，而且我在确定`slow`指针的位置的时候，是与`fast`指针一起移动的。由于没有新建链表之外的节点，所以我在边界上的判断就会显得稍微多一点，没有该解法简洁。

```
public ListNode rotateRight(ListNode head, int n) {
    if (head==null||head.next==null) return head;
    ListNode dummy=new ListNode(0);
    dummy.next=head;
    ListNode fast=dummy,slow=dummy;

    int i;
    for (i=0;fast.next!=null;i++)//Get the total length 
    	fast=fast.next;
    
    for (int j=i-n%i;j>0;j--) //Get the i-n%i th node
    	slow=slow.next;
    
    fast.next=dummy.next; //Do the rotation
    dummy.next=slow.next;
    slow.next=null;
    
    return dummy.next;
}
```

解法二：**成环**方法

既然是**循环移动**，K的值只要满足非负数就可以任意取值，那么只需要将原链表成环，爱怎么循环移动就怎么循环移动。

成环，首先要遍历链表元素，找到链表末尾的节点，然后将其和链表头节点相连接即可。（以下是C++代码）

```
class Solution {
public:
    ListNode* rotateRight(ListNode* head, int k) {
        if(!head) return head;
        
        int len=1; // number of nodes
        ListNode *newH, *tail;
        newH=tail=head;
        
        while(tail->next)  // get the number of nodes in the list
        {
            tail = tail->next;
            len++;
        }
        tail->next = head; // circle the link

        if(k %= len) 
        {
            for(auto i=0; i<len-k; i++) tail = tail->next; // the tail node is the (len-k)-th node (1st node is head)
        }
        newH = tail->next; 
        tail->next = NULL;
        return newH;
    }
};
```

### 总结

怎么说呢？解法二和解法一其实都差不多，只不过解法二没有一快一慢两个指针，但是代价就是，需要成环，然后开环（好像这也不是什么代价......），相对而言解法一就不需要成环，但是需要用一快一慢两个指针确定整体搬移的起止位置。

在两者复杂度基本相同的情况下，我个人还是比较倾向于解法一不成环的方式的，因为该解法里沿用了链表算法中常用的两种思路：链表外新建节点和快慢指针组合，用起来得心应手。

不过以后关于链表的问题，也可以适当地考虑将原链表**成环**后进行操作。