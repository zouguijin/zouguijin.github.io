title: leetcode148 Sort List

date: 2017/08/30 15:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- SortAlgorithms
- DivideConquerAlgorithm
- Recursion

---

## leetcode#148 Sort List

>Sort a linked list in *O*(*n* log *n*) time using constant space complexity.

#### 解释

在空间复杂度O(1)、时间复杂度O(nlogn)的情况下，对链表进行排序。

#### 理解

面对这道题的时候，排序算法已经忘得差不多了......虽然上一道题写的是直接排序和插入排序，但是面对本题时间空间复杂度的要求，明显不能用这两种算法。

查阅排序算法的资料后，有以下结论：

- 堆排序、快速排序、归并排序，时间复杂度都是O(nlogn)，空间复杂度依次是O(N)、O(1)、O(N)；
- 针对数组而言，归并排序的空间复杂度确实是O(N)，因为需要开辟O(N)的额外空间，用于有序数组的归并；
- 针对链表而言，不需要额外的O(N)空间，因为链表只需要改变`next` 指针的指向即可；
- 所以本题适合使用归并排序算法解决。

#### 我的解法

- 首先，递归将链表按照二分法的方式，切分成单个节点—— 使用快慢指针`slow`和`fast` ；
- 然后，由单个节点开始，进行归并——归并的内部没有使用递归的方式，只是简单的比较和修改指针指向；
- 最后，将归并的结果返回给上一层的递归，从而进行更大的归并。

看LeetCode很多人评价这种解法并不是空间复杂度O(1)的解法，原因在于：

- 递归本身需要存储关于递归的信息，不可能达到空间复杂度O(1)；
- 归并方法中： `ListNode faker = new ListNode(0);` 创建了新的节点。

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
    public ListNode sortList(ListNode head) {
        if(head == null || head.next == null) return head;
        
        ListNode pre = null;
        ListNode slow = head;
        ListNode fast = head;
        
        while(fast != null && fast.next != null) {
            pre = slow;
            slow = slow.next;
            fast = fast.next.next;
        }
        pre.next = null;
        // Recursion
        ListNode list1 = sortList(head);
        ListNode list2 = sortList(slow);
        // return the result of merge
        return merge(list1,list2);
    }
    
    public static ListNode merge(ListNode list1, ListNode list2) {
        ListNode faker = new ListNode(0);
        ListNode mov = faker;
        while(list1 != null && list2 != null) {
            if(list1.val <= list2.val) {
                mov.next = list1;
                list1 = list1.next;
            }
            else {
                mov.next = list2;
                list2 = list2.next;
            }
            mov = mov.next;
        }
        if(list1 == null) {
            mov.next = list2;
        }
        else {
            mov.next = list1;
        }
        return faker.next;
    }
    
}
```

#### 大神解法

递归的方法大同小异，这里介绍一个自底向上的非递归方法——据说真正达到了题目的要求（O(1)空间，O(nlogn)时间）。

**可我暂时没看懂？先贴上来慢慢看** 

```
public class Solution {
    ListNode dummyRes = new ListNode(0);
    public class MergeResult {
        ListNode head;
        ListNode tail;
        
        MergeResult(ListNode h, ListNode t) { head = h; tail = t;}
    } 
    
    public ListNode sortList(ListNode head) {
        if(head == null || head.next == null) return head;
        
        int length = length(head);
        
        ListNode dummy = new ListNode(0);
        dummy.next = head;
        MergeResult mr = new MergeResult(null, null);
        for(int step = 1; step < length; step <<= 1) {
            ListNode left = dummy.next;
            ListNode prev = dummy;
            while(left != null) {
                ListNode right = split(left, step);
                if(right == null) {
                    prev.next = left;
                    break;
                }
                ListNode next = split(right, step);
                merge(left, right, mr);
                prev.next = mr.head;
                prev = mr.tail;
                left = next;
            }
        }
        
        return dummy.next;
    }
    
    public ListNode split(ListNode head, int step) {
        while(head != null && step != 1) {
            head = head.next;
            step--;
        }
        if(head == null) return null;
        ListNode res = head.next;
        head.next = null;
        return res;
    }
    
    public int length(ListNode head) {
        int len = 0;
        while(head != null) {
            head = head.next;
            len++;
        }
        
        return len;
    }
    
    public void merge(ListNode head1, ListNode head2, MergeResult mr) {
        if(head2 == null) {
            mr.head = head1;
            mr.tail = null;
        }
        ListNode res = dummyRes;
        ListNode tail = res;
        while(head1 != null && head2 != null) {
            if(head1.val < head2.val) {
                tail.next = head1;
                head1 = head1.next;
            }else{
                tail.next = head2;
                head2 = head2.next;
            }
            tail = tail.next;
        }
        
        while(head1 != null) {
            tail.next = head1;
            head1 = head1.next;
            tail = tail.next;
        }
        
        while(head2 != null) {
            tail.next = head2;
            head2 = head2.next;
            tail = tail.next;
        }
        
        mr.head = res.next;
        mr.tail = tail;
    }
}
```

#### 总结

综上，可以发现，很多的排序算法在讨论复杂度的时候，往往都是针对数组，而且很多的排序算法都鼓励使用数组进行操作，而不是使用链表，可能是因为数组是效率最高的数据结构吧。