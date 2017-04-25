title: leetcode25 Reverse Nodes in k-Group

date: 2017/04/25 18:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- reverse

---

## leetcode#25 Reverse Nodes in k-Group

>Given a linked list, reverse the nodes of a linked list *k* at a time and return its modified list.
>
>*k* is a positive integer and is less than or equal to the length of the linked list. If the number of nodes is not a multiple of *k* then left-out nodes in the end should remain as it is.
>
>You may not alter the values in the nodes, only nodes itself may be changed.
>
>Only constant memory is allowed.
>
>For example,
>Given this linked list: `1->2->3->4->5`
>
>For *k* = 2, you should return: `2->1->4->3->5`
>
>For *k* = 3, you should return: `3->2->1->4->5`

##### 解释

给定一个单链表，要求**每k个节点为一组**进行逆序，返回处理之后的链表。

k是一个正整数，且其大小小于或者等于链表的长度。如果余下的节点数不足k，则需要保留这部分节点原来的顺序。

同样，要求不能改变节点的值，只能改变节点的位置；空间复杂度要求constant space。

例如：

输入：1->2->3->4->5

若k = 2，返回：2->1->4->3->5

若k = 3，返回：3->2->1->4->5

##### 理解

基本的处理思想与**leetcode#24**的解法相同，即每k个节点为一组进行移动，并在最后对链表进行反转。

但是，有几个问题需要注意：

- 在leetcode#24中，只要求k = 2，即不管剩下一个还是两个节点，都可以对处理后的链表直接反转，但是当k > 2时，情况就不一样了，因为剩余的**不足k个节点的部分需要保持原有的顺序**，所以需要将满足k个节点一组的部分与不足k个一组的部分区分开来，前者执行链表反转之后，再将剩余不足k个节点的部分**附加**到反转之后的链表末尾；
- 每次都是以k个节点为一组进行移动，所以只需要**两个指针**，其中一个指针指向这一组的起始节点，另一个指针指向这一组的末尾节点；
- 为了将满足k个一组的部分与不足k个一组的部分区分开来，考虑使用一个**链表外新创建的节点**`faker`，每凑够k个一组就将该组作为一个整体插入到`faker`之后，之后只对`faker`之后的链表进行反转。

##### 我的解法

我的算法基于上述的理解：

每次数出k个节点作为一组，确定该组的起始与终止位置，把这一组节点插入到`faker`之后，当遇到不足k个节点的时候，跳出两层循环，先对`faker`之后的链表片段进行反转，最后再将不足k个节点的部分附加到链表片段反转之后的末尾。

本解法对链表只进行了一次遍历，所以时间复杂度是`O(n)`（leetcode测试8ms）；没有使用额外的空间，也没有使用递归，所示空间复杂度近似于`O(1)`（为什么是近似？因为考虑到新创建了一个节点）；同时逆序的操作**复用**了之前就已经写过的链表反转的代码。

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
    public ListNode reverseKGroup(ListNode head, int k) {
        if(head == null || head.next == null) { return head; }

        ListNode begin = head;
        ListNode end = head;
        ListNode faker = new ListNode(0);
        faker.next = null;
        boolean flag = true;
        while(end != null) {
            int i = 1;
            while(i < k) {
                if(end.next != null) {
                    end = end.next;
                    i++;
                }
                else {
                    flag = false;
                    break;
                }
            }
            if(flag) {
                ListNode next = end.next;
                end.next = faker.next;
                faker.next = begin;
                begin = next;
                end = next;
            }
            else {
                break;
            }
        }
        if(faker.next == null) { return head; }
        else {
            ListNode tail = faker.next;
            faker.next = reverseList(faker.next);
            tail.next = begin;
            return faker.next;
        }
    }

    public ListNode reverseList(ListNode head) {
        if(head == null || head.next == null) { return head; }
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

解法一（递归）

虽然递归不满足本题的条件——constant space，但是递归的解法往往都非常的简洁，特别是应对复杂问题的时候。

同样，以k个节点为一组进行递归操作，如果真的有k个节点为一组，则将**k个节点一组的下一个节点**作为参数传入下一层的递归，递归返回的时候，以计数器`count`的递减与0的比较作为循环条件，**三个指针**`curr`、`head`和`tmp`依次递进，交换所指的节点。

```
public ListNode reverseKGroup(ListNode head, int k) {
    ListNode curr = head;
    int count = 0;
    while (curr != null && count != k) { // find the k+1 node
        curr = curr.next;
        count++;
    }
    if (count == k) { // if k+1 node is found
        curr = reverseKGroup(curr, k); // reverse list with k+1 node as head
        // head - head-pointer to direct part, 
        // curr - head-pointer to reversed part;
        while (count-- > 0) { // reverse current k-group: 
            ListNode tmp = head.next; // tmp - next head in direct part
            head.next = curr; // preappending "direct" head to the reversed list 
            curr = head; // move head of reversed part to a new node
            head = tmp; // move "direct" head to the next node in direct part
        }
        head = curr;
    }
    return head;
}
```

解法二（非递归）

该非递归的方法同样也**创建了一个链表之外的节点**`dummyhead`，同样也是只对链表进行了一次遍历，k个一组为单位进行操作，逆序的方法与解法一相同：都是使用了**三个指针**，依次指向三个相邻的节点，然后交换他们的位置，最后再平移一个节点的位置。

```
public ListNode reverseKGroup(ListNode head, int k) {
    ListNode begin;
    if (head==null || head.next ==null || k==1)
    	return head;
    ListNode dummyhead = new ListNode(-1);
    dummyhead.next = head;
    begin = dummyhead;
    int i=0;
    while (head != null){
    	i++;
    	if (i%k == 0){
    		begin = reverse(begin, head.next);
    		head = begin.next;
    	} else {
    		head = head.next;
    	}
    }
    return dummyhead.next;
    
}

public ListNode reverse(ListNode begin, ListNode end){
	ListNode curr = begin.next;
	ListNode next, first;
	ListNode prev = begin;
	first = curr;
	while (curr!=end){
		next = curr.next;
		curr.next = prev;
		prev = curr;
		curr = next;
	}
	begin.next = prev;
	first.next = curr;
	return first;
}
```

### 总结

- 递归可以极大地减少针对复杂问题解法的代码量；
- 涉及到链表头结点的改变，常常新创建链表之外的一个节点`faker`/`dummy`；
- 复杂建立在基础之上，在解决一个问题的时候，要多多想想：是否解决该问题的方法，可以有更广阔的应用空间？是不是可以普适化？是不是可以提供更大的扩展性？是不是可以复用以前就已经有的方法代码？这样一来，可以写出扩展性更好的代码，减少以后重复造轮子或者从头思考解决方法的过程。