title: Machine Learning - Basis

date: 2017/06/27 10:00:00

categories:

- Study

tags:

- MachineLearning

---

## Machine Learning 基础

### 0 Definition

- Task：要让机器完成的学习任务；
- Experience：经过学习之后，机器将会获得的经验；
- Performance：机器通过学习得到的经验，处理类似的任务时的性能表现。

### 1 Machine Learning Algorithms

#### 1.1 Supervised Learning（监督式学习）

将会给出一部分正确的答案，也称作样本集合（训练集合，Training Set），通过对现有的样本集合的学习和训练，形成一个合适的方法或函数，之后就可以根据生成的方法或函数预测其他的情况。

- Regression（回归问题），现实情况的样本集合一般都会是离散型的数据，回归就是需要根据离散型的数据，预测出连续的结果。
- Classification（分类问题），根据样本集合得到的概率分布，输出离散的结果。

监督式学习的基本过程：

```
Training Set -> Learning Algorithm -> h(hypothesis,假设/函数)
new input -> h -> estimated output(预测结果)
```

举个栗子：

**线性回归模型**

一个简单的线性回归预测问题，其中$\theta_0$和$\theta_1$是线性拟合直线的两个参数，$i$表示第i个数据，$x^{(i)}$表示第i个数据的输入值，$y^{(i)}$表示第i个数据的输出值，$h_{\theta}(x^{(i)})$表示第I个数据的预测值，为了让拟合的效果最好，即让${(h_\theta(x^{(i)})-y^{(i)})}^2$的结果最小：
$$
{minimize({\theta_0}{\theta_1})} {\ 1\over 2m} {\sum_{i=1}^m}{(h_\theta(x^{(i)})-y^{(i)})}^2
$$


令
$$
J(\theta_0,\theta_1) = {\ 1\over 2m} {\sum_{i=1}^m}{(h_\theta(x^{(i)})-y^{(i)})}^2
$$


则$J(\theta_0,\theta_1) $称为**代价函数（Cost Function）**，也成为平方误差代价函数（Square Error Cost Function）。

通过最小化代价函数（通过可视化，找到代价函数的图像的最低点），从而找到最佳的拟合函数。

**轮廓图（Contour plot）**，即等高线图。

**机器学习，就是需要研究出一种算法，自动地找到最小化代价函数。**而不是人工收集数据，然后将代价函数的曲线，例如轮廓图画出来，再从中寻找最小化的代价函数。

最小化代价函数的算法——**梯度下降算法（Gradient Descent）**

`repeat util convergence :`
$$
\theta_j := \theta_j - \alpha \frac{\partial}{\partial \theta_j} J(\theta_0, \theta_1)
$$

- 梯度下降法讲究“**同时（simultaneously）**”，即在计算$\theta_0$和$\theta_1$的时候，所用到的变量，都需要是本次计算之前的值（而不能先计算出了$\theta_0$，然后将其带入$\theta_1$的计算中）。

- $\alpha$表示梯度下降的速率，也称为**学习速率**，类似于下山的步子大小，与微分项一起，决定了我们以多快的频率更新$\theta_j$。

  如果学习速率太小，那么收敛的速度会过慢，反之，如果学习速率太大，可能会越过局部最优点或者全局最优点，造成收敛过程的波动，从而造成另一种收敛过慢。

- 微分部分$\ \frac{\partial}{\partial \theta_j} J(\theta_0, \theta_1)$，则可以动态地表示函数增长或减少的速率，结合$\alpha$可以动态地调整学习速率，即越接近极值点或局部最优点，学习速率会放慢步子变小，更为细致地接近最优点。

### 1.2 Linear Algebra: Matrix & Vector（线性代数：矩阵和向量） 

- Matrix（矩阵）

  矩阵的维数（Dimension）= 行数 $\times$ 列数
  $$
  A_{ij} = entry of, {i^{th}}row, j^{th}column
  $$
  一般使用大写字母表示矩阵。

- Vector（向量）——$n \times 1$的矩阵

  向量的维数 = n

  一般用小写字母表示向量。

- 矩阵与向量相乘
  $$
  A \times x = y
  $$
  $A$，是一个$m \times n$矩阵；$x$，是一个$n \times 1$向量；$y$，是一个$m \times 1$向量。

- 矩阵与矩阵相乘
  $$
  A \times B = C
  $$
  $A$，是一个$m \times n$矩阵；$B$，是一个$n \times o$矩阵；$C$，是一个$m \times o$矩阵。

- 矩阵运算律
  $$
  A \times B \neq B \times A
  $$

  $$
  (A \times B) \times C = A \times (B \times C)
  $$

  $$
  A_{m \times n} \times I_{n \times n} = I_{n \times n} \times A_{m \times n} = A_{m \times n}
  $$

- 矩阵的逆（Inverse）与转置（Tanspose）

  如果矩阵$A$是一个$m \times m$**方阵**，且**它有逆**，那么满足：
  $$
  A(A^{-1}) = A^{-1}A = I_{m \times m}
  $$
  没有逆的矩阵称为“**奇异矩阵**”或者“**退化矩阵**”。

  例如，以下矩阵就没有逆：
  $$
  A = [ \begin{array}{ccc}
  0 & 0 & 0 \\
  0 & 0 & 0 \\
  0 & 0 & 0 \\
  \end{array}]
  $$
  一个$m \times n$矩阵的转置，是一个$n \times m$矩阵，即：
  $$
  if \ B = A^T,\ then\  B_{ij} = A_{ji} 
  $$



#### 1.x Unsupervised Learning（非监督式学习）

- 聚类问题（Cluster），没有样本集合用于学习和训练，直接给定数据集，想方法找出其中蕴含的某种类型结构。

应用：数据中心集群协同工作、社交网络分析、市场用户习惯分类等。

- Others：Reinforcement Learning（强化学习）、Recommender System（推荐系统）

