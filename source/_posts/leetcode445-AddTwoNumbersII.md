title: leetcode445 Add Two Numbers II

date: 2017/04/17 22:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- stack

---

## leetcode#445 Add Two Numbers II

>You are given two **non-empty** linked lists representing two non-negative integers. The most significant digit comes first and each of their nodes contain a single digit. Add the two numbers and return it as a linked list.
>
>You may assume the two numbers do not contain any leading zero, except the number 0 itself.
>
>**Follow up:**
>What if you cannot modify the input lists? In other words, reversing the lists is not allowed.
>
>**Example:**
>
>```
>Input: (7 -> 2 -> 4 -> 3) + (5 -> 6 -> 4)
>Output: 7 -> 8 -> 0 -> 7
>```

##### 解释：

给定两条非空单链表，每条链表都代表一个非负的整数，链表的每一个节点的值都表示整数中的一个数字。要求将两个整数相加，并一个单链表的形式返回结果。

假设两个整数的首位都不是0，除非其本身就是0。

限制不能使用单链表反转的方法解题。

##### 理解：

单链表，即只能向一个方向遍历链表的节点，如果限制不能使用单链表反转的方式解题，那么就需要另外考虑怎么先将链表所有节点的值**存储**起来，再一个一个的拿出来相加，然后生成一个新的链表节点，把相加后的值（0~9范围）放进去，最后把新的节点加到链表中，返回该新创建的链表。

##### 我的解法：

最初的解法，没有考虑到输入会超过整型变量的范围，最后在测试的时候出现了**溢出**。

```
public ListNode addTwoNumbers(ListNode l1, ListNode l2) {
        int num1 = 0;
        int num2 = 0;
        while(l1 != null) {
            num1 = num1 * 10 + l1.val;
            l1 = l1.next;
        }
        while(l2 != null) {
            num2 = num2 * 10 + l2.val;
            l2 = l2.next;
        }
        num1 = num1 + num2; // 会发生溢出
        if(num1 == 0) { return new ListNode(0); }
        ListNode head = new ListNode(0);
        head.next = null;
        while(num1 != 0.0) {
            head.val = num1 % 10;
            ListNode front = new ListNode(0);
            front.next = head;
            head = front;
            num1 = num1 / 10;
        }
        return head.next;
    }
```

##### 大神解法：

遍历链表，将链表节点的值存储在**栈Stack**中，然后一个一个地取出来相加，并取当前的和的**余数**作为当前节点的值，然后把该节点加入链表中，然后**求商**，所得的结果将于下一步取出的值进行相加。

最后注意一个特殊情况，栈Stack中取出**最后一个节点**，其值与上一步取商留下的数相加后，出现了**进位**的情况：这就要求在每一步都**提前生成一个节点**`head`，其值用于保存值`sum/10`，这样一来，就可以在最后一个节点取出并计算完之后，通过判断节点`head`是否是0，从而返回`head`还是`head.next`。

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
        Stack<Integer> numStack1 = new Stack<Integer>();
        Stack<Integer> numStack2 = new Stack<Integer>();

        while(l1 != null) {
            numStack1.push(l1.val);
            l1 = l1.next;
        }
        while(l2 != null) {
            numStack2.push(l2.val);
            l2 = l2.next;
        }
        int sum = 0;
        ListNode head = new ListNode(0);
        head.next = null;
        while(!numStack1.isEmpty() || !numStack2.isEmpty()) {
            if(!numStack1.isEmpty()) { sum += numStack1.pop(); }
            if(!numStack2.isEmpty()) { sum += numStack2.pop(); }
            head.val = sum % 10;
            ListNode point = new ListNode(sum / 10);
            point.next = head;
            head = point;
            sum = sum / 10;
        }
        return head.val == 0? head.next : head;
    }
}
```

### 总结：

- 考虑变量的范围和可能产生的溢出的情况；
- 栈Stack的使用；
- 虽然使用JAVA库的数据结构和方法，会降低程序的速度和运行效率，但是还是**不要吝惜**使用，除非能在短时间内想到更好的方法。