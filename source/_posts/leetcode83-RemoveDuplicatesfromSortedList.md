title: leetcode83  Remove Duplicates from Sorted List & VS leetcode#21

date: 2017/03/30 10:30:00

catergories:

- Study

tags:

- leetcode
- linkedlist
- array
- recursive algorithm

---

## leetcode#83  Remove Duplicates from Sorted List

> Given a sorted linked list, delete all duplicates such that each element appear only *once*.
>
> For example,
> Given `1->1->2`, return `1->2`.
> Given `1->1->2->3->3`, return `1->2->3`.

##### 解释：

给定一个**排好序**的链表，要求删除链表中**重复**的元素，以达到链表中的元素只出现一次。

##### 理解：

由于链表已经排好序了（假设从左往右依次增大），所以只需要比较一下相邻元素的大小即可，如果符合大小排序，只需要移动标记指针（用于标记哪些元素被选进了新的链表中）即可，如果出现相邻元素相等（在排好序的链表里，只能出现这种情况了），则只移动遍历指针（用于遍历所有的元素）而不移动标记指针，直到出现符合排序的情况，再将标记指针指向该元素，从而将该元素加入链表。

##### 我的解法（递归方式）：

首先是边界判断（每一个程序都需要做的一步）；其次是循环和递归。

我的解法中，**递归是镶嵌在循环过程的条件之中**的，也就是通过了条件的判断才能进行递归，确保了每一次递归的准确性、精准性。

从另外一个角度来说，我在解题的时候，其实是想**从头到尾依次遍历**每一个元素，然后将符合条件的元素**依次摘取**出来，放到列表之中，所以出现了一个循环和条件判断的操作。

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
        /*边界判断*/
        if(head == null) {return null;}
        if(head.next == null) {return head;}
        /*循环找到不相等的元素，再使用递归将该元素作为当前节点.next，之后需要一个递归终结条件，即 break，以免从最后递归回来的时候，链表又再次向后遍历（无限循环）*/
        ListNode newHead = head;
        while(newHead.next != null) {
            if(newHead.next.val > newHead.val) {
                head.next = deleteDuplicates(head.next);
                break;
            }
            else{
                newHead = newHead.next;
            }
        }
        return newHead;
    }
}
```

##### 大神解法（递归方式）：

很简洁的语言表达，第一行边界判断，第二行执行递归，第三行根据元素值的比较结果选择或返回当前节点的下一个节点或返回当前节点本身。

该解法的递归的过程中没有做任何的比较判断，**直接一次递归到最后一个元素**，然后**从最后一个元素递归返回**的过程中再一个一个进行比较：最后一个节点肯定会返回自己本身，之前的节点如果相等，则返回其身后的节点，如果不相等则返回当前节点，这样就实现了**从后到前递归联结而成的链表**了。

```
public ListNode deleteDuplicates(ListNode head) {
        if(head == null || head.next == null)return head;
        head.next = deleteDuplicates(head.next);
        return head.val == head.next.val ? head.next : head;
}
```

##### 总结：

采用递归方式解题，如果条件允许，尽量不要将递归嵌套在循环或者条件等结构体中，一次性递归到最后一个元素，递归返回的时候再进行条件的判断等步骤。

链表的问题是一条链，如果涉及到树的的问题，有很多个树杈可能就会先判断再进入递归。

---

### **比较**：

数组中也有这么一道删除有序数组中重复元素的题

> leetcode#21 Remove Duplicates from Sorted Array
>
> Given a sorted array, remove the duplicates in place such that each element appear only *once* and return the new length.
>
> Do not allocate extra space for another array, you must do this in place with constant memory.
>
> For example,
> Given input array *nums* = `[1,1,2]`,
>
> Your function should return length = `2`, with the first two elements of *nums* being `1` and `2` respectively. It doesn't matter what you leave beyond the new length.

##### 解释：

给定一个**排好序**的数组，将数组中重复的元素删除，并且返回**新数组的长度**。

**不能额外地申请新的空间**。只需要返回新数组的长度，不管该长度之后是不是还有其他的元素。

##### 理解：

（1）排好序，意味着只有可能出现两种大小情况——前者小于后者（无重复，不动），前者等于后者（出现重复，需要删除后者）；

（2）不能额外申请空间，即只能在原数组上进行删除或者移动；

（3）返回新数组的长度，即只需要有一个标记指针指到新数组的末尾即可，不需要管后续还有其他几个元素。

##### 我的解法：

既然不能申请额外空间，那么只能在比较相邻元素遇到重复的时候，将数组的后半部分整体往前搬移一个元素的位置，将重复的元素覆盖，即采用了JAVA的数组复制方法`arraycopy()` ，让数组本身复制自己。这个方法的关键在于，要精确地计算应该将后续的多少个元素，移到前面的哪个位置，比较麻烦也比较容易出错。

```
public class Solution {
    public int removeDuplicates(int[] nums){
        if(nums.length == 0){
            return 0;
        }
        else{
            int deleteNum = 0;
            int currentP = 0;
            while(deleteNum + currentP != nums.length-1){
                if (nums[currentP] == nums[currentP + 1]){
                    System.arraycopy(nums, currentP + 2, nums, currentP + 1, nums.length - (currentP + 2));
                    deleteNum++;
                }
                else{
                    currentP++;
                }
            }
            return currentP+1;
        }
    }
}
```

##### 大神解法：

很简洁，第一行判断边界，然后一个`for` 循环，嵌套着条件判断语句：依次提出数组中的元素，与当前标记指针所指的元素比较，如果相等则不移动标记指针，若大于标记指针所指的元素，则将取出的元素加入标记指针所指位置，并将标记指针后移一位（因为是要返回数组长度=数组元素最大序号+1）。对于数组元素第一位，即`arr[0]` 采用直接覆盖。

可以看到，这种方法是**从头开始覆盖数组元素**，然后把符合条件的元素**摘取**出来，放到标记指针所指的位置。

```
public int removeDuplicates(int[] nums) {
    int i = 0;
    for (int n : nums)
        if (i == 0 || n > nums[i-1])
            nums[i++] = n;
    return i;
}
```

---

### **链表VS数组**

链表（特指题目所定义的链表结构），其结构需要之前有`next`指针相互关联，而数组则只需要用序号下标表示即可。

所以链表无法用一个**循环**做到“摘取一个元素，放到当前元素之后”，因为当前的标记指针在循环里是不会类似于下标序号一样+1+1发生变化的，所以最好采用递归的方式，**从后往前**依次将元素添加到**某一次递归过程的标记指针**的`next`位置，然后**返回的结果作为一个整体**，再添加到上一级递归过程的标记指针的`next`指针位置，依次进行直到首位。

---

By ZGJ.