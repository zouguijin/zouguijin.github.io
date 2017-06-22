title: Java---Generics

date: 2017/06/22 11:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java Generics——泛型

>泛型，是一种方法，更是一种思想，它的目的在于“泛化”的表达，通过它可以创建出通用性更好的代码，能够用于更多的类型，并提供相应的类型安全保障，尽管与潜在类型机制还有一定的差距。

### 0 Java的泛型

Java泛型的**核心**在于：告诉编译器想使用什么类型，然后编译器帮你处理一切细节。

即在使用泛型的时候，只需要指定他们的名称以及类型参数列表即可。

Java泛型的**特点**：

- Java泛型是通过运行时的**擦除**实现的，即在使用泛型时，任何具体的类型信息都会被擦除，唯一知道的是你在使用一个对象（却不知道它实际的类型）。

  例如，`List<String>`与`List<Integer>`在运行时，实际上通过擦除成为了相同的类型——`List`。

  只有在从容器中**取出元素**的时候，会执行类型检查。

- Java泛型**无法使用基本类型作为类型参数**，也即Java泛型的局限性

  好在Java SE5之后具备了基本类型的包装类以及自动打包和自动拆包的工作机制。

- 一个类不能够实现同一个泛型接口的两种变体，因为泛型擦除会使得这两种变体成为相同的接口。


```
interface Behavior<T> {}
class Cat implements Behavior<Cat> {}
// class Dog implements Behavior<Dog> {} // can not compile
// 擦除后，Behavior<Cat>和Behavior<Dog>会变成相同的Behavior
```

- 由于类型擦除的原因，泛型方法不能以类型参数不同区分，如果被擦除的参数不能产生唯一的参数列表时，必须以明显区别的方法名作区分。


### 1 元组的概念

有时候需要“调用一次方法，就可以返回多个对象”的需求，但是`return`一次只能返回一个对象，怎么办？

这时候就需要**“元组”——创建一个对象，用它来持有所需要返回的多个对象**。

元组的特点：

- 从概念上看，元组相当于一个具有类型的容器；

- 元组对象允许读取其中的元素，但是不允许向其中存放新的对象，即元组中的属性域将会使用**`final`关键字**进行修饰，因此元组也称为**数据传送对象**或**信使**；

  因此，若想使用不同类型元素的元组，则需要另外创建新的元组对象。

- 元组可以具有任意长度，且元组中的对象可以具有不同的类型；

- 元组隐含地保持其中元素的次序；

- 可以使用继承机制实现更长的元组。

```
// Tuple Template
public class TwoTuple<A,B> {
  public final A tupleA;
  public final B tupleB;
  public TwoTuple(A a, B b) {
    tupleA = a;
    tupleB = b
  }
  public String toString() {
    return "(" + tupleA + "," + tupleB + ")";
  }
}
public class ThreeTuple<A,B,C> extends TwoTuple<A,B> {
  public final C tupleC;
  public ThreeTuple(A a, B b, C c) {
    super(a,b);
    tupleC = c;
  }
  public String toString() {
    return "(" + tupleA + "," + tupleB + "," + tupleC + ")";
  }
}
// Test Code
public class TupleTest {
  // 使用元组，首先如上述定义元组模板，然后选用相应的模板作为方法的返回值，在 return 语句中创建(new)该元组，并把相应的参数传入即可
  static TwoTuple<String,Integer> f1(String s, int i) {
    return new TwoTuple<String,Integer>(s,i);
  }
}
```

PS. 后续将会介绍更通用的**[设计模式——适配器模式]()**。

### 2 泛型实现简单的堆栈类

利用泛型实现简单的内部链式存储机制：

```
// LinkedStack Template
public class LinkedStack<T> {
  // 内部私有类
  private static class Node<U> {
    U item;
    Node<U> next;
    Node() { item = null; next = null; }
    Node(U item, Node<U> next) {
      this.item = item;
      this.next = next;
    }
    boolean end() { return item == null && next == null; }
  }
  private Node<T> top = new Node<T>();
  public void push(T item) {
    top = new Node<T>(item,top);
  }
  public T pop() {
    T result = top.item;
    if(!top.end()) top = top.next;
    return result;
  }
}
// Test LinkedStack
public class TestLinkedStack {
  public static void main(String[] args) {
    LinkedStack<String> test = new LinkedStack<String>();
    for(String s : "I am a student from Beijing University of Post and Telicommunication.".split(" ")) {
      test.push(s);
    }
    String s;
    while((s = test.pop()) != null) {
      System.out.print(s + "/");
    }
  }
}
```

### 3 泛型接口

泛型接口将会提供类型待定、更加泛化的方法。

```
public interface Generator<T> { T next(); }
```

上述是自定义的一个泛型接口，用于生成特定类型的对象。

但是一开始，谁知道它是做什么用的呢？但是为什么不定义成特定类型的接口呢？

```
public interface Generator { String next(); }
public interface Generator<String> { String next(); }
```

可以看到，普通的、具有特定类型信息的接口，只能规定特定返回类型的方法，或者只能生成特定类型的对象，而泛型接口可以根据需要，通过不同的实现生成和返回不同类型的对象。

而且，提供一个具有意义的名字的泛型接口，让具有相同操作的类来实现，也是一件规范易读且有意义的事情。

### 4 泛型方法

>是否拥有泛型方法，与其所在的类是否是泛型没有关系

泛型方法使得方法本身能够独立于类而产生变化。

**泛型类VS泛型方法：**

使用泛型类，必须在创建对象的时候指定类型参数的值；使用泛型方法，则不必指明参数类型，编译器可以由**类型参数推断（Type Argument Inference）**，通过传入方法的参数的类型，替我们找出具体的类型。

那么，什么时候使用泛型方法呢？**基本的原则是：无论何时，只要能够做到，就尽量使用泛型方法。**即如果使用泛型方法可以取代整个类的泛型化，那么就单纯使用泛型方法即可。

```
public class GenericMethods {
  public <T> void f1(T obj) { System.out.println(obj.getClass().getName()); }
  public static void main(String[] args) {
   GenericMethods gm = new GenericMethods();
   gm.f1("str"); // print: java.lang.String 
   gm.f1(1); // print: java.lang.Integer
   // ...
  }
}
```

但是，类型参数推断有一个缺点：**只对赋值操作有效**，也即只有在赋值操作的时候才能检测参数类型，如果将一个泛型方法调用的结果作为方法的参数传递给另一个方法，那么编译器不会推断出该结果的类型。（也即，需要先赋值，再将赋值的结果作为参数传递出去）

**可变参数的泛型方法：**

```
public static <T> List<T> makeList(T... args) {
  List<T> result  = new ArrayList<T>();
  for(T item : args) {
    result.add(item);
  }
  return result;
}
```

### 5 构建复杂模型

类似于集装箱运输，一层一层地将货物组合起来，然后包装起来，最后装船运输，复杂模型也是从最简单的类开始，依次将某一些类，作为另一个类的类型参数，然后再作为其他类的类型参数，依次“包装”起来，形成一个更为复杂的模型。

```
package Generics;
import java.util.*;
/**
 * 泛型的应用——构建复杂模型：容器化的货船模型
 * 在这个货船模型中，货物利用具有类型信息的容器，将类一层一层地包裹起来：货物 -> 货箱 -> 集装箱 -> 货船
 */
class Product {
    private int productID;
    private String productDescription;
    private double productPrice;
    public Product(int productID, String productDescription, double productPrice) {
        this.productID = productID;
        this.productDescription = productDescription;
        this.productPrice = productPrice;
    }
    public String toString() {
        return "(" + productID + " " + productDescription + " " + productPrice + ")";
    }
    public void descriptionUpdate(String newDescription) {
        this.productDescription = newDescription;
    }
    public void priceUpdate(double newPrice) {
        this.productPrice = newPrice;
    }
    public static Product newDefaultProduct() {
        Random r = new Random(47);
        int randomNumber = r.nextInt(100);
        return new Product(new Random(randomNumber).nextInt(10000), "CargoShip's Product", 0.0);
        // 很奇怪，这个随机数怎么不随机...
    }
    public static Product newProduct(int productID, String productDescription, double productPrice) {
        return new Product(productID, productDescription, productPrice);
    }
    public int getProductID() {
        return this.productID;
    }
}

class ProductBox extends ArrayList<Product> {
    private int productBoxID;
    private int productQuantity;
    public ProductBox() {
        this.productBoxID = (new Random(50).nextInt(1000));
        this.productQuantity = 0;
    }
    public ProductBox(int productQuantity) {
        this.productQuantity = productQuantity;
        this.productBoxID = (new Random(50).nextInt(1000));
        for(int i = 0; i < productQuantity; i++) {
            add(Product.newDefaultProduct());
        }
    }
    public static ProductBox newDefaultProductBox() {
        return new ProductBox();
    }
    public static ProductBox newProductBox(int productQuantity) {
        return new ProductBox(productQuantity);
    }
    public int getProductBoxID() {
        return this.productBoxID;
    }
}

class Container extends ArrayList<ProductBox> {
    private int containerID;
    private int productBoxQuantity;
    public Container() {
        this.containerID = (new Random(50).nextInt(100));
        this.productBoxQuantity = 0;
    }
    public Container(int productQuantity, int productBoxQuantity) {
        this.containerID = (new Random(50).nextInt(100));
        this.productBoxQuantity = productBoxQuantity;
        for(int j = 0; j < productBoxQuantity; j++) {
            add(ProductBox.newProductBox(productQuantity));
        }
    }
    public static Container newDefaultContainer() {
        return new Container();
    }
    public static Container newContainer(int productQuantity, int productBoxQuantity) {
        return new Container(productQuantity, productBoxQuantity);
    }
    public int getContainerID() {
        return this.containerID;
    }
}

public class CargoShip extends ArrayList<Container> {
    private int cargoShipID;
    public CargoShip() {
        this.cargoShipID = (new Random(50).nextInt(10));
    }
    public CargoShip(int containerQuantity, int productQuantity, int productBoxQuantity) {
        this.cargoShipID = (new Random(50).nextInt(10));
        for(int k = 0; k < containerQuantity; k++) {
            add(Container.newContainer(productQuantity, productBoxQuantity));
        }
    }
    public String toString() {
        StringBuilder cargoInfo = new StringBuilder();
        for(Container c : this) {
            cargoInfo.append( "--------------------\n" + "CargoShipID: " + cargoShipID + "\n");
            for(ProductBox pb : c) {
                cargoInfo.append("ProductBoxID: " + pb.getProductBoxID() + "\n");
                for(Product p : pb) {
                    cargoInfo.append(p);
                    cargoInfo.append("\n");
                }
            }
        }
        return cargoInfo.toString();
    }

    public static void main(String[] args) {
        System.out.print(new CargoShip(2,12,4));
    }
}

// Output:
// --------------------
// CargoShipID: 7
// ProductBoxID: 117
// (9122 CargoShip's Product 0.0)
...
```

### 6 泛型的擦除 边界 通配符

#### 6.1 擦除

>在泛型代码内部，无法获得任何有关泛型参数类型的信息。

擦除是有历史渊源的，即为了兼容最初未使用泛型的Java代码，因此擦除的操作降低了Java泛型的“泛化”程度。

在使用Java泛型的时候，任何具体的类型信息都被擦除，唯一知道的只是在使用一个对象（Object）。

可以使用关键字`extends`，在给定泛型类型使用范围的同时，告诉编译器泛型擦除的**边界**。

例如： `<T extends Pet>`

泛型类型参数将会**擦除到它的第一个边界**（也即，可以有多个边界），即`<T extends Pet>`擦除之后，相当于在类的声明里用`Pet`代替`T`一样。

由于擦除在方法体中移除了类型信息，所以运行时的关注点和常出现问题之处就在于——**边界：即对象进入和离开方法的位置**，因为这正是编译器在编译期执行类型检查并插入转型代码的位置——**对传递进来的值进行额外的编译期检查，对传递出去的值插入相应的转型类型信息**。

总之，**边界是泛型中所有动作发生的地方**。

#### 6.2 边界

关键字`extends`在泛型中重用之后，其意义虽然与继承中的意义完全不同，但是用法上还是类似的。

例如：

```
class Pet {}
class WildAnimal {}
interface Height { // Methods }
interface Weight { // Methods }
<T extends Pet>
<T extends Pet & Height>
<T extends Pet & Height & Weight>
// <T extends Pet & WildAnimal> // Error
```

- `extends`后需先接`class`，后接`interface`；
- `extends`后只能接一个类，但是可以接多个接口，形成多边界。

#### 6.3 通配符

Java泛型中的通配符（Wildcards）主要有三种用法：

- 上界通配符（Upper Bounds Wildcards），`<? extends T>`
- 下界通配符（Lower Bounds Wildcards），`<? extends T>`
- 无界通配符，`<?>`

```
class Holder<T> {
  private T obj;
  public Holder() { obj = null; }
  public Holder(T obj) { this.obj = obj; }
  public void set(T obj) { this.obj = obj; }
  public T get() { return this.obj; }
}
```

**为什么要使用通配符？**即使容器的类型参数之间具有继承关系，在程序运行的时候类型信息是会被擦除的，所以类型参数的继承关系，并不能带给容器本身，即不能将`Holder<Apple>`的引用传递给`Holder<Fruit>`，因为编译器的逻辑是：

- 苹果`IS-A`水果
- 装苹果的容器`NOT-IS-A`装水果的容器

所以，需要使用带有通配符的类型参数，让“装苹果的容器”与“装水果的容器”发生关系。

##### **上界通配符**

即`Holder<? extends T>`，表示：**一个能放置类型为T以及一切类型为T的派生类的容器**，所以`Holder<? extends Fruit>`也即表示：能放置所有水果类型的容器。

所以，`Holder<? extends Fruit>`是`Holder<Fruit>`和`Holder<Apple>`的基类，所以可以有以下操作：

```
Holder<? extends Fruit> holder1 = new Holder<Apple>(new Apple());
Holder<? extends Fruit> holder2 = new Holder<Fruit>(new Fruit());
```

##### **下界通配符**

即`Holder<? super T>`，表示：**一个能放置类型为T以及一切类型为T的基类的容器**，所以`Holder<? super Fruit>`也即表示：能放置类型为水果或者类型为水果基类的东西的容器。

如果有`class Fruit extends Food {}`，那么有以下操作：

```
Holder<? super Fruit> holder3 = new Holder<Fruit>(new Fruit());
Holder<? super Fruit> holder4 = new Holder<Food>(new Food());
```

##### **上界VS下界**

*上界`<? extends T>`修饰的容器，不能往里存，只能往外取*

```
// 可以通过赋值的方式，将对象放进容器
Holder<? extends Fruit> holder1 = new Holder<Apple>(new Apple());
// 但是不能调用方法将对象存进去
// holder1.set(new Fruit()); // Error
// holder1.set(new Apple()); // Error
// 取出来，只能放在 Fruit 以及 Fruit 的基类中
Fruit f = holder1.get();
Object obj = holder1.get();
// Apple a = holder1.get(); // Error
```

1. `Holder<? extends Fruit>`是`Holder<Apple>`的基类；

2. `set()`方法的参数类型是`? extends Fruit`，所以编译器不能从这里了解具体是Fruit的哪一个类型，所以直接拒绝；

3. 根据类型擦除，`<? extends Fruit>`将会被擦除成`<Fruit>`，所以在将容器中对象取出来的时候，类型Fruit将会被插入给对象，即取出的对象类型是Fruit，所以只能用Fruit以及Fruit的基类引用盛放。

   也可以这么理解，由于`<? extends Fruit>`可能存放Fruit以及Fruit的派生类，为了类型安全，不能使用任何一种Fruit的派生类的引用盛放取出的对象，只能使用Fruit以及Fruit的基类引用盛放。

*下界`<? super T>`修饰的容器，可以往里存，但是往外取只能放在Object对象中（即丢失类型信息）*

```
// 可以通过赋值的方式，将对象放进容器
Holder<? super Fruit> holder3 = new Holder<Fruit>(new Fruit());
// 可以调用方法将对象存进去
holder3.set(new Fruit());
holder3.set(new Apple());
// 取出来，只能放在 Object类 中，因此会丢失类型信息
Object obj1 = holder3.get();
// Apple a = holder3.get(); // Error
// Fruit f = holder3.get(); // Error
```

1. `Holder<? super Fruit>`是`Holder<Fruit>`的基类，也是其下界，但是这个下界到Fruit为止，不包括`Holder<Apple>`，所以不能将`Holder<Apple>`赋值给`holder3`；
2. 由于`<? super Fruit>`表示下界是Fruit，往上都是Fruit的基类，所以Fruit以及Fruit的派生类都可以利用`set()`方法，放心地存进该容器中；
3. 由于`<? super Fruit>`表示的是Fruit以及Fruit的基类，往上最远可达Object类，所以为了从容器中取出对象的类型安全，只能使用Object类的引用盛放取出的对象。

##### **PECS原则**

PECS（Peoducer Extends Consumer Super）

- 频繁往外读取内容的，适合使用上界通配符；
- 经常往里插入内容的，适合使用下界通配符。

##### **无界通配符**

即**`<?>`**，意味着任何事物，使用起来的效果与使用原生类型一样，但是**意义上是有区别**的：`List<?>`表示“持有某种特定类型而非原生类型的List，只是不知道是什么类型”，而`List`则单纯表示“持有任何Object类型的原生List”。所以，使用`List<?>`更为具体，表示程序员已经经过思考才这么Coding的。

在捕获转换的情况下，特别需要使用无界通配符而不是原生类型。

**捕获转换**，即如果向一个使用`<?>`的方法传递原生类型，编译器可能会推断出实际的类型参数，使得这个方法可以回转并调用另一个使用该类型的方法。

```
public class CaptureConversion {
  static <T> void f1(Holder<T> h1) {
    T t = h1.get();
    System.out.print(t.getClass().getSimpleName());
  }
  static void f2(Holder<?> h2) {
    f1(h2);
  }
  public static void main(String[] args) {
    Holder<?> t = new Holder<Double>(1.0);
    f2(t);
  }
}
// Output:
// Double
// Explaination: t是一个具有无界通配符的容器，相当于Holder<? extends Object>，因此可以收下Holder<Double>对象，f()方法也是无界通配符修饰的容器，可以接纳t，然后将t作为参数传给f1()，接着将之前放在Holder<?>容器中的Holder<Double>对象中存储的对象取出来，获得其类型信息。
// 整个过程中，Holder<?>容器持有的是一个具有特定类型的对象，虽然不知道是什么，但是它不将该对象转换成原生类型Object，所以在最后取出该对象的时候还能推断出其类型。
```

### 7 潜在类型机制

也称结构化类型机制，又称鸭子类型机制——“如果它走起路来像鸭子，叫声也像鸭子，那就把它当作鸭子看待”，言下之意就是：**只要你有特定的方法就行，至于你本质是什么特定类型，我不关心**。

可见，潜在类型机制本质上就是一种代码组织和复用机制，追求的是代码的终极“泛化”和极致“复用”——编写一次，多次使用。

两种支持潜在类型机制的是C++（静态类型语言，编译期执行类型检查）和Python（动态类型语言，所有类型检查发生在运行时）。

Java没有潜在类型机制。

**Java对潜在类型机制的补偿：**

- 反射机制与动态代理，实现运行时的类型信息获取与类方法的动态代理调用，但反射机制将类型检查都推到了运行时，所以需要使用相应的`try`语句捕获可能出现的异常；

- 设计模式——适配器模式

  通过解读潜在类型机制的含义（不关心具体类型，只需要你具有相应的方法即可），可以知道潜在类型机制本质上是**创建了一个包含所需方法的隐式接口**，那么只要我们基于现用的东西，再手动编写、新增相应所需的接口，那应该就可以完美的解决问题。

  **基于现有接口，编写代码产生所需的接口，即适配器模式。**

  可能当前接口中的方法或者方法的参数没有你所需的，你就需要继承/实现基类/原有接口，并在他们上面扩展成你所需的方法，然后在传参数的时候再将你编写的类的对象传递进去，这样在合适的地方就会根据对象的类型调用你自己所实现的方法。

### 8 总结

泛型类型机制最大的优点在于，可以使用丰富多样的容器类。

泛型使用原则：当你希望使用的类型参数比某个具体类型（以及它的所有子类）更加“泛化”的时候——即当你希望写出的代码**能够跨多个类工作**的时候，泛型才是正确的选择。

所以，有必要查看所有的代码，以确定它是否“足够复杂”到必须使用泛型的程度。

由于Java泛型的非天生性，存在很多的问题，但是也催生出了很多的解决方式，比如反射机制，适配器模式，这些方法是熟练使用Java泛型所必须掌握的技能。

### 附：

#### 1 自限定类型

```
class SelfBounded<T extends SelfBounded<T>>
```

含义是：创建一个新类，其继承自一个泛型类型，该泛型类型的类型参数则是新创建的类。

类似于C++中的古怪的循环泛型（CRG）：基类用导出类替代其参数，意味着泛型基类变成了一种其所有导出类的公共功能的模板。

自限定的意义在于，在继承关系中保证类型参数必须与正在被定义的类相同，即只能用于继承关系中。

自限定类型的价值在于，可以产生**协变参数类型——即方法参数类型会随着子类而变化** 。

#### 2 动态类型安全

`java.util.Collections`中的工具可以帮助检查类型安全问题。

静态方法，例如：`checkCollection()`、`checkList()`、`checkMap()`、`checkSet()`、`checkSortedMap`、`checkSortedSet`，将希望动态检查的容器作为方法的第一个参数，希望动态检查的类型作为方法的第二个参数，之后受检查的容器将会在试图插入类型不正确的对象的时候抛出**ClassCastException**异常，而一般情况下只有从容器中取出对象的时候才会检测类型的不正确并抛出异常。

#### 3 泛型用于动态异常检测

泛型的类型参数可以用在一个方法的throws子句中，从而编写出**随着检查出的异常的类型而变化**的动态泛型代码。

#### 4 函数对象与策略设计模式