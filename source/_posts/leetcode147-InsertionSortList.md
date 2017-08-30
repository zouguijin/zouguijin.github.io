title: leetcode147 Insertion Sort List

date: 2017/08/30 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- SortAlgorithms

---

## leetcode#147 Insertion Sort List 

>Sort a linked list using insertion sort.

#### 解释

题目说得很简单：使用**插入排序**的方式，对链表进行排序。

#### 理解

插入排序中，序列最初分为有序序列部分和无序序列部分，排序过程中的每一步都将从无序序列部分中取出元素，然后放入有序序列部分，形成新的有序序列部分，以此类推，直到整个序列都有序。

链表结构适合于节点的插入和删除，因此链表对于插入排序的操作来说还算是比较友好（相对于数组，数组的插入排序每次都需要将数组元素后移）。

需要注意的有以下几点：

- 节点的获取和插入位置，最好保有位置之前的一个节点位置的信息 ；
- 有序序列部分需要给定一个边界—— `head` 到 `end` ；
- 对于有序序列部分需要进行查找操作，可以使用二分法减少搜索量——快慢指针`fast`和`slow` ，确定有序序列部分的中间节点`midNode` 。

#### 我的解法

- 创建辅助节点`faker` ；
- 规定有序序列的边界—— 从`faker.next` 到`end` ；
- 如果`end.next` 节点的值小于边界节点`end` 的值，那么需要将其插入有序序列，否则简单地向后移动边界节点`end` ；
- 对有序序列的查找搜索采用的是从头到尾的方式，没有使用二分法；
- 为了方便，都是采用当前节点的`next` 的方式访问需要移动和插入的节点位置，插入完成后即跳出循环。 

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
    public ListNode insertionSortList(ListNode head) {
        if(head == null || head.next == null) return head;
        
        ListNode faker = new ListNode(0);
        faker.next = head;
        ListNode end = head;
        while(end.next != null) {
            if(end.val > end.next.val) {
                int sortVal = end.next.val;
                ListNode mov = faker;
                while(mov != end) {
                    if(mov.next.val > sortVal) {
                        ListNode tmp = end.next;
                        end.next = tmp.next;
                        tmp.next = mov.next;
                        mov.next = tmp;
                        break;
                    }
                    else {
                        mov = mov.next;
                    }
                }
            }
            else {
                end = end.next;
            }
        }
        return faker.next;
    }
}
```

顺便还写了一个**直接排序**的解法：

直接排序，也分为有序序列部分和无序序列部分，排序的过程中，每次都遍历无序序列部分，找出最小值对应的节点，然后将该节点插入到有序序列部分的尾部。

```
class Solution {
    public ListNode insertionSortList(ListNode head) {
        if(head == null || head.next == null) return head;
        
        ListNode faker = new ListNode(0);
        faker.next = head;
        ListNode mark = faker;
        while(mark.next != null) {
            ListNode mov = mark.next;
            if(mov.next == null) {
                break;
            }
            int minVal = mov.val;
            ListNode minNode = mov;
            ListNode minPreNode = mark;
            while(mov.next != null) {
                if(mov.next.val < minVal) {
                    minVal = mov.next.val;
                    minNode = mov.next;
                    minPreNode = mov;
                }
                mov = mov.next;
            }
            minPreNode.next = minNode.next;
            minNode.next = mark.next;
            mark.next = minNode;
            
            mark = mark.next;
        }
        return faker.next;
    }
}
```

#### 大神解法

思想类似，不过他在插入节点的时候是循环移动，最后再跳出来插入节点。

```
public ListNode insertionSortList(ListNode head) {
		if( head == null ){
			return head;
		}
		
		ListNode helper = new ListNode(0); //new starter of the sorted list
		ListNode cur = head; //the node will be inserted
		ListNode pre = helper; //insert node between pre and pre.next
		ListNode next = null; //the next node will be inserted
		//not the end of input list
		while( cur != null ){
			next = cur.next;
			//find the right place to insert
			while( pre.next != null && pre.next.val < cur.val ){
				pre = pre.next;
			}
			//insert between pre and pre.next
			cur.next = pre.next;
			pre.next = cur;
			pre = helper;
			cur = next;
		}
		
		return helper.next;
	}
```

#### 总结

自己写的插入排序和直接排序的Runtime比较：前者是91.6%，后者是4%，虽然可能是我实现方式上的问题造成了效率的大不同，但是大概率还是因为插入排序相对于直接排序确实要高效。

BTW，有这么一句话：

>For God's sake, don't try sorting a linked list during the interview

意思就是：

>So it might be better to actually copy the values into an array and sort them there.
>
>相对于链表排序来说，更合适的方式为：将链表的值拷贝到数组中，并在数组结构中对其进行排序，最后在拷贝回去。

需要思考！也许原因是，数组是效率最高的数据结构？有更好的但适合用于数组的排序方式？