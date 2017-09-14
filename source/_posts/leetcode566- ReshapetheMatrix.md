title: leetcode566 Reshape the Matrix

date: 2017/09/14 11:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#566 Reshape the Matrix

>In MATLAB, there is a very useful function called 'reshape', which can reshape a matrix into a new one with different size but keep its original data.
>
>You're given a matrix represented by a two-dimensional array, and two **positive** integers **r** and **c** representing the **row** number and **column** number of the wanted reshaped matrix, respectively.
>
>The reshaped matrix need to be filled with all the elements of the original matrix in the same **row-traversing** order as they were.
>
>If the 'reshape' operation with given parameters is possible and legal, output the new reshaped matrix; Otherwise, output the original matrix.
>
>**Example 1:**
>
>```
>Input: 
>nums = 
>[[1,2],
> [3,4]]
>r = 1, c = 4
>Output: 
>[[1,2,3,4]]
>Explanation:
>The row-traversing of nums is [1,2,3,4]. The new reshaped matrix is a 1 * 4 matrix, fill it row by row by using the previous list.
>
>```
>
>**Example 2:**
>
>```
>Input: 
>nums = 
>[[1,2],
> [3,4]]
>r = 2, c = 4
>Output: 
>[[1,2],
> [3,4]]
>Explanation:
>There is no way to reshape a 2 * 2 matrix to a 2 * 4 matrix. So output the original matrix.
>
>```
>
>**Note:**
>
>1. The height and width of the given matrix is in range [1, 100].
>2. The given r and c are all positive.

#### 解释

MATLAB中的`reshape()` 方法可以在保留原有元素的同时，将矩阵转换成不同维度的新矩阵。

给定一个二维矩阵，以及两个大于零的整数r和c——分别表示希望通过转换获得的矩阵的行数与列数，要求转换完成之后获得的矩阵，顺序仍旧按照原矩阵的顺序（先行后列）。

如果转换的操作合法，那么就返回相应的新矩阵；否则，输出原矩阵。

- 矩阵的宽高范围为：[1,100]，所以肯定不为空；
- 给定的r与c都是正数。

#### 我的解法

首先，需要判断转换操作是否可以进行——原矩阵元素的数量是否等于新矩阵元素的数量；其次，基于给定的r与c，创建一个二维矩阵，然后依次遍历原矩阵，将元素依次放入新矩阵中。

```
class Solution {
    public int[][] matrixReshape(int[][] nums, int r, int c) {
        int originR = nums.length;
        int originC = nums[0].length;
        int[][] res;
        if(originR*originC != r*c) res = nums;
        else {
            res = new int[r][c];
            int tmpR = 0;
            int tmpC = 0;
            for(int i = 0; i < nums.length; i++) {
                for(int j = 0; j < nums[i].length; j++) {
                    res[tmpR][tmpC] = nums[i][j];
                    tmpC++;
                    if(tmpC >= c) {
                        tmpC = 0;
                        tmpR++;
                    }
                }
            }
        }
        return res;
    }
}
```

#### 大神解法

思路是一样的，不过处理的方式上比较有技巧：

- `i<r*c` 以所有元素为目标进行遍历；
- `res[i/c][i%c] = nums[i/m][i%m]` 进行赋值——由于是**先遍历完一行的所有列，再开始遍历下一行**，所以利用`i/c` 作为二维数组的行索引，`i%c` 作为数组的列索引，同理，`i/m` 作为原数组的行索引，`i%m` 作为原数组的列索引。

```
public int[][] matrixReshape(int[][] nums, int r, int c) {
    int n = nums.length, m = nums[0].length;
    if (r*c != n*m) return nums;
    int[][] res = new int[r][c];
    for (int i=0;i<r*c;i++) 
        res[i/c][i%c] = nums[i/m][i%m];
    return res;
}
```
