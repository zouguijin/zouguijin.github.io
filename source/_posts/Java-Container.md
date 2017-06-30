title: Java---Container

date: 2017/06/30 10:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java Container——容器

### 0 容器的出现

>如果一个程序值包含固定数量且生命周期已知的对象，那么算不上一个复杂的程序。

如果需要实现一个较为复杂的程序，那么就不能在程序运行之前就定义好所有的对象和变量，需要留有一定的空间给程序本身，让其在运行的过程中根据需要**动态**地产生相应的对象和变量，因此不能依靠一个一个创建命名的引用的方式来持有每一个对象，而是需要**容器（Container）批量式地持有大量的对象**。

Java用于持有对象最常用、最基本的容器，也即数组，虽然数组简单易用，查询数组元素效率高，但是数组的大小需要在创建数组的时候确定，且之后再也不能修改，这对于动态复杂的程序来说将是一个很大的限制。

所以，Java提供了一套容器类（也称集合类）——**Collection**，包括**List**、**Set**、**Queue**、**Map**以及他们的派生类。不同的容器类具有各自特别的属性，不过**所有的容器类都可以自动地调节自身的尺寸**，给动态程序带来了极大的便利。

注：容器类中没有关键字。

### 1 容器的基本概念

- Collection

  每一个位置只能保存一个元素，形成一个独立元素的**序列**，这些元素都服从一条或者多条规则，比如：List按照插入元素的顺序保存元素，Set中不能有重复的元素，Queue具有“先进先出（FIFO）”原则，Stack具有“后进先出（LIFO）”原则等。

- Map

  每一个位置能保存两个元素，即一组成对的**“键值对”对象**，可以通过Key值查询Value值，其中Key值不能重复，Value值则可以重复。Map中，Key与Value既可以是简单的基本类型，也可以是某一个类的对象。所以，也称Map是“关联数组”或“字典”。

**所有的Collection都可以用`foreach`语法进行遍历。**

### 2 容器类的通用方法

- `Arrays.asList()`，接受一个数组或者一个用逗号分隔的元素列表，返回一个List对象；
- `Collections.addAll()`，接受一个Collection对象和一个数组或者一个逗号分隔的元素列表，将数组或者元素列表添加进Collection对象。
- 对于数组，打印必须使用`Arrays.toString()`方法，但是打印容器可以直接调用`System.out.print()`完成。

### 3 List

List，即列表，将按照插入元素的顺序保存元素。

- ArrayList，适合随机访问元素，但是插入和移除元素的效率较低；

- LinkedList，适合顺序访问元素，适用于插入和移除元素。

  **LinkedList中还有适合用于定制栈、队列和双端队列的方法**，可以利用LinkedList的方法**自定义**一个Stack类、Queue类。

### 4 Set

Set，即集，不保存重复的元素。因此，经常将Set用于**查找**某个对象是否在Set之中：

```
set.contains(obj); // 判断某元素obj是不是在set中
```

所以，存入Set的对象必须定义`equals()` 方法，用于确定存入对象的唯一性。

Set具有与Collection一样的接口，因此与Collection的功能相同，只是行为不一样（即继承与多态的应用：表现不同的行为）。

- HashSet，使用散列函数确定元素在容器中的存储位置，提供最高效的访问速度 ；
- TreeSet，使用红-黑树进行存储，存储的元素之间具有顺序：升序；
- LinkdeHashSet，兼有LinkedList和HashSet的优点。

### 5 Queue

队列，先进先出（FIFO），可以将对象从程序的某个区域安全地转移到另一个区域。

**LinkedList实现了Queue的接口**，并提供了一系列支持队列的方法，因此LinkedList可以作为Queue的一种实现，可以将LinkedList向上转型为Queue。

```
Queue<Integer> queue = new LinkedList<Integer>();
```

- PriorityQueue

  优先级队列，与普通队列（让等待时间最长的元素先出列）不同的是，它提供了一种**排序方式**，让具有最高优先级的元素优先出列。

  Integer、String、Character可以直接与PriorityQueue一起使用，因为这些类型内部已经有自然的排序方式。如果想让优先级队列支持自定义的类的优先级排序，需要**额外设计和实现排序的方式**，或者在自定义的类中实现相应的**Coparator** 。

- 双向队列

  Java中没有显式用于双向队列的接口，但是所存在的**LinkedList**中包含支持双向队列的方法，因此，可以自己组建一个双向队列类，该类中使用LinkedList的方法。

  ```
  public class Deque<T> {
    private LinkedList<T> deque = new LinkedList<T>();
    // 使用双向队列的方法名，封装LinkedList的方法
  }
  ```

### 6 Map

Map，即映射表，具有将一个对象映射到另一个对象上的能力。

Map的Key值不能重复——所以，存储为Key值的对象都需要实现 `equals()` 方法，Value值可以重复，因此Map的Key值可以组成一个Set。

- HashMap，使用散列函数实现快速高效的存储与查找；
- TreeMap，以升序的顺序保存Key值；
- LinkedHashMap，则兼有LinkedList和HashMap的优点；
- WeakHashMap，弱键映射，允许释放映射所指向的对象，即垃圾回收器可以回收映射所指向的对象——如果这些对象没有其他普通引用所指的话；
- ConcurrentHashMap，线程安全的Map，不涉及同步加锁；
- IdentityHashMap，使用==代替`equals()` ，对Key值进行比较。

如果希望创建自己的Map类型，就必须同时定义**Map.Entry**的实现——Map.Entry是一个接口：

```
public class MyMapEntry<K,V> implements Map.Entry<K,V> {
  private K key;
  private V value;
  public MyMapEntry(K key, V value) {
    this.key = key;
    this.value = value;
  }
}
```

### 7 迭代器

作为持有对象的容器，容器类需要具有将对象存进容器并且将容器内的对象读取出来的功能。这本来是一件非常简单的事情，但是容器类有这么多种容器，而且不同容器还可能具有不同类型的对象，难道要每一种每一类都编写功能相同的一段代码么？那可真蠢！

所以，需要利用**迭代器（也是一种设计模式）**解决这个问题。

迭代器是一个**轻量级对象**（创建该对象的代价较小），用于**遍历并选择序列中的对象**，在这个过程中可以对客户端程序员屏蔽序列底层的结构。

Java的迭代器对象——**Iterator（只能单向移动）**：

- 使用容器对象调用`iterator()`方法，将返回属于该容器的迭代器对象Iterator，此时迭代器对象将指向序列的第一个对象；
- `Iterator.next()`方法获取序列的下一个对象；
- `Iterator.hasNext()`方法判断序列是否具有下一个对象；
- `Iterator.remove()`方法将迭代器最近返回的对象（即`next()`方法产生的最后一个对象）从序列中删除，所以删除之前必须调用`next()` ；
- Iterator需要有泛型参数，即需要参数类型——`Iterator<T>`

```
public class IteratorTest {
  public static void main(String[] args) {
    List<Integer> e = new LinkedList<Integer>();
    Random rand = new Random(47);
    for(int i = 0; i < 10; i++) {
      e.add(rand.nextInt(100));
    }
    Iterator<Integer> it = e.iterator();
    while(it.hasNext()) {
      int result = it.next();
      System.out.print(result + " ");
    }
    it = e.iterator();
    while(it.hasNext()) {
      int result = it.next();
      if(result <= 50) {
      	// 删除所有小于等于50的元素，需事先调用 next()
        it.remove();
      }
    }
    System.out.print(e);
  }
}
```

**ListIterator——Iterator的子类型，支持双向移动，但只能用于List的访问**

ListIterator通过产生相对于所指向的当前位置的前一个和后一个元素的索引，实现双向移动。

通过调用`listIterator()`方法创建一个指向List起始位置的ListIterator对象，或者调用`listIterator(n)`方法直接创建一个指向索引为n的元素的ListIterator对象。

使用`set()`方法可以替换`previous()`或者`next()`访问过的最后一个元素，同理在使用上述两个方法之前，需要使用对应的`hasPrevious()`或者`hasNext()`方法。

### 8 foreach与迭代器 

foreach语法能用于数组。

foreach语法也能用于Collection对象，这是因为Java SE5引入的新接口——Iterator，Iterator接口通过`iterator()`方法产生的Iterator轻量级对象可以用来指向容器中的对象，foreach利用Iterator对象就可以实现对容器类中对象的遍历和选取。

因此，如果自定义了一个类，希望这个类的对象能用foreach语法遍历，那么需要先在**该类中实现Iterator接口**。

```
public class IterableClass implements Iterator<String> {
  public String[] words = ("I love you so much !").split(" ");
  public Iterator<String> iterator() {
    return new Iterator<String>() {
      // Do Something you like, define your own Iterator
      private int index = 0;
      public boolean hasNext() {
        return index < words.length;
      }
      public String next() {
        return words[index++];
      }
      public void remove() {
        words[index] = "NULL";
      }
    };
  }
  public static void main(String[] args) {
    for(String str : new IteratorClass()) {
      System.out.print(str + " ");
    }
  }
}
```

### 附：

#### 1 生成器——Generator

```
public interface Generator<T> {
  T next();
}
```

之后，若一个容器想要装填类型为**T** 的对象，如果想利用生成器，那么**首先需要让类T 实现`Generator<T> `接口**，并实现其中的`next()`方法——生成并返回一个**T** 类的对象，然后通过`add((new Generator<T>).next())` 即可将类型为**T** 的对象装填入容器中。

#### 2 享元

如果一个普通的解决方案需要过多的对象，或者产生普通对象太占用空间的时候，可以使用 **享元** 模式——可以具体化一部分对象，而不是一下子具体化全部的对象。

由此，我们可以在更高效的外部表中查找对象的一部分或者整体（类似于外链），而不是将对象所包含的所有事物都包含在对象内部。

#### 3 Collection操作

[Collection接口以及相应的方法](http://docs.oracle.com/javase/7/docs/api/java/util/Collection.html)

[Collections及接口以及相应的方法（更多方法）](http://docs.oracle.com/javase/8/docs/api/java/util/Collections.html)

#### 4 `equals()`与`hashCode()`同在

对于需要保证容器内的对象唯一不重复的，需要对象所在类实现`equals()` 方法，比如Set和Map的Key值；对于需要使用哈希函数的容器，则需要对象所在类实现`hashCode()` 方法。

对于良好的编程风格而言，最好在覆盖`equals()` 方法的同时，覆盖`hashCode()` 方法。

#### 5 散列

散列的目的在于：**想要使用一个对象来查找另一个对象**。

散列的价值在于：**速度** ，散列将会使用存储元素最快的数据结构——数组，存储映射表**Key值的信息，即散列码**（注：不是存储Key本身），而散列码将由定义在Object类中、且可能由程序员自己覆盖过的`hashCode()` 生成。

这就面临一个问题：使用数组存储散列码，数组本身的大小是不能随着所存储元素的数量变化而改变的，那么当映射表的元素增多到一定程度的时候，就会出现**散列冲突** 。

散列冲突的解决，有外部链接完成：数组本身的每一个位置不单单存储散列值，而是存储一个**Entry对象**，每一个Entry对象除了散列值之外，还会带着一个引用变量，用于指向下一个散列值与之相等的Entry对象。即，**数组的每一个位置都有可能带有一条Entry链表**。

散列表的桶位（Bucket），即每一个存储Entry对象的位置，为了让散列分布得尽量均匀，一般桶位的数量会选择质数（但也有使用2的整数次方数）。

`hashCode()` 方法覆盖的意义所在：

- 无法控制Bucket数组的下标值（即相同Entry对象的散列值）的产生，这个值依赖于HashMap对象的容量，而容量的改变与容器的充满程度和负载因子有关；
- 保证同一个对象调用`hashCode()` 方法前后都应该生成同样的哈希值；
- 既不要让`hashCode()` 方法依赖于变化的值（散列码会不断变化），也不要依赖于具有唯一性的对象信息（无法随着新对象的加入，生成新的Key值），而是要**将`hashCode()`方法与对象内具有意义的信息绑定**。

HashMap的术语：

- 容量：桶位数，即每一个存储Entry对象的位置；
- 初始容量，HashMap在创建的时候定义的桶位数；
- 尺寸：HashMap当前所存储的项数（对象数）；
- 负载因子 = 尺寸/容量，负载轻的表出现冲突的概率小，查找速率也会较快，但是会增加HashMap的存储空间。可以使用相应的构造方法在创建HashMap的时候指定负载因子的大小（默认0.75），当达到负载水平的时候容量将自动增加：大致是容量加倍，然后重新将现有的对象分布到新的桶位中——**再散列**。

#### 6 Comparable接口与Comparator接口

两者都是用于实现类对象的排序的，常用于实现集合中对象的排序。

对于集合排序来说，Comparable实现的比较与排序是**内部定义**的，即集合所存储的对象如果要具有比较和排序的能力，那么对象所在的类需要实现Comparable接口，实现并覆盖`compareTo()` 方法；而Comparator所实现的比较与排序则是**外部定义**的，即比较和排序将会在独立于集合和集合所存储对象之外的另一个类中实现。

由此可以看出，Comparator接口使用的是**策略模式**，提供一个外在的策略对象，在不改变集合中所存储对象所在类的前提下，完成对集合中对象的比较和排序。当然，如果你具有集合所存储对象的所属类的修改权限，使用Comparable接口也是不错的。

如果需要容器具有比较和排序的能力，比如TreeSet和TreeMap，则需要装载入容器的对象所在类实现Comparable接口，或者是在另一个独立的类中实现Comparator接口。

#### 7 只读的Collection或Map

```
List<String> roArray = Collections.unmodifiableList(new ArrayList<String>(data));
Set<String> roHashSet = Collections.unmodifiableSet(new HashSet<String>(data));
Map<String,String> roArray = Collections.unmodifiableMap(new HashMap<String,String>(data));
```

#### 8 同步的Collection或Map

将上述的`Collections,unmodifiableXXX()` 替换成`Collections.synchronizedXXX()` 即可。

#### 9 快速报错机制

探查容器上的任何除了你的进程所进行的操作以外的所有变化。

使用`try-catch` 语句，如果有问题，则会抛出 **ConcurrentModificationException** 异常。

**ConcurrentHashMap、CopyOnWriteArrayList和CopyOnWriteArraySet**都支持该异常。

#### 10 Reference类与持有引用

`java.lang.ref` 类库中包含一组类，为垃圾回收提供了更大的灵活性。

对象是**可获得的（Reachable）**，表示此对象可以在程序中的某处找到，即意味着在栈中存在某一个**普通的引用**指向该对象，也可能是栈中的引用指向某个对象，而该对象中含有另一个引用指向正在讨论的对象。

如果一个对象是“可获得的”，说明程序的某处还需要使用它，那么垃圾回收机制无法将其回收并释放相应的资源。

因此，就带来了**Reference类及其派生类对象的应用场景：**

希望持有对某个对象的引用，以便将来某个时候对其进行访问，但是希望垃圾回收机制可以自行回收该对象并释放相应的资源。

在上述情况下，可以**利用Reference对象对普通的引用进行包装**，即在程序和对象之间的引用链接替换成了Reference对象，而不是普通的引用。

主要包括**Reference** 抽象类以及派生类（以下排序由上至下，由强到弱）：

- SoftReference，用于实现敏感的高速缓存；
- WeakReference，实现“规范映射”，不妨碍垃圾回收机制回收映射的Key与Value；
- PhantomReference，用于调度回收前的清理工作，比Java终止机制更为灵活。
- 前两者在使用的时候可以考虑是否将它们放进ReferenceQueue，而最后一个只能依赖于ReferenceQueue。

**WeakHashMap**

- 可以实现“规范映射”，在这种映射中，**每个值只保存一份实例**以节省存储空间，当程序需要某一个值的时候，就在映射中**查询现有的对象实例** ，然后使用它（而不是重新创建一个与现有实例相同的实例）
- 可以用于保存WeakReference，映射会**自动使用WeakReference包装相应的Key和Value**，从而允许垃圾回收机制自动清理Key和Value，除非有普通的引用指向Key或Value，否则将会被回收和释放。

#### 11 旧容器

Hashtable、Vector、Stack都是遗留下来的就容器类，目的只是为了支持老一版本的程序，不要在新版本的程序中使用它们。