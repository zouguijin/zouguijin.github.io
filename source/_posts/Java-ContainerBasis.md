title: Java---ContainerBasis

date: 2017/06/22 11:00:00

categories:

- Study

tags:

- JavaBasis

---

## Java Container(Basis)——容器（基础）

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

Set具有与Collection一样的接口，因此与Collection的功能相同，只是行为不一样（即继承与多态的应用：表现不同的行为）。

- HashSet，使用散列函数确定元素在容器中的存储位置，提供最高效的访问速度；
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

### 6 Map

Map，即映射表，具有将一个对象映射到另一个对象上的能力。

Map的Key值不能重复，Value值可以重复，因此Map的Key值可以组成一个Set。

- HashMap，使用散列函数实现快速高效的存储与查找；
- TreeMap，以升序的顺序保存Key值；
- LinkedHashMap，则兼有LinkedList和HashMap的优点。

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

