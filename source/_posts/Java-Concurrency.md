title: Java---Concurrency

date: 2017/07/19 18:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java Concurrency——并发

> 如果视而不见，就会遭其反噬。

利用并发解决的问题可以分为两类：速度和设计可管理性。

- 速度

  并发通常是提高运行在**单处理器**上的程序的性能。

  表面上看，在单处理器上，程序的所有部分当作单个任务运行似乎会更快一点，因为这将会节省**上下文切换**（从一个任务切换到另一个任务）的代价。

  但是，程序会存在“**阻塞**”的情况，阻塞将会使程序中的某个任务因为程序外的条件限制（经常是IO）而不能继续执行。

  并发的存在，可以让被阻塞的任务暂时挂起，转而执行其他的任务，在条件满足之后，再考虑继续执行之前挂起的任务，从而充分利用程序执行的时间。当然，如果程序中根本没有任务会发生阻塞，那么在单处理器上使用并发将没有任何意义。

  此外，并发还可以通过**事件驱动编程**方式提高单处理器的处理性能，最常用的例子是用于产生具有可响应的用户界面，赋予程序一定程度的可响应性。

- 设计可管理性

  并发中的**协作多线程**机制。

  **Java的线程机制是抢占式**的，即调度机制会**周期性地中断线程**，将上下文切换到另一个线程，从而为每个线程都提供时间片，使得每个线程都会分配到数量合理的时间去驱动它的任务。

  协作式系统中，每个任务都会**自动地放弃对于时间片的控制**，这要求程序员有意识地在每个人物中插入某种类型的让步语句。**协作式系统的优势**：上下文切换的开销通常比抢占式系统低廉得多；对于同时执行的线程数量理论上没有任何限制。

  通过并发，可以了解和掌握**基于消息机制的架构**——这是**分布式系统**创建的主要方式，因为分布式系统涉及到多台独立的计算机，并发将会是多进程级别的，如何在**进程间同步信息**将会是整个分布式系统协同工作的重点。 

  线程可以提供更为**松耦合**的设计。

### 1 线程机制

线程机制，允许我们**将程序划分成多个分离、独立运行的任务**，然后每一个任务都可以交由多个不同的执行线程进行驱动。一个线程就是当前执行进程中的一个单一顺序控制流，即进程可以包含多个线程（多个并发执行的任务），底层机制是切分CPU时间片，在线程看起来似乎自己拥有了自己的CPU一样。由于底层切分CPU时间片对于线程机制来说是透明、可扩展的，所以如果发现当前线程机制运行较慢，添加CPU即可。

#### 1.1 “任务”的定义一（Runnable）

“任务”的定义可以由**Runnable接口**提供：实现Runnable接口并编写其中的`run()`方法——方法中的内容即为任务运行时将会执行的命令。

```
public class Task implements Runnable {
  // ...
  public void run() { // task commands ...}
}
```

#### 1.2 Thread类（线程类）

仅仅实现Runnable接口中的`run()`方法并不存在任何线程机制，要实现线程行为，必须**显式**地将一个任务附着到线程上。

最基本的方式，是将实现Runnable接口的对象，传递给一个Thread类构造器。

```
Thread t = new Thread(new Task());
t.start();
```

`start()`方法将会开启一个线程，并**自动调用**`run()`方法，执行相应的任务命令。

注意：`main()` 方法本身就是一个线程——主线程（**这意味着可以在任何一个线程中，启动另一个线程**）。

**线程调度机制存在不确定性**，即不确定线程将会分配给哪一个处理器运行（如果有多个处理器的话）、哪一个线程会优先执行，即使在程序上以先后顺序排列，如果希望让线程调度有优先级或者顺序，需要使用相应的数据结构或者自定义一套调度机制。

#### 1.3 Executors（执行器类）

虽然可以使用Thread类创建线程，然后将任务附着到线程上，由此实现线程的行为，但是每次都需要创建一个线程的操作着实很繁琐。

`java.util.concurrent` 中的执行器（Executors）类将提供管理Thread对象的方法，从而简化并发编程。Executors在客户端和任务之间提供了一个**间接层**，间接层创建的中介对象将会代替客户端执行任务，同时给予异步任务执行的管理方法，从而避免了显式管理线程的生命周期。

**推荐使用执行器类启动任务，而不是单独创建一个Thread对象。**

```
public class ExecutorTasks {
  public static void main(String[] args) {
    ExecutorService exec = Executors.newCacheThreadPool(); // 不限制线程数
    // ExecutorService exec = Executors.newFixedThreadPool(SIZE); // 限制线程数为SIZE
    // ExecutorService exec = Executors.newSingleThreadExecutor(); // SIZE=1的FixedThreadPool
    for(int i = 0; i < 8; i++) {
      exec.execute(new Task()); // 将新任务提交给执行器exec，每一个任务都会附着到一个新的线程上，然后将自动调用run()执行相应的任务（多线程）
    }
    exec.shutdown(); // 将会中止所有提交给exec的任务
  }
}
```

执行器将会通过创建**线程池**的方式，为提交的任务分配线程：

- `Executors.newCacheThreadPool()` ，创建的线程池将不限制分配的线程数量，不过当线程回收的数量大于新提交的任务数量，线程池将停止创建新线程，**Executors的首选**；
- `Executors.newFixedThreadPool(SIZE)` ，创建线程数量为SIZE的线程池，一次性完成线程池的创建，之后不再创建新的线程，如果提交的任务数量大于线程池中的线程数，那么将会在等待队列中（阻塞）等待回收的线程；
- `Executors.newSingleThreadExecutor()` ，线程数为1的线程池，适用于希望在另一个线程中**连续运行**的任务，比如监听进入的套接字连接的任务，也适用于线程中运行的**短任务**。同样，如果提交多个任务，SingleThreadExecutor将会序列化所有提交给它的任务，并回维护其（隐藏）的悬挂任务队列。

#### 1.4 “任务”的定义二（Callable）与Future对象

实现Runnable接口的任务只是执行任务的独立任务，没有返回值。

如果希望任务执行完毕后**有返回值**，那么需要实现**Callable接口** ，并将任务内容放置在`call()` 方法中，而且必须使用`ExecutorService.submit()` 方法提交任务。

```
class TaskCall implements Callable<String> {
  public String call(){ // Task Commands... }
}
public class TaskCallTest {
  public static void main(String[] args) {
  		ExecutorService exec = Executors.newCacheThreadPool();
  		ArrayList<Future<String>> res = new ArrayList<Future<String>>();
  		for(int i = 0; i < 8; i++) {
    		res.add(exec.submit(new TaskCall()));
  		}
  		// Do Something to res...
  		exec.shutdown();
	}
}
```

注意，方法`submit()` 的调用将会产生**Future对象**，Future对象将会以`call()` 方法的返回值作为类型参数，即上述代码段的`Future<String>` ，一般利用泛型容器保存。

#### 1.5 优先级

设置线程的优先级，可以将线程的重要性信息传递给线程调度器，以便线程调度器以**较高的频率**执行高优先级的线程。

有两点需要注意：

- “较高的频率”，也不能说明执行的顺序和时间；
- **优先级不会导致死锁**，只是低优先级的执行频率稍微少了一些。

不同操作系统中的优先级级别有些许差异，所以如果要使用优先级（没事尽量不要操作优先级，按照默认即可），尽可能使用三级优先级，即：`MAX_PRIORITY`、`NORM_PRIORITY`、`MIN_PRIORITY` 。

#### 1.6 让步

让步——`Thread.yield()`，即在完成任务之后，告诉线程调度器：我的工作已经完成，可以将资源分配给其他线程使用。但这只是“建议”，并不一定成功，所以对于重要性高的控制，不建议使用。

#### 1.7 后台线程（Daemon）

后台线程，即在程序运行的时候在后台提供的一种通用服务的线程，并**不属于程序不可或缺的一部分** 。所以，当所有非后台程序完成之后，程序也就终止了，同时将杀死所有的后台线程。

后台线程也是线程，**实现上唯一的区别**在于：需要在启动线程之前，调用`Thread.setDaemon(true)` 方法，将线程设置为后台线程。

#### 1.8 实现线程的几种常见方式

大体上分为**实现Runnable接口**和**继承Thread类**两种方式。实现Runnable的好处在于：可以同时继承其他类。

```
// 自管理的Runnable
class SelfManaged implements Runnable {
  Thread t = new Thread(this);
  public SelfManaged(){ t.start(); } // 构造方法中直接启动线程
  public void run() { // Do Somthing... } // 使用Thread类继承的方式，也需要提供run()方法
}

// 如果内部类中具有在其他方法中需要访问的特殊能力或特殊方法，那么使用内部类实现线程具有意义

// 命名内部类方式
class NamedInner {
  private class Inner extends Thread {
    Inner(String name){
      super(name);
      start(); // 在命名内部类的构造方法中直接启动线程
    }
    public void run() { // Do Something... }
  }
}

// 匿名内部类方式
class AnonymousInner {
  public AnonymousInner(String name) {
    Thread t = new Thread(name){
      public void run(){ Do Something... }
    };
    t.start();
  }
}

// 命名Runnable接口方式
class NamedRunnable {
  private class Inner implenments Runnable { // 这里可以继承其他类
    Thread t;
    public Inner(String name){
      t = new Thread();
      t.start();
    }
    public void run() { Do Something... }
  }
}

// 匿名Runnable接口方式
class AnonymousRunnable {
  public AnonymousRunnable(String name) {
    Thread t = new Thread(new Runnable(){
      public void run() { Do Something... }
    },name); 
    t.start();
    // 即 new Thread(Runnable r, String s);
  }
}

// 在自定义的方法中创建线程（仅作为类的一个方法，当该方法被调用的时候才会创建线程）
class SelfDefined {
  private String name;
  public SelfDefined(String name) { this.name = name; }
  public void runTask() {
    Thread t = new Thread(name){
      public void run() { Do Something... }
    };
    t.start();
  }
}
```

#### 1.9 ThreadFactory接口

即线程工厂，利用工厂设计模式，与线程池配合使用，用于创建线程和设置所创建线程的行为。ThreadFactory接口只有一个方法`newThread()`，其用法经常如下：

```
class SimpleThreadFactory implements ThreadFactory {
   public Thread newThread(Runnable r) {
     return new Thread(r);
   }
 }
```

#### 1.10 线程的异常捕获

JVM的设计理念来源于：**线程是独立执行的代码片段，线程的问题应该由线程自身解决**。

所以，Java中所有线程都不能捕获从线程中逃逸的异常，必须由线程自己处理，否则就会直接将异常打印在控制台上。

可以使用**Thread.UncaughtExceptionHandler接口** ，该接口允许在每个Thread对象上附着一个异常处理器，相应的方法`Thread.UncaughtExceptionHandler.uncaughtException()` ，将会在线程因未捕获的异常而临近死亡的时候调用，从而捕获线程中出现的异常。

```
// 实现 UncaughtExceptionHandler接口，并提供uncaughtException()方法的内容
class MyUncaughtExceptionHandler implements Thread.UncaughtExceptionHandler {
	public void uncaughtException(Thread t, Throwable e) {
      	System.out.println("Caught" + e);
	}
}
// 利用 ThreadFactory接口，创建线程
class HandlerThreadFactory implements ThreadFactory {
  	public Thread newThread(Runnable r) {
      	Thread t = new Thread(r);
      	t.setUncaughtExceptionHandler(new MyUncaughtExceptionHandler()); // 将上述实现的异常处理器，绑定到当前线程对象上
      	// t.getUncaughtExceptionHandler(); //返回实现UncaughtExceptionHandler接口的对象信息
      	return t; // 该方法返回一个线程对象
  	}
}
public class UncaughtExceptionTest {
  	public static void main(String[] args) {
      	ExecutorService exec = Executors.newCacheThreadPool(new HandlerThreadFactory()); // 将线程对象作为参数传给线程池，也即让线程池创建并提供该类线程，之后提交的任务都将由这类线程驱动处理，由此便可捕获任务执行过程中出现的异常
      	exec.excute(new Task());
      	TimeUnit.MILLISECONDS.sleep(1000);
      	exec.shutdown();
  	}
}
```

如果你希望在代码的所有位置使用相同的异常处理器，那么可以简单一点——在Thread类中设置一个静态域，并将某个异常处理器设置为**默认的未捕获异常处理器** ：

```
Thread.setDefaultUncaughtExceptionHandler(new MyUncaughtExceptionHandler());
```

#### 1.11 线程状态

一个线程可以处于以下四种状态之一：

- 新建（New），线程被创建，分配资源，执行初始化，有机会获取CPU时间片，接下来转入就绪或者阻塞状态；
- 就绪（Runnable），该状态下，只要调度器将CPU时间片分配给线程，线程就能运行；
- 阻塞（Blocked），线程由于某种条件，即使获得了时间片也不能运行，所以调度器不会给这种状态下的线程分配时间片，接下来可能保持阻塞状态，或者转入就绪或死亡状态；
- 死亡（Dead），由于任务完成或者中断，线程将会死亡，再也不可调度。

线程进入阻塞状态的原因：

- 调用`sleep()`方法，线程休眠；
- 调用`wait()`方法，线程挂起，需要等待`notify()`或`notifyAll()`的消息通知；
- 等待I/O；
- 试图访问具有同步控制的内容，但是暂时没有获得相应的对象锁。

#### 1.12 中断

如果希望停止一个任务或杀死一个线程，可以中断它。

最好的方式是，使用执行器类Executors创建线程，然后在最后使用`Executors.shotdown()` ，一次性地发送`intertupt()`给执行器对象创建的所有线程，由此关闭由其创建的所有线程。

如果希望**关闭单一线程**，那么在线程启动的时候，不使用`Executors.execute()` ，而是选择`Executors.submit()` ，该方法将会返回一个泛型Future<?>，然后在需要关闭的时候，使用之前获得的泛型对象`Future<?>.cancel()` ，中断任务。

其中，**I/O和synchronized同步控制块的阻塞是不可中断**的（所以这两者都不需要任何的InterruptedException处理器），但是可以利用**关闭其底层资源**的方式，强行中断任务。

可以通过`Thread.interrupted()` 检测当前线程是否被中断，即`interrupt()` 是否被调用了，同时将中断状态清除。

### 2 共享有限资源

> 你永远不知道一个线程何时在运行，也不知道一个资源是不是正在被占有。

基本上所有的并发模式在解决线程访问共享资源的冲突问题时，都是采用**序列化共享资源的**方案——意味着在给定时刻只允许一个任务访问共享资源。一般使用**锁语句**产生一种互相排斥的效果——即**互斥量**的机制。

#### 2.1 synchronized

关键字synchronized将会提供**最基本但也是最通用**的线程同步机制，防止访问共享资源时的线程冲突。

当任务要执行被synchronized修饰的代码片段的时候，将首先检查该片段的锁是否可用，然后获取锁，执行代码，最后将该片段的锁释放，以供其他任务使用。

**共享资源的访问控制**：

- 首先，需要将其包装进一个对象，并将其声明为**private** （使其只能通过类方法访问）；
- 其次，将**所有可能访问**该资源的方法用synchronized修饰（**Brains同步规则**）。

**所有对象都自动含有单一的锁（也成为监视器）。**

当在对象上调用**其**任意synchronized修饰的方法的时候，此对象都会被加锁，**对象所有的synchronized方法共享同一个锁**，只有当该对象的锁被释放之后，其他的synchronized方法才能调用该对象。

**每一个类也有一个锁**——使用**synchronized static**修饰的方法可以在类的范围防止对**static数据**的并发访问。

#### 2.2 显式Lock对象

`java.util.concurrent.locks` 提供了显式的互斥机制——Lock对象必须显式地创建、锁定和释放。

```
private Lock lock = new ReentrantLock();
...
lock.lock(); // 尝试获取锁，会一直阻塞直到拿到
// lock.tryLock(); //尝试获取锁，一段时间还拿不到就放弃
// 需要同步的部分
lock.unlock();
```

通常只有在解决特殊问题的时候，才会使用显式的Lock对象，一般都使用synchronized关键字，比如，追求更细粒度的控制，显式Lock对象在加锁和释放锁方面，粒度更细，这在实现专用同步结构上很有用，可用于锁耦合等功能。

#### 2.3 临界区

很多情况下，只是希望防止多个线程同时访问方法内部的**部分**代码，而不是防止访问整个方法。因此，将**需要设置同步机制的代码段分离出来，称为临界区**。

临界区可以使用synchronized修饰——**同步控制块**，同步控制块的synchronized用于指定某个对象，此**对象的锁用来对花括号内的代码进行同步控制** （要进入临界区，必须获取同步控制块对象的锁）：

```
synchronized(syncObj) {
  	// 同步控制块中的代码内容，只有拥有syncObj对象的锁的任务才能访问和调用
}
```

同步控制块，可以使多个任务访问对象的时间性能得到明显提高。

同步控制块必须给定一个在其上进行同步的对象，其中最合理的方式是使用正在调用该方法的对象，即：

```
synchronized(this) { // ... }
```

如果在this上进行同步，临界区将会直接缩小在同步的范围内，即**修改的临界区只是正在同步的对象的临界区** ，也就是意味着，可以将this换成其他的对象，那么当使用同步控制块的时候，修改的临界区将会是其他对象的临界区（？）。

两个任务可以同时进入同一个对象，只要这个**对象上的方法是在不同的锁上同步**即可。

#### 2.4 线程本地存储 

除了加锁之外，避免在共享资源上产生冲突的方式还有**根除对变量的共享**——线程本地存储。

线程本地存储是一种自动化机制，可以为使用相同变量的每个不同的线程都创建不同的存储，该机制可以将状态和线程关联起来。

`java.lang.ThreadLocal`类负责创建和管理线程本地存储。

```
private static ThreadLocal<Integer> value = new ThreadLocal<Integer>() {}
```

利用ThreadLocal对象当作静态域存储。**ThreadLocal保证不会出现竞争条件**。

每个线程都会分配自己的存储，维护和跟踪ThreadLocal对象。

#### 2.5 死锁

死锁，即任务之间相互等待的连续循环，谁都得不到锁，谁都处于阻塞状态。

防止死锁，在于程序设计的仔细。

**死锁的四个条件**（只有同时满足，才会死锁，也就意味着，破坏任意一个条件，就可以避免死锁）：

- 互斥条件，任务使用的资源中至少有一个是不能共享的，才会在同时访问时出现冲突；
- 至少有一个任务必须先持有一个资源，然后正在等待获取另一个资源，而这个资源当前正被其他任务所持有；
- 资源不能被任务抢占，即任务都会按照顺序，“礼貌”地释放和获取资源；
- 必须有循环等待。

#### 2.6 内置同步的类库

##### 2.6.1 CountDownLatch

同步一个或者多个任务，强制先完成的任务等待其他任务的完成。

最初，需要给CountDownLatch对象设置一个计数值，任何在CountDownLatch对象上调用`await()` 方法都会阻塞，直至计数值减至0，任何任务都可以在完成任务后通过CountDownLatch对象调用方法`countDown()` 减少计数值。

需要同步的任务，需要使用同一个CountDownLatch对象，同一个CountDownLatch对象的计数值只能被**初始化一次** （希望重置计数器的，可以使用CylicBarrier）。

```
CountDownLatch latch = new CountDownLatch(SIZE);
...
latch.countDown();
...
latch.await();
```

##### 2.6.2 CylicBarrier

与CountDownLatch的功能相同——一组任务并行工作，先完成的任务需要等待其他任务完成之后，才能继续一起前进。

只不过CountDownLatch只能触发一次事件（同一个CountDownLatch对象的计数值只能初始化一次），而CylicBarrier可以多次重用（可以重置计数值）。

```
class Task implements Runnable {
  	//...
  	private static CylicBarrier barrier;
  	public void run() { 
  		// 每个任务需要完成的工作
  		barrier.await(); // 在所有其他任务完成之前，挂起当前任务
  	}
}
public class TaskBarrier {
	private CylicBarrier barrier;
	private List<Task> tasks = new ArrayList<Task>();
	private ExecutorService exec = Executors.newCacheThreadPool();
  	public TaskBarrier(int taskNum, int pause) {
      	barrier = new CylicBarrier(taskNum,new Runnable() {
          	public void run() {
              	// 栅栏的动作将定义在这里
              	// ...
              	// 同时，应该将栅栏动作的停止定义在这里，当满足相应条件时：
              	exec.shutdown();
              	return;
          	}
      	});
      	// 初始化、并启动所有任务
      	// 如果所有任务都完成了，栅栏动作将会执行，并判断是否达到了最终的条件，如果不满足，会再次执行以下代码段（而CountDownLatch只能执行一次）
      	for(int i = 0; i < taskNum; i++) {
          	Task task = new Task(barrier);
          	tasks.add(task);
          	exec.execute(task);
      	}
  	}
  	public static void main(String[] args){...}
}
```

CylicBarrier中的Runnable接口`run()` 方法所定义的栅栏动作，将会在所有的任务都完成之后，**自动执行** ，之前所需要做的，就是在创建任务对象的时候，将CylicBarrier对象作为参数传入任务对象的构造器中。

##### 2.6.3 DelayQueue

**DelayQueue = BlockingQueue + PriorityQueue + Delayed**

DelayQueue是一个无界的BlockingQueue，用于放置实现了**Delayed接口**的对象，利用延迟时间作为优先级比较的标准。队列中的对象只能在其到期时才能被取出队列。所以，DelayQueue是有序的：队列头对象的延迟到期时间最短，将会被最先处理。

既然是有序的，那么DelayQueue就需要提供比较的方法——实际上，Delayed接口继承了Comparable接口，所以在DelayQueue中需要实现`compareTo()` 方法，提供合适的比较方式。

##### 2.6.4 PriorityBlockingQueue

优先级阻塞队列，提供可阻塞的读取操作。

同样需要提供比较方式的实现。

##### 2.6.5 SchedualedThreadPoolExecutor

提供让任务在特定时间运行的功能。

```
// 创建线程池
SchedualedThreadPoolExecutor s = new SchedualedThreadPoolExecutor(SIZE);
// 只在特定时间运行一次
s.schedual(Runnable r, long delay, TimeUnit.MILLISECONDS);
// 周期性运行
s.schedualAtFixedRate(Runnable r, long delay, long period, TimeUnit.MILLISECONDS);
```

##### 2.6.6 Semaphore

即信号量，允许n个任务同时访问同一资源，而锁机制在某个时刻只允许一个任务访问同一资源。

此外，信号量还可以看作是在向外分发资源使用的“许可证”（尽管根本不存在“许可证”），拥有“许可证”就可以访问资源。

```
private Semaphore access = new Semaphore(int size, boolean flag); // flag = true，表示使用Semaphore
// 获取信号量的许可证
access.acquire();
// 释放信号量的许可证
access.release();
```

##### 2.6.7 Exchanger

**两个任务之间交换对象的栅栏** ：当两个任务进入栅栏的时候，它们各自拥有一个对象，然后它们相互交换所持有的对象，最后他们各自离开。

应用场景为：一个任务在创建对象，对象的生产代价很高，另一个对象在消耗对象，于是**希望在对象创建的同时将其直接消耗掉**。

```
private Exchanger<List<T>> exchanger;
// 需要双方使用相同的Exchanger对象，调用exchange()方法，才能实现对象的交换
exchanger.exchange(producerHolder);
exchanger.exchange(ConsumerHolder);
```


### 3 线程协作

加锁提供的互斥量，可以实现多任务对共享资源的同时访问。而要想让多任务可以一起解决某个问题，则需要线程之间的协作。

线程协作，关键在于**任务之间的握手**。由于互斥机制确保只有一个任务可以响应某个信号，可以根除任何可能的竞争条件，所以线程协作首先要基于互斥机制，然后在之上，线程协作为任务添加了一种能力：**在外界条件不满足的情况下，将自身暂时挂起，等待外界条件满足之后，由外界通知其继续执行**。

综上，任务之间的握手，也即：**Object（而不是Thread）的方法`wait()`和`notify()/notifyAll()`** 或**Condition对象的 `await()`和`signal()/signalAll()`** （Conditon对象只在更加困难的多线程问题中才是必须的）。

#### 3.1 `wait()`与`notify()/notifyAll()`

`wait()` 为当前任务提供了**将自身挂起**的能力，以等待外界某个条件变化以满足自身的要求，当外界条件满足之后，一般通过**在其他任务的同步控制块中获取相应的对象的锁**，然后调用`notify()/notifyAll()` 通知之前被挂起的任务，让其继续工作。

**调用`sleep()`和`yield()` 的时候锁并没有释放。**

**调用`wait()` ，线程的执行被挂起，同时对象的锁被释放。** 允许该对象的其他synchronized方法在此期间被调用，以生成被挂起线程所需的条件（即在`wait()` 释放锁之后，需要有人获取所释放的锁，然后完成相应的任务，否则挂起的任务将永远不会被唤醒）。

**只能在同步控制方法或同步控制块中调用`wait()`与`notify()/notifyAll()`** ，因为这些方法之间的消息机制要求在调用这些方法的时候拥有（获取）对象的锁。

特定条件的检测，一般会放在`while` 循环中：

```
synchronized(obj) { // obj 常用 this 代替
  	while(condition) {
      	obj.wait(); // 或者直接写 wait()
  	}
}
```

本质即，检查所感兴趣的特定条件，在条件不满足的情况下返回到`wait()` 中。将条件的检测包裹在`while`中，并放进 同步控制块中，这样每一个启动的线程就会不断检测特定条件，**避免信号的错失**。

如果希望使用同一时刻只能唤醒一个任务的方法`notify()` 时，必须保证唤醒特定的任务——**一般会获取被挂起任务的对象，然后用该对象调用`notify()`** 。

由于不知道有多少个任务被挂起了，它们可能都在等待相同的条件，所以最好在条件满足的时候，调用`notifyAll()`  方法，一次性摆平它们。如果想单独唤醒其中一个任务，也可以**单独使用某个对象调用`notifyAll()` 方法** ，就可以单独之前释放该对象的锁的任务。

```
synchronized(obj) {
  	obj.notifyAll(); // 将单独唤醒 传入对象obj 对应的挂起任务
}
```

#### 3.2 生产者与消费者

生产者与消费者模型是多线程中很重要的模型，贯穿多线程的线程分配与回收过程以及消息机制。

```
// 一个饭店，一个厨师和一个服务员，服务员必须等待厨师准备好菜品，厨师准备好时会通知服务员，服务员把菜品端走，再次等待下一道菜品
// 即厨师是生产者，服务员是消费者，菜品是他们之间交互的信息
class Meal {
  	private final int orderNum;
  	public Meal(int num) { orderNum = num; }
  	public String toString() { return "Meal" + orderNum; }
}
// Consumer
class Waiter implements Runnable {
  	private Restaurant restaurant;
  	public Waiter(Restaurant r) { restaurant = r; }
  	public void run() {
    	try{
          	while(!Thread.interrupted()) {
          		synchronized(this) {
              		while(restaurant.meal == null) {
                  		wait(); // 等待厨师将菜品做好
              		}
              		// 线程将会在上面的 wait() 挂起，直到条件满足（菜品做好并通知），才能继续执行以下代码
              		System.out.println("Waiter got meal: " + restaurant.meal);
              		synchronized(restaurant.chef) {
                  		restaurant.meal = null;
                  		restaurant.chef.notifyAll(); // 通知厨师，菜品已经端走，可以准备下一道菜了
              		}
          		}
    		}
    	}
    	catch(InterruptedException e) { System.out.print("Interrupted!"); }
  	}
} 
// Producer
class Chef implements Runnable {
  	private Restaurant restaurant;
  	private int count = 0;
  	public Chef(Restaurant r) { restaurant = r; }
  	public void run() {
      	try{
          	while(!Thread.interrupted()) {
              	synchronized(restaurant.chef) {
                  	while(restaurant.meal != null) {
                      	wait(); // 说明上一道菜还没上，那就不做下一道菜
                  	}
              	}
              	// 除非wait()等到了相应的条件，否则保持挂起，不执行下面的代码
                if(++count == 10) {
                	System.out.println("Time for resting...");
                	restaurant.exec.shutdown();
                }
                System.out.println("New Meal is ready!");
                synchronized(restaurant.waiter) {
                	restaurant.meal = new Meal(count);
                	restaurant.waiter.notifyAll();
                }
                //TimeUnit.MILLISECONDS.sleep(1000);
          	}
      	}
      	catch(InterruptedException e) { System.out.println("Interrupted!"); }
  	}
} 

public class Restaurant {
  	// 在Restaurant中声明 Meal Waiter Chef，这样Restaurant对象就可以调用这些对象，访问他们的方法和状态
  	Meal meal;
  	Waiter waiter = new Waiter(this); // 用this作为参数，即将当前的Restaurant对象作为参数传给 Waiter 和 Chef，之后就可以使用 resraurant.waiter 调用
  	Chef chef = new Chef(this);
  	ExecutorService exec = Executors.newCacheThreadPool();
  	public Restaurant() {
      	exec.execute(waiter);
      	exec.execute(chef);
  	}
  	public static void main(String[] args) {
      	new Restaurant();
  	}
}
```

注意：

- 需要将同步控制块放在try语句中，以便出现异常可以抛出，在深入一点可以实现Thread.UncaughtExceptionHandler接口，提供自定义的异常捕获机制；
- 这只是个简单的生产者消费者模型，具体更复杂的模型最好使用**先进先出队列**实现。

#### 3.3 同步队列

`java.util.concurrent.BlockingQueue` 中提供了同步队列的实现，包括**LinkedBlockingQueue（无界队列）** 、**ArrayBlockingQueue（固定尺寸）** 以及**SynchronousdQueue**。

使用了同步队列对任务进行存储、排队和取出，就可以忽略同步问题（不使用synchronized或者Lock对象）。

#### 3.4 线程与管道

Java以“管道”的形式，为线程之间的I/O提供了支持——**PipedWriter类（允许任务向管道写）**、**PipedReader类（允许不同的任务从同一管道中读）**。

**管道本质上就是一个阻塞队列。**

PipedReader的建立必须在其构造器中与一个PipedWriter相关联，当管道中没有数据时，读取操作将会阻塞，同时PipedReader是可中断的（而标准I/O是不能中断的）。

### 附：

#### 1 进程与线程

进程是实现并发最直接的方式——操作系统级别。进程是运行在进程自身的地址空间内的**自包容**程序，多任务操作系统可以通过周期性地将CPU从一个进程切换到另一个进程，实现同时运行多个进程（程序），操作系统可以将进程之间相互隔离，即**进程之间不共享资源、不相互干涉**。

线程则是在由执行程序表示的单一进程中创建的任务（可以理解为在进程中创建多个线程），**线程机制的好处：操作系统的透明性**，即不依赖与操作系统底层的具体实现，所编写的多线程并发程序可以运行在不同的操作系统上。但是，线程实现的并发需要共享一个进程所提供的资源，包括内存、IO等，所以多线程并发编程中，最基本的挑战在于如何协调不同线程所驱动的任务之间的**资源共享问题**，避免同一资源在同一时刻被多个任务访问。

由于彼此之间的独立性，进程之间没有通信的需要，操作系统将会处理文件的细节。但是，进程的使用却有数量和开销的限制，以确保基于进程的并发系统的可应用性，毕竟进程与操作系统相关。

#### 2 休眠

`java.util.concurrent.TimeUnit` 类提供了多线程中常用的**延时**和**时间颗粒度转换**的实用方法。

```
TimeUnit.MILLISECONDS.sleep(10000);
/*
TimeUnit.DAYS          //天
TimeUnit.HOURS         //小时
TimeUnit.MINUTES       //分钟
TimeUnit.SECONDS       //秒
TimeUnit.MILLISECONDS  //毫秒
*/
```

#### 3 `join()`

```
class Sleeper extends Thread {
  public void run(){}
}
class Joiner extends Thread {
  private Sleeper sleeper;
  public void run() {
    sleeper.join(); // Joiner线程将会被暂时挂起，直到Sleeper线程完成任务，才会轮到Joiner线程
    ...
  }
}
```

#### 4 原子性和可视性

- 原子性

**“原子操作不需要进行同步控制”，这是错误的。**

虽然**原子操作是不能被线程调度机制中断的操作**，但是由于JVM机制的问题，可能会出现“字撕裂”的情况（特别是对long/double类型数据的读写情况），造成数据不一致。

- 可视性

一个任务做出的修改，即使在不中断的意义上是原子性的，但对其他任务可能是不可视的，即**不同的任务对应用的状态拥有不同的视图**。

在处理器系统中，同步机制强制一个任务做出的修改必须在应用中是可视的，即**同步机制保证了可视性**，从而保证了数据的一致性。

此外，**volatile** 关键字也可以保证可视性，即若一个域用volatile修饰，则只要对该域产生写操作，那么所有的读操作都可以看到该修改。即使一个任务的修改暂存在本地缓存中，**volatile域也会立即写入主存中**（读操作将会访问主存）。

综上：

- 在非volatile域中的原子操作不会立刻刷新到主存中，因此其他读取该域的任务也不会看到新修改的值，但是**对于本任务来说，任何修改都是实时可视的**；
- 若希望多个任务能够同时读取到某个域修改后的值，那么这个域需要使用volatile修饰；
- 如果不使用volatile修饰，也可以使用同步机制（比如synchronized）实现可视性，但是**同步机制与volatile不能同时使用**；
- 使用volatile唯一安全的情况是，类中仅有一个可变的域，而且该域的值不依赖于它之前的值（比如递增就会产生依赖）；
- 同步机制优先选择，除非很熟练；
- volatile修饰的域，可以告知编译器对该域不进行优化。

#### 5 原子类

`java.util.concurrent.atomic`中，具有AtomicInteger、AtomicLong、AtomicReference等特殊的原子变量类，在涉及优化时比较有用。

#### 6 免锁容器 

即对容器的修改可以与读取操作同时发生，只要**读取者只能看到完成修改的结果**即可。

所以，免锁容器将会为修改内容提供一个副本，这个副本在修改完成之前是不可视的，只有修改完成之后才会自动地并入原内容中。所以，读取操作获得的实际上是原内容（不包括正在修改的副本内容），也因此，读取的内容可能不是实时的修改结果。

```
CopyOnWriteArrayList
CopyOnWriteArraySet
ConcurrentHashMap
ConcurrentLinkedQueue
```

#### 7 活动对象 

每个对象都将维护自己的工作器线程和消息队列，并且所有对活动对象的请求都将进入队列排队，任何时刻都只能运行其中的一个——为**串行化消息**提供了方法。

代理编程，也即对活动对象的编程。