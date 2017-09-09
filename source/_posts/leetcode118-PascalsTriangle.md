title: leetcode118 Pascal's Triangle

date: 2017/09/08 10:00:00

categories:

- Study

tags:

- leetcode
- array
- DynamicProgramming

---

## leetcode#118 Pascal's Triangle

>Given *numRows*, generate the first *numRows* of Pascal's triangle.
>
>For example, given *numRows* = 5,
>Return
>
>```
>[
>     [1],
>    [1,1],
>   [1,2,1],
>  [1,3,3,1],
> [1,4,6,4,1]
>]
>```

#### 解释

Pascal's Triangle，帕斯卡三角形，又称杨辉三角。

给定一个整数，要求返回**以该整数作为三角形层数**的杨辉三角。

#### 我的解法

虽然题目要求返回一个以链表作为对象的链表容器，但是仍然可以将其转换为数组问题——利用数组索引查询的便利性，可以很容易（其实我还是想了一会......）地构造出一个二维数组，然后再将二维数组转换成链表，返回即可。

接下来，分析一下杨辉三角，可以看到：

- 第 i 层，有 i 个元素；
- 每一层的元素值都是对称分布的，且首尾两个元素值一直都是1；
- 除了首尾两个元素值外，每一层的第 j 个元素值都等于上一层的第 j 个元素值加上第 (j-1) 个元素值（如果有的话）。

所以，只要在计算第 i 层数组的时候，保留有上一层的数组，就可以通过数组索引查找的方式，很简单地完成新数组元素的计算和填充。每完成一层数组的填充，就可以将其放入全局的二维数组中。最后再将二维数组转换成链表即可。

时间复杂度为O(N2)，1ms。

```
class Solution {
    public List<List<Integer>> generate(int numRows) {
        List<List<Integer>> pascal = new ArrayList<List<Integer>>();
        int[][] pascalArray = new int[numRows][];
        if(numRows == 0) return pascal;
        else {
            int[] preArray = {0};
            for(int i = 1; i <= numRows; i++) {
                int[] layer = new int[i];
                layer[0] = 1;
                layer[i - 1] = 1;
                for(int j = 1; j < (i+1)/2; j++) { // 每次求一半即可，另一半是对称的
                    layer[j] = preArray[j - 1] + preArray[j];
                    layer[i-1-j] = layer[j];
                }
                preArray = layer;
                pascalArray[i- 1] = layer;
            }
            // List list = Arrays.asList(pascalArray);
            // 很神奇，需要强制转换成List，再赋值给pascal才不会有误
            pascal = (List)Arrays.asList(pascalArray);
            return pascal;
        }
    }
}
```

#### 大神解法

使用**子链表+动态规划**。

解题思想都是一样的，但是由于无法像数组一样快速地通过索引定位元素值，所以需要对子链表的所有节点进行赋值（即使存在对称）。

优点是，每完成一个子链表，就可以直接作为对象加入最终的链表容器（也算作是动态规划吧），省去了数组转链表的一个操作。

```
public class Solution {
	public List<List<Integer>> generate(int numRows) {
		List<List<Integer>> res = new ArrayList<List<Integer>>();
		List<Integer> row, pre = null;
		for (int i = 0; i < numRows; ++i) {
			row = new ArrayList<Integer>();
			for (int j = 0; j <= i; ++j)
				if (j == 0 || j == i)
					row.add(1);
				else
					row.add(pre.get(j - 1) + pre.get(j));
			pre = row;
			res.add(row);
		}
		return res;
	}
}
```

#### 总结

本题还是比较灵活的，既可以使用数组的方式解决，也可以使用链表。而且在使用数组的时候，对**数组索引灵活运用**的考察还是比较关注的。