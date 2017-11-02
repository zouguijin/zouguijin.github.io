title: Java进阶概念

date: 2017/10/25 18:00:00

categories:

- Study

tags:

- JavaAdvanced

---

## Java进阶概念

>介绍Java的一些进阶概念和内容。

### 回调机制

在应用开发中，特别是模块开发中，经常存在模块之间的调用，其中调用的方式有：

- 同步调用

  A的方法a()调用B的方法b()，一直等待b()方法完成后，a()才会继续往下走。

  这种调用方式适用于方法b()执行时间不长的情况，否则会引起a()的阻塞。

- 异步调用

  类A的方法方法a()通过新起线程的方式调用类B的方法b()，代码接着直接往下执行。

  异步调用是为了解决同步调用可能出现阻塞，导致整个流程卡住而产生的一种调用方式。但是这种方式，由于方法a()不等待方法b()的执行完成，在方法a()需要方法b()执行结果的情况下（视具体业务而定，有些业务比如启异步线程发个微信通知、刷新一个缓存这种就没必要），必须通过一定的方式对方法b()的执行结果进行监听——在Java中，可以使用Future+Callable的方式做到这一点。

- 回调

  首先，类A的a()方法调用类B的b()方法；然后，类B的b()方法执行完毕后，主动调用类A的callback()方法，将结果返回给A。

  所以回调机制中，既不需要等待，也不需要监听，只需要一个回调接口并让A实现该接口，然后在B中利用接口对象调用A中所实现的接口方法即可。

---

### Spring  AOP基本概念

- 通知、增强处理（Advice）：指你所需要的功能，也就是业务逻辑之外的安全、事务、日志等。需要事先定义好，然后再在想用的地方用一下。（包含Aspect的一段处理代码）
- 连接点（JoinPoint） ：指spring允许你设置通知（Advice）的地方，基本上每个方法的前、后（两者都有也行），或抛出异常时都可以是连接点，spring只支持方法连接点。其他如AspectJ还可以在构造器或属性注入时设置连接点，只要记住，**和方法有关的前前后后都是连接点**。
- 切入点（Pointcut）：在连接点的基础上，可以进一步定义切入点，一个类里可能会有十几个方法，那就会相应的有十几个连接点，但是可能你并不想在所有方法的附近都使用通知（使用的时候叫织入，见下），你**只是想在其中的几个连接点使用通知**，在调用这几个方法之前、之后或者抛出异常时干点什么，那么就用切入点来定义这几个方法。
- 切面（Aspect）：通知和切入点的结合，通知说明了干什么和什么时候干（什么时候通过方法名中的befor，after，around等就能知道），而切入点则是为了说明在哪干（指定到底是哪个方法）——即Advisor（通知器），将通知和切入点相结合。
- 引入（Introduction）：允许我们向现有的类中添加新方法属性。即，将切面（也就是新方法属性：通知定义的）添加到目标类中。
- 目标（Target） ：即目标类，就是要被通知的对象，也就是真正需要处理的业务逻辑。目标类可以在毫不知情的情况下，被织入切面，即添加新功能，而目标类本身只需要专注于业务逻辑本身即可。
- 代理（Proxy）：整套AOP机制都是通过代理来实现的。
- 织入（Weaving）：指把切面应用到目标对象中来创建新的代理对象的过程。织入有三种方式，spring采用的是运行时织入。
- 目标对象：项目原始的Java组件。
- AOP代理：由AOP框架生成Java对象。
- AOP代理方法 = Advice + 目标对象的方法。

---

### Spring  AOP的两种代理模式

- 实现与目标类相同的接口（兄弟模式）

  基于反射机制，Spring使用JDK的java.lang.reflect.Proxy类，动态生成一个新的类实现目标类的接口，并在新类中织入相应的通知，之后对于该接口的调用都将转发给目标类进行处理；

  `Proxy.newProxyInstance(classLoader, proxiedInterfaces, this);`

  `this` 对应InvocationHandler对象——JDK定义的反射类接口，该接口定义`invoke()` 方法——`invoke()` 方法是代理对象的回调方法——拦截的时候将会调用`invoke()` 方法，通过该方法的具体实现可以为目标对象方法织入切面。

- 生成子类的调用（父子模式）

  Spring使用CGLIB库生成目标类的一个子类，并在创建子类的时候织入通知，之后对于目标类的调用都将转发给子类处理。

  `Callback aopInterceptor = new DynamicAdvisedInterceptor(this.advised);`

  在CGLIB的回调中，AOP的实现是通过DynamicAdvisedInterceptor拦截器来完成的——回调的入口为`intercept()` ——在该方法中，将会通过CglibMethodInvocation启动advice通知。

---

### Spring  AOP拦截与拦截器的调用

虽然AOP有两种代理模式，但是AOP对于拦截器链的调用都是在ReflectiveMethodInvocation中由`proceed()` 方法实现的——`proceed()` 方法将在**匹配**代理方法之后，会逐个运行拦截器的拦截方法——`proceed()` 将会迭代进行，直到拦截器链中的拦截器都完成拦截过程为止。

如何获取拦截器？当然是先获取拦截器链了。那么如何获取拦截器链？——通过`advised` 对象完成：

`List<Object> chain = this.advised.getInterceptorsAndDynamicInterceptionAdvice(method, targetClass);` 

该方法的调用会实际调用`advisorChainFactory` 的同名方法：

`List<Object> cached = this.advisorChainFactory.getInterceptorsAndDynamicInterceptionAdvice(this, method, targetClass);` 

在上述方法中，将会完成拦截器的适配和注册。

**具体的实现**是，上述方法将关于通知的配置信息`Advised`由参数对象的方式（应该就是`this`）从外传递方法内——通过`advised.getAdvisors()` 方法提取相应的通知器Advisor——由GlobalAdvisorAdapterRegistry的单例对象调用`getInterceptors()` 方法从通知器Advisor中提取出通知本身Advice——由实现了AdvisorAdapter接口的类对通知Advice进行适配（即判断该通知是需要织入在目标方法之前还是之后还是ThrowAdvice，该过程会有相应的正则匹配），在适配的过程中，将把通知封装入对应的拦截器中，从而完成通知的适配和注册——之后调用目标方法的时候，将会回调拦截器，并在拦截器中完成通知的增强功能和原方法的功能。

---

### 事务处理

ACID属性：

- 原子性（Atomicity）
- 一致性（Consistancy）
- 隔离性（Isolation）
- 持久性（Durability）

---

### Spring 事务处理

- TransactionProxyFactoryBean

  使用AOP生成Proxy代理对象。

- TransactionInterceptor

  事务拦截器，用于切面增强的织入。

- AbstractPlatformTransactionManager

  适配和管理多种不同的底层数据库。

#### 声明式事务

从Spring的角度可以这么看：

- 准备阶段

  为事务处理配置好AOP的基础设施（Proxy代理对象和拦截器对象）——读取事务属性配置（由TransactionInterceptor完成）——完成事务处理的准备工作。

- 事务处理阶段

  - TransactionInfo对象

    类似于一个栈，对应于每一次事务方法的调用（事务的创建与提交），保存着每一次事务方法调用的事务处理信息，通过与线程的绑定实现事务的隔离性（与线程的ThreadLocal变量进行绑定）。

  - TransactionStatus对象

    也是TransactionInfo对象的一个属性，管理着事务执行的详细信息，包括具体的事务对象、事务执行状态、事务设置状态等。

  - TransactionManager

    事务具体的处理，包括创建（Begin）、提交（Submit）、挂起（Suspend）、回滚（Rollback）等具体处理动作，都使用TransactionManager下具体的事务处理器完成的，比如DataSourceTransactionManager和HibernateTransactionManager等。

#### 编程式事务

编程式的事务处理看上去显得较为简单：

- TransactionDefinition

  持有事务的属性。

- TransactionStatus

  保存事物的状态。

- TransactionManager

  管理事务的具体处理过程，包括提交和回滚。

其中，不像声明式事务一样，在初期有复杂的准备工作（需要准备阶段的各种配置和读取操作），但是正因为与AOP结合使用，正因为将事务的配置和处理过程与应用业务逻辑分离，才完成了应用与具体数据源之间的解耦，反观编程式事务处理，虽然初期简单，但是却容易在持续的开发中导致事务处理与业务逻辑的紧耦合。

---

### 关于JDBC的一些概念

#### CURD

数据库的四大操作：

- Create，创建；
- Update，更新；
- Research，查询；
- Delete，删除。

#### JDBC与驱动

Java Database Connectivity，是标准的Java API，是一套客户端与数据库交互的规范，JDBC提供了一套通过Java操纵数据库的完整接口。

JDBC的实现，需要JDBC驱动程序支持，不同的数据库对应有着不同的驱动程序（对应的需要将不同的驱动Jar包导入项目中）。调用JDBC API的时候，JDBC将调用请求交给JDBC驱动，最终在驱动程序的作用下完成与数据库的交互，包括开启数据库连接、关闭数据库连接以及事务的控制。

#### JDBC API的重要接口与类

- DriverManager： 该类用来管理数据库驱动程序，当需要建立一个连接时，DriverManager将使用第一个满足要求的Driver来建立连接。
- Driver：该接口负责处理所有与数据库的交互。
- **Connection** ： 该接口表示一次数据库连接。**所有的数据库操作都是在一次数据库连接中进行的**，连接关闭后，将不能再进行数据库操作。
- **Statement**： 我们可以通过该接口**执行SQL语句**，并得到返回结果。
- ResultSet： 通过Statement执行查询语句后，我们将得到类型为ResultSet的返回结果。该结果是一个**迭代器**，存储了所有查询返回的数据。
- SQLException： 这个类处理的数据库应用程序中发生的任何错误。

JDBC默认将`auto-commit` 置为`true` ，这种情况下：

- Connection与Statement之间有一层Transaction（事务）；
- 一个Connection可以进行多个Transaction；
- 一个Transaction可以包含多条Statement；
- 每一条Statement都是一个Transaction。

一般不建议每次CRUD的时候都建立新的Connection（Connection占用底层资源，比如Socket，所以需要限制Connection的数量），也不建议使用共享的单例Connection（不应该在多个线程之间共享Connection，可能会导致效率的下降和线程安全性问题）。

所以，**每个线程应该使用独立的Connection，但在线程之内共享同一个Connection**——最简单的实现是：创建一个Connection，将其与一个线程绑定，并将该Connection的引用存放在该线程的**ThreadLocal**变量之中，在线程结束时关闭Connection。

更好一点的实现是使用数据库连接池。

#### 数据库连接池

基本思想是，为数据库连接建立一个缓冲池，预先放入一定数量的连接Connection。当需要使用Connection的时候，直接从缓冲池中取出即可，使用完毕再将Connection放回缓冲池中。从而解决“重复且频繁地打开和关闭Connection”以及“Connection数量过多”带来的数据库和系统性能和稳定性下降的问题。

#### 简单的JDBC过程

```
onnection con = null;
Statement stmt ＝null;

try {
    // 1、加载MYSQL驱动，这是`Driver`的实现，MySQL的JDBC驱动类是com.mysql.jdbc.Driver
    Class.forName("com.mysql.jdbc.Driver").newInstance(); 

    // 2、连接到MYSQL，通过`DriverManger`来操作`Driver`，获取数据库连接
    con = DriverManager.getConnection("jdbc:mysql://127.0.0.1:3306/tianmayingblog", "root", ""); 

    // 3、创建用以执行SQL语言的声明
    Statement stmt = con.createStatement();

    // 4、执行SQL，获取结果
    ResultSet rs = stmt.executeQuery("select * from `user`");

    // 5、遍历并解析结果
    while (rs.next()) {
        long id = rs.getLong("id");
        // ...
    }
} catch (Exception e) {

    // 如果有异常，进行异常处理
    System.out.print("MYSQL ERROR:" + e.getMessage());

} finally {
    // 6、关闭连接与声明
    try {
        if (stmt != null) {
            stmt.close();
        }

        if (con != null) {
            con.close();
        }
    } catch (SQLException ignored) {

    }
}
```

---

### Hibernate

一个基于Java的对象/关系数据库映射工具——将对象模型表示的数据映射到SQL表示的关系模型。

Hibernate管理Java-数据库之间的映射关系，提供关于数据库的CURD等操作，简化了对于[数据持久化层](#DataPersistenceLayer)的编程任务。



---

### ORM与数据持久化

<span id="DataPersistenceLayer"></span>