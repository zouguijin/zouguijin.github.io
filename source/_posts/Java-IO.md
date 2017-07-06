title: Java---IO

date: 2017/07/02 10:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java IO——输入输出

> 如果缺乏历史的眼光，很快我们就会对什么时候该使用哪些类，以及什么时候不该使用它们而感到迷惑。

### 0 File类

File类，既能代表一个特定文件的名称，又能代表一个目录下的一组文件的名称：

- `File.list()` 可以返回一个字符数组`String[]` ，包含File对象所拥有的所有文件列表；

- 实现 **FilenameFilter接口** ，并使用其中的`accept()` 方法，在其中使用正则表达式匹配方法，在这之后，在调用`File.list()` 的同时，通过回调`accept()` 方法就可以完成过滤的功能——**策略模式** ；

- 当然，也可以使用匿名内部类的方式实现FilenameFilter接口，只不过`fileFilter()` 方法的参数需要`final` 修饰，因为这样才能让实现了FilenameFilter接口的内部类能访问到外部类的参数。

  ```
  public class FileFilterTest {
    public static FilenameFilter fileFilter(final String regex) {
      // create anonymous inner class
      return new FilenameFilter() {
        private Pattern pattern = Pattern.compile(regex);
        public boolean accept(File path, String name) {
          return pattern.matcher(name).matches();
        }
      };
    }
    public static void main(String[] args) {
      // To Do
    }
  }
  ```

  可见，`accept()` 方法的参数列表中含有File对象，而`list()` 方法则会为File对象下的每一个文件名调用`accept()` 方法，以此来判断该文件是不是在File对象所表示的文件目录中——所以，`accept()` 方法参数中的File对象，也即实现回调的一个链接吧。

File类的常用方法：

- `File[] local(File path, <final> String regex)` 方法，产生由本地目录中的文件构成的File对象的数组；
- `List<File> walk()` 方法，产生给定目录下的由整个目录树中所有文件构成的`List<File>` （一般需要实现`Iterable<File>` 接口）

### 1 输入输出与流

说到输入输出，一般都会提到一个概念——“流”，即表示任何有能力产出数据的数据源对象或者有能力接收数据的接收端对象。

**流屏蔽了数据实际处理的细节。**

Java中输入输出流的使用，一般会使用**装饰器模式**，即通过**选择和叠合多个合适的对象，来提供所需的功能**。

#### 1.1 InputStream类/Reader类

所有与输入有关的类，都继承于InputStream类，即每一种数据源都有相应的InputStream子类，通过相应的InputStream子类，可以**提供相应封装的流的形式，以接收对应的输出流提供的数据** 。此外，FilterInputStream也属于一种InputStream，作为一个抽象类，为输入的“装饰器”提供基类。

|  ByteArrayInputStream / CharArrayReader  |          允许将内存的缓冲区当作InputStream          |
| :--------------------------------------: | :--------------------------------------: |
| **StringBufferInputStream / StringReader** | **将String转换成InputStream，底层需要使用StringBuffer** |
|     **FileInputStream / FileReader**     |               **从文件中提取信息**               |
|    **PipedInputStream / PipedReader**    |           **管道，将会作为多线程中的数据源**            |
|         **SequenceInputStream**          | **将两个或者多个InputStream对象转换成单一InputStream** |

#### 1.2 OutputStream类/Writer类

OutputStream以及相应的子类，将决定**输出将要去往的目标**。

同样，FilterOutputStream属于一种OutputStream，作为一个抽象类，为输出的“装饰器”提供基类。

| ByteArrayOutputStream / CharArrayWriter |       内存中创建缓冲区，所有送入流的数据都要暂时放置在缓冲区中       |
| :-------------------------------------: | :--------------------------------------: |
|    **FileOutputStream / FileWriter**    |               **将信息写到文件中**               |
|   **PipedOutputStream / PipedWriter**   | **任何写入该流中的信息都会自动作为对应的PipedInputStream的输出，从而组成一个连续的“管道”，用于多线程任务中的通信** |
|            **StringWriter**             |           **对应于StringReader**            |

#### 1.3 FilterInputStream类/FilterReader类

FilterInputStream类以及其派生类**都将接收InputStream作为参数，并从InputStream中读取数据** ，所提供的功能，能够完成两件不同的事情：

- 通过DataInputStream从流中读取从不同的基本类型数据和String对象，结合对应的DataOutputStream就可以将数据作为“流”的形式，从一个地方搬移到另一个地方；
- 其他的派生类则可以从内部修改InputStream的行为方式：是否缓冲、是否保留其读取过的数据行（允许查询行数或者设置行数）、是否把单一字符放回输入流中等等。

|             DataInputStream              |     与DataOutputStream结合使用，用于从流中读取数据      |
| :--------------------------------------: | :--------------------------------------: |
| **BufferedInputStream / BufferedReader** | **提供一个数据的缓冲区，避免每次读取数据时都需要实际地写（即可以先把数据读到缓冲区，最后写数据的时候一次性地写出）** |
| **LineNumberInputStream / LineNumberReader** | **跟踪输入流中的行号，拥有方法`getLineNumber()` 和`setLineNumber(int i)` （其实这个类并不常用，因为可以在使用BufferdeInputStream封装流的时候，在每读取一行的时候随手添加一个行号）** |
| **PushBackInputStream / PushBackReader** | **具有“能弹出一个字节的缓冲区”，可以将读到的最后一个字节回退到输入流中。** |

#### 1.4 FilterOutputStream类/FilterWriter类

相对应的，FilterOutputStream类以及其派生类，将会**接收OutputStream作为参数，并将向OutputStream中写入数据**，同样所提供的功能能完成两件不同的事情：

- 通过DataOutputStream，可以将各种基本数据类型以及String对象格式化输出到“流”中，从而可以让DataInputStream可以从流中读取和操作数据；
- 修改OutputStream内部的行为方式，改变数据输出的形式。

|             DataOutputStream             |    可以将数据格式化输出到流中，以供DataInputStream读取     |
| :--------------------------------------: | :--------------------------------------: |
| **BufferedOutputStream / BufferedWriter** | **提供数据输出的缓冲区，可以最后将数据一次性地输出到流中或者文件里。可以使用`flush()` 方法清空缓冲区。** |
|      **PrintStream / PrintWriter**       |      **以可视化的格式打印所有的基本数据和String对象。**      |

#### 1.5 Reader类与Writer类

Java1.1对基本I/O流进行了重大修改，为了国际化的目的，提供了Reader/Writer类以及相应的派生类（见上述对应），但是新类的提供并不代表替代了原来的InputStream和OutputStream，因为：

- InputStream和OutputStream主要提供**面向字节形式的I/O流**的功能；
- Reader和Writer的出现则是为了**兼容Unicode**，并提供**面向字符形式的I/O流**的功能。

有时候，需要实现将来自于“字节”层次结构中的类和“字符”层次结构中的类**结合**起来使用——即使用**适配器**，**InputStreamReader/OutputStreamWriter**可以将InputStream和OutputStream转换成相应的Reader和Writer。

#### 1.6 注意事项

- 关于新旧两种I/O方案怎么使用，应该保持“**可以用新就不用旧**”的原则：尽量地使用Reader和Writer，如果发现不能编译，则转而使用面向字节的InputStream和OutputStream。

- DataInputStream是I/O类库的首选成员，除了一种情况：使用**`readLine()`** 方法的时候，应该使用**BufferedReader**；

- BufferedWriter不是FilterWriter（抽象类，没有子类）的子类；

- 未改变的类：DataOutputStrream、File（文件目录类）、RandomAccessFile（自我独立的类）、SequenceInputStream。

  **DataOutputStream**——如果想以**“可传输的”格式**存储和检索数据（将数据转化成流的格式，随时拿下来修改，随时再次转化成流的形式），一般使用InputStream和OutputStream的继承层次结构构造I/O流。

  **RandomAccessFile**——适用于大小已知的记录组成的文件，可以通过方法`seek()` 实现在文件内向前或者向后移动，即支持文件的搜寻，同时还可以指定对文件的操作是“随机读（r）”还是“既读既写（rw）”。在`java.nio.*` 中，RandomAccessFile的大多数功能由**存储映射文件**代替。

#### 1.7 小结

I/O流的用法，本质上可以看成**层层的封装**，通过**使用不同的封装层，可以提供不同的能力**。

一般最内层获取/写出数据，中间层将数据信息转换成String、Byte等类型，最外层则一般会使用具有缓冲区的类，比如BufferedInputStream等具有Buffered的类，一些特殊的需求会要求转换成DataInputStream/DataOutputStream。

在使用I/O流的过程中，需要提供异常捕捉或者抛出机制，最完善的方式当然是为每一次的I/O操作提供异常捕捉机制，最简单的方式则是在**`main()` 方法上给定抛出的异常**，即`throws IOException, ClassCotFoundException` 。

### 2 I/O流的常用方式

所谓“输入”，就是读取，可以从文件中读取，也可以从流中读取；所谓“输出”，就是写出，可以将内容写到流中，也可以直接写出到文件中。

#### 2.1 开辟缓冲区，输入文件内容

```
BufferedReader br = new BufferedReader(new FileReader("filename"));
String s = br.readLine();
br.close(); // 最后需要调用 close() 方法安全关闭文件
```

#### 2.2 从内存输入 

```
StringReader in = new StringReader(BufferedInputFile.read(filename));
int c;
while((c = in.read()) != -1) { System.out.print((char)c); } // read() 方法以int的形式返回一个字节，若没有内容则返回-1

// 格式化内存输入
// 由于格式化数据字节形式的流，所以要读取格式化的数据，需要使用DataInputStream，而不是Reader
// 当然，可以使用InputStream以及相应的派生类，将任何数据（包括文件内容）转换成字节形式的流
DataInputStream in = new DataInputStream(
	new ByteArrayInputStream(BufferedInputFile.read(filename).getBytes()));
while(in.available() != 0) { System.out.print((char)in.readByte()); }
// 因为readByte()对于任何字节都会返回合法的结果，所以需要available()方法判断是否还有字节
// 同样，readByte()方法读取字节，将以int的形式返回一个字节
```

#### 2.3 基本的文件输出

```
public class FileOutTest {
  static String inFilename = "testIn.txt";
  static String outFilename = "testOut.txt";
  public static void main(String[] args) throws IOException{
    BufferedReader in = new BufferedReader(
    	new StringReader(BufferedInputFile.read(inFilename)));
    PrintWriter out = new PrintWriter(
    	new BufferedWriter(new FileWriter(outFilename)));
    // 可以简化为 PrintWriter out = new PrintWriter(outFilename);
    // 这么说 PrintWriter 自带缓冲区？
    int line = 1;
    String s;
    while((s = in.readLine()) != null) { // 使用StringReader装饰之后，内容为空表示为null而不是-1
      out.println(line++ + ": " + s); // PrintWriter对象自带print()和println()方法
    }
    out.close();
    // 打印刚写入文件的内容
    System.out.print(BufferedInputFile.read(outFilename));
  }
}
```

#### 2.4 数据的存储与恢复 

虽然PrintWriter能够以可视化的形式输出数据，但是**为了能让输出的数据恢复成原本数据的形式**，需要使用**DataOutputStream输出数据**，同时使用**DataInputStream读取数据并恢复**。

```
// 将数据写入文件中
DataOutputStream out = new DataOutputStream(
	new BufferedOutputStream(new FileOutputStream(filename)));
out.writeUTF("xxx"); // 一般利用该方法写 String 对象，即UTF-8编码
out.writeDouble(1.234);
out.close();

// 从文件中读取数据到流中，调用方法打印出来
DataInputStream in = new DataInputStream(
	new BufferedInputStream(new FileInputStream(filename)));
System.out.print(in.readUTF()); // 一般使用该方法将 String 对象恢复
System.out.print(in.readDouble());
```

从上述程序段可见，要想正确地解析和存储数据的存放位置，要么为存储在文件中的数据选择固定的格式（即在存入的时候调用合适的方法，但是好像很麻烦...），要么将额外的信息一并存入文件中。

**对象序列化**和**XML**将会是存储和恢复复杂数据结构更容易、更好的方式。

### 3 标准 I/O

> 利用标准 I/O，可以很容易地将程序以数据的方式串联起来，一个程序的标准输出可以成为另一个程序的标准输入。

程序的所有输入都可以来自于标准输入，所有输出也都可以发送到标准输出，通过标准输出的方式输出。

Java标准I/O模型提供了三个标准I/O方式：**System.in**、**System.out**、**System.err** 。

其中，System.out和System.err已经事先被包装成了PrintStream对象，所以我们可以立即使用这两者作用于数据；但是，**System.in却是一个没有经过包装的InputStream**（为什么会出现这种半拉子工程？），所以在使用System.in读取的数据时，只能把它当成一个InputStream，然后根据需要对其进行相应的包装。

- System.in

  ```
  // 需要使用readLine()方法，包装成BufferedReader
  BufferedReader in = new BufferedReader(new InputStreamReader(System.in)); 
  ```

- System.out

  System.out是一个PrintStream（即一个OutputStream），有属于自己的`print()`和`println()` 方法，也可以转换成PrintWriter。

  ```
  // 利用构造方法，将System.out转换成PrintWriter
  PrintWriter out = new PrintWriter(System.out,true);
  ```

  对于System.err也是同理。

**标准I/O重定向**

Java的System类提供了静态方法，用于重定向标准I/O流：

`setInt(InputStream)`、`setOut(PrintStream)`、`setErr(PrintStream)`

对于想要编写一段**能够反复使用的I/O流测试程序**，对标准I/O进行重定向操作就很有价值，可以大幅度减少I/O层层装饰的工作量。

在程序内部都使用标准I/O（System.in、System.out、System.err），而在进入程序之前重定向I/O，即将标准I/O重定向到特定的某个I/O上，最后在测试完成、程序结束之前再次重定向回标准的I/O即可。

```
// 需要 InputStream 类型的参数
BufferedInputStream in = new BufferedInputStream(new FileInputStream("testIn.txt")); 
// 需要 PrintStream 类型的参数
PrintStream out = new PrintStream(new FileOutputStream(textOut.txt));
System.setIn(in);
System.setOut(out);
System.err(out);
// 利用重定向后的标准I/O进行测试
BufferedReader brIn = new BufferedReader(new InputStreamReader(System.in));
String s;
while((s = brIn.readLine()) != null) { Syste.out.println(s); }
// 完成测试后，记得关闭输出流，将标准I/O流复位
out.close();
System.setIn(System.in);
System.setOut(System.out);
System.err(System.err);
```

可以看到，全程使用的都是InputStream和OutputStream，而不是Reader/Writer，因为**标准I/O重定向使用的是字节流**，而非字符流。

### 4 新I/O `java.nio.*`

`java.nio.*` 的目的在于提高I/O的速度，即使在编写程序时没有使用nio，也会从中受益，因为旧的I/O库已经使用nio优化过。

#### 4.1 通道FileChannel与缓冲器ByteBuffer

nio优化的速度原理，是因为nio使用的I/O结构更接近与**操作系统执行I/O的方式** ：

- **通道**，即数据流动和存放的地方；
- **缓冲器** ，即在通道和数据输入/输出之间的一个缓冲区。

也即，作为操纵数据输入/输出的我们并没有直接与通道交互，不论是我们还是通道，都是从缓冲区获取数据，或者向缓冲器发送数据。

**唯一直接与通道交互的缓冲器是ByteBuffer——可以存储未经加工过的字节** ，即接受InputStream/OutputStream的字节流。

旧I/O类库中有三个类被修改，用于产生通道**FileChannel** ：FileInputStream、FileOutputStream、RandomAccessFile。可见，这三个类都是**操纵字节流的类**，与`java.nio.ByteBuffer` 所操纵的流类型一致，而Reader/Writer操纵字符流的类不能用于产生通道。

通道是一个相当基础的东西：可以向它传送用于读写的ByteBuffer，也可以锁定文件的某些区域用于独占式的访问。

**`java.nio.channels.Channels` 类提供的方法，可以在通道中产生Reader/Writer类。**

```
// 产生 写 通道
FileChannel fc = new FileOutputStream(filename).getChannel();
// 向通道中写入 ByteBuffer 包装的数据
fc.write(ByteBuffer.wrap("xxxx".getBytes())); // ByteBuffer.wrap()需要接收字节数组作为参数
// 写完要关上输出流
fc.close();
// 产生 读 通道
FileChannel fc = new FileInputStream(filename).getChannel();
// 准备缓冲器准备接收从通道读来的数据，并指定大小，然后将通道的数据读取放入缓冲器中
ByteBuffer buff = ByteBuffer.allocate(BuffSize);
fc.read(buff);
// 读取完通道的数据，必须使用 flip() 方法，让缓冲器准备好将数据提供给程序的其他部分读取
buff.flip();
while(buff.hasRemaining()) {
  System.out.print((char)buff.get()); // buff中的数据都是以字节的方式存在的
}
// 如果需要利用缓冲器实时对两个通道分别进行读取和写出的操作，实现将数据从一个通道转移到另一个通道的操作，则buff.flip()和buff.clear()方法必须同时使用，分别放在读取和写出之后，用于准备数据（以便缓冲器将数据提供给输出）和清空数据（以便缓冲器读取下一个字节）。
// 方法 transferTo() 和 transferFrom() 可以实现两个通道的直接相连
```

可见，通道里存储和流动的是字节流，所以ByteBuffer读取到的数据也将会是字节形式。转换成可读形式的简单方法就像上述程序段一样——为每一个字节执行char类型转换，显而易见，这样的方式很低级。

缓冲器ByteBuffer中数据存储的形式是字节，想要将数据转换成字符形式，要么在将数据放入缓冲器之前就将数据进行编码，要么在将数据从缓冲器输出的时候对数据进行解码。

`java.nio.charset.Charset` 类库提供了多种编码格式以及编码的工具。

```
// 1.在从缓冲器输出的时候对其进行解码
String encoding = System.getProperty("file.encoding"); // 获取用于文件内容编码的编码方式
System.out.print(Charset.forName(encoding).decode(buff)); //对缓冲器buff中的字节进行解码，输出成可读的字符形式
// 2.在写入缓冲器的时候对其进行编码
FileChannel fc = new FileOutputStream(filename).getChannel(); // 准备向通道中写入数据
// 在getBytes()中确定编码的格式，然后转换成字节的形式写入缓冲器，最后在写入通道中
fc.write(ByteBuffer.wrap("String".getBytes("UTF-16BE"))); 
fc.close();
fc = new FileInputStream(filename).getChannel(); // 准备从通道里读取数据
buff.clear(); // 如果使用之前的buff，就要事先清空buff中的数据
fc.read(buff); // 将数据从通道读取到缓冲器中
buff.flip(); // 准备缓冲器，以便将数据从缓冲器中输出
System.out.print(buff.asCharBuffer()); // 对于事先编码过字节，只需要调用 saCharBuffer() 方法，即可还原成可读的字符形式
// 3.使用 buff.asCharBuffer().put("string") 方法，将字符数据放入缓冲器，用 buff.asCharBuffer()即可读会字符
```

#### 4.2 视图缓冲器

视图缓冲器，介于上层数据展示形式与底层数据实际存放形式之间，提供以某种特定的基本数据类型的视窗查看底层数据的存放——即ByteBuffer。不仅能查看，同时对于视窗的任何修改都可以映射到ByteBuffer中数据的修改。

```
ByteBuffer br = ByteBuffer.allocate(BSIZE);
IntBuffer ib = br.asIntBuffer(); // int 类型的视图缓冲器
ib.put(new int[]{1,2,3,4,5}); 
// 利用put()将数据放进视图缓冲器，底层ByteBuffer将会存储相应的字节数据，类似于ByteBuffer接收字节数组，IntBuffer可以接受int数组
System.out.print(ib.get(3)); // 可以利用get()获取缓冲器的数据，可以提供绝对位置的访问方式，put()方法也有此功能
```

将特定类型的数据写入相应的视图缓冲器，底层的ByteBuffer就会映射出相应的字节数据，可以将ByteBuffer缓冲的数据传送给通道，然后从通道读取到ByteBuffer缓冲器中的数据，利用相应类型的视图缓冲器就可以直接恢复出相应的类型格式——即，**特定类型数据 > 视图缓冲器 > ByteBuffer > 通道> ByteBuffer > 视图缓冲器 > 相应类型数据** 。

此外，缓冲器Buffer类还有很多的方法，可以参见[相关网页](http://docs.oracle.com/javase/7/docs/api/java/nio/Buffer.html) ，各种视图缓冲器类，比如IntBuffer，都是Buffer类的派生类。

#### 4.3 内存映射文件

内存映射文件允许创建和修改因为过大而**不能放入内存中的文件** ，文件的一部分放入内存，而文件的其他部分交换出去。

#### 4.4 文件加锁

通过对文件进行加锁的操作，可以实现同步访问共享文件。

Java文件锁对所有的操作系统都是可见的，因为它直接映射到本地操作系统的加锁工具上。

通过对通道FileChannel调用`tryLock()`或者`lock()` 方法，可以获得整个文件的锁FileLock。

```
FileLock fl = new FileOutputStream(filename).getChannel().tryLock();
FileLock().release(); // 释放锁
```

`tryLock()` 方法是非阻塞式的，`lock()` 方法是阻塞式的。

对文件的一部分上锁：

```
tryLock(long 起点位置, long 上锁长度, boolean true表示该锁是共享锁)；
lock(long 起点位置, long 上锁长度, boolean true表示该锁是共享锁);
```

### 5 压缩与解压缩

I/O流的压缩和解压缩类都属于InputStream/OutputStream继承层次的一部分（而不属于Reader/Writer一类），即压缩与解压缩操纵的都是字节流。（当然，可以利用适配器转换成Reader/Writer）

- 压缩
  - 基类：DeflaterOutputStream
  - ZipOutputStream/GZIPOutputStream，以ZIP/GZIP格式压缩文件
  - checkOutputStream，其构造方法和`GetCheckSum()` 方法将为任何OutputStream产生校验和
- 解压缩
  - 基类：InflaterInputStream
  - ZipInputStream/GZIPOutputStream，对ZIP/GZIP格式的压缩文件解压
  - checkInputStream，其构造方法和`GetCheckSum()` 方法将为任何InputStream产生校验和

```
BufferedReader in = new BufferedReader(new StringReader(BufferInputFile.read("test.txt")));
BufferedOutputStream out = new BufferedOutputStream(
	new ZipOutputStream(new FileOutputStream("test.zip")));
String s;
while((s = in.readLine()) != null) {
  out.write(s);
}
in.close();
out.close();
```

GZIP和Zip库的使用不仅仅局限于文件，它们可以压缩任何东西，包括需要通过网络发送的数据。

### 6 对象序列化

Java的对象序列化机制将实现了**Serializable接口**的对象转换成一个**字节序列** ，并能够在之后的某个时刻将该字节序列**完全恢复**为原来的对象。序列化的对象也可以通过网络传输之后恢复，即这个过程是跨操作系统的。

Java对象序列化机制可以实现**轻量级的持久性** ，所谓**“持久性”**，即意味着一个对象的生存周期并不取决于是否正在执行，而是可以生存于程序的调用之间，即使上一次程序运行停止了，下一次程序运行起来对象的信息仍存在并可以恢复。而所谓**“轻量级”**，即对象的序列化与反序列化还原都需要显式地执行，而不是系统自行维护。（若需要一个更严格的持久性机制，可以参考**Hibernate**等工具）

Serializable接口，仅仅是一个标记接口，并不包含任何的方法。所以，对一个实现了Serializable接口的对象的序列化恢复的过程中，**没有调用任何构造器或其他方法**，只是**单纯地从InputStream获取的数据里将对象恢复**。

**对象序列化的步骤：**

- 希望序列化的对象所属类必须实现Serializable接口；
- 创建OutputStream对象，并将其封装到ObjectOutputStream对象中；
- 通过ObjectOutputStream对象调用`writeObject()` 方法，待序列化的对象作为该方法的参数，既可以将对象序列化成字节流。

**反序列化还原的步骤：**

- 创建InputStream对象，并将其封装到ObjectInputStream对象中；
- 通过ObjectInputStream对象调用`readObject()` 方法，即可将流中的字节序列还原成对象，方法返回的是一个引用，指向一个Object对象，需要强制转型为对应的对象。

```
public class Pet implements Serializable {}
// I/O流封装的时候，输入和输出每一层一般都需要相互对应
// 向文件中写入序列化的数据
ObjectOutputStream out = new ObjectOutputStream(new FileOutputStream(filename)); 
out.writeObject("xxx");
out.writeObject(new Pet());
out.close();
// 读取文件中的序列化数据，并恢复
ObjectInputStream in = new ObjectInputStream(new FileInputStream(filename));
String s = (String)in.readObject();
Pet p = (Pet)in.readObject();
in.close();

// 序列化字节数组
ByteArrayOutputStream buff = new ByteArrayOutputStream();
ObjectOutputStream out2 = new ObjectOutputStream(buff);
out2.writeObject("xxx");
out2.writeObject(new Pet());
out2.flush();
out2.close();
// 由于序列化字节数组没有写入存储介质或者网络流中，直接输出了，所以反序列化还原只是模拟了一下收到字节数组还原的情形
ObjectInputStream in2 = ObjectInputStream(new ByteArrayInputStream(buff.toByteArray()));
String s = (String)in2.readObject();
Pet p = (Pet)in2.readObject();
in.close();
```

**对象序列化的神奇之处**在于：不仅可以序列化某个对象，还可以同时包含对象内所包含的所有引用，并保存引用所指的那些对象，即类似于链式追踪一样——深度复制（Deep Copy）。

对象序列化的成功实现，必须保证Java虚拟机能够找到相关的**.class文件**。

`writeObject()`和`readObject()` 方法只是用于对象的序列化（包括String对象），**基本类型数据的序列化**也有相应的方法，比如`writeInt()`、`writeByte(int i)`、`writeBytes(String s)` 等。

#### 6.1 序列化的控制

考虑到安全的问题，有时候需要实现**对象某一部分的序列化**。

序列化的控制，有三种方法：

- **实现Externalizable接口**，替代实现Serializable接口，该接口中有两个方法：`writeExternal()`和`readExternal()` ，这两个方法将会在序列化和反序列化的过程中被**自动调用** ，只有在这两个方法中才能显式地实现序列化，之外的数据不会序列化。

  因此，必须在`writeExternal()` 中将对象信息写入（不仅仅是将对象的某些信息序列化，同时还需要将某些不需要序列化的信息写入流中），同时在`readExternal()` 中恢复数据（不仅仅是恢复序列化数据，同时还需要恢复之前没有被序列化的数据）

  **Serializable接口 VS Externalizable接口：**

  实现前者的对象，完全以它存储的二进制位来构造，序列化恢复不使用构造器；实现后者的对象，序列化恢复的时候，对象所属类的**所有默认构造器都会调用** ，之后才会调用`readExternal()` ，因此之前存在使用非默认构造器初始化的对象和值，需要在`readExternal()` 方法中专门对其进行恢复。

- **transient关键字** ，即瞬时关键字。在**实现Serializable接口**的类的某些字段之前，利用transient关键字修饰，即可阻止某些字段被序列化。如果不对序列化加以控制，即使是private字段也可以由序列化机制还原并获取。

  但是，为了让自己知道和恢复transient关键字修饰的字段，必须**自行设计一种安全的信息保存和恢复方法**。

- 实现Serializable接口，并手动添加`writeExternal()`和`readExternal()` 方法（要求具有准确的形参），这样就可以不使用默认的序列化机制。

  ```
  private void writeExternal(ObjectOutputStream stream) throws IOException
  private void readExternal(ObjectInputStream stream) throws IOException, ClassNotFoundException 
  ```

#### 6.2 小结

- Java序列化可以跨操作系统，不仅可以将数据序列化到存储介质中，还可以通过网络传送序列化数据；
- Java序列化只是Java自身的解决方案，即只有Java程序才能将序列化的数据还原成原数据。

### 附：

#### 1 Scanner类

位于`java.util.Scanner` 中，只能用于读取输入和文件，而不能用于写文件。

#### 2 XML

位于`javax.xml.*` 中，XML格式化数据之后，可以为各种平台和语言使用。

XML数据的格式化呈现**树形结构** 。

#### 3 JSON与GSON

JSON（JavaScript Object Notation），是一种轻量级的数据交换格式。

在JSON中，分为JSON Object和JSON Array：

```
// JSON Object
{ "Name" : "Jack", "Age" : 18, "Male" : true, "Skills" : [{"1":"Java","2":"C++"}]}
// JSON Array
[{"Name":"jack","Age":16},{"Name":"jack","Age":16},.......]
// JSON Primitive，例如一个字符串或整型
// JSON Null，值为null
```

GSON，是Google发布的一个开源Java库，主要用于将Java对象序列化为JSON字符串，或将JSON字符串反序列化为Java对象。

#### 4 Preferrences

Preferrences API可以提供更为严格的持久性，因为它可以自动存储和读取信息，缺点在于存储的大小和数据类型有限——8K、基本类型和字符串对象。因此，一般用于存储和读取配置信息和用户喜好信息。