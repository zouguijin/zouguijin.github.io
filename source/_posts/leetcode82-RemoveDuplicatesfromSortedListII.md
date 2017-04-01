title: leetcode82 Remove Duplicates from Sorted List II

date: 2017/04/01 10:00:00

catergories:

- Study

tags:

- leetcode
- recursive algorithm
- linkedlist

---

## leetcode#82 Remove Duplicates from Sorted List II

>Given a sorted linked list, delete all nodes that have duplicate numbers, leaving only *distinct* numbers from the original list.
>
>For example,
>Given `1->2->3->3->4->4->5`, return `1->2->5`.
>Given `1->1->1->2->3`, return `2->3`.

##### 解释：

给定一个**排好序**的链表，要求将链表中的重复元素**全都删除**，只留下不重复的元素。

##### 理解：

本题与`leetcode#83` 都是针对有序链表删除重复元素，但是本题的要求稍微高一点，即不仅仅是删除重复多出的部分，而且不能留下出现了重复的元素。这样一来，就不能像`leetcode#83` 的三行解法一样，直接遍历到链表末尾再递归返回了，而需要将递归操作嵌套在一个**`while` 循环**的条件判断中，而且每一次的比较都需要至少涉及**相邻的三个元素**，以避免漏删重复元素，比如`3-4-4`的情况。

##### 我的解法：

同样，首先是边界的判断。

然后每一次的递归都会给出两个局部变量`tmpMove` 和`tmpFix` ，分别用于**遍历**链表元素和**暂时性地标记**下一个不同的元素（因为重复之后可能还会出现重复，虽然两个重复之间是不同的，但不应该直接移动`head` ，比如`1,1,1,2,2,2` ，虽然`1 2`是不同的，但是这两者都是重复的，此时都不应该将`1 2` 加入到新链表中），只有当；

同时还有一个标志变量`flag` ，用于标志**是否进行了递归赋值**（若没有进行递归赋值&&`tmpMove = null`跳出循环，则说明从上一个不同的元素开始，之后的元素全都是重复的，所以返回一个`null`即可）。

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
    public ListNode deleteDuplicates(ListNode head) {
        if(head == null || head.next == null) return head;
        ListNode tmpMove = head;
        ListNode tmpFix = head;
        int flag = 0; // 用于标识区分是否进到了递归赋值的那一步
        while(tmpMove != null){
            if(tmpFix.next == null) { return tmpFix; } 
            // 如果是最后一个元素且不同于前面的元素，则将其加入新链表
            if(tmpMove.val == tmpFix.val) { tmpMove = tmpMove.next; }            
            else if(tmpFix.val == tmpFix.next.val) { tmpFix = tmpMove; }
            else {  
                    head = tmpFix;
                    head.next = deleteDuplicates(head.next);
                    flag = 1;
                    break;
            }
        }
        if(flag == 1) { return head; }
        else { return null; }
    }
}
```

##### 大神解法：

同样将递归过程嵌套在了循环和条件中，不同的是：

- 没有比较相邻的三个元素
- 一出现不同就直接进行递归
- 对于`2,3,3,3` 这种3与2不同，但是3是重复元素的情况，将3排除的做法是：一直循环寻找下一个与3不相同的元素，找到后跳出循环**`return deleteDuplicates(head.next);` **

```
public ListNode deleteDuplicates(ListNode head) {
    if (head == null) return null; 
    
    if (head.next != null && head.val == head.next.val) {
        while (head.next != null && head.val == head.next.val) {
            head = head.next;
        }
        return deleteDuplicates(head.next);
    } else {
        head.next = deleteDuplicates(head.next);
    }
    return head;
}
```

---

### 总结：

**`return deleteDuplicates(head.next);`** 

直接返回下一个元素的递归结果，一来可以避免链表开头就出现的重复元素，二来可以在遇到`3,4,4,4` 情况的时候，跳过重复的元素4，返回4之后的不同元素或者`null` 。