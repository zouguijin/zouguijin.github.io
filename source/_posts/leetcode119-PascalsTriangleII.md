title: leetcode119 Pascals Triangle II

date: 2017/09/08 15:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#119 Pascals Triangle II

>Given an index *k*, return the *k*th row of the Pascal's triangle.
>
>For example, given *k* = 3,
>Return `[1,3,3,1]`.
>
>**Note:**
>Could you optimize your algorithm to use only *O*(*k*) extra space?

#### 解释

给定一个索引值k，要求返回杨辉三角的第k行（假设从第0行开始计数，第0行为`[1]` ）。

是否能够将算法的空间复杂度控制在O(k)内？

#### 我的解法

利用**数组** ：

本题是leetcode118的变形，如果只要求返回第k行，那么就不需要维持一个二维数组，只需要维持一个前置数组即可。由于本题从第0行开始计数，第0行为`[1]` ，所以最后，前置数组将保存第`rowIndex` 行（程序中表示为`rowIndex+1` 行）的数据，然后再将数组中的数据依次添加进链表中。

```
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<Integer> list = new ArrayList<Integer>();
        
        int[] preArray = {0};
        for(int i = 1; i <= rowIndex+1; i++) {
            int[] layer = new int[i];
            layer[0] = 1;
            layer[i - 1] = 1;
            for(int j = 1; j < (i+1)/2; j++) {
                layer[j] = preArray[j] + preArray[j-1];
                layer[i-1-j] = layer[j];
            }
            preArray = layer;
        }
        for(int k = 0; k < rowIndex+1; k++) {
            list.add(preArray[k]);
        }
        return list;
    }
}
```

利用**链表** ：

每次向链表的末尾（有的解法是向链表的头部）添加一个`1` ，然后反方向将两个相邻元素相加，作为当前位置上的新元素，即在上一层数据构成的链表的本身进行修改。

```
class Solution {
    public List<Integer> getRow(int rowIndex) {
        List<Integer> list = new ArrayList<Integer>();
        if(rowIndex < 0) return list;
        
        for(int i = 1; i <= rowIndex + 1; i++) {
            list.add(i - 1, 1);
            for(int j = i - 2; j > 0; j--) {
                list.set(j, list.get(j) + list.get(j-1));
            }
        }
        return list;
    }
}
```

#### 大神解法

类似上述第二种算法，只不过从头部添加新的元素`1` 。

```
  public List<Integer> getRow(int rowIndex) {
	List<Integer> list = new ArrayList<Integer>();
	if (rowIndex < 0)
		return list;

	for (int i = 0; i < rowIndex + 1; i++) {
		list.add(0, 1);
		for (int j = 1; j < list.size() - 1; j++) {
			list.set(j, list.get(j) + list.get(j + 1));
		}
	}
	return list;
}
```

