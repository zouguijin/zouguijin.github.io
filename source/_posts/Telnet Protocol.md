title: Telnet Protocol

date: 2017/04/21 22:00:00

categories:

- Study

tags:

- TCP/IP
- Telnet Protocol

---

### 0  Telnet与远程登录

远程登录，即通过先登录一台主机，然后再通过网络远程登录到任何一台连接到网络的主机上（需要有登录账号和口令），而不需要为每一台主机连接一个硬件终端。

TCP/IP网络上，远程登录采用C/S模式，有两种远程登录的方法：

（1）Telnet，最古老的Internet应用，全称Telecommunication Network Protocol（电信网络协议）。Telnet受到TCP/IP的广泛支持，可以运行在不同操作系统的主机之间，Telnet客户端和服务器端之间通过**选项协商机制**，确定通信双方所能提供的通信功能。

（2）Rlogin，起源于伯克利Unix，现在也可以在其他操作系统上运行，比Telnet简单。

### 1  Telnet与C/S模式

- Telnet客户进程同时与**终端用户**和**TCP/IP协议模块**进行交互，所以在客户进程上键入的任何信息，将会通过TCP连接传输到服务器端，同时键入的信息和返回的信息都会回显在终端上。
- Telnet只使用一条TCP连接，意味着控制信息和数据信息将会在一条TCP连接上传输，因此必须要有相应的方式区分控制命令和数据。
- Telnet客户进程和服务器进程属于用户应用程序。

### 2  NVT ASCII 与 Telnet 命令

Telnet协议定义了一种通用字符终端——网络虚拟终端NVT（Network Virtual Terminal）。

相应的，有NVT ASCII——7比特的ASCII字符集，网络之间的协议族都使用NVT ASCII。每7比特都将最高位置为0，然后以8比特的格式进行传送。

每一行结束都有两个字符——CR（回车） LF（换行），也可以用`\r\n`表示。

NVT ASCII应用广泛，FTP、SMTP等协议都使用其来描述客户端发出的**命令**以及服务器对命令的**应答** 。

...（未完）

