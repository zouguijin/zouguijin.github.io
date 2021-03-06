title: Telnet Protocol

date: 2017/04/21 22:00:00

categories:

- Study

tags:

- TCPIP
- TelnetProtocol

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

- NVT ASCII

  Telnet协议定义了一种通用字符终端——网络虚拟终端NVT（Network Virtual Terminal）。

  相应的，有NVT ASCII——**7比特**的ASCII字符集，网络之间的协议族都使用NVT ASCII。每7比特都将最高位置为0，然后以8比特的格式进行传送。

  每一行结束都有两个字符——**CR（回车） LF（换行）**，也可以用`\r\n`表示。

  NVT ASCII应用广泛，FTP、SMTP等协议都使用其来描述客户端发出的**命令**以及服务器对命令的**应答** 。


- Telnet命令

  Telnet通信的两个方向都采用**带内信令**方式，即在一个TCP连接上既传送数据又传送控制信令。

  **IAC**（Interpret as Command，字节码为0xff，即255），是Telnet命令的标识，**其后**会跟着相应的命令字节，所有**IAC+命令字节**构成了Telnet命令集。


- 选项协商

  Telnet的连接双方在连接之初，首先会进行交互，以确定连接双方各自所需的通信功能，所用的方式就是**选项协商机制**。选项协商是**对称**的，即任何一方都可以主动地发送选项协商请求给对方。

  选项协商需要3个字节：（1）IAC字节；（2）WILL/DO/WONT/DONT，四个字节中的一个；（3）ID字节，用于指定激活或者禁止选项。

  虽然选项协商机制是对称的，但是客户端和服务器在协商的时候，**各自的要求可以不一样**，因为远程登录毕竟不是对称的应用，客户端有自己需要完成的任务，服务器则有属于自己的任务。

- 子选项协商

  有些选项，不是简单地通过3个字节就能完全确定的，所以需要在3个字节的协商条件下，继续完成后续的协商，即子选项协商。

  子选项协商建立在之前的3字节选项的基础上，**以IAC SB起始，接ID字节，接后续子选项字节，最后以IAC SE终止**，例如：

  < IAC,SB,24,1,IAC,SE >

- 通信方式

  Telnet客户端与服务器之间一共有四种通信方式：半双工、一次一个字符（默认方式）、一次一行（准行方式）以及行方式。

  其中，一次一个字符的默认方式，客户端所键入的每个字符都会单独发送到服务器进程，然后服务器进程将会回显大多数的字符（除非服务器应用程序没有启用回显功能）。

- 同步方式与同步信号

  以Data Mark（DM）命令作为同步信号，该同步信号将以TCP**紧急数据**的形式发送（即标志比特URG=1），也即同步信号将**随着数据流传输**，用于告诉同步信号的接收端回到正常的处理过程上，即重新开始正常地接收数据、处理数据。

  为什么要使用TCP紧急数据的形式传输同步信号？因为，**即使TCP数据流已经被TCP流量控制所终止，但是紧急数据（URG=1）还是可以进行传输**，而同步信号（IAC+DM）就位于紧急数据的最后一个字节，这样一来就可以通过同步信号，告诉对方回到正常的数据传输和处理上。

### 3  总结

Telnet作为Internet最早的应用之一，其基于TCP的通信模式和流程，为后来的很多Internet应用提供了最基础的参照。对Telnet的学习和理解，以及后续的实现（*又挖一个坑...*），对未来理解和实现网络编程应该会有具有很大的帮助。







