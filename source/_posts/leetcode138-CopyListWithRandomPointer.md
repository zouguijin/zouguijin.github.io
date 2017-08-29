title: leetcode138 Copy List With Random Pointer

date: 2017/08/29 10:00:00

categories:

- Study

tags:

- leetcode
- linkedlist
- hashmap
- deepcopy

---

##leetcode#138  Copy List With Random Pointer

>A linked list is given such that each node contains an additional random pointer which could point to any node in the list or null.
>
>Return a deep copy of the list.

#### 解释

给定的单链表中，每个节点不仅有简单的`next` 指针，还有一个指向随机的`random` 指针（可以指向任何节点或者`null`） 。现在需要对该链表进行**深拷贝（Deep Copy）** ，并返回深拷贝之后的链表。

#### 理解

简单来说，就是获取给定链表的一个深拷贝——不仅需要拷贝链表的值，同时需要拷贝链表的所有指针，包括`next`和`random` 。

链表的深拷贝，可以抽象为值的拷贝和节点关系的拷贝两个部分：

- 值的拷贝很简单，一个存储结构就可以解决；
- 节点关系的拷贝又分成两个部分：
  - `next` 指针，从头到尾，依次链接即可；
  - `random` 指针，难点就在这里，它是随机的，要么将这个关系**整体搬移**到新链表中，要么在`next` 指针完成处理之前处理它——因为在拷贝的时候，原链表与新链表之间是需要建立指针连接的，完成拷贝之后则需要断开之前建立的指针连接，`next` 指针有规律可循，所以放在最后断比较合适。

#### 我的解法

考虑整体搬移——先将原链表的完整关系存储在HashMap中，然后再将这些关系依次在新链表节点上创建。

```
/**
 * Definition for singly-linked list with a random pointer.
 * class RandomListNode {
 *     int label;
 *     RandomListNode next, random;
 *     RandomListNode(int x) { this.label = x; }
 * };
 */
public class Solution {
    public RandomListNode copyRandomList(RandomListNode head) {
        if(head == null) return null;
        Map<RandomListNode,RandomListNode> map = new HashMap<RandomListNode,RandomListNode>();
        // 先将原链表节点的值以新节点的形式，存储在HashMap中
        RandomListNode iter = head;
        while(iter != null) {
            map.put(iter,new RandomListNode(iter.label));
            iter = iter.next;
        }
        // 依次获取原链表的节点关系，然后赋予新链表的节点
        iter = head;
        while(iter != null) {
            map.get(iter).next = map.get(iter.next);
            map.get(iter).random = map.get(iter.random);
            iter = iter.next;
        }
        return map.get(head);
    }
}
```

#### 大神解法

该解法是最基础最原始的解法——没有利用高级的数据结构，完全是一步一步将原链表的值和节点关系搬移到新链表上的：

- 值的搬移，同时构建原链表与新链表之间的连接关系；
- `random` 指针关系的搬移，借助了之前构建的新旧链表之间的连接关系；
- `next` 指针关系的搬移，同时删去了新旧链表之间的连接关系，让两条链表各自独立。

认真阅读之后，可以说是非常Elegant了。

```
public RandomListNode copyRandomList(RandomListNode head) {
	RandomListNode iter = head, next;

	// First round: make copy of each node,
	// and link them together side-by-side in a single list.
	while (iter != null) {
		next = iter.next;

		RandomListNode copy = new RandomListNode(iter.label);
		iter.next = copy;
		copy.next = next;

		iter = next;
	}

	// Second round: assign random pointers for the copy nodes.
	iter = head;
	while (iter != null) {
		if (iter.random != null) {
			iter.next.random = iter.random.next;
		}
		iter = iter.next.next;
	}

	// Third round: restore the original list, and extract the copy list.
	iter = head;
	RandomListNode pseudoHead = new RandomListNode(0);
	RandomListNode copy, copyIter = pseudoHead;

	while (iter != null) {
		next = iter.next.next;

		// extract the copy
		copy = iter.next;
		copyIter.next = copy;
		copyIter = copy;

		// restore the original list
		iter.next = next;

		iter = next;
	}

	return pseudoHead.next;
}
```

