title: Java---String

date: 2017/05/21 12:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java String——字符串

### 1 String对象是不可变的（常量）

String对象具有只读特性，可以给一个String对象添加任意多的别名（也即引用），引用不能改变String对象本身的值。

不可变性，在字符串连接的操作过程中，会涉及到效率的问题。

如果单纯地使用Java重载的运算符“+”和“+=”，对字符串进行连接的操作，那么每一次连接之后都会新生成一个String对象，再获得最终连接结果之前会一直占据着内存空间，直到获得最终的字符串连接结果之后，中间生成的String对象都需要回收，影响回收的效率和资源。

所以，涉及到字符串连接的问题时，一般会采用**StringBuilder**的方式，生成一个StringBuilder对象，通过**StringBuilder.append()**方法，将需要连接的字符串全部连接到该StringBuilder对象上，最后输出的时候利用**StringBuilder.toString()**将StringBuilder对象转换成String对象即可。

使用StringBuilder创建一个StringBuilder对象，默认初始容量是16个字节，当然也可以**自定义容量**。只要加入的字符串长度没有超过StringBuilder的容量，就无需分配新的的内部缓冲区，否则StringBuilder的容量就会自动增大，即分配新的内部缓冲区。

### 2 String类的常用操作

对于String对象的操作，如果没有改变String对象的内容，那么只是生成了一个新的引用指向原字符串对象；若改变了String对象的内容，则会创建一个新的String对象。

|                    方法                    |                    用法                    |
| :--------------------------------------: | :--------------------------------------: |
|                 length()                 |                 获取字符串长度                  |
|              charAt(int i)               |       获取字符串相应位置的字符，范围是0~length()-1       |
|             equals(String s)             |            两个字符串比较是否相同，考虑大小写             |
|        equalsIgnoreCase(String s)        |            两个字符串比较是否相同，不考虑大小写            |
|           compareTo(String s)            | 两个字符串按照字典顺序比较大小，考虑大小写，实际上就是**依次比较**两个字符串对应位置商字符的ASCII码：调用对象字符的ASCII码 - 参数字符的ASCII码，最后返回一个数值（正数 负数 零） |
| subString(int s)/subString(int s,int e)  | 获取字符串的子串，范围是0~length()-1：（1）截取从s到字符串末尾的子串；（2）截取从s到(e-1)的子串 |
|              toUpperCase()               |              将字符串里的所有字符变成大写              |
|              toLowerCase()               |              将字符串里的所有字符变成小写              |
| String.valueOf(xxx)/Number.valueOf(String s) | （1）将xxx转换成String对象；（2）将String对象转换成特定的基本数据包装类的对象，比如Integer/Double/Byte等 |

### 3 格式化的输出方式

格式化风格的输出方式，便于在输出的时候控制字符之间的间距，将内容打印出表格形式的样子。

#### （1）C语言风格的printf()方法

由于C语言没有对字符串重载连接符“+”和“+=”，所以需要使用特殊的占位符——**格式化说明符**来表示将来需要填入数据的位置。

例如：`printf("The match is between %s and %s, and the result is: %d : %d.\n", team1, team2, team1Score, team2Score)`

其中，`%x`表示特定的类型数据，之后的变量将会按照顺序填入之前确定好的位置之中。

#### （2）System.out.format()方法

该方法可以用于PrintStream或者PrintWriter对象，与**System.out.printf()**的用法是一样的。

#### （3）Formatter类

即`java.util.Formatter`类，当创建一个Formatter对象的时候，需要向Formatter的构造器传递参数，告诉最终的结果将会**输出**到哪里：`new Formatter(System.out)`,这样在该类里，`Formatter.format()`方法的输出，将会自然而然地输出到`System.out`，就跟普通的打印到控制台一样。

经过重载的Formatter类的构造器可以接受多种输出目的地，常用的是System.out  PrintStream  OutputStream  File 。

#### （4）格式化说明符

`%[-] <距离> <类型转换字符> [%<距离> <类型转换字符>] ......\n`

默认情况下，数据的输出是右对齐的，若要实现左对齐，需要在格式化说明符的最前面加上`-`标志。

**类型转换字符**

`格式化说明符 = %<距离> <类型转换字符> `

类型转换字符，可以将输入的参数转换成相应的类型数据，并输出。**转换需要符合类型转换的规则**。

`Formatter.format("%s\n",'d');`，意思就是将字符d转换成字符串。

| **d** |  **整数（十进制）**  | **c** | **Unicode字符（其实就是char类型）** |
| :---: | :-----------: | :---: | :-----------------------: |
| **s** |  **String**   | **x** |       **整数（十六进制）**        |
| **b** | **Boolean值**  | **h** |       **散列码（十六进制）**       |
| **f** | **浮点数（十进制）**  | **%** |         **字符 %**          |
| **e** | **浮点数（科学计数）** |       |                           |

`String.format() `是一个静态方法，使用方法和`Formatter.format()`一样，只不过输出的是String对象。

### 4 正则表达式与String类

正则表达式可以用于解决各种**字符串处理**相关的问题，包括匹配、选择、编辑以及验证等等。

关于正则表达式，将会有另一篇文章介绍。[正则表达式]()

#### （1）String.split()

该方法将字符串从**正则表达式匹配**的地方，**切分**成前后字符串，以数组的方式返回结果。切分后的一般会使用`Arrays.toString()`方法转换为字符串：`Arrays.toString(str.split(" "));`

#### （2）String.replaceFirst()/String.replaceAll()

`String.replaceFirst("regex","replaceWords")`，只替换正则表达式匹配到的**第一个**子串。

`String.replaceAll("regex","replaceWords")`，会将正则表达式匹配到的**所有**子串都替换。

### 附：

#### 1 关于运算符重载

用于字符串连接的“+”和“+=”是Java中仅有的两个重载过的操作符。

#### 2 StringBuilder与StringBuffer

StringBuilder是线程不安全的，即一般在单线程使用字符缓冲区的时候使用，多线程的时候保证线程安全一般使用StringBuffer。但是，StringBuffer由于考虑到了线程安全，所以较StringBuilder要慢一点。

#### 3 toString()方法

所有的容器类都覆写了toString()方法。

若想打印**对象的内存地址**，准确的应该是调用**Object.toString()**，即**super.toString()**，而不是当前类的this.toString()。（Object类是所有类的父类，包括容器类）

#### 4 Java Doc

http://docs.oracle.com/javase/7/docs/api/java/lang/StringBuilder.html

