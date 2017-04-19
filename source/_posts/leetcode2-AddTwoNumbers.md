title: leetcode2 Add Two Numbers

date: 2017/04/19 12:00:00

categories:

- Study

tags:

- leetcode
- linkedlist

---

## leetcode#2 Add Two Numbers

>You are given two **non-empty** linked lists representing two non-negative integers. The digits are stored in reverse order and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.
>
>You may assume the two numbers do not contain any leading zero, except the number 0 itself.
>
>**Input:** (2 -> 4 -> 5-> 2) + (5 -> 6 -> 4)
>**Output:** 7 -> 0 -> 0-> 3

##### 解释

给定两条非空的链表，用于代表两个非负的整数。整数以逆序的方式存储在链表中，链表的每一个节点的值都代表整数中的一个数字。要求将两条链表代表的整数相加，然后以链表的形式返回加和之后的整数。

假设两个整数的首位都不是0，除非其本身就是0。

例如：

输入：(2 -> 4 -> 5-> 2) + (5 -> 6 -> 4)

输出：7 -> 0 -> 0-> 3

##### 理解

解答本题的方式有很多，可以先将输入链表的各节点值存储到栈Stack中，然后再依次取出相加，也可以用递归的方式。

不过，把问题想简单一点，对于本题还是直观的方式比较简单：新创建一个输出链表，从头到尾遍历输入链表，每次取出一个节点的值用于相加，然后把结果**对10的余数**作为新链表的当前节点的值，**对10的商**则属于相加的进位，用于下一次遍历的相加，然后再将之前的节点和新生成的当前节点相连接，即将新节点加入输出链表中。

需要注意的一点是，也许在最后将两条输入链表都遍历完之后，**最后一次的加和结果出现进位**，所以需要在跳出循环之后，做一个**判断**的工作，如果加和的结果对10的商不等于0，则说明最后一步的遍历加和出现了进位，需要再生成一个新的节点加入输出链表。

##### 我的解法：

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
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode head = new ListNode(0);
        ListNode mov = head;
        int sum = 0;
        while(l1 != null || l2 != null) {
            if(l1 != null) { 
                sum += l1.val; 
                l1 = l1.next;
            }
            if(l2 != null) { 
                sum += l2.val; 
                l2 = l2.next;
            }
            ListNode newNode = new ListNode(sum % 10);
            mov.next = newNode;
            mov = newNode;
            sum = sum / 10;
        }
        if(sum != 0) {
            ListNode newNode = new ListNode(sum);
            mov.next = newNode;
        }
        return head.next;
    }
}
```

##### 大神解法：

基本也是这个思路。

其实本题的这种解法，是一种基础的解法，之后可以进行扩展，运用到很多更复杂的题中，比如`leetcode#445 Add Two Numbers II`中，只不过由于`leetcode#445`的特殊性，需要额外借助**栈Stack**这个数据结构。

```
public class Solution {
    public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        ListNode c1 = l1;
        ListNode c2 = l2;
        ListNode sentinel = new ListNode(0);
        ListNode d = sentinel;
        int sum = 0;
        while (c1 != null || c2 != null) {
            sum /= 10;
            if (c1 != null) {
                sum += c1.val;
                c1 = c1.next;
            }
            if (c2 != null) {
                sum += c2.val;
                c2 = c2.next;
            }
            d.next = new ListNode(sum % 10);
            d = d.next;
        }
        if (sum / 10 == 1)
            d.next = new ListNode(1);
        return sentinel.next;
    }
}
```

### 总结：

- 基础算法题虽然简单，但是积累基础算法题高效简练的解题方法，对于后续复杂题型的解答有很大的**启发和促进**作用；
- 复杂题型，通过分析，可以先将**流程**提取出来，看看是不是类似于之前做过的简单题型，如果是就可以尝试用简单题型的思路进行解答，毕竟是复杂题型，所以解答的过程中可以通过**额外使用数据结构**辅助解决该问题。