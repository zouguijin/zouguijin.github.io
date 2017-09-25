title: FTP 文件传送协议

date: 2017/04/20 18:00:00

categories:

- Study

tags:

- TCP/IP
- FTP

---

### 0  主要特点 

FTP（File Transfer Protocol），文件传输协议，所提供的的文件传送功能可以将一个完整的文件从一个系统复制到另一个系统中。若要使用FTP，或需要有登录文件服务器的账号，或通过允许使用匿名FTP的文件服务器。

- FTP采用**两个TCP连接**来传输一个文件：

  - 控制连接：用于传送客户发送的命令和服务器的响应，该连接以C/S的方式建立，**始终在等待**客户与服务器之间的通信（服务器**被动地**打开用于FTP的端口`PORT 21`，客户端则**主动地**打开`PORT 21`，即FTP控制连接的建立以及后续的控制命令的传送，都是由客户端向服务器的`PORT 21`发送命令，然后服务器响应完成的）

    IP对控制连接的**服务类型**为**“最大限度地减少迟延”**，因为客户端命令通常是由用户键入的。

  - 数据连接：用于在客户端和服务器之间文件的传输。

    IP对数据连接的**服务类型**为**“最大限度地提高吞吐量”**。

### 1  控制文件传送和存储的选择

FTP文件传输（在数据连接中传）的选择有四个方面，每一个方面必须做一个选择：

- 文件类型

  常用的有（1）ASCII码文件类型（默认选择）（2）图像文件类型（也称二进制文件类型）。

  ASCII码文件类型，文本文件将以**NVT ASCII码**的形式在数据连接中传输（即要求每一个系统都必须拥有NVT ASCII码与本地文本文件互相转换的能力）。NVT ASCII码传输的每一行都带有一个回车CR，接着是一个换行LF，这意味着文件的收方必须扫描每一个字节，找到**CR LF对**。

  图像文件类型（即二进制文件类型），连续的比特流，通常用于传输二进制文件。

- 格式控制

  只对上述的ASCII码文件类型有效。

  常用的有非打印（默认），即文件中不含有垂直格式信息。

- 结构

  常用的有文件结构（默认），该选项下，文件被认为是一个**连续的字节流**，不存在内部的文件结构。

- 传输方式

  规定文件在数据连接中如何传输。

  常用的有流方式（默认），即文件将以**字节流**的方式在数据连接中传输。对应于上述文件结构，发送方将在文件末尾提示关闭数据连接。

  此外还有块方式，压缩方式。

  PS.上述常用的选择，也即是Unix系统中对FTP的传输限制。

### 2  FTP命令与应答

命令和对命令的响应，在C/S之间的**控制连接**上，以**NVT ASCII码**的形式传送，即要求每行的结尾都要返回**CR LF对**。

PS. **Telnet协议**也用到NVT ASCII码，在FTP的的控制连接通信中，部分场景使用了Telnet命令，这些命令都是以**IAC**开头。*（关于Telnet命令，将在另一篇文章中介绍）*

- 客户端 -> 服务器的命令

  其中Telnet命令只包含中断进程< IAC,IP >和Telnet的同步信号，即紧急方式下< IAC,DM >；

  常用的FTP命令：



|           命令           |                  解释                  |
| :--------------------: | :----------------------------------: |
|     USER username      |            输入并传送服务器上的用户名             |
|     PASS password      |            输入并传送服务器的登录口令             |
|     LIST filelist      |              列表显示文件或者目录              |
|     RETR filename      |             检索一个文件（读文件）              |
|     STOR filename      |             存放一个文件（写文件）              |
|       TYPE type        |  说明文件的类型：type=A表示ASCII码，type=I表示图像   |
| PORT n1,n2,n3,n4,n5,n6 | 客户端的IP地址（n1.n2.n3.n4）和端口号（n5*256+n6） |
|          SYST          |             要求服务器返回系统类型              |
|          QUIT          |             从服务器退出并注销登录              |
|          ABOR          |           放弃先前的FTP命令和数据传输            |

- 服务器 -> 客户端的应答

  应答都是ASCII码形式的**3位数字**，并在数字之后跟有报文选项。

  3位数字的每一位都有不同的含义，组合起来就是应答的最终含义。

  FTP典型应答，每一个典型应答都带有一个可能的报文选项：



| 应答数字 |      携带的报文选项      |
| :--: | :---------------: |
| 125  |   数据连接已经打开，传输开始   |
| 200  |       服务器就绪       |
| 214  |    帮助报文（面向用户）     |
| 331  | 用户名正确，要求输入对应的登录口令 |
| 425  |     无法打开数据连接      |
| 452  |      用户错写文件       |
| 500  |   语法错误（未被认可的命令）   |
| 501  |    语法错误（参数无效）     |
| 502  | 未实现的MODE（方式命令）类型  |

### 3  FTP连接的建立与管理

FTP连接包括控制连接和数据连接，其中控制连接在C/S连接的全过程都会**保持**，而数据连接则可以根据需要**随时来随时走**，甚至在没有数据连接、没有数据传输时候，控制连接还可以一直保持着。

- 控制连接的建立

  当客户端希望与服务器建立起上传或下载文件的数据传输业务时，客户端会向服务器的TCP `PORT21`发起建立连接的请求，服务器若接受客户端的请求，并完成连接的建立，则C/S控制连接就建立完成。

  PS. 为什么要叫做“TCP端口”？因为FTP的通信是建立在TCP协议的基础之上的，FTP的默认端口就是TCP的21端口。

- 数据连接的建立

  数据连接即是用于数据传输的连接，有三大用途：（1）从客户端向服务器发送一个文件；（2）从服务器向客户端发送一个文件；（3）从服务器向客户端发送文件列表或者目录列表。

  由于文件传输方式一般是流的方式，**文件的结尾是以关闭数据连接为标志**（即一个文件传输完了，就会关闭该数据连接），所以对每一个文件或者目录列表的传输都需要建立一个全新的数据连接（**一对一**）。

  数据连接的建立有两种：（1）主动模式`PORT`；（2）被动模式`pasv` ：

  （这里的“主动”是以先打开数据连接的端口并通知对方的一方为准）

  - 主动模式`PORT`

    在控制连接建立的基础上`PORT21`，当需要传送数据时，客户端在控制连接上通过`PORT`命令告诉服务器：“客户端打开了XXXX端口，请服务器来连接我”，然后服务器通过`PORT20`向端口XXXX发送连接请求，并由此建立数据连接，之后便在该数据连接上传输数据。

    PS. 主动模式`PORT`中，数据连接的服务器一侧将会**一直使用`PORT20`**，不论后续将会有多少个客户端的连接。

    PSS. 如果FTP服务器没有使用默认端口`PORT21`，而使用了其他的某一个端口A建立控制连接，那么在数据连接将会使用端口A-1，因此在设置的时候，需要将服务器端的这两个端口都保留。

  - 被动模式`PASV`

    在控制连接建立的基础上`PORT21`，当需要传送数据时，服务器通过控制链路使用`PASV`命令告诉客户端：“服务器打开了端口XXXX，请客户端来连接我”，然后客户端将在可用的端口号中选取一个，用于与服务器的端口XXXX建立数据连接。

    PS. 被动模式`PASV`中，每需要开启一个数据传输的过程，服务器都需要**使用一个新的可用的端口**，如此一来，当数据传输的请求过多时，服务器将会开启并使用过多的端口，服务器的安全性将会受到威胁。也因此，正常情况下，都会使用主动模式。

    那为什么还存在被动模式呢？这是因为**NAT**的出现，内网的多台主机将会对外网呈现同一个IP地址，如果仍使用主动模式，则内网的客户端主动向服务器通告的socket信息（A:XXXX），将会在出网关、进外网的时候由NAT修改新的socket信息（B:XXXX），如此一来服务器将会认为需要与B:XXXX建立数据连接并传送数据，可惜公网IP地址B并没有开启XXXX端口。所以，这种情况下，需要使用被动模式`PASV`，由服务器来告知内网的客户端，服务器一侧开启的端口信息。

- 连接的管理

  - 临时数据端口：主动模式`PORT`下建立数据连接，客户端将会要求TCP为其数据连接提供一个**临时端口号**，并通过`PORT`命令将包含该端口号的socket信息由控制连接发送给服务器。

  - 默认数据端口：在上述已经建立了一条数据连接的基础上，客户端希望再次与服务器建立数据连接，如果使用`PORT`命令则又会申请到一个临时端口号，但若没有使用`PORT`命令，则意味着本次请求建立数据连接，没有指明数据连接客户一侧的端口号，此时服务器将会使用**控制连接客户端一侧的端口号**作为数据连接客户端一侧的端口号。

    设，控制连接的客户端和服务器socket分别是：< A:P1 >，< B:P2 >，原有的数据连接的客户端和服务器socket分别是：< A:P3 >，< B:P2-1 >。

    如果使用`PORT`命令，就会使用TCP提供的新的临时端口，数据连接两侧socket为：< A:P4 >，< B:P2-1 >

    如果不使用`PORT`命令，就会使用默认数据端口，即新的数据连接两侧的socket为：< A:P1 >，< B:P2-1 >

    由于socket四元组只要有一个不相同，就可以使用，因此使用默认数据端口，是可以的。

    但是默认数据端口的使用会存在**问题**：

    在上一个使用默认数据端口的数据连接关闭之后，按照TCP对**连接关闭的“四次握手”规则**，该数据连接的socket对将会被置为**2MSL等待**，若此时紧接着又希望使用默认数据端口建立数据连接，那么连接建立将会失败，因为上一个连接已经使用了< A:P1 >，< B:P2-1 >这一对socket，而且还处于2MSL的等待状态，无法建立新连接。（还有一个原因，**TCP规定禁止服务器发送同步信息SYN**，这就没办法让服务器跳过socket对的2MSL等待状态来重用相同的socket对）

- 连接的停止

  在文件传输结束的时候，文件流末尾将会携带相应的信息，提示关闭数据连接，由此就可以通过“四次握手”停止数据连接。

  至于控制连接，可以通过`QUIT`命令注销用户登录，进行停止。

### 4  FTP文件传输的异常中止

- 异常中止客户端向服务器的文件传输

  只需要客户端停止在数据连接上传输数据，并通过控制连接向服务器发送`ABOR`命令即可。

- 异常中止客户端接受服务器传输来的文件

  比较复杂，需要客户端告知服务器立即停止数据的发送，需要用到**Telnet同步信号**。

  尽管已经知道并作出了异常中止文件传输的操作，但是客户进程还需要在数据连接上接受部分数据报文（即**并不是立即停止接受数据**）

### 5  匿名FTP

允许匿名FTP的服务器，将会允许任何人注册并使用FTP与该服务器进行文件的传输。

匿名FTP，必须使用“**anonymous**”作为用户名注册。

### 6  总结

FTP是基于TCP通信模式的文件传输协议，FTP比较简单易懂，设计和实现的思路也很清晰，通过对FTP的认识和理解，有助于后续理解基于TCP所开发的额外功能和应用，也对以后开发基于TCP的通信功能或者类FTP的功能有所帮助。

FTP使用两个TCP连接的特点，在保持客户端与服务器会话的长期性的同时，尽可能地减少了由于客户端断断续续与服务器之间传输文件，重复与服务器建立连接、取消连接，所带来的控制信息的开销（毕竟TCP“三次握手”的过程还是很复杂的，通信开销还是蛮多的）。