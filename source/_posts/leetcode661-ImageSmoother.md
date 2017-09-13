title: leetcode661 Image Smoother

date: 2017/09/12 10:00:00

categories:

- Study

tags:

- leetcode
- array

---

## leetcode#661 Image Smoother

>Given a 2D integer matrix M representing the gray scale of an image, you need to design a smoother to make the gray scale of each cell becomes the average gray scale (rounding down) of all the 8 surrounding cells and itself. If a cell has less than 8 surrounding cells, then use as many as you can.
>
>**Example 1:**
>
>```
>Input:
>[[1,1,1],
> [1,0,1],
> [1,1,1]]
>Output:
>[[0, 0, 0],
> [0, 0, 0],
> [0, 0, 0]]
>Explanation:
>For the point (0,0), (0,2), (2,0), (2,2): floor(3/4) = floor(0.75) = 0
>For the point (0,1), (1,0), (1,2), (2,1): floor(5/6) = floor(0.83333333) = 0
>For the point (1,1): floor(8/9) = floor(0.88888889) = 0
>
>```
>
>**Note:**
>
>1. The value in the given matrix is in the range of [0, 255].
>2. The length and width of the given matrix are in the range of [1, 150].

#### 解释

给定一个二维整数矩阵M，用于表示图像的灰度，要求编写程序，计算每一个cell（数组元素值）的平均灰度，计算方法是：将围绕该点（相邻）的其他元素值以及自己本身的值加起来，然后求平均，然后舍去小数部分。

假设：

- 元素值大小范围：[0,255]；
- 矩阵的长度和宽度范围：[1,150]。

#### 我的解法

本题考察点在于**二维数组的边界**，很直白，只要判定好边界，保证不越界，就可以加和在一起，连带的计数值也需要累加，最后将累加值除以计数值，得到平均数，放在结果数组的ij位置即可。

#### 大神解法

思路是一致的。巧妙的地方在于，利用了一个计数值`count` 这样可以避免很多的条件判断语句。

```
public int[][] imageSmoother(int[][] M) {
        int[][] res = new int[M.length][M[0].length];
        int count = 0;
        int sum = 0;
        for(int i = 0 ; i < M.length ; i++){
            
            for(int j = 0 ; j < M[0].length ; j++){
                sum =M[i][j];
                count=1;
                // 除了第一行之外的情况——一个点的上、右上、左上的元素值
                if(i-1>=0){
                    sum+=M[i-1][j];
                    count++;
                    if(j-1>=0){
                        sum+=M[i-1][j-1];
                        count++;
                    } 
                    if(j+1<M[0].length){
                        sum+=M[i-1][j+1];
                        count++;  
                    }
                }
            	// 除了最后一列的情况——这里包含了 i = 0 的情况——一个点的右上角元素值
                if(j+1<M[0].length){
                    sum+=M[i][j+1];
                    count++;
                }
                // 除了第一列之外的情况——一个点的左、左下的情况
                if(j-1>=0){
                    sum+=M[i][j-1];
                    count++;
                    if(i+1<M.length){
                        sum+=M[i+1][j-1];
                        count++;
                    }
                }
				// 除了最后一行的情况——一个点的下、右下的情况                
                if(i+1<M.length){
                    sum+=M[i+1][j];
                    count++;
                    
                    if(j+1<M[0].length){
                        sum+=M[i+1][j+1];
                        count++;
                    }
                }
                res[i][j] = (int)Math.floor(sum/count);
            }
        }
        
        return res;
    }
```
