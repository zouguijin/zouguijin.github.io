title: Java Design Patterns

date: 2017/11/22 10:00:00

categories:

- Study

tags:

- JavaAdvanced

---

## Java DesignPatterns

### 设计原则

>灵活变通，过犹不及。

#### 单一职责原则（SRP）

>接口的设计一定要满足单一职责原则，类的设计尽量满足单一职责原则。

单一职责原则（Single Responsibility Principle，SRP）：**应该有且只有一个原因引起类的变更**

——实现类通常是继承于其他类（抽象类或者上层类）或实现其他接口，因此，SRP的含义也即，尽量将**不同类别**的功能/方法，放在不同的父类或者接口中，比如业务对象的管理模块和业务逻辑的实现模块应该划分到不同的接口中。

但是，过于细致的划分，会带来过于庞大的类规模，所以在实际使用的过程中，也需要考虑SRP的使用程度和范围。

#### 里氏替换原则（LSP）

>避免子类的“个性”，将子类当做父类使用。维持程序的健壮性，保证升级时的兼容性。

里氏替换原则（Liskov Substitution Principle，LSP）：**只要是父类能出现的地方，子类就能出现，而且替换为子类也不会产生任何错误或异常**。

——因为有“**向上转型**”的保证，同时子类也拥有父类的所有属性和方法，同时，**LSP要求在调用其他类时，务必使用该类型的父类或者接口** （即使所使用的父类是抽象类，作为参数也是可以的，因为实际传参的时候，传入的是继承了抽象类的子类），否则说明类的设计违反了LSP。

**在继承的时候，需要考虑：子类是否能完整地实现父类的业务？** ——如果应用场景真的需要继承，且子类只能实现父类的部分业务，那么可以适当地将父类的业务进行**拆分**；或者断开继承关系，改用**依赖、聚合、组合等关系代替继承关系**。

契约设计（Design By Contact）的前置条件和后置条件：

- 前置条件：你要让我执行，就必须满足我的条件；
- 后置条件：我执行完毕，反馈（返回）的标准是什么。

在**满足LSP**的前提下，关于重载和重写，有：

- 重载（方法名相同，方法参数不同）：子类的输入参数范围宽于父类的输入参数范围——这样一来，子类重载的方法将永远不会被调用，而是会调用父类相应的方法；
- 重写（方法名相同，方法参数也相同）：方法参数相同，即前置条件相同，则子类方法的作用范围或返回值范围就需要小于父类的方法。

> Java中，一个变量可以拥有两种类型：
>
> 静态类型，也称为表面类型（也就是定义时赋予变量的类型，编译期确定）和实际类型（也就是变量实际的类型，运行期确定）。
>
> 实际类型可以通过适当的手段转化成静态类型，比如向上转型、强制转型等。

*（上述问题有什么想不通的，重新思考一次LSP就明白了）*

#### 依赖倒置原则（DIP）

>DIP可以减少类间耦合性，提高系统的稳定性，降低并行开发带来的风险，提高代码的可读性和可维护性。

依赖倒置原则（Dependence Inversion Principle，DIP）：

- 高层模块（业务场景类）不应该依赖低层模块（抽象类或者接口的实现类），不论是高层模块还是低层模块，都应该依赖其抽象（抽象类或接口）——**模块之间的依赖关系通过接口或者抽象类产生，实现类之间不发生直接的依赖关系**；
- 抽象不应该依赖细节（实现类）；
- 细节应该依赖抽象。

所以，依赖倒置原则又可以称为“**面向接口编程**”——既是面向对象设计的精髓，也是Spring框架设计的核心所在。

类之间的依赖关系，只要在确定类之间的接口或抽象类关系，各个类就可以独立并行开发。

其中，**测试驱动开发（TDD）**是DIP的高级应用模式：可以先写好单元测试类，然后再完成实现类的编写——这样就可以在开发的过程中，不断地利用测试类抽象虚拟出一个对象进行测试工作，确保实现类的编写不至于跑偏。

依赖关系可以传递，只要做到抽象依赖，就不用担心依赖关系在传递的过程中出现理不清的情况。

依赖关系的三种传递方式：

- 构造函数注入依赖——通过构造函数的参数，注入另一抽象类或者接口的对象；
- Setter方法注入依赖——在抽象类或接口中设置Setter方法声明依赖关系，实现类实现Setter方法的时候具体化方法内容即可完成依赖的注入；
- 接口注入依赖——简单地在接口的方法中注入依赖关系。

**如何做到DIP**：

- 每个类尽量都有接口或者抽象类——**接口**负责定义public 属性和方法，并用于声明与其他对象的依赖关系；**抽象类**则负责公共构造部分的实现；**实现类**在抽象类和接口的基础上，准确地实现业务逻辑，并在适当的时候对父类进行细化；
- 变量的表面类型尽量是接口或者抽象类——这样才能更好地通过依赖注入的方式传递参数；
- 任何类都不应该从具体类派生，而是应该由抽象类派生——即尽量让实现类的父类是抽象类，实在不行，也尽量不要让继承关系超过两层；
- 尽量不要重写基类的方法——因为DIP要求依赖通过抽象类或者接口进行传递；

DIP很关键，但是使用不应该影响项目开发的进度。

#### 接口隔离原则（ISP）

Java中的接口有两种：

- 实例接口：也即Java的类；
- 类接口：interface关键字定义的接口。

接口隔离原则（Interface Segregation Principle，ISP）所述内容的两种表达方式：

- 客户端不应该依赖它所不需要的接口；
- 类间的依赖关系应该建立在最小的接口上。

**接口隔离原则的本质**：尽量建立单一接口，不要建立臃肿庞大的接口——接口中的方法不要过多，尽量建立多个**专门**的接口，使得提供给每个模块使用的都是单一接口，而不是所有模块都使用同一个大接口。

**如何做到接口隔离原则**：

- 拆分、细化接口的时候，首先必须满足单一职责原则SRP——保证属于同一类/行使同一职责的方法不再继续拆分，同时也避免接口或者抽象类的过于庞大，避免复杂化与可维护性的提升；
- 保证接口的高内聚——即，提高接口、类、模块的自身处理能力，**减少与外界的交互**，具体到接口隔离原则就是，尽量减少对外公布public 方法（public方法尽量放在实现类中）；
- 如果接口的设计不合理，能改则改，不能改则使用**适配器模式**对其进行转化。

#### 迪米特法则（LoD）

>一个对象应该对其他对象有最少的了解。

迪米特法则（Law of Demeter，LoD），也成为最少知识原则（LKP）。

朋友类的定义：出现在A类成员变量、方法的输入参数中的类，称为A类的成员朋友类。

**LoD的本质**就是：做到类间低耦合——一个类的修改，对与之有关系的类的影响最小化，如此一来，才能让类的复用率得到提高。

**如何做到LoD**：

- 只与朋友类交互，如果可以，尽量断绝与其他类的关系；

- 保持与朋友类的距离，即尽量减少类的public属性或方法——如果确实需要外界调用本类的某些方法，也可以尝试将这些方法定义为私有并封装到本类的一个public方法中（Spring中经常会看见类似的操作），例如：

  ```
  // 之前
  public class LoDTest {
    public void m1() { //... }
    public void m2() { //... }
    public void m3() { //... }
  }
  // 之后
  public class LoDTest {
    private void m1() { //... }
    private void m2() { //... }
    private void m3() { //... }
    public void publicMethod() {
      this.m1();
      this.m2();
      this.m3();
    }
  }
  ```

- 如果一个方法放在自己的类中也不影响实现，那么就放在自己的类中；

- 谨慎使用序列化Serializable接口。

#### 开闭原则

>对扩展开放，对修改关闭。

**开闭原则的本质**：一个软件实体应该通过扩展来实现变化，而不是通过修改已有代码实现变化——并不意味不做任何修改，而是尽量少地修改。

开闭原则的作用：

- 有利于测试——只需要针对要测试的模块，新扩展相应的类就可以了；
- 提高复用性和可维护性——只要业务逻辑的颗粒度足够细，那么就可以在需要的时候，扩展新的模块即可使用，同时模块层次分明的设计有利于后期对各个模块的单独测试和维护。

**如何做到开闭原则**：

- 抽象约束——开闭原则的首要前提。

  抽象约束包含三个层次的内容：

  - 通过抽象类或者接口约束一组可能变化的行为，从而限制不存在于抽象类或接口中的public方法；
  - 参数类型、引用对象尽量使用抽象类或接口——让依赖关系在抽象类或接口之间传递（DIP）；
  - 抽象层尽量保持稳定——抽象类或接口谨慎定义，定义好了尽量不改动。、

- 元数据控制模块行为

  元数据，即描述环境和数据的数据，也称为配置文件。

  类似于Spring，在编写好模块代码之后，利用元数据（配置文件），就可以将模块与模块连接起来，而不用手动编写模块之间的连接代码。

- 封装变化——相同的变化封装在一个抽象中；不同的变化封装在不同的抽象中。

- 规范的项目章程与文档。

---

### 设计模式

#### 单例模式（Singleton）

>内存中只有该类的一个对象。

确保某一个类**只有一个实例对象**，而且**自行实例化**并向整个系统提供这个实例。

```
// 饿汉模式
public class Singleton {
  private static final Singleton singleton = new Singleton();
  private Singleton() { //.... }
  public static Singleton getInstance() { return singleton; }
  // 保证单例创建一次之后，在内存中是唯一的一个，之后调用即可，无需再次创建，也不允许修改
  // 由于static final对单例对象的修饰，即使在高并发场景下，也可以不用synchronized进行同步
  // 私有构造方法，不能让外界调用单例类的实例构造函数，确保类只有一个实例
  // 向外界提供一个获取单例类实例的public static方法——只能通过类名调用类方法
  ...
}
```

单例模式的优点：

- 适合只需要某类的唯一对象的场景——比如唯一序列号的生成器；
- 适合频繁性创建和销毁的对象——对象在内存中只占有一块内存，减少内存开支；
- **适合需要较多资源和配置才能生成的对象**——可以在应用启动/类加载时，通过单例类生成该对象，并让该对象常驻内存（`static final` 修饰），比如访问I/O和数据库的对象；
- 可以限制并发操作——当并发操作需要持有某个对象才可以进行时，比如写某个特定的文件，可以使用单例模式，创建单例对象，从而限制并发操作，避免对资源的多重占用；
- 同理，可以利用**单例作为全局共享的访问点**，从而优化数据和资源的共享访问——比如全局计数器等。

单例模式的缺点：

- 对扩展不友好——单例模式一般没有接口，若要扩展，只能修改单例类本身的代码；
- 对测试不友好——单例类没有编写完成，就无法拿到单例对象，自然无法测试，同理也是因为没有接口，所以不能使用mock方式虚拟类的对象进行测试；

单例模式的扩展——**有上限的多例模式**：

在原有的单例类中，增加一个私有`static final`的计数值，用于规定类实例的上限数量。

```
public class Singleton {
  private static final int MAX_SINGLETONS = 3；
  private static ArrayList<Singleton> singletons = new ArrayList<Singleton>();
  private static ArrayList<String> singletonName = new ArrayList<String>();
  // 静态初始化块，保证在类加载的时候，就完成类实例的创建和初始化
  static {
    for(int num = 1; num <= MAX_SINGLETONS; num++) {
      singletons.add(new Singleton("NO:" + singletonNumber + "Singleton."));
    }
  }
  private Singleton() { //.... }
  private Singleton(String param) {
    singletonName.add(param);
  }
  private static int number = 0;
  public static Singleton getInstance() {
    Random rand = new Random();
    number = rand.nextInt(MAX_SINGLETONS);
    return singletons.get(number);
  }
  ...
}
```

**Sring中，每一个Bean都是单例**——Spring容器可以管理Bean的生命周期，何时创建、何时销毁。

#### 工厂方法模式（FactoryMethod）

定义一个用于创建对象的接口（或抽象类），让子类自己决定实例化哪一个类（子类的依赖类）——工厂方法**让一个类的实例化延迟到其子类**。

```
// 抽象工厂类
public abstract class AbstractFactory {
  public abstract <T extends Product> T createProduct(Class<T> cp) {}
}
// 抽象产品类
public abstract class Product {
  public abstract void method() {}
}
// 具体产品类
public class Product_1 extends Product {
  public void method() { //... }
}
public class Product_2 extends Product {
  public void method() { //... }
}
// 具体工厂类
public class ConcreteFactory {
  public <T extends Product> T createProduct(Class<T> cp) {
    Product p = null;
    try {
      p = (Product)Class.forName(cp.getName()).newInstance();
    } catch(Exception e) {
      e.printStackTrace();
    }
    return (T)p;
  }
}
// Main
public class Client {
 public static void main(String[] args) {
   AbstractFactory c = new ConcreteFactory();
   Product p = c.createProduct(Product_1.class);
   ...
 } 
}
```

优点：

- 封装性，降低类间耦合度——只需要知道所需产品类的类名，即可以创建相应的产品类对象，而不需要知道创建的细节；
- 扩展性——如果新增产品类，只需要对工厂接口实现一个新的、用于生成该产品的工厂类即可；
- 屏蔽产品类的实现细节——不需要知道它们是怎么实现的，只需要知道它们所提供的接口是什么，接口不变，那么工厂方法就不变，上层模块也不变；
- **符合设计原则**——工厂方法模式是典型的解耦框架，高层模块只需要知道产品类的抽象类或接口即可，其他的一概不问（符合LoD），依赖抽象（符合DIP），子类可以替换父类（符合LSP）。

扩展：

- 静态工厂模式——如果一个模块只需要一个工厂时（怎么确定就值需要一个呢？这种问题应该在设计的时候好好考虑，然后写进文档），可以省略抽象工厂类，并将具体工厂类的工厂方法设置为静态`static` 即可。

  ```
  // 具体工厂类
  public class ConcreteFactory {
    public static <T extends Product> T createProduct(Class<T> cp) {
      Product p = null;
      try {
        p = (Product)Class.forName(cp.getName()).newInstance();
      } catch(Exception e) {
        e.printStackTrace();
      }
      return (T)p;
    }
  }
  // 这样，之后在场景类中就可以直接通过类名调用方法创建产品类实例
  ```

- 多工厂模式——如果一个产品类有多种实现方式，那么视情况需要分别给每个产品类配置对应的具体工厂类（符合SRP），从而形成多工厂模式。

  复杂应用中常采用多工厂模式，在此基础上，添加“**协调类**”，将多个具体工厂类**封装**，并对外提供统一的访问接口，从而避免外界与具体工厂类不必要的交互。

- 替代单例模式，弥补缺点——利用**反射**

  ```
  public class SingletonFactory {
    private static Singleton singleton;
    static {
      try {
        Class c = Class.forName(Singleton.class.getName());
        Constructor con = c.getDeclaredConstructor(); // 获取类的实例构造器
        con.setAccessible(true);
        singleton = (Singleton)con.newInstance();
      } catch(Exception e) {
        e.printStackTrace();
      }
    }
    public static Singleton getInstance() {
      return singleton;
    }
  }
  ```

  弥补了单例模式的扩展问题——单例工厂模式，**可以根据传入的类型，生成对应类型的实例**。

- 延迟初始化，重复使用，限制实例化数量

  工厂方法模式可以让一个对象在被消费完毕之后，不立即释放，而是保持其初始状态，等待再次使用。同时，可以在工厂类中定义一个类似“**存储仓库**“的数据结构，用于存储生产出的产品，这样就可以对产品进行重复使用，而不是反复创建（若定义”仓库“的容量，还可以起到限制一个工厂类实例化产品的数量）

  ——适用于对象频繁创建且所创建的对象基本都是同一类型的场合，特别是对象的创建消耗资源比较多的情况，比如I/O访问、数据库访问等。

#### 抽象工厂模式（AbstractFactory）

为了创建一组对象，对象之间相关或者相互依赖——就像一个产品的生产，对应一个工厂一样，抽象工厂**提供一个接口或抽象类**，且不需要指定具体类。

感觉，抽象工厂模式的本质——多类产品，多类工厂，每一类工厂对应生产一类产品，可以批量生产，而工厂方法模式的本质——只有一类工厂和一类产品，批量生产这一类产品。

所以，抽象工厂模式与工厂方法模式的关系为：前者是后者的扩展，后者是前者的细节的具体化。

```
// 抽象工厂类
public abstract class AbstractFactory {
  public abstract AbstractProductA createProductA() {}
  public abstract AbstractProductB createProductB() {}
  // 如果有C/D/E等类型的产品，需要在这里添加相应的抽象方法————产品类的扩展较难，需要修改抽象工厂类，不符合开闭原则
}
// 抽象产品类
public abstract class AbstractProductA {
  public void sharedMethod() {}
  public abstract void doSomething();
}
public abstract class AbstractProductB {
  public void sharedMethod() {}
  public abstract void doSomething();
}
// 具体产品类
public class ProductA_1 extends AbstractProductA {
  public void doSomething() { //... }
}
public class ProductA_2 extends AbstractProductA {
  public void doSomething() { //... }
}
// 可能会有多个生产A类型产品的方法，添加即可————同类产品的生产方法可扩展性好，即可以生产多个批次
// 同理，生产类型B/C/D产品也会有相应的方法
// 具体工厂类
public class Factory_1 extends AbstractFactory {
  public AbstractProductA createProductA() {
    return new ProductA_1();
  }
  public AbstractProductB createProductB() {
    return new ProductB_1();
  }
}
// 之后，还可以有Factory_2和ProductA_2 ProductB_2等等
// Main
public class Client {
  // 可以通过扩展多个具体工厂类，创建相应的具体工厂对象，实现同类产品的多批次生产
  AbstractFactory f1 = new Factory_1();
  AbstractFactory f2 = new Factory_2();
  AbstractProductA pa1 = f1.createProductA();
  AbstractProductA pb1 = f1.createProductB();
  AbstractProductA pa2 = f2.createProductA();
  AbstractProductA pb2 = f2.createProductB();
}
```

从抽象工厂模式的实现中看出：

- 有M个产品生产批次（或者说产品等级也可以），就需要有M个具体工厂类；
- 在每个具体工厂类中，可以实现不同类别的产品的生产任务——由抽象工厂类定义和决定；
- 场景类中，所有的实现与具体的产品类无关——所有产品的表面类型都是抽象产品类，都是通过工厂类的方法将产品生产出来，从而体现了设计中良好的**封装性** ；
- 所生产的产品类型之间的约束关系，对于高层调用模块来说是透明的——约束关系在具体工厂类中实现，高层模块只需要如何调用工厂方法把对象生产出来即可，并不需要考虑产品类别之间的约束关系。

抽象工厂模式的**适用场景**：

一个对象族（或者说一组具有多个类型的对象集合），生成不同状态（或等级或批次）的对象族所需的条件，对于对象族内的所有对象都是相同一致的，那么就可以使用抽象工厂模式——比如同一个软件，安装的时候，识别操作系统并进行配置的过程，应该就是抽象工厂模式。

#### 模板方法模式（ModelMethod）

定义一个算法框架，将其中的一些操作步骤延迟到子类中（即继承）——使得子类可以不改变一个算法的结构，就可以重新定义算法中的某些操作步骤。

算法框架（抽象类）中的方法有两种：

- 基本方法

  将由交由子类实现，并在抽象类中由模板方法调用——一般使用`protected` 修饰（对本包和子类可见，也就是说减少朋友类的可见性，**若想修改就继承**），符合LoD；

- 模板方法

  可以有一个或者多个，一般是具体方法（不是`abstract`），**用于调用基本方法**，框架的形式——其中完成对基本方法的调用规则和流程设计与实现，为了防止逻辑被修改，一般模板方法会使用**`final` 修饰**。

```
// 抽象模板类
public abstract class AbstractModel {
  // 基本方法
  protected abstract void method1() {}
  protected abstract void method2() {}
  // 模板方法
  public final void templateMethod() {
    this.method1();
    // 通过 钩子方法 设计算法框架
    if(hookMethod()) {
      this.method2();
    }
  }
  // 钩子方法 HookMethod
  protected boolean hookMethod() {
    return true;
  }
}
// 子类
public class ConcreteModel extends AbstractModel {
  private boolean flag = false;
  // 实现或重写 父类基本方法
  protected void method1() { //... }
  protected void method2() { //... }
  protected boolean hookMethod() {
    return this.flag;
  }
  // setter 方法，用于判断是否启用 钩子方法
  public void setHookMethod(boolean f) {
    this.flag = f;
  }
}
// Main
public class Client {
  public static void main(String[] args) {
    AbstractModel am = new ConcreteModel();
    am.templateMethod();
  }
}
```

可见，模板方法模式的特点为：

- 子类继承并实现（或重写）父类的基本方法，实现自己所需的逻辑；
- 高层模块中，通过向上转型得到表面类型为父类的对象，从而调用父类的模板方法，按照父类定义好的算法框架，调用基本方法；
- **父类负责算法框架和调用流程，子类负责具体方法的实现**；
- **共性交由父类把握，个性则由子类实现**——符合继承的理念，也是模板方法模式的适用场景。
- 由钩子方法定义算法框架，规定调用的规则和流程。

#### 建造者模式（Builder）

将一个复杂对象的**构建过程与表示过程相分离** ，使得同样的构建过程可以**重复**用于创建不同的表示。

- 产品类——即实现了模板方法模式的类（包括抽象模板类和具体模板类）；
- 抽象建造者——定义建造过程所需的方法；
- 具体建造者——实现抽象类定义的方法，返回一个建造好的产品对象；
- 导演类——用于安排已有模块的顺序，启动建造。

```
// 产品类，即模板方法模式
public abstract AbstractModel {...}
public class ConcreteModel extends AbstractModel {...}
// 抽象建造者
public abstract class AbstractBuilder {
  public abstract void setPart();
  public abstract ConcreteModel buildProduct();
}
// 具体建造者
public class ConcreteBuilder extends AbstractBuilder {
  private ConcreteModel product = new ConcreteModel();
  public void setPart() {
    // 用于调整产品类内的逻辑或者组成部分——不同的具体建造者这部分实现的不同，可以建造出满足各种需求的产品
  }
  public ConcreteModel buildProduct() {
    return product;
  }
}
// 导演类
public class Director {
  private AbstractBuilder builder = new ConcreteBuilder();
  public ConcreteModel getProduct() {
    // 在setPart()方法前后，可以编写特定的方法，向具体建造者传递参数
    builder.setPart();
    return builder.buildProduct();
  }
}
```

由此，可以得到建造者模式的特点：

- 产品的类别数量与具体建造者的数量一致，且产品类具有相同的接口或者抽象类——抽象模板类的子类；
- 封装性——由导演类完成，将高层模块与建造者的方法相隔离；
- 扩展性——建造者之间相互独立，扩展只需要实现抽象，并在导演类中补充即可；
- 适合场景：
  - **建造一个对象所用的方法相同，只不过方法执行的顺序不同，从而得到不同的对象**；
  - 产品可以由**多个部件**组成，不同部件组成顺序的不同或组合的不同会造成产品对象的不同。

**工厂方法模式VS建造者模式：**

前者用于批量生产相同的对象，**关注点在于如何创建对象**，生产的过程中不考虑组成对象的部件以及部件组合的顺序；后者的**关注点则在于部件的类型和组合的顺序**——默认基本的部件对象都已经创建好了。

#### 代理模式（Proxy）

为其他对象提供一种代理，以控制对这个对象的访问。

本质也就是，将某个对象的访问控制权交给一个代理对象，代理对象具有访问和控制该对象的权力（只不过这个“权力”的范围根据需求可以适当的变化，即**访问控制**）。

- 抽象主题类或接口
- 具体主题类——被代理的类，也是业务逻辑的实现类，所有方法的实现都定义在该类中；
- 代理类——具有访问具体主题类的权力，同时可以对具体主题类的方法进行“**切面增强**”（即类似于Spring中，在目标方法的前或后，增加其他的业务处理逻辑）。

````
public interface AbstractSubject {
  public abstract void method();
}
public class Subject implements AbstractSubject {
  public void method() { //... }
}
public class Proxy implements AbstractSubject {
  private AbstractSubject s = null;
  public Proxy() {
    this.s = new Proxy();
  }
  public Proxy(AbstractSubject s) { // 可以将具体主题类的对象传入代理类
    this.s = s;
  }
  public void before() { //... }
  public void after() { //... }
  public void method() {
    this.before();
    this.s.method();
    this.after();
  }
}
````

代理模式是Spring AOP最核心的设计模式，有大量的应用：

- 目标类和代理类是对同一个抽象的实现，即二者的父类/父接口是相同的；
- 很简单——代理谁，就将谁的对象传入代理类中，然后在代理类中通过被代理类的对象调用其方法，实现代理；
- 扩展性，也可以理解成代理类的“个性”——如果原有方法的功能不足，但又不能修改源码，那么可以通过代理，在代理类中对目标方法进行**增强**（即上述`before()`和`after()` 方法），补充相应的功能，比如拦截和过滤。
- 实现过程必须有被代理类完成，代理类不承担主要业务逻辑的实现责任。

普通代理VS强制代理（透明代理）：

- 普通代理——调用者知道并且只需要知道代理类的存在即可，目标类的实现由代理类封装，只需要将被代理类的名称或参数传入代理类即可。

  ```
  // 在代理类中注入目标类的信息
  private Subject s = null;
  public Proxy(String targetClassName) {
    try {
      s = new Subject(this, targetClassName);
    } catch(Exception e) {
      e.printStackTrace();
    }
  }
  ```

- 强制代理，也成为透明代理——必须通过目标类指定的代理类才可以对目标类进行访问，即由目标类管理代理类，具体的实现过程是：**高层模块通过`new` 的方式创建一个目标类对象，结果返回的是代理类对象，然后利用返回的代理类对象访问目标类的方法**...这个过程，你不知道代理类的存在，但是你的所作所为实际上是通过代理类对象完成的。

  ```
  // 在目标类中生成代理对象，并获取和返回
  private AbstractSubject proxy = null;
  public AbstractSubject getProxy() {
    this.proxy = new Proxy(this);
    return this.proxy;
  }
  ```

##### 动态代理（DynamicProxy）

在实现阶段不用关心目标类是谁，只有在运行阶段才指定目标类——**AOP（面向切面编程）**的核心。

**InvocationHandler接口**，是JDK提供的动态代理接口，该接口有一个`invoke()` 方法——实现`invoke()` 方法之后，**所有通过动态代理类实现的方法**，将会**自动调用`invoke()` 方法**，按照`invoke()` 方法内部的业务逻辑顺序完成相应的切面增强和目标类方法调用。

```
public class MyInvocationHandler implements InvocationHandler {
  // 目标类对象
  private Object target = null;
  public MyInvocationHandler(Object obj) {
    this.target = obj;
  }
  // invoke 方法
  public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
    // 前后可以增加相应的切面增强代码
    return method.invoke(this.target, args); //调用目标类的方法
  }
}
```

**动态代理类** 

```
public class DynamicProxy<T> {
  private T dpObj = null;
  public static <T> T newProxyInstance(ClassLoader cl, Class<?>[] interfaces, InvocationHandler h) {
    // 前后可以添加切面增强代码
    if(true) {
      (new BeforeAdvice()).exec();
    }
    // 创建并返回动态代理对象
    dpObj = (T)Proxy.newProxyInstance(cl, interfaces, h);
    if(true) {
      (new AfterAdvice()).exec();
    }
    return dpObj;
  }
}
```

可见，动态代理类需要参数：

- 目标类的类加载器——`obj.getClass().getClassLoader()` ；
- 目标类所实现的接口——即，若想要具有动态代理能力，要求目标类至少实现一个接口，`obj.getClass().getInterfaces()` ，之后将由实现了InvocationHandler接口的类的对象**负责调用**目标类所实现接口的所有方法；
- InvocationHandler接口——之后自动调用`invoke()` 方法。

**通知类** 

```
public interface Advice {
  public void exec();
}
public class BeforeAdvice implements Advice {}
public class AfterAdvice implements Advice {}
```

#### 原型模式（Prototype）

用原型实例指定创建对象的种类，并且通过**拷贝原型的方式**创建新的对象——**不通过new关键字产生一个对象**，而是通过对象复制实现对象的创建。

原型模式的核心是一个`clone()` 方法（通过该方法的实现完成对象的拷贝）。Java提供一个Cloneable接口**标识**某个对象是可以拷贝的——Cloneable接口中没有任何方法（对，没错，Cloneable接口中没有任何的方法，`clone()` 方法是在Object类中定义的）。

**必须实现Cloneable接口，并重写`clone()` 方法，满足这两个条件之后，才能实现对象的拷贝。**

```
public class PrototypeClass implements Cloneable {
  // 重写Object中的clone方法
  @Override
  public PrototypeClass clone() {
    PrototypeClass pc = null; // 置空
    try {
      pc = (PrototypeClass)super.clone();
    } catch(Exception e) {
      e.printStackTrace();
      // ...
    }
    return pc;
  }
}
```

通过原型模式的通用源码，可以知道：

- “用原型实例**指定**创建对象的种类”的含义就是：**想要实现对某类对象的复制，就要让该类实现Cloneable接口** ；
- 适合重复创建相同类别对象的场景——原型模式的拷贝是在**内存二进制流的拷贝** ，为新的拷贝重新分配一个内存块，性能要优于new一个新对象；
- 避开了实例构造函数的约束（既是优点，也是缺点）——由于直接在内存中实现拷贝，所以**实力构造函数是不会执行**的；
- 实际使用的时候，经常**与工厂方法模式联合使用**：原型模式通过内存拷贝批量生成对象，工厂方法模式将对象提供给调用者使用。

##### 浅Copy VS 深Copy

- 浅Copy——只Copy本对象，对象内部的**数组、引用、以及所属类的成员变量，都不Copy**，这些不Copy的内容都属于原有对象（地址都指向原有对象相应的内存地址）——因此，会导致一种现象：本来应该是Copy了一个新对象，但是大家的**数据仍然是共享**的。

  所以，浅Copy只负责基本类型以及String的Copy，只涉及这两类数据的Copy时，使用浅Copy也是OK的。

- 深Copy——实现了对象所有信息的完全Copy，之后两个对象的**数据将会相互独立**。

- 需要Copy的类对象，类的成员变量不要使用`final`修饰。

```
public class PrototypeClass implements Cloneable {
  private ArrayList<String> list = new ArrayList<String>();
  // 重写Object中的clone方法
  @Override
  public PrototypeClass clone() {
    PrototypeClass pc = null; // 置空
    try {
      pc = (PrototypeClass)super.clone();
      this.list = (ArrayList<String>)this.list.clone(); // 如果不加这一句，那么就是浅Copy
    } catch(Exception e) {
      e.printStackTrace();
      // ...
    }
    return pc;
  }
}
```

#### 中介者模式（Mediator）

**利用一个中介对象封装一系列的对象交互**——中介者的存在让各对象之间不再需要显示地相互作用，从而将各对象的关系解耦，提高程序的灵活性和可扩展性。

- 抽象中介者——定义统一的接口，并与目标类的抽象进行依赖；
- 具体中介者——必须依赖各个目标类，从而在各个目标类之间起到中间人的角色；
- 抽象目标类——与抽象中介者建立依赖关系；
- 目标类——只与中介者依赖，目标类之间不建立依赖关系，目标类的行为分为两种：一是目标类本身的行为（自发行为），与外界类无依赖，二是依赖方法，必须依赖中介者，完成与其他目标类的交互。

```
// 抽象中介者
public abstract class Mediator {
  protected Target t1;
  protected Target t2;
  // 使用 setter/getter方法注入目标类的依赖关系——目标类的依赖注入，是在抽象中介类中完成的（如果目标类具有相同的方法，提取到抽象目标类中，经由抽象目标类将依赖注入抽象中介类中，那更好，符合DIP，这里是因为目标类本身才有实现具体的业务逻辑，且一般实现的业务逻辑是不相同的，所以才使用的目标类，而不是抽象类）
  public void setT1(Target t) { this.t1 = t; }
  public Target getT1() { return t1; }
  public void setT2(Target t) { this.t2 = t; }
  public Target getT2() { return t2; }
  // 定义中介者自己的业务逻辑
  public abstract void method();
}
// 抽象目标类
public abstract class AbstractTarget {
  protected Mediator m;
  // 由抽象中介类注入依赖关系
  public AbstractTarget(Mediator m) {
    this.m = m;
  }
}
// 具体中介类
public class ConcreteMediator extends Mediator {
  @Override
  public void mMethod() {
    super.t1.method1();
    super.t2.method2();
  }
}
// 目标类
public class Target extends AbstractTarget {
  public Target(Mediator m) {
    super(m);
  }
  // 自发行为方法
  public void method1() { //... }
  // 依赖方法
  public void method2() { //... }
  // 目标类不能自己处理的业务逻辑，委托给中介者处理
  super.m.mMethod();
}
```

可以看出，中介者模式的特点：

- 中介者与所有的需要中介的目标类都存在依赖关系，准确来说，是**中介类依赖目标类**——因为所有的**目标类都必须在抽象中介类中定义一个类实例**，便于中介调用的时候使用该实例访问类的方法；
- 经由中介的协调，目标类之间的关系更为清晰，依赖关系大大减少，耦合程度大大下降，可扩展性也得到了提高，当然，缺点也是中介类会随着目标类的增多、目标类关系的复杂化而不断膨胀——所以，中介者模式的适用场景就是：只有在对象之间**耦合程度过于紧密**，关系呈现网状结构趋势的时候，需要利用中介者模式将关系整理成星型结构；
- 适合**中转站**的场景——将某一信息经过判断，转发给特定的对象，或者执行特定的处理，而不是发给所有人；
- MVC框架的使用是典型的中介者模式，其中的C就是中介者。

#### 命令模式（Command）

将**高层模块的请求封装成对象**，从而使得**请求参数化**——可以对请求进行排队、记录等处理，以及请求的撤销和恢复操作。

- 命令执行者——接收命令，完成相应命令；
- 抽象命令类——定义所需执行的所有命令；
- 具体命令类——实现所定义的命令，将命令封装成对象；
- 调用者类——**面向高层模块的统一接口**，统一接收高层模块的命令请求，对抽象命令类产生依赖，根据收到请求的不同，调用并执行相应的命令。

```
// 命令执行者
public abstract class AbstractReceiver {
  // 定义所有执行者的共性方法
  public abstract void rMethod();
}
// 抽象命令类
public abstract AbstractCommand {
  public abstract void execute();
}
// 具体执行者
public class Reciever1 extends AbstractReceiver {
  public void rMethod() { //... }
}
// 具体命令类
public abstract Command1 extends AbstractCommand {
  private AbstractReciever r;
  public Command1(AbstractReciever ar) {
    this.r = ar;
  }
  public void execute() {
    this.r.rMethod();
  }
}
// 调用者类
public class Invoker {
  private AbstractCommand ac;
  public void setCommand(AbstractCommand ac) {
    this.ac = ac;
  }
  public void action() {
    this.ac.execute();
  }
}
```

命令模式的思想非常简单：

- 高内聚，解耦不需要联系的类关系，可扩展性好——将调用者类与命令执行者分离，高层模块的请求统一交给调用者类就可以，至于后续的命令执行细节不需要知道，而命令执行者则只需要知道如何完成命令即可，不需要知道命令来自哪里；


- 层次清晰，依赖关系仅仅出现在相邻两层之间——**参数传递的顺序**：Reciever--->Command--->Invoker； **命令调用的顺序**：Invoker--->Command--->Reciever；
- 可以与其他模式联合使用——结合**责任链模式**，实现命令族解析任务；结合**模板方法模式**，可以减少AbstractCommand子类的膨胀问题（将更多子类共性的属性和方法，抽象到父类中，尽可能地复用，而不是再造）。
- 适用场景——认为是命令的地方，都可以使用命令模式，只不过要避免AbstractCommand子类的膨胀问题。
- 关于命令的撤销——结合**备忘录模式** ，适合还原状态的变更情况，不适合事件处理；新增一个回滚命令，结合事务日志，实现每一个命令执行者都可以执行命令的撤销操作。

#### 责任链模式（Handler）

根据实际情况，请求的处理可能由**多个处理者**中的一个满足条件的处理者进行处理，这时候，就可以将这些处理者对象连成一条责任链，并**沿着这条链传递该请求**，直到有处理者接受该请求并处理即可。

- 抽象处理者——定义一个通用的请求处理方法`handleMessage()` ；定义一个责任链的编排方法`setNext()` ，用于设置当前责任块的下一个链上的责任块；定义具体处理者必须要实现的方法`getHandlerLevel()` 和`response()` ，分别用于获取请求的标识（通过标识可以判断由哪一个责任块处理请求）和处理并返回请求处理的结果；
- 具体处理者——继承或实现抽象处理者，然后根据需要，实现本责任块的`getHandlerLevel()` 和`response()` 方法；
- 额外相关的类——标识类Level（用于定义请求的标识），请求类（将请求封装成对象），响应类（同理，将请求的处理结果封装成对象）。

```
// 抽象处理者
public abstract class AbstractHandler {
  private AbstractHandler nextH;
  public final Response handlerMessage(Request req) {
    Response res = null;
    // 根据标识判断是不是本责任块负责的请求
    if(this.getHandlerLevel().equals(req.getHandlerLevel())) {
      res = this.response(req);
    }
    else {
      // 若不是属于自己的责任，则判断并交给责任链的下一个责任块
      if(this.nextH != null) {
        res = this.nextH.handlerMessage(req);
      }
      else {
        // 说明责任链上没有对该请求负责的对象，业务自行处理
        // ...
      }
    }
  }
  public void setNext(AbstractHandler h) {
    this.nextH = h;
  }
  public abstract Level getHandlerLevel();
  public abstract Response response(Request req);
}
// 具体处理者
public class Handler1 extends AbstractHandler {
  protected Level getHandlerLevel() {
    // 定义属于该责任块的标识
    return ...;
  }
  protected Response response(Request req) {
    // 定义请求的处理逻辑
    return ...;
  }
}
// 额外的类
public class Level {}
public class Request {
  public Level getHandlerLevel() { //... }
}
public class Response {}
```

可见，责任链模式的特点为：

- 请求与处理的分离——只需要将请求传递给责任链开放接口即可，之后将会根据标识匹配请求和相应的责任块，完成请求的处理并返回处理结果；
- 与模板方法模式结合，满足SRP——抽象类提取并完成相同的功能，即请求的传递功能，子类完成各自不同的请求处理逻辑，只有请求不同这一个原因引起责任块类选择上的不同；
- 扩展性良好——若有新的请求处理标识或级别，只需要在原有责任链的基础上，添加一个新的责任块即可，之前的责任链都可以不用改变；
- 但是性能问题和调试问题需要注意——请求与责任块相匹配的过程，本质是一个遍历链表的过程，所以需要限制责任链的长度，以免出现性能上的问题和调试上的困难。

#### 装饰模式（Decorator）

**动态地给一个对象添加额外的功能**——对于添加功能，相比于生成子类，装饰模式更加灵活。

- 抽象目标类
- 目标类——装饰类需要装饰的目标；
- 抽象装饰类——继承抽象目标类，同时又与抽象目标类有聚合的关系，所以其中必然有一个`private` 成员变量指向抽象目标类；
- 装饰类——实现抽象装饰类，添加**新的装饰方法**，然后**重写**抽象装饰类的执行方法——在其中通过抽象层面的依赖，调用目标类的执行方法，并在调用的前后布置装饰方法，从而达到装饰和增强的目的。

```
// 抽象目标类
public abstract class AbstractTarget {
  public abstract void operate();
}
// 目标类
public class Target extends AbstractTarget {
  public void operate() { //... }
}
// 抽象装饰类
public abstract class AbstractDecorator {
  private AbstractTarget t = null;
  public AbstractDecorator(AbstractTarget at) {
    this.t = at;
  }
  @Override
  public void operate() {
    this.t.operate();
  }
}
// 具体装饰类
public class Decorator extends AbstractDecorator {
  public Decorator(AbstractTarget at) {
    super(at);
  }
  // 定义新的装饰方法
  public void method() { //... }
  // 重写执行方法，向其中添加装饰方法
  @Override
  public void operator() {
    super.operate();
    this.method();
  }
}
// Main
public class Client {
  public static void main(String[] args) {
    AbstractTarget t = new Target();
    t = new Decorator(t);
    t.operate(); // 将会执行装饰类定义的执行方法
  }
}
```

装饰模式的特点有：

- 装饰类与目标类拥有同一个父类——具有相同的抽象，那么两个类的实例就可以使用相同的表面类型，所以不论目标类装饰了多少层，返回的对象表面类型都是抽象目标类，即仍旧是`is-a` 的关系，反观多层次的继承之后，基本上看不到原来的抽象类了；
- 相互独立，可扩展性高——装饰类与目标类是各自独立的，在需要装饰的时候，**动态添加**一层功能即可，不需要的时候，**动态撤销**装饰层即可；
- **装饰效果可以叠加，但没有先后顺序**——每次装饰后，都会返回一个添加了新功能的对象，所以下一次装饰的对象是已经具备上一次装饰效果的对象；
- 适用场景——为目标对象**动态添加/撤销功能**；为一批**兄弟类**改装或加装功能。

#### 策略模式（Strategy）

定义一组算法，并将每个算法封装起来，算法封装后向外提供相同的接口，使得每个算法都可以替换成其他算法。

- 抽象策略——策略、算法的抽象，一般为接口，定义算法相同的方法和属性
- 具体策略类——实现具体的算法；
- 封装类，也成为上下文类——封装算法类，向高层模块提供统一的接口，屏蔽高层模块对算法类的直接访问。

```
// 抽象策略
public interface AbstractStrategy {
  public void algorithm();
}
// 具体策略类
public class Strategy1 implements AbstractStrategy {
  public void algorithm() { //... }
}
public class Strategy2 implements AbstractStrategy {
  public void algorithm() { //... }
}
// 上下文类
public class Context {
  private AbstractStrategy s = null;
  public Context(AbstractStrategy as) {
    this.s = as;
  }
  public void useAlgorithm() {
    this.s.algorithm();
  }
}
```

策略模式的特点为：

- **算法策略模块可以自由切换**——通过抽象策略，可以向高层模块提供统一的接口，实现了抽象策略的具体类，可以由高层模块自由的选择调用，也因此，扩展性良好；
- 算法策略的具体规则内容的运行情况对高层模块是透明的，但是高层模块必须知道算法能实现什么功能，知道算法名称——不然为什么调用？怎么调用？即，涉及到一个问题，所有的算法策略类都需要**对外暴露**，让高层模块知道都存在哪些算法策略，不符合LoD；
- 策略模块复用性的不足可能导致策略类的膨胀——一般超过4个算法策略需要调度，需要考虑结合其他设计模式，比如工厂方法模式等。

策略模式的扩展——**策略枚举** 

定义一个抽象执行方法，并**在每个枚举成员中对抽象执行方法进行实现**。

策略枚举的方式，对策略的封装更为彻底——只需要知道策略的名称就可以，连策略对象都可以不用创建，但是缺点也很明显——修改和扩展比较困难，每个枚举项都是`final`、`static`、`public` ，如果不能直接接触枚举类，那么基本无法扩展，所以**策略枚举比较适合定义一些不经常变化的策略算法**。

```
public enum EnumStrategy {
  Strategy1("注释，可有可无") {
    // 定义本策略的过程，然后调用抽象执行方法
    public void exec( // param) {
      return ...
    }
  }
  Strategy2("注释，可有可无") {
    public void exec( // param) {
      return ...
    }
  }
  // ......
  // 定义其他所需的成员方法
  public abstract void exec( // param);
}
// Main
public class Client {
  public static void main(String[] args) {
  	// 定义一些参数
    EnumStrategy.Strategy1.exec(// param);
    EnumStrategy.Strategy2.exec(// param);
  }
}
```

####适配器模式（Adapter）

将一个类的接口变换成客户端所期待的另一种接口，从而使得原本因为接口不匹配而无法在一起工作的两个类能够在一起工作——即**在两个类之间适配接口** ，添加一个中转类（适配器）。

- 目标接口——也就是所需要适配、转换成的接口；
- 源类——已存在且正在运行的类，需要将其重新包装成能够适配目标接口的类；
- 适配器类——通过继承或者关联的方式，将源类转换成能够匹配目标接口的新类。

```
// 目标接口
public interface Target {
  public void target();
}
// 目标接口实现类
public class TargetClass implements Target {
  public void target() { //... }
}
// 源类
public class Adaptee {
  public void adaptMethod() { //... }
}
// 适配器类
// 尽量满足DIP和LSP，将依赖关系放在抽象层面
// 实现接口方法&调用父类方法
public class Adapter extends Adaptee implements Target {
  public void target() {
    super.adaptMethod();
  }
}
```

适配器模式的特点为：

- 可以让两个没有任何关系的类在一起运行；
- 增加了类的透明性——高层模块上看，是调用了目标类的方法`target()` ，但是实际的实现逻辑使用的是源类的方法；
- 类的复用度得以提高——一个规划很好的目标类（拥有通俗易懂的方法名，整个框架定义的规范），可以通过适配器模式，注入新的源类业务逻辑，从而实现目标类的复用，同时可以实现源类的新包装；
- 可扩展性高，灵活性好；
- 不是设计阶段考虑的事情——适配器模式是用来解决实际运行阶段需要补充和适配的模块问题。

适配器的扩展——关联与聚合

如果适配器所需要适配的**源类不止一个**的时候，由于Java不支持多继承，所以需要使用关联或者聚合的方式——在适配器类中，设置多个源类对象作为私有成员变量，并在实例构造函数中进行初始化：

```
public SourceClass1 {}
public SourceClass2 {}
public SourceClass3 {}
public class Adapter implements Target {
  private SourceClass1 sc1 = null;
  private SourceClass2 sc2 = null;
  private SourceClass3 sc3 = null;
  public Adapter(SourceClass1 sc1, SourceClass2 sc2, SourceClass3 sc3) {
    this.s1 = s1;
    this.s2 = s2;
    this.s3 = s3;
  }
}
// 之后的处理与上述相同
```

通过关联与聚合方式的适配手段，是对象层面的委托，所以也称为对象适配器——与之相对的，上述适配方法也称为类适配器。

#### 组合模式（Composite）

将对象组合成**树形结构**以表示“部分-整体”的层次结构，使得用户**对单个对象和组合对象的使用具有一致性** —— 所以组合模式又称为“部分-整体模式”。

- 抽象组合——定义所有参与组合的对象的共性方法和属性；
- 叶子构件——树形结构的最小遍历单元，叶子之下再无其他构件；
- 树枝构件——一个树枝构件之下可能还有其他叶子构件和树枝构件。

```
// 抽象组合类
public abstract class AbstractComposite {
  public void publicMethod() { //... }
  // 此外，还可以定义父类节点，以方便遍历（子类可以继承父类的私有属性和方法，但只能通过父类的public方法访问所继承的私有XX）
  private AbstractComposite parent = null;
  // 一并定义访问父类私有属性的方法
  protected void setParent(AbstractComposite p) {
    this.parent = p;
  }
  public AbstractComposite getParent() {
    return this.parent;
  }
}
// 叶子构件
public class Leaf extends AbstractComposite {
  // 定义自己的方法或者重写父类的方法
}
// 树枝构件
public class Branch extends AbstractComposite {
  // 构件的容器（只有树枝构件有）
  private ArrayList<AbstractComposite> list = new ArrayList<AbstractComposite>();
  // 此外，还可以定义父类节点，以方便遍历
  private AbstractComposite parent = null;
  // 构件的添加与删除
  public void add(AbstractComposite ac) {
    this.list.add(ac);
  }
  public void remove(AbstractComposite ac) {
    this.list.remove(ac);
  }
  // 获取树枝构件的容器
  public ArrayList<AbstractComposite> getContainer() {
    return this.list;
  }
}
// Main
public class Client {
  // 递归遍历
  public static void find(Branch root) {
    for(AbstractComposite node : root.getContainer()) {
      if(node instanceof Leaf) {
        node.xxx();
      }
      else {
        find((Branch)node);
      }
    }
  }
  public static void main(String[] args) {
    Branch root = new Branch();
    Branch branch = new Branch();
    Branch leaf = new Leaf();   
    root.add(branch);
    branch.add (leaf);
    // 直接使用了具体类，不符合依赖倒置原则，抽象的扩展受限
  }
}
```

组合模式的特点是：

- 扩展性好——树形结构，节点可以任意添加；
- 直接使用了具体类，不符合依赖倒置原则，抽象的扩展受限；
- 适用场景：**树形结构**；部分-整体关系的场景，比如树形文件夹、文件管理等；需要从一个整体中，抽出某一个模块或功能的场景。
- **所组合的构件对于高层模块的透明性**——在遍历树形结构的过程中，高层模块无需知道和处理当前遍历到的构件（因为所有的构件，遍历出的表面类型都是抽象类），相应的业务逻辑会根据构件的实际类型对构件进行处理。

#### 观察者模式（Observer）

定义对象之间一种**一对多的依赖关系**——**每当一个对象改变状态，则依赖于该对象的其余对象都会得到通知并自动更新**。

- 被观察者——定义被观察者的职责，即管理（动态地添加或删除）和通知依赖于自身的观察者；
- 观察者——收到通知信息之后，对接受到的信息进行处理。

```
// 被观察者的抽象
public abstract class AbstractObservable {
  // 定义一个观察者集合
  private ArrayList<AbstractObserver> list = new ArrayList<AbstractObserver>();
  public AbstractObservable(AbstractObserver ao) {
    this.list.add(ao);
  }
  public void addObserver(AbstractObserver ao) {
    this.list.add(ao);
  }
  public AbstractObserver delObserver(int index) {
    return this.list.remove(index);
  }
  public void delObserver(AbstractObserver ao) {
    this.list.remove(ao);
  }
  public void notifyObservers() {
    for(AbstractObserver ob : this.list) {
      ob.update();
    }
  }
}
// 具体的被观察者
public class Observable1 {
  public void method() {
    // ...
    super.notifyObservers();
  }
}
// 观察者的抽象
public interface AbstractObserver {
  public void update();
}
// 具体观察者
public class Observer implements AbstractObserver {
  public void update() {
    // ...
  }
}
```

观察者模式的特点：

- 一种**监视监控的模式**——实现一个对象的状态变化，可以通知到监控该对象的其他对象，
- 满足抽象依赖，容易扩展；
- 适合场景：建立一整套的**多级触发机制**（通知的一级一级传递，触发相应的动作）；建立**关联行为**的场景（选择了A将会触发什么动作，选择了B又将会触发什么动作，，以此类推）；跨系统的**消息交换**场景（由于可以将观察者对象放置在被观察者类中，所以可以在被观察者状态变化的时候，通过类中的观察者对象，将信息传递到远端的观察者类中，从而进行后续的处理）；
- 最好让被观察者实现一定的**自主性**——即由被观察者自己决定，在什么情况下需要通知观察者（而不是什么都通知，会让消息堆积在观察者上）。

观察者模式存在的一点问题：

- 性能问题——由于观察者模式倾向于建立多级触发机制或者关联触发机制，所以很容易出现因为其中某一级观察者的卡死，影响整体的执行效率的问题，或者出现一个对象的双重身份（既是观察者，又是被观察者），从而造成广播链问题，影响信息的准确度（因为在广播的过程中，很容易对信息进行再次加工和修改）——这时候需要考虑异步执行的方式（多线程方式），以及规定消息最多转发一次即传递两次（保证信息的准确度）；
- 异步处理时的线程安全问题。

**观察者模式的扩展**：

JDK提供了`java.util.Observable`和`java.util.Observer` 接口。

其中`java.util.Observable` 接口**封装**了上述抽象被观察类中，添加/删除/通知观察者类的方法——所以，可以直接使用JDK提供的接口，简化观察者模式的实现。

`java.util.Observer` 接口的`update()` 方法，需要Observable对象作为参数传入，另外一个参数一般是DTO（一般以JavaBean的形式或XML的形式传入）。

#### 门面模式（Facade）

定义一个门面对象，要求一个子系统内部与外部的通信都必须通过该对象进行——门面模式提供了一个**高层次的统一接口**，提高了子系统的封装性以及高层模块的易用性。

- 门面对象——介于子系统与高层模块之间，知道子系统的所有功能和职责，并为高层模块提供统一的访问子系统的接口，一般来说，门面对象不包含业务逻辑，也不参与业务逻辑；
- 子系统——可以同时有一个或者多个子系统，每一个子系统都不是单独的类，而是一个**类的集合** ，对于子系统来说，访问它的就是门面对象，它并不知道有高层模块。

```
// 子系统（可以有多个互不相关的类组合而成）
public class ClassA {
  public void methodA() {
    //...
  }
}
public class ClassB { //... }
public class ClassC { //... }
// 门面类
public class Facade {
  private ClassA c1 = new ClassA();
  private ClassB c2 = new ClassB();
  private ClassC c3 = new ClassC();
  // 作为一个接口，向高层模块提供子系统的方法
  public void A() {
    this.c1.methodA();
  }
  public void B() {
    this.c2.methodB();
  }
  // ...
}
```

门面模式的特点：

- 减少底层系统与高层模块之间的依赖与交互——所有的操作通过统一的接口进行；
- 扩展性与灵活性——耦合度降低必然带来的优点；
- **权限管理**与安全性提升——可以通过设置不同的门面，规定不同的访问权限；
- 适用场景：子系统是复杂模块，功能相对独立，封装性良好；不希望外界接触子系统的代码。

门面模式的注意事项：

- 保证门面对象的简洁性——如果接口代码过于庞大，可以适当地将其拆分为多个门面对象类（这个过程可以按照单一职责原则SRP来做）；
- 门面模式的权限管理扩展；
- 只提供访问接口，**不参与子系统内的业务逻辑** ，否则会产生一个**倒依赖**的问题——子系统功能的实现需要依赖门面对象；
- 设计门面模式需要多考虑——因为门面对象运行之后，一般不会改动（统一的接口怎么能够随意地改动）。

#### 备忘录模式（Memento）

在**不破坏封装性**的前提下，获取一个对象的**内部状态**，并在该**对象之外保存**这个状态，以便在以后某个阶段将该对象恢复到之前保存的某个状态——即一个**对象的备份模式**，一种程序数据的备份方法。

- 备份类，也是备份动作的发起人——定义需要备份的数据和状态，负责记录当前时刻的状态，并创建和恢复备份数据；
- 备忘录类——类似于一个**状态仓库**，存储和提供备份类对象的状态；
- 备忘录管理员类——类似于一个仓库管理员，对备忘录类对象进行管理（可能有多个备忘录）。

```
// 备份类
public class Backup {
  // 定义内部状态与相应方法
  private String state = "";
  public String getState() { //... }
  public void setState(String s) { //... }
  // 创建一个备忘录
  public Memento createMemento(this.state) {
    return new Memento(this.state);
  }
  public void restoreMemento(Memento backup) {
    this.setState(backup.getState());
  }
}
// 备忘录类
public class Memento {
  private String state = "";
  public Memento(String s) {
    this.state = s;
  }
  public String getState() {
    return this.state;
  }
  public void setState(String s) {
    this.state = s;
  }
}
// 备忘录管理员类
public class Manager {
  private Memento m;
  public Memento getMemento() {
    return m;
  }
  public void setMemento(Memento m) {
    this.m = m;
  }
}
```

备忘录模式的特点：

- 备忘录可以理解为是，**数据或状态的存储仓库**，可以单独存储对象的某一个状态，也可以直接存储对象的拷贝（要注意深Copy和浅Copy）——实际上就是**多状态的存储**，当然多状态的存储还可以使用类似HashMap的数据结构；
- 作为仓库，备忘录**无法决定**存储什么数据或者状态，必须由备份类定义哪些状态需要备份，并定义相应的方法用于操作备份的过程；
- 作为仓库，备忘录可以在时间线上**扩展所存储的状态数量**——添加一个标记（类似时间戳，也可以用字符串），标记备忘录的**检查点（CheckPoint）**，说明备忘录的创建时间；
- 适用场景：数据或状态的存储与恢复；需要一个可回滚（RollBack）操作——类似数据库的事务管理；作为副本监控——在不影响系统主业务的情况下，生成一个副本进行监控；
- 注意事项：需要**主动管理备忘录对象的生命周期**，使用才建立，不使用就删除其引用；不在频繁建立备份的场景中使用该模式——因为无法控制备忘录对象的数量。

#### 访问者模式（Visitor）

**对一些操作进行封装**——操作将作用于某种数据结构中的各元素，它可以在**不改变数据结构**的前提下定义作用于这些元素的新的操作——即**对同样的内容执行不同的操作**。

- 访问者抽象类——声明访问者可以访问哪些元素；
- 具体访问者——实现访问者的具体业务逻辑，即访问一个元素时要做什么、怎么做；
- 抽象元素类——声明自己将接受哪些访问者的访问（通过`accept()` 方法将访问者的抽象类传入，从而建立依赖）；
- 具体元素类——实现`accept()` 方法，基本已经定型：`visitor.visit(this);` ；
- 元素容器——用于存储和生成元素。

```
// 访问者抽象类
public interface AbstractVisitor {
  public void visit(Element1 e1);
  public void visit(Element2 e2);
}
// 抽象元素类
public abstract class AbstractElement {
  public abstract void method();
  public abstract void accept(AbstractVisitor av);
}
// 具体元素类
public class Element1 extends AbstractElement {
  public void method() { //... }
  public void accept(AbstractVisitor av) {
    av.visit(this);
  }
}
public class Element2 extends AbstractElement { //... }
// 具体访问者
public Visitor implements AbstractVisitor {
  public void visit(Element1 e1) {
    e1.method();
  }
  public void visit(Element2 e2) {
    e2.method();
  }
}
// 元素容器
public class ElementContainer {
  public static AbstractElement createElement() {
    // 可以使用工厂模式批量生产元素类的对象
  }
}
```

访问者模式的特点：

- 顾名思义，就是一种访问封装好的数据的方式——这种方式可以在不改动原有封装数据的基础上，通过定义和实现不同的访问逻辑（创建一个新的具体访问者类），得到所需要的数据展现形式；
- 满足单一职责元素SRP——访问者定义数据的展现形式，数据本身由元素类定义；
- 扩展性好，灵活——很明显，访问者和元素类各司其职，可以根据需要添加所需的访问者或者元素，其他已有模块都可以保持不变或仅仅微调；


- 适用场景：**业务规则要求遍历多个不同的对象** ——即不同类或实现不同接口的对象（迭代器只能遍历同类或实现同一接口的数据，当然，若迭代器与instanceof结合，也可以实现遍历不同的对象）；
- 不足：从上述代码实现来看，访问者类直接使用了具体元素类，不符合LoD和DIP，且由于这个原因，具体元素类的修改将会变得困难——因为修改会直接影响访问者类中的业务逻辑。

访问者模式的扩展：

- 统计功能的实现；
- 一个对象，多个访问者——功能的拆分，创建多个访问者，每个访问者的职责单一；
- **双分派**？

#### 状态模式（State）

**当一个对象内在状态改变时，允许其改变行为**，从外看来，就好像这个对象改变了其类——即，**封装**，状态的变更引起了行为的变更，而外界对此并不知情。

- 抽象状态类——定义对象的状态，封装上下文对象，用于实现状态切换；
- 具体状态类——每一个具体对象的职责有两个：**本状态的行为管理**（在本状态下需要做什么），**状态的切换管理**（能切换到哪种状态以及如何切换到其他状态）；
- 上下文类——传入定义好的状态对象，负责具体状态的转换，向高层模块提供接口。

```
// 抽象状态类
public abstract class AbstractState {
  protected Context c;
  public void setContext(Context c) {
    this.c = c;
  }
  public abstract void handle1();
  public abstract void handle2();
}
// 具体状态类
public class State1 extends AbstractState{
  public void handle1() { // 定义本状态的行为管理 }
  public void handle2() {
    // 状态切换管理
    super.c.setCurrentState(Context.STATE2); // 子类不能继承protected修饰的成员变量，只能访问
    super.c.handle2();
  }
}
public class State2 extends AbstractState{
  public void handle2() { // 定义本状态的行为管理 }
  public void handle1() {
    super.c.setCurrentState(Context.STATE1);
    super.c.handle1();
  }
}
// 上下文类
public class Context {
  // 声明的状态对象为静态常量，有几个状态对象就声明几个静态变量
  private final static AbstractState STATE1 = new State1();
  private final static AbstractState STATE2 = new State2();
  private AbstractState cs;
  public AbstractState getCurrentState() {
    return cs;
  }
  public void setCurrentState(AbstractState as) {
    this.cs = as;
    this.cs.setContext(this);
  }
  // 委托的方式 进行方法的调用
  public void handle1() {
    this.cs.handle1();
  }
  public void handle2() {
    this.cs.handle2();
  }
}
```

状态模式的特点：

- 符合SRP——每一个具体状态都是一个类，都有自己的方法，可以通过增加子类的方式增加状态的数量；
- 封装良好——状态变化的过程封装在相应的具体状态类中，并通过上下文类以**委托**的方式进行调用，**高层模块并不知道状态是否变化、是怎么变化的**，只知道行为发生了变化；
- 适用场景：行为随着状态变化而变化（比如访问者的权限）；类中条件、分支判断语句的替代（一个判断条件可以理解为一个状态）——为了避免子类膨胀，状态的数量最好限制在5个以内；
- 扩展：状态保持不变，需要调整状态的组合顺序——建造者+状态模式，从而创造出某个对象在**不同场景下的状态转换流程**（比如正常工作场景下、调试场景下等）。

#### 享元模式（FlyWeight）

通过使用**共享对象**，支持大量的细粒度的对象——**池技术**的重要实现方式。

细粒度对象，即势必会创建大量性质相近的对象，通过提取相同的信息，可以将对象的信息分成两个部分：内部状态和外部状态：

- 内部状态：对象可以共享的信息，内部状态存储在享元对象内部并且不会随着环境的改变而变化——**可共享不改变**的信息；
- 外部状态：对象依赖的唯一标记，会随着环境的改变而变化，不可以共享——**不共享会改变的唯一标识**信息。



- 抽象享元类——定义对象的外部状态和内部状态以及相应方法的抽象；
- 具体享元类——传入外部状态，定义在外部状态下的业务逻辑，同时内部状态的处理应该与环境无关；
- 享元工厂类——构造一个池容器，提供从池中获取对象的方法。

```
// 抽象享元类
public abstract class AbstractFlyweight {
  private String in; // 既然是共享信息，就定义为父类中的private————那么一个父类将会代表一批对象，如果内部状态不同，则需要创建另一个平级的父类对象
  private final String out; // final，避免初始化之后再修改外部状态
  // 享元角色必须接受外部状态
  public AbstractFlyweight(String out) {
    this.out = out;
  }
  public abstract void operate();
  // 内部状态的 setter/getter 
  public void setIn(String in) {
    this.in = in;
  }
  public String getIn() {
    return in;
  }
}
// 具体享元类
public class Flyweight1 extends AbstractFlyweight{
  public Flyweight1(String out) {
    super(out);
  }
  public void operate() { //... }
}
// 享元工厂类
public class FlyweightFactory {
  // 池容器
  private static HashMap<String, AbstractFlyweight> pool = new HashMap<String, AbstractFlyweight>();
  // 获取享元对象（有则取，无则创建放入并返回）
  public static AbstractFlyweight getFlyweight(String out) {
    AbstractFlyweight f = null;
    if(pool.containsKey(out)) {
      f = pool.get(out);
    }
    else {
      f = new Flyweight1(out);
      pool.put(out,f);
    }
    return f;
  }
}
```

享元模式的特点：

- 共享——可以创建对象池，通过共享技术，大大减少应用程序创建的对象数量；
- 状态提取与分离——提取出相同的状态作为内部状态，作为父类的私有对象，留下可能不同的状态作为外部状态，放在子类中确定，作为子类的唯一标识（同时，状态的分离工作也加大了系统的复杂度）；
- 适用场景：存在或需要创建大量相似的对象；一批对象的外部状态相近——可以用于唯一标识对象的方式相近，或者说用于作为标识的数据类型是一样的；需要创建缓冲池（出于性能考虑，尽量使用基本类型作为外部状态唯一标识对象——因为如果使用自定义的类对象作为外部状态唯一标识，那么需要重写对象的比较方法`equals()`和`hashCode()` ，从而完成唯一标识的工作）。

对象池VS享元：

- 对象池：关注对象的**复用**，池中的每一个对象都是可以替换的（即使用A和使用B的效果是一样的）；
- 享元：关注对象的**共享**，即如何建立多个可共享的细粒度对象。

#### 桥梁模式（Bridge）

将**抽象和实现解耦**，使得两者可以独立的变化。

- 抽象化角色的抽象——定义角色的行为，同时保存一个实现化对象的引用（抽象类引用）；
- 实现化角色的抽象——定义具体某一类角色实现所需的行为和属性。

*注：“抽象化”不等于“抽象”，同理，“实现化”不等同于“实现”——抽象化可以理解成是一个框架，本来这个框架中是顺带实现具体对象的（通过继承实现），但是继承的关系过于紧密，不利于框架与框架内对象的独立变化和后续的扩展，所以现在要将“抽象化”的框架与“实现化”的具体对象拆开。*

```
// 实现化角色的抽象
public interface Implementor {
  public void method();
}
// 实现化角色的具体实现
public class Implementor1 implements Implementor {
  public void method() { //... }
}
// 抽象化角色的抽象
public abstract class Abstraction {
  private Implementor imp;
  // 定义有参构造函数，让子类重写构造函数，传入特定的实现化类
  public Abstraction(Implementor imp) {
    this.imp = imp;
  }
  public void request() {
    this.imp.method();
  }
  public Implementor getImp() {
    return imp;
  }
}
// 抽象化角色的具体实现
public class Abstraction1 extends Abstraction {
  public Abstraction1(Implementor imp) {
    super(imp);
  }
  public void request() {
    // 可以添加一些具体的业务处理逻辑
    super.request();
  }
}
```

桥梁模式的特点：

- 简单——只使用了类间的聚合关系、继承、重写等功能；
- 解耦——抽象和实现之间的解耦，两者和独立变化，提高了扩展性和灵活性，一定程度上解决了继承带来了紧耦合的问题；
- 适用场景：不适合使用继承的场景；接口或者抽象类不稳定的场景（不稳定，意味着可能会修改）；重用性要求比较高——桥梁模式的设计可以让粒度更细，而继承由于会收下父类的包袱，粒度肯定是不会细的；
- 类间弱关联关系——将**父类中可能会发生变化的方法抽取出去，自成一类（即上文的实现化角色）**，子类继承父类之后，若希望获得被抽取出去的方法，那么将实现化角色类聚合过来即可，不想要了也OK，聚合关系取消即可。

#### 迭代器模式（Iterator）

提供一种访问容器对象中各个元素的方法，但又不需要暴露容器对象内部的细节——即，容器对象的职责在于如何增减修改容器内的元素，有另外的方法从外界遍历访问容器内元素。

由于现在JDK的容器基本都实现了**`java.util.Iterator` 接口**，所以迭代器模式基本已经没落了，不是非常需要的场景，直接使用容器自带的`Iterator()` 方法即可。

#### 解释器模式（Interpreter）

给定一门语言，定义它的文法的一种表示，并定义一个解释器——**解释器使用文法表示来解释语言中的句子**。

解释器模式比较复杂：

- 需要定义所需要解释的语言的文法表示——如何将输入按照文法规则解释成需要的内容；
- 需要定义语法单元——解析的过程将是递归调用的过程，最终递归到最小的语法单元完成解析；
- 递归调用和循环结构的设计；

解释器模式的特点：

- 可以理解为一个语法分析工具——自定义一套解析规则，对输入进行解析，输出所需的结果或者可读的结果；
- 适用场景：频繁出现的不同的表现形式，但是所组成的语法单元相同——可以通过解释器将不同表达形式的含义解释出来；简单的语法解释场景——过于复杂的场景，加上递归调用，对于性能的要求可能会较高；
- 较难调试和维护——因为使用的是递归调用和循环结构，单步调试比较困难；
- 不是很常用——现已有很多的语法分析工具和解析工具包，并不推荐从头开始造轮子。

---

