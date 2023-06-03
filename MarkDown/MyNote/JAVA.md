<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>


# <center>JAVA</center>

---

---

---

### 基本数据类型

|  类型   |  包装类   | 默认值 |
| :-----: | :----: | :----: |
|  byte   |   Byte    |   0    |
|  short  |   Short   |   0    |
|   int   |  Integer  |   0    |
|  long   |   Long    |   0L   |
|  float  |   Float   |  0.0F  |
| double  |  double   |  0.0D  |
|  char   | Character |   0    |
| boolean |  Boolean  | false  |

> 注：

```java
1.数值范围【double > float > long > int > short > byte】;
2.char、byte、short三种数据类型在进行数学运算的过程中, 会自动提升为int数据类型, 然后再进行运算;
3.进行数学运算的过程中, 数据类型不同不能直接进行运算, 取值范围小的数据类型会自动转成取值范围大的数据类型, 然后进行运算;
4.基本数据类型的赋值操作传递的是数据值, 应用数据类型(非基本数据类型)的赋值操作传递的是对象的地址值, 操作时先通过地址值找到对应的对象, 在对对象进行操作;
```

---
### Final修饰符

> ###### 特点

```java
1.被"final"修饰的类不可以被继承;
2.被"final"修饰的成员属性只能被赋值一次;
3.被"final"修饰的成员方法不能被子类重写;
```

> ###### 使用规范

```java
实际开发中, 被"final"修饰的成员属性一般作为配置信息, 不会随意更改, 属性名一般全部使用大写字母, 多个单词之间用下划线隔开;
```

---

### Static修饰符

> ###### 特点

```java
被"static"修饰的成员属性和成员方法被该类所有的实例化对象所共享(不属于对象, 属于类);
```

> ###### 调用方式

```java
1.通过类名或接口名调用(推荐); 2.通过对象名调用;
```

> ###### 用途

```java
静态属性: 常用于设置JavaBean中对象共享的一致属性;
静态方法: 常用于工具类(帮助我们做一些事情, 但不描述任何事物的类);
```

```java
注: 同一个类中, 静态方法内无法访问非静态成员; 工具类应该私有化构造方法, 因为不需要创建对象, 只需要通过类名调用类中的静态方法;
```

---

### Abstract修饰

> ###### 特点

```java
"abstract"用于修饰抽象类和抽象方法
```

> ###### 抽象类和抽象方法

```java
public abstract 类名 { // 抽象类
    权限修饰符 abstract 返回值类型 方法名(参数···); // 抽象方法(权限修饰符不能是private)
    ···
}
```

> ###### 注意事项

```java
1.抽象方法不能存在方法体;
2.抽象类的非抽象子类必须重写父类的所有抽象方法;
3.抽象类可以存在构造方法但不能被实例化, 即不能用于创建对象;
4.抽象类中不一定有抽象方法, 但是包含抽象方法的类一定是抽象类;
```

---

### 权限修饰符

> ###### 作用范围

|    修饰符     | 同一个类中 | 同一个包中 | 不同包下的子类 | 不同包下的无关类 |
| :--------: | :-----: | :-----: | :------: | :--------: |
|  **private**  |     ✔      |     ❌      |       ❌        |        ❌         |
|  **default**  |     ✔      |     ✔      |       ❌        |        ❌         |
| **protected** |     ✔      |     ✔      |       ✔        |        ❌         |
|  **public**   |     ✔      |     ✔      |       ✔        |        ✔         |

---

### 静态代码块

> ###### 格式

```java
static {
    ···
}
```

```java
注: 静态代码块是在类中直接声明的, 而不是在方法中声明;
```

> ###### 特点

```java
静态代码块随着类的加载而加载, 并且自动触发、只执行一次, 只有在对象第一次被创建的时候执行, 可以用于进行数据的初始化操作;
```

---

### 键盘录入

> ###### Step1.导包

```java
import java.util.Scanner;
```

> ###### Step2.创建Scanner对象

```java
Scanner scanner = new Scanner(System.in);
```

> ###### Step3.获取键盘录入内容

```java
/*法一: 以上方法录入过程中不可以存在空格或制表符*/
String value = scanner.next();
int value = scanner.nextInt();
long value = scanner.nextLong();
byte value = scanner.nextByte();
float value = scanner.nextFloat();
double value = scanner.nextDouble();
boolean value = scanner.nextBoolean();
```

```java
/*法二: 接收一整行, 录入过程中可以存在空格或制表符*/
String value = scanner.nextLine();
```

> ###### Step4.关闭Scanner对象

```java
scanner.close(); // 一旦执行该操作, 后续将无法使用Scanner对象(新建也不行), 因此要在确定后续不会继续使用Scanner对象时执行该操作
```

---

### 判断语句

> ###### if语句

```java
if (关系表达式) {
    ···
} else if (关系表达式) {
    ···
} 
    ···
else {
    ···
}
```

> ###### switch语句(通用)

```java
switch (表达式) {
    case 值1:
        ···
        break;
    case 值2:
        ···
        break;
    ···
    default:
        ···
        break;
}
```

> ###### switch语句(适用于JDK12及以后)

```java
switch (表达式) {
    case 值1 -> {
        ···
    }
    case 值2 -> {
        ···
    }
    ···
    default -> {
        ···
    }
}
```

---

### 循环语句

> ###### for循环

```java
/*法一*/
for (初始化语句; 条件语句;) {
     ···
    条件控制语句;
}
```

```java
/*法二*/
for (初始化语句; 条件语句; 条件控制语句) {
     ···
}
```

```java
// 例:
for (int i = 1; i <= 5;) {
    System.out.println(i);
     i++;
}
for (int i = 1; i <= 5; i++) {
	System.out.println(i);
}
```

> ###### while循环

```java
初始化语句;
while (条件判断语句) {
    ···
    条件控制语句;
}
```

```java
// 例:
int i = 1;
while (i <= 5) {
    System.out.println(i);
    i++;
}
```

> ###### do···while循环

```java
初始化语句;
do {
    ···
    条件控制语句;
} while (条件判断语句);
```

```java
// 例:
int i = 1;
do {
    System.out.println(i);
    i++;
} while (i <= 5);
```

> ###### 增强for循环

```java
for (数据类型 变量名 : 数组名或集合名) {
    ···
}
```

```java
// 例:
int[] arr = {1, 2, 3, 4, 5};
for (int num : arr) {
    System.out.println(num);
}
```

> 注:

```java
1.for循环与while循环是先判断再执行;  do···while循环是先执行再判断;
2.在循环体中执行"break;"表示结束整个循环操作; 执行"continue;"表示跳出本次循环操作继续执行下一次循环操作;
```

---

### 异常

> ###### 异常的抛出

```java
/*格式*/
throw new 异常类类名(···);
```

```java
// 列:
throw new NullPointerException("访问的变量不存在 ...");
```

> ###### 异常的声明

```java
修饰符 返回值类型 方法名(参数···) throws 异常类类名1, 异常类类名2, ···{
    ···
}
```

```java
注: "throws"关键字运用于方法声明之上, 表示当前方法可能抛出的异常类型; 若异常类型是编译时期异常必须声明, 若异常类型是运行时期异常可以省略;
```

> ###### 异常的捕获

```java
try {
    ···(可能发生异常代码)
} catch (异常类A 变量名) { 
    ···(捕获异常后的操作)
} catch (异常类B 变量名) { 
    ···(捕获异常后的操作)
} ··· finally {
    ···(最终要执行的操作) // 常用于关闭资源
}
```

```java
注: 如果异常类型之间存在继承关系, 则级别高的异常类型要写在下面; 一般只捕获异常类型的顶级父类"Exception"("Throwable"下分"Error"和"Exception"两个子类, "Error"代表系统级别的错误, 开发人员不用管, 因此常将"Exception"是为是异常类型的顶级父类), 变量名一般使用字母"e"表示; 可以采用"catch (异常类1 | 异常类2 | ··· 变量名)"的方式由一个"catch"捕获多种异常, 适用于对多种异常采取相同操作的情形;
```

> ###### 异常信息的处理

```java
/*Throwable类常用成员方法*/
String getMessage(); // 获取异常的描述信息
String toString(); // 获取异常的类型和描述信息
void printStackTrace(); // 打印异常的跟踪栈信息并输出到控制台
```

```JAVA
注: 异常信息的详细程度"printStackTrace" > "toString" > "getMessage"
```

---

### 继承

> ###### 格式

```java
public class 子类 extends 父类 {
    ···
}
```

```java
注: 未声明父类的类默认继承"Object"类, 因此可以将"Object"类看作是一切类的祖宗类
```

> ###### 子类继承的内容

| 父类的内容 | 非私有 | 私有 |
| :-----: | :----: | :--: |
|  构造方法  |   ❌    |  ❌   |
|  成员属性  |   ✔    |  ✔   |
|  成员方法  |   ✔    |  ❌   |

```java
注: 子类虽然能够继承父类的私有成员属性, 却不能直接在子类内对其进行设置和调用, 可以通过"set"和"get"方法进行相关操作;
```

> ###### this和super关键字

|     关键字      | 访问构造方法 |  访问成员属性  |  访问成员方法  |
| :-------: | :-------: | :------: | :------: |
| **this(本类)**  |  `this(···);`  | this.成员属性 | this.成员方法  |
| **super(父类)** | `super(···);` | super.成员属性 | super.成员方法 |

```java
注: 可以利用"this"和"super"关键字针对性地调用局部、成员、父类中重名的属性或方法(非重写方法), 静态方法中不能使用"this"和"super"关键字;
```

```java
注: 子类虽然不能继承父类的构造方法, 但是子类的构造方法默认会先调用父类的无参构造方法, 即首行执行"super();", 其目的是对从父类继承的各属性和方法进行初始化, 我们同样可以通过首行执行"super(···);"的方式调用父类的含参构造方法; 
```

> ###### 方法重写

```java
当父类的方法不能满足子类当前的需求时, 需对父类的方法进行重写, 即在子类中重写一个与父类中重名的方法, 并在重写方法上方添加"Override"的注解;
```

```java
/*注意事项*/
1.父类中的私有方法和静态方法不能被重写;
2.重写方法的方法名、形参列表必须与父类中的一致;
3.重写父类方法时, 返回值类型必须小于等于父类(指返回值类型之间的继承关系);
4.重写父类方法时, 访问权限子类必须大于等于父类(default < protected < public);
```

---

###  接口

> ###### 接口的创建

```java
public interface 接口名 {
    定义抽象方法;
    ···
}
```

> ###### 接口的实现

```java
public class 类名 implements 接口1, 接口2, ··· {
    重写接口中所有的抽象方法;
    ···
}
```

> ###### 接口的特点

```java
1.接口不存在构造方法;
2.接口和接口之间可以存在多继承的关系;
3.接口中方法的默认修饰符为"public abstract";
4.接口中的成员属性只能是常量(即"final"修饰), 其默认修饰符为"public static final";
```

> 注:

```java
JDK版本小于8, 接口中只能声明抽象方法;
```

```java
JDK版本大于等于8, 接口中可以声明由"public static"和"public default"修饰的包含方法体的方法; 其中"public default"修饰的方法不强制要求实现类对其进行重写, 但在多实现关系中, 如果存在多个接口中包含同名的且由"public default"修饰的方法, 实现类必须对该方法进行重写;
```

```java
JDK版本大于等于9, 接口中可以声明由"private"和"private static"修饰的的包含方法体的方法; 其目的是服务于接口内部的方法, 并且防止被外部调用;
```

---

### 泛型

> ###### 定义格式

```java
<泛型符号> // 常用E、K、T、V等大写字母表示, 若要声明多个泛型符号, 各泛型符号之间用逗号隔开
```

> ###### 泛型类

```java
/*格式*/
修饰符 class 类名<泛型符号> { // 该方式声明的泛型符号能在本类中的任意位置使用
    ···
}
```

```java
// 例:
public class ArrayList<E> {
    ···
}
```

> ###### 泛型接口

```java
/*格式*/
修饰符 interface 接口名<泛型符号> { // 该方式声明的泛型符号能在本类接口中的任意位置使用
    ···
}
```

```java
// 例:
public interface List<E> {
    ···
}
```

> ###### 泛型方法

```java
/*格式(在非泛型类中)*/
修饰符<泛型符号> 返回值类型 方法名(参数···) { // 该方式声明的泛型符号只能在本方法中使用
    ···
}
```

```java
// 例:
public class MyClass {
    private<E> void myFunction(E e) {
        ···
    }
    ···
}
```

> ###### 限制泛型的匹配范围

```java
<? super 数据类型> // 只可以传递对应数据类型和其所有父类类型的数据
<? extends 数据类型> // 只可以传递对应数据类型和其所有子类类型的数据
```

```java
注: 该方式常用于限制方法中带有泛型的参数的匹配范围, 使用该方式不需要声明泛型符号;
```

```java
// 例:
public class MyClass {
    private void myFunction(List<? extends ParentClass> list) {
        ···
    }
    ···
}
```

---

### 多态

> ###### 对象创建

```java
父类类型 对象名 = new 子类构造方法; // 父类类型可以是子类所继承的父类, 也可以是子类所实现的接口
```

> ###### 类型转换

```java
if (对象 instanceof 子类类型) { // "instanceof"用于判断对象是否为该子类类型, 此处判断用于防止发生错误的强制转换
    子类类型 对象名 = (子类类型)对象; // 强制类型转换
    ···
}
```

> 注:

```java
多态对象调用的成员属性是父类中的成员属性; 对象调用的成员方法必须存在于父类, 但优先使用子类中的重写方法, 子类中没有重写方法则调用父类中的成员方法; 如果想调用子类中独有的成员属性或方法, 需要将多态对象强制转换为子类类型后进行调用;
```

---

### 内部类

> ###### 定义

```java
写在一个类里面的类就叫内部类, 内部类可以直接访问外部类的成员, 但外部类不能直接访问内部类的成员, 需创建对象后访问;
```

> ###### 成员内部类

```java
写在成员位置, 属于外部类的成员, 修饰规则与部类的成员一致;
```

```java
/*定义格式*/
public class 外部类类名 {
    ···
    权限修饰符 class 内部类类名 {
        ···
    }
}
```

```java
/*创建成员内部类对象*/
在外部类定义一个成员方法, 返回成员内部类对象; // 法一(当内部类为private修饰时)
外部类.内部类 对象名 = new 外部类构造方法.new 内部类构造方法; // 法二(当内部类为非private修饰时)
```

```java
/*内部类成员方法中区分不同作用域的重名属性*/
变量名; // 就近访问局部变量
this.属性名; // 访问内部类成员属性
外部类.this.属性名; // 访问外部类成员属性
```

> ###### 静态内部类

```java
由"static"修饰的成员内部类
```

```java
/*定义格式*/
public class 外部类类名 {
    ···
    权限修饰符 static class 内部类类名 {
        ···
    }
}
```

```java
/*创建静态内部类对象*/
外部类.内部类 对象名 = new 外部类类名.内部类构造方法;
/*调用静态内部类中的静态方法*/
外部类类名.内部类类名.方法名(参数···);
/*调用静态内部类中的非静态方法*/
先创建静态内部类对象, 用对象调用;
```

> ###### 局部内部类

```java
写在方法中的类, 其地位等同于方法中的局部属性;
```

```java
/*定义格式*/
public class 外部类类名 {
    ···
    修饰符 返回值类型 方法名(参数···) {
        class 内部类类名 {
			···
		}
        ···
    }
}
```

```java
注: 外界无法直接使用局部内部类, 仅能在其所在方法内部创建对象并使用;
```

> ###### 匿名内部类

```java
定义一个没有名字的内部类(类名由虚拟机生成), 整个过程包含了类的定义、类的继承或接口的实现、对象的创建;
```

```java
/*完整格式*/
类名或接口名 对象名 = new 类名或接口名() { // 等号左边的类或接口级别要高于或等于等号右边的类或接口
    重写类或接口中的抽象方法;
    ···
}; // 注意此处的分号！！！
```

```java
注: 匿名内部类的实质是定义了一个继承了等号右边的类或实现了等号右边接口的类, 并直接创建了该类的实例化对象, 可以直接用该对象调用重写的方法;
```

```java
/*Lambda表达式格式*/
接口名 对象名 = (参数···) -> { // 对应接口中的抽象方法
    ···
}; // 注意此处的分号！！！
```

```java
注: Lambda表达式只能简化函数式接口(接口中有且仅有一个抽象方法)的匿名内部类的写法; Lambda表达式中参数类型可以省略不写, 如果参数只有一个, "()"可以省略; 如果方法体只有一行, "{}"、"return"以及";"也可省略(要同时省略); 
```

```java
/*方法引用格式*/
接口名 对象名 = 类名::new // 引用类的构造方法
接口名 对象名 = 类名::方法名 // 引用类的静态方法
接口名 对象名 = 对象::方法名 // 引用类的成员方法
接口名 对象名 = this::方法名 // 引用本类的成员方法
接口名 对象名 = super::方法名 // 引用父类的成员方法
```

```java
注: 方法引用与只Lambda表达式一样, 只能简化函数式接口(接口中有且仅有一个抽象方法)的匿名内部类的写法, 被引用的方法与接口中抽象方法的返回值类型和形参列表必须保持一致; 
```

```java
注: 当使用"类名::方法名"的方式引用成员方法(非静态方法)时, 被引用方法的参数列表需比接口中抽象方法的参数列表少一个参数, 且与接口中抽象方法参数列表的第二个参数至最后一个参数保持一致, 接口中抽象方法参数列表的第一个参数为被引用方法的调用者, 即被引用方法只能是该参数对应数据类型中的成员方法;
```

---

### 字符串

> ###### 字符串比较

```java
boolean 字符串.equals(String anotherString); // 完全比较
boolean 字符串.equalsIgnoreCase(String anotherString); // 忽略英文大小写比较
```

```java
问: 为什么不可以用"=="进行比较;
答: "=="仅适用于基本数据类型之间的比较, 对于非基本数据类型的数据"=="比较的内容实际为被比较双方的内存地址是否相同;
```

> ###### 常用成员方法

```java
int length(); // 获取字符串长度
char[] toCharArray(); // 字符串转字符数组
char charAt(int index); // 获取字符串索引对应的字符
byte[] getBytes(); // 采用默认的编码方式将字符串转字节数组
String[] split(String regex); // 使用正则表达式对字符串进行拆分
boolean contains(CharSequence s); // 判断字符串是否包含字符串"s"
static String valueOf(Object obj); // 将其他类型的数据转化为字符串
boolean endsWith(String suffix);  // 判断字符串是否以"suffix"结尾
boolean startsWith(String prefix); // 判断字符串是否以"prefix"开头
byte[] getBytes(Charset charset); // 采用指定的编码方式将字符串转字节数组
String substring(int beginIndex); // 字符串截取, 截取范围从起始位置至末尾
boolean matches(String regex); // 判断字符串是否与正则表达式匹配(仅限单行字符串)
String substring(int beginIndex, int endIndex); // 字符串截取, 截取范围左闭右开
String replaceAll(String regex, String newStr); // 用"newStr"替换掉正则表达式匹配的内容
String replaceAll(String regex, String replacement); // 使用正则表达式对字符串中的内容进行替换 
String replace(CharSequence target, CharSequence replacement); // 使用字符串对字符串中的内容进行替换
```

> ###### 字符串拼接

```java
/*法一: 适用于少量的字符串拼接*/
String string = 字符串1 + 字符串2 + 字符串3 + ···;
```

```java
/*法二: 适用于大量的字符串拼接*/
// 1.构建StringBuilder对象
StringBuilder stringBuilder = new StringBuilder(); // 无参构造
StringBuilder stringBuilder = new StringBuilder(String str); // 含参构造
// 2.向StringBuilder对象中添加字符串(支持添加的的类型很多, 此处只展示追加字符串)
stringBuilder.append(字符串1);
stringBuilder.append(字符串2);
stringBuilder.append(字符串3);
···
// 补充StringBuilder的常用方法
stringBuilder.reverse(); // 颠倒StringBuilder对象中字符串
stringBuilder..length(); // 获取StringBuilder对象中字符串的长度
// 3.将StringBuilder对象转化为字符串
String string = stringBuilder.toString();
```

```java
// 例(效率比较):
// 法一
String string = "";
for (int i = 0; i < 999999; i++) {
    string = string + "0";
}
System.out.println(string);
// 法二
StringBuilder stringBuilder = new StringBuilder();
for (int i = 0; i < 999999; i++) {
    stringBuilder.append("0");
}
String string = stringBuilder.toString();
System.out.println(string);
```

> ###### 字符串与基本数据类型的转换

```java
byte Byte.parseByte(String s); // 将字符串转换为对应的byte类型
int Integer.parseInt(String s); // 将字符串转换为对应的int类型
long Long.parseLong(String s); // 将字符串转换为对应的long类型
short Short.parseShort(String s); // 将字符串转换为对应的short类型
float Float.parseFloat(String s); // 将字符串转换为对应的float类型
double Double.parseDouble(String s); // 将字符串转换为对应的double类型
boolean Boolean.parseBoolean(String s); // 将字符串转换为对应的boolean类型
```

---

### 数组

> ###### 一维数组初始化

```java
/*法一*/
数据类型[] 数组名 = new 数据类型[数组长度]; // 动态初始化
数据类型[] 数组名 = {元素1, 元素2, 元素3, ···}; // 静态初始化简化版
数据类型[] 数组名 = new 数据类型[]{元素1, 元素2, 元素3, ···}; // 静态初始化完整版
```

```java
/*法二*/
数据类型 数组名[] = new 数据类型[数组长度]; // 动态初始化
数据类型 数组名[] = {元素1, 元素2, 元素3, ···}; // 静态初始化简化版
数据类型 数组名[] = new 数据类型[]{元素1, 元素2, 元素3, ···}; // 静态初始化完整版
```

```java
注: 动态初始化后的数组, 数组中各元素为该数据类型的默认值;
```

```java
// 例:
int[] intArray = new int[5];
int[] intArray = {1, 2, 3, 4, 5};
int[] intArray = new int[]{1, 2, 3, 4, 5};
int intArray[] = new int[3];
int intArray[] = {1, 2, 3, 4, 5};
int intArray[] = new int[]{1, 2, 3, 4, 5};
```

> ###### 一维数组的遍历

```java
for (int i = 0; i < arrayObject.length; i++) {
    ···
}
```

```java
// 例:
int[] intArray = new int[]{1, 2, 3};
for (int i = 0; i < intArray.length; i++) {
    System.out.println(intArray[i]);
}
```

> ###### 二维数组初始化

```java
/*法一*/
数据类型[][] 数组名 = new 数据类型[二维数组长度][每个一维数组长度]; // 动态初始化
数据类型[][] 数组名 = {一维数组1, 一维数组2, 一维数组3, ···}; // 静态初始化简化版
数据类型[][] 数组名 = new 数据类型[][]{一维数组1, 一维数组2, 一维数组3, ···}; // 静态初始化完整版
```

```java
/*法二*/
数据类型 数组名[][] = new 数据类型[二维数组长度][每个一维数组长度]; // 动态初始化
数据类型 数组名[][] = {一维数组1, 一维数组2, 一维数组3, ···}; // 静态初始化简化版
数据类型 数组名[][] = new 数据类型[][]{一维数组1, 一维数组2, 一维数组3, ···}; // 静态初始化完整版
```

```java
注: 动态初始化后的数组, 数组中各元素为该数据类型的默认值;
```

> ###### 二维数组的遍历

```java
for (int i = 0; i < arrayObject.length; i++) {
    for (int j = 0; j < arrayObject[i].length; j++) {
        ···
    }
}
```

```java
// 例:
int[][] intArray = new int[][]{
    {1, 2, 3}, 
    {4, 5, 6}, 
    {7, 8, 9}
};
for (int i = 0; i < intArray.length; i++) {
    for (int j = 0; j < intArray[i].length; j++) {
        System.out.println(intArray[i][j]);
    }
}
```

> ###### 可变参数

```java
数据类型 ... 参数名
```

```java
注: 方法的参数列表中只能存在一个可变参数, 且必须位于参数列表末尾; 可变参数在方法内部被接收为一个一维数组; 传参时也可以将参数封装到一个数组中整体传入;
```

```java
// 例:
public static int getSum(int ... intArr) {
    int sum = 0;
    for (int value : intArr) {
        sum += value;
    }
    return sum;
}
```

---

### 单列集合

> ###### Collection

```java
"Collection"是单列集合的顶层接口, 其常用的具体子接口有"Set"和"List"; "Set"中的元素不存在索引且不允许重复, "List"中的元素存在索引且允许重复; 
```

```java
/*常用成员方法*/
int size(); // 获取集合的长度
void clear(); // 清空集合中的元素
boolean add(E e); // 向集合中添加元素
boolean isEmpty(); // 判断集合是否为空
Object[] toArray(); // 将集合转化为数组
Stream<E> stream(); // 获取此集合作为源的Stream对象
Iterator<E> iterator(); // 获取迭代器对象, 指向集合的首个元素
boolean remove(Object o); // 从集合中移除指定的元素, 删除第一个匹配项
boolean removeAll(Collection<?> c); // 从集合中移除特定集合中的所有元素
boolean addAll(Collection<? extends E> c); // 向集合中添加另一个集合中的全部元素
boolean contains(Object o); // 判断集合中是否存在指定的元素, 底层是遍历集合中的元素通过调用equals方法进行比较
void forEach(Consumer<? super T> action); // 对集合中的元素进行遍历, "action"是一个重写"Consumer"接口中"accept"方法的实例化对象(常用匿名内部类), 通过"accept"方法对当前遍历元素进行操作
<T> T[] toArray(T[] a); // 将集合转化为特定数据类型"T"的数组, 若数组"a"的长度小于集合的长度, 则会创建一个新的数组来存储元素; 若数组"a"的长度大于或等于集合的长度, 则会使用数组"a"来存储元素, 数组的第"集合长度"索引位置的元素会被设置为"T"类型的默认值, 第"集合长度 + 1"及之后索引位置上的元素为数组"a"原索引位置上的元素
```

```java
/*Set集合的特有方法*/
static <E> Set<E> of(E... elements); // 创建不可变Set集合, 创建后不可对集合进行修改相关的操作
static <E> Set<E> copyOf(Collection<? extends E> coll) // 复制集合"coll"中的内容, 生成一个不可变Set集合, 创建后不可对集合进行修改相关的操作
```

```java
/*List集合的特有方法*/
E get(int index); // 依据索引查找集合中的元素
E remove(int index); // 删除集合中的元素, 依据索引进行查询, 返回被删元素
E set(int index, E element); // 依据索引重置对应元素, 返回被修改元素, 即原来的旧值
void add(int index, E element); // 向集合中的指定位置插入元素, 原来索引上的元素会依次后移
static <E> List<E> of(E... elements); // 创建不可变List集合, 创建后不可对集合进行修改相关的操作
ListIterator<E> listIterator(); // 获取List集合的列表迭代器, 指向集合的首个元素(ListIterator是Iterator的一个子类)
istIterator<E> listIterator(int index); // 获取List集合的列表迭代器, 并设置指针的初始位置(ListIterator是Iterator的一个子类)
static <E> List<E> copyOf(Collection<? extends E> coll); // 复制集合"coll"中的内容, 生成一个不可变List集合, 创建后不可对集合进行修改相关的操作
```

> ###### 迭代器Iterator

```java
boolean hasNext(); // 判断当前指针指向位置是否有元素
E next(); // 获取当前指针指向的元素, 并将指针移动至后一个元素
void remove(); // 删除当前迭代器获取的元素(使用迭代器的过程中无法使用Collection的add方法或remove方法对集合进行修改)
```

> ##### 列表迭代器ListIterato

```java
/*在Iterator的基础上新增方法*/
boolean hasPrevious(); // 判断当前指针指向的前一个位置是否有元素
E previous(); // 获取当前指针指向的前一个元素, 并将指针移动至前一个元素
void add(E e); // 在当前指针指向位置插入元素, 原来索引上的元素会依次后移
void set(E e); // 修改当前迭代器获取的元素(使用迭代器的过程中无法使用Collection的add方法或remove方法对集合进行修改)
```

> ###### HashSet

```java
"HashSet"是"Set"接口的一个实现类, 其存储数据的模式采用的是哈希表结构, 集合中存储的数据是无序的; 
```

```java
/*存储机制*/
基于待存储元素的"HashCode"方法获取哈希值, 根据哈希值计算在数组中的存储位置, 若存储位置上没有数据, 则将元素存储到该位置上; 若存储位置上已有数据, 则基于元素的"equals"方法与存储位置上的数据进行比较, 若相同则放弃存储, 若不同则与存储位置上的已有数据形成链表结构(链表结构过长时会转化为红黑树结构)存放在数组的同一个位置上;
```

> ###### LinkedHashSet

```java
"LinkedHashSet"是"HashSet"的一个子类, 其存储数据的模式采用的是哈希表结构, 并采用双向链表结构记录数据的添加顺序, 集合中存储的数据是有序的;
```

```java
/*有序机制*/
元素的存储机制与"HashSet"一致, 但在存储的过程中会为每一个元素记录上一个存入元素和下一个存入元素的地址值, 形成一个双向链表结构, 遍历时依据双向链表从头至尾按存入顺序遍历;
```

> ###### TreeSet

```java
"TreeSet"是"Set"接口的一个实现类, 其存储数据的模式采用的是红黑树结构, 存储的过程中会对存储元素进行排序(可自定义比较规则); 默认数值由小到大排序, 字符按照ASCII码表中的数字由小到大排序;
```

```java
/*存储机制*/
若比较规则返回的是负数, 则认为待存储元素应当位于树的左侧; 若比较规则返回的是正数, 则认为待存储元素应当位于树的右侧; 若比较规则返回的是零, 则认为待存储元素在集合中已存在, 放弃存储; 
```

```java
/*定义比较规则*/
1.引用数据类型可以通过实现"Comparable"接口并重写其中的"compareTo"方法定义比较规则; "compareTo"方法中的参数指集合中已经存在的元素, 可以用"this"关键字表示待存储元素;
2.创建"TreeSet"对象(构造方法)时传入一个重写"Comparator"接口中"compare"方法的实例化对象(常用匿名内部类)定义比较规则; "compare"方法的两个参数分别指待存储元素与集合中已经存在的元素;
```

> ###### ArrayList

```java
"ArrayList"是"List"接口的一个实现类, 其存储数据的模式采用的是数组结构, 集合中存储的数据是有序且连续的, 所有元素共享一个内存空间; 
```

```java
/*特点*/
查询快: ArrayList查询元素时, 可以通过索引直接锁定元素;
修改慢: ArrayList在插入元素前或删除元素后, 需要移动原本位置上的元素;
```

> ###### LinkedList

```java
"LinkedList"是"List"接口的一个实现类, 其存储数据的模式采用的是双向链表结构, 集合中存储的数据是有序但非连续的, 集合中每一个元素有被封装为一个"Node"对象, 其中存储了自身的元素值, 以及前后元素所在"Node"对象的地址值;
```

```java
/*特点*/
查询慢: LinkedList查询元素时, 需要从头或从未遍历, 寻找目标元素所在"Node"对象的地址值;
修改快: LinkedList在插入或删除元素时, 只需修改相邻元素所在"Node"对象中存储的"Node"对象的地址值;
```

```java
/*针对首尾元素的操作*/
E getFirst(); // 获取集合中的首个元素
E getLast(); // 获取集合中的最后一个元素
void addLast(E e); // 在集合尾部插入指定元素
void addFirst(E e); // 在集合开头插入指定元素
E removeFirst(); // 删除集合中的首个元素, 返回被删元素
E removeLast(); // 删除集合中的最后一个元素, 返回被删元素
```

---

### 双列集合

> ###### Map

```java
"Map"是双列集合的顶层接口, 双列集合一次需要存储一对数据(键值对), 键不可以重复, 值可以重复;
```

```java
/*常用成员方法*/
int size(); // 获取集合的长度
void clear(); // 清空集合中的元素
boolean isEmpty(); // 判断集合是否为空
V get(Object key); // 查找集合中键所对应的值
Set<K> keySet(); // 获取集合中键对应的Set集合
V remove(Object key); // 删除集合中键对应的元素
Collection<V> values(); // 获取集合中值对应的单列集合
boolean containsKey(Object key); // 判断集合中是否包含指定的键
boolean containsValue(Object value); // 判断集合中是否包含指定的值
V put(K key, V value); // 若"key"在集合中不存在, 则向集合中添加元素, 返回null; 若"key"在集合中已存在, 则覆盖其原本对应的值, 返回被覆盖的值
Set<Map.Entry<K, V>> entrySet(); // 获取集合对应的键值对的单列集合, 对于每个"Map.Entry<K, V>"对象, 可以利用其"getKey"和"getValue"分别获取其中存储的键和值
static <K, V> Map<K, V> copyOf(Map<? extends K, ? extends V> map); // 复制集合"map"中的内容, 生成一个不可变的Map集合, 创建后不可对集合进行修改相关的操作
static <K, V> Map<K, V> ofEntries(Entry<? extends K, ? extends V>... entries); // 基于"Map.Entry<K, V>"对象创建不可变的Map集合, 创建后不可对集合进行修改相关的操作
void forEach(BiConsumer<? super K, ? super V> action); // 对集合中的元素进行遍历, "action"是一个重写"BiConsumer"接口中"accept"方法的实例化对象(常用匿名内部类), 通过"accept"方法对当前遍历元素的键和值进行操作
```

> ###### HashMap

```java
"HashMap"是"Map"接口的一个实现类, 其存储数据的模式采用的是哈希表结构, 集合中存储的数据是无序的; 
```

```java
/*存储机制*/
基于待存储元素键的"HashCode"方法获取哈希值, 根据哈希值计算在数组中的存储位置, 若存储位置上没有数据, 则将对象存储到该位置上; 若存储位置上已有数据, 则基于元素键的"equals"方法与存储位置上的元素键进行比较, 若相同则覆盖原本键对应的值, 若不同则与存储位置上的已有数据形成链表结构(链表结构过长时会转化为红黑树结构)存放在数组的同一个位置上;
```

> ###### LinkedHashMap

```java
"LinkedHashMap"是"HashMap"的一个子类, 其存储数据的模式采用的是哈希表结构, 并采用双向链表结构记录数据的添加顺序, 集合中存储的数据是有序的;
```

```java
/*有序机制*/
元素的存储机制与"HashMap"一致, 但在存储的过程中会为每一个元素记录上一个存入元素和下一个存入元素的地址值, 形成一个双向链表结构, 遍历时依据双向链表从头至尾按存入顺序遍历;
```

> ###### TreeMap

```java
"TreeMap"是"Map"接口的一个实现类, 其存储数据的模式采用的是红黑树结构, 存储的过程中会对存储元素的键进行排序(可自定义比较规则); 默认数值由小到大排序, 字符按照ASCII码表中的数字由小到大排序;
```

```java
/*存储机制*/
若比较规则返回的是负数, 则认为待存储元素应当位于树的左侧; 若比较规则返回的是正数, 则认为待存储元素应当位于树的右侧; 若比较规则返回的是零, 则认为待存储元素的键在集合中已存在, 覆盖其原本对应的值; 
```

```java
/*定义比较规则*/
1.作为键的引用数据类型可以通过实现"Comparable"接口并重写其中的"compareTo"方法定义比较规则; "compareTo"方法中的参数指集合中已存在元素的键, 可以用"this"关键字表示待存储元素的键;
2.创建"TreeMap"对象(构造方法)时传入一个重写"Comparator"接口中"compare"方法的实例化对象(常用匿名内部类)定义比较规则; "compare"方法的两个参数分别指待存储元素的键与集合中已经存在的元素键;
```

---

### Stream流

> ###### 遍历

```java
void forEach(Consumer<? super T> action); // 对Stream对象中的元素进行遍历, "action"是一个重写"Consumer"接口中"accept"方法的实例化对象(常用匿名内部类), 通过"accept"方法对当前遍历元素进行操作
```

```java
// 例:
Integer[] intArr = new Integer[]{1, 2, 3, 4, 5};
Stream<Integer> intArrStream = Arrays.stream(intArr);
intArrStream.forEach((integer) -> System.out.println(integer));
```

> ###### 过滤

```java
Stream<T> filter(Predicate<? super T> predicate); // 对Stream对象中的元素进行过滤, "predicate"是一个重写"Predicate"接口中"test"方法的实例化对象(常用匿名内部类), 通过"test"方法对当前遍历元素并进行判断, 若方法返回值为true表示保留当前元素, 若方法返回值为false表示舍弃当前元素
```

```java
// 例:
Integer[] intArr = new Integer[]{1, 2, 3, 4, 5};
Stream<Integer> intArrStream = Arrays.stream(intArr);
intArrStream.filter((integer) -> integer > 3).forEach((integer) -> System.out.println(integer));
```

> ###### 数据类型转换

```java
<R> Stream<R> map(Function<? super T, ? extends R> mapper); // 对Stream对象中的元素的数据类型进行转换, "mapper"是一个重写"Function"接口中"apply"方法的实例化对象(常用匿名内部类), "Function"接口中得到两个泛型分别表示当前Stream对象中的数据类型"T", 以及要转换的目标数据类型"R"; 通过"apply"方法对当前遍历元素进行操作, 返回目标类型的数据
```

```java
// 例:
Integer[] intArr = new Integer[]{1, 2, 3, 4, 5};
Stream<Integer> intArrStream = Arrays.stream(intArr);
intArrStream.map((integer) -> "String: " + integer).forEach((s) -> System.out.println(s));
```

> ###### Stream对象转数组

```java
<A> A[] toArray(IntFunction<A[]> generator); // 将Stream对象转为数据类型为"A"的数组, 数据类型"A"要与Stream对象中存储的数据类型保持一致, "generator"是一个重写"IntFunction"接口中"apply"方法的实例化对象(常用匿名内部类), "apply"方法的参数表示Stream对象中元素的个数, "apply"方法的方法体就是创建与Stream对象等长且数据类型为"A"的数组
```

```java
// 例:
Integer[] intArr = new Integer[]{1, 2, 3, 4, 5};
Stream<Integer> intArrStream = Arrays.stream(intArr);
// 完整匿名内部类格式
Integer[] newIntArr = intArrStream.toArray(new IntFunction<Integer[]>() {
    @Override
    public Integer[] apply(int value) {
        return new Integer[value];
    }
});
// lambda表达式格式
Integer[] newIntArr = intArrStream.toArray((value) -> new Integer[value]);
System.out.println(Arrays.toString(newIntArr));
```

> ###### Stream对象转集合

```java
/*转单列集合*/
Set<T> collect(Collectors.toSet()); // Stream对象转Set集合
List<T> collect(Collectors.toList()); // Stream对象转List集合
```

```java
/*转双列集合*/
Map<K,V> collect(Collectors.toMap(Function<? super T, ? extends K> keyMapper, Function<? super T, ? extends U> valueMapper)); // Stream对象转Map集合, 其中"toMap"方法中的参数"keyMapper"与"valueMapper"是两个重写"Function"接口中"apply"方法的实例化对象(常用匿名内部类), "Function"接口中得到两个泛型分别表示当前Stream对象中的数据类型"T", 以及要作为Map集合中键和值的目标数据类型"K"和"V"; 通过各自"apply"方法对当前遍历元素进行操作, 返回目标类型的数据; 这个转化过程中不可以生成重复的键, 否则会报错
```

```java
// 例:
Integer[] intArr = new Integer[]{1, 2, 3, 4, 5};
Stream<Integer> intArrStream = Arrays.stream(intArr);
// 完整匿名内部类格式
Map<String, Integer> map = intArrStream.collect(Collectors.toMap(new Function<Integer, String>() {
    @Override
    public String apply(Integer integer) {
        return "Integer" + integer;
    }
}, new Function<Integer, Integer>() {

    @Override
    public Integer apply(Integer integer) {
        return integer;
    }
}));
// lambda表达式格式
Map<String, Integer> intMap = intArrStream.collect(Collectors.toMap((integer) -> "Integer: " + integer, (integer) -> integer));
System.out.println(map);
```

> ###### 其他常用成员方法

```java
long count(); // 统计Stream对象中元素的个数
Object[] toArray(); // 将Stream对象中的元素封装到一个数组中
static<T> Stream<T> of(T... values); // 将一些零散的同类型数据封装成一个Stream对象
Stream<T> skip(long n); // 跳过Stream对象中的前"n"个元素, 余下元素组成一个新的Stream对象
Stream<T> limit(long maxSize); // 截取Stream对象中的前"maxSize"个元素, 组成一个新的Stream对象
Stream<T> distinct(); // 对Stream对象中的元素进行去重操作, 过程中采用元素对象的"equals"方法判断元素之间是否重复
static <T> Stream<T> concat(Stream<? extends T> a, Stream<? extends T> b); // 合并"a"和"b"两个Stream对象
```

---

### JavaBean

> ###### 定义

```java
用来描述一类具体事物的类
```

> ###### 类的封装

```java
public class 类名 {
    设置成员属性;
    ···
    设置构造方法;
    ···
    设置成员方法;
    ···
}
```

> ###### 构造方法

```java
/*无参构造*/
修饰符 类名() {
    操作语句;
}
```

```java
/*含参构造*/
修饰符 类名(参数···) {
    操作语句;
}
```

> ###### 创建对象

```java
类名 对象名 = new 类名(); // 调用空参构造方法
类名 对象名 = new 类名(参数···); // 调用含参构造方法
```

> 注:

```java
1.每一个可自定义属性都应该添加"private"关键字, 并为属性生成"set"和"get"方法; 其目的是方便在给属性赋值时可以进行判断操作等; 
2.如果我们未在类中设置任何构造方法, 虚拟机会默认提供一个空参构造方法; 如果我们设置了含参构造方法, 建议重写一个空参构造方法, 否则将无法调用空参构造方法;
```

> 例:

```java
/*JavaBean类*/
public class Person {
    private int age;
    private String name;
    // 无参构造
    public TestDemo() {
    }
    // 含参构造
    public TestDemo(int age, String name) {
        this.age = age;
        this.name = name;
    }
    // 成员属性的get和set方法
    public int getAge() {
        return age;
    }
    public void setAge(int age) {
        this.age = age;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

```java
/*测试类*/
public class Main {
    public static void main(String[] args) {
        Person person = new Person();
        person.setAge(18);
        person.setName("张三");
        System.out.println(person.getName() + ":" + person.getAge());
    }
}
```

---

### 正则表达式

> ###### 符号

|    符号     |                          含义                          |
| :------: | :----------------------------: |
|    **^**    |                          取反                          |
|   **\|**    |                         逻辑或                         |
|  **[···]**  |                        取单字符                        |
|  **(···)**  |                        分组符号                        |
|    **.**    |                        任意字符                        |
|   **\\**    |                        转义字符                        |
|   **\d**    |                        任意数字                        |
|   **\D**    |                       任意非数字                       |
|   **\s**    |                      任意空白字符                      |
|   **\S**    |                     任意非空白字符                     |
|   **\w**    |               任意英文、数字、下划线字符               |
|   **\w**    |            任意非英文、非数字、非下划线字符            |
| **\number** | 捕获分组, "number"为组别的编号, 按"("出现的顺序从1开始 |

> ###### 数量词

```java
? // 一次或零次
* // 零次或多次
+ // 一次或多次
{n} // 正好n次
{n,} // 至少n次
{n,m} // 至少n次但不超过m次
```

> ###### 单字符匹配

```java
[···] // 匹配"···"中的任意字符, 如"[abc]"即匹配"a"或"b"或"c"
[^···] // 匹配除"···"以外的任意字符, 如"[^abc]"即匹配"a"、"b"、"c"以外的任意字符
[···-···] // 匹配字符"···至字符"···"之间的任意字符, 如[a-z]即匹配任意小写字母
[···[···]] // 匹配两个"···"之间的并集部分, 如[a-z[A-Z]]即匹配任意大小写字母, 等同于[a-zA-Z]
[···&&[···]] // 匹配两个"···"之间的交集部分, 如[a-z&&[^m-p]]即匹配除"m"至"p"以外的任意小写字母, 等同于[a-lq-z]
```

> ###### 捕获分组

```java
/*正则表达式内*/
\Number  // "Number"为组别的编号, 从左到右按"("出现的顺序从1开始编号
```

```java
/*正则表达式外*/
$Number // "Number"为组别的编号, 从左到右按"("出现的顺序从1开始编号
```

```java
/*不参与捕获分组的括号*/
(?!···) // 表示后方跟随的内容不为"···"
(?:···) // 表示后方跟随的内容为"···", 获取数据时连同"···"内容一起获取
(?=···) // 表示后方跟随的内容为"···", 获取数据时不包含"···"代表的内容
```

```java
// 例:
"AAA123AAA".matches("((.)\\2*).*\\1"); // true
"AAA123AAAB".matches("((.)\\2*).*\\1"); // false
"ABBCCCDDDD".replaceAll("(.)\\1+", "$1"); // ABCD
```

> ###### 忽略大小写

```java
(?i)··· // 匹配时忽略"(?i)"右侧内容的大小写, "(?i)"不参与捕获分组
```

```java
// 例:
"ABC".matches("(?i)abc"); // true
"aBC".matches("a(?i)bc"); // true
"ABC".matches("a(?i)bc"); // false
"aBc".matches("a((?i)b)c"); // true
"ABC".matches("a((?i)b)c"); // false
```

> ###### 爬取数据

```java
/*网络爬虫(将网页内容转换成字符串)*/
URL url = new URL("···"); // 创建URL对象
StringBuilder stringBuilder = new StringBuilder(); // 创建StringBuilder容器对象
URLConnection urlConnection = url.openConnection(); // 与网页建立链接
InputStream inputStream = urlConnection.getInputStream(); // 将网页转换为一个字节输入流进行读取
InputStreamReader inputStreamReader = new InputStreamReader(inputStream); // 将字节输入流转换为一个字符输入流
int length; // 用于判断字符流是否读到末尾
char[] chars = new char[10000]; // 定义一个字符缓冲区用于接收字符输入流读取的字符
while ((length = inputStreamReader.read(char)) != -1){
    stringBuilder.append(char, 0, length); // 将读取的字符存放到StringBuilder容器中
}
inputStreamReader.close(); // 关流
String input = stringBuilder.toString(); // StringBuilder容器中的内容拼接成一个整体字符串
```

```java
/*针对字符串进行操作*/
String input = "···"; // 定义要爬取的文本内容
Pattern pattern = Pattern.compile(String regex); // 获取正则表达式对象
Matcher matcher = pattern.matcher(CharSequence input); // 获取文本匹配器对象(输入一个字符串)
while(matcher.find()) { // 每一次调用"find()"方法, 会判断是否能够匹配到符合要求的内容, 并在匹配器记录匹配内容的"起始索引"和"结束索引+1", 下一次调用"find()"方法时, 则从"结束索引+1"开始向下重复判断以及匹配的操作
    String string = matcher.group(int group); // 根据"find()"方法记录的索引截取匹配内容, 参数"group"为分组编号, 默认为0即捕获匹配的整体
    ···
}
```

---

### 时间相关类

> ###### Data

```java
/*常用构造方法*/
Date(); // 获取当前系统时间
Date(long date); //指定毫秒数, 计算自标准基准时间(1970年1月1日00:00:00 GMT)以来的时间
```

```java
/*常用成员方法*/
long getTime(); // 获取自标准基准时间(1970年1月1日00:00:00 GMT)以来到当前Data对象中存储日期的毫秒数
```

> ###### SimpleDateFormat

```java
/*常用构造方法*/
SimpleDateFormat(); // 采用时区默认的日期格式
SimpleDateFormat(String pattern); // 自定义日期格式
SimpleDateFormat(String pattern, Locale locale); // 自定义地区日期格式
```

| 常用字符 |   字符含义   |
| :---: | :-------: |
|  **y**   |      年      |
|  **M**   |      月      |
|  **d**   |      日      |
|  **a**   |  上午或下午  |
|  **H**   | 小时数(0-23) |
|  **k**   | 小时数(1-24) |
|  **K**   | 小时数(0-11) |
|  **h**   | 小时数(1-12) |
|  **m**   |    分钟数    |
|  **s**   |     秒数     |
|  **S**   |    毫秒数    |
|  **E**   |     星期     |
|  **z**   |   一般时区   |
|  **Z**   |  RFC822时区  |
|  **X**   | ISO8601时区  |

```java
/*常用成员方法*/
String format(Date date); // 将Date对象转为规定格式的字符串日期
Date parse(String source); // 将规定格式的字符串日期解析为Date对象
```

> ###### calendar

```java
/*获取Calendar对象*/
Calendar calendar = Calendar.getInstance(); // 根据不同时区获取当前时间的Calendar对象(Calendar是一个抽象类, 无法直接创建对象)
```

```java
注: Calendar用"0-11"表示"1月-12月", 用"1-7"表示"周日-周六";
```

```java
/*常用成员方法*/
Date getTime(); // 将Calendar对象转化为Data对象
int get(int field); // 获取Calendar对象中存储的指定字段的值
long getTimeInMillis(); // 将Calendar对象转化为毫秒为单位的时间值
void setTime(Date date); // 给定Data对象将其中的信息封装到Calendar对象中
void set(int field, int value); // 设置Calendar对象指定字段的值(其他字段值会自动矫正)
void add(int field, int amount); // 向Calendar对象指定字段的内容追加值(其他字段值会自动矫正)
void setTimeInMillis(long millis); // 指定毫秒数, 计算自标准基准时间(1970年1月1日00:00:00 GMT)以来的时间, 并将信息封装到Calendar对象中
```

|         常用字段          |             字段含义             |
| :--------------: | :---------------: |
|     **Calendar.YEAR**     |                年                |
|    **Calendar.MONTH**     |     月("0-11"表示"1月-12月")     |
| **Calendar.DAY_OF_MONTH** |                日                |
|     **Calendar.HOUR**     |           小时数(1-12)           |
|      **HOUR_OF_DAY**      |           小时数(0-23)           |
|    **Calendar.MINUTE**    |              分钟数              |
|    **Calendar.SECOND**    |               秒数               |
|      **MILLISECOND**      |              毫秒数              |
| **Calendar.DAY_OF_WEEK**  | 星期(用"1-7"表示"星期日-星期六") |

> ###### ZoneId

```java
/*获取ZoneId对象*/
static ZoneId systemDefault(); // 获取系统默认时区对象
static ZoneId of(string zoneId); // 获取指定的时区对象
```

```java
/*常用成员方法*/
static Set<string> getAvailableZoneIds(); // 获取Java中支持的所有时区
```

> ##### Instant

```java
/*获取Instant对象*/
static Instant now(); // 获取当前世界标准时间的Instant对象
static Instant ofEpochMilli(long epochMilli); // 指定毫秒数, 计算自标准基准时间(1970年1月1日00:00:00 GMT)以来的时间Instant对象
static Instant ofEpochSecond(long epochSecond); // 指定秒数, 计算自标准基准时间(1970年1月1日00:00:00 GMT)以来的时间Instant对象
```

```java
/*常用成员方法*/
ZonedDateTime atZone(ZoneId zone); // 为Instant对象指定时区, 创建一个带有时区的ZonedDateTime对象
boolean isAfter(Instant otherInstant); // 判断调用者Instant对象代表的时间是否在参数Instant对象之后
boolean isBefore(Instant otherInstant); // 判断调用者Instant对象代表的时间是否在参数Instant对象之前
Instant plusMillis(long millisToAdd); // 为Instant对象代表的时间向后追加毫秒数, 返回一个新的Instant对象
Instant plusSeconds(long secondsToAdd); // 为Instant对象代表的时间向后追加秒数, 返回一个新的Instant对象
Instant minusMillis(long millisToSubtract); // 为Instant对象代表的时间向前减少毫秒数, 返回一个新的Instant对象
Instant minusSeconds(long secondsToSubtract); // 为Instant对象代表的时间向前减少秒数, 返回一个新的Instant对象
```

> ###### ZonedDateTime与LocalDateTime

```java
/*获取ZonedDateTime或LocalDateTime对象*/
static ZonedDateTime|LocalDateTime now(); // 获取当前时间的ZonedDateTime或LocalDateTime对象(系统默认时区)
static ZonedDateTime|LocalDateTime ofXxx(···); // 采用不同的方式获取指定的ZonedDateTime或LocalDateTime对象
static ZonedDateTime|LocalDateTime now(ZoneId zone); // 获取当前时间的ZonedDateTime或LocalDateTime对象(指定时区)
```

```java
/*常用成员方法*/
Xxx getXxx(···); // 获取ZonedDateTime或LocalDateTime对象的"Xxx"时间属性
ZonedDateTime|LocalDateTime withXxx(···); // 修改ZonedDateTime或LocalDateTime对象的"Xxx"时间属性, 返回一个新的ZonedDateTime或LocalDateTime对象
ZonedDateTime|LocalDateTime plusXxx(···); // 为ZonedDateTime或LocalDateTime对象代表的时间的"Xxx"时间属性向后追加"···"个单位, 返回一个新的ZonedDateTime或LocalDateTime对象
ZonedDateTime|LocalDateTime minusXxx(···); // 为ZonedDateTime或LocalDateTime对象代表的时间的"Xxx"时间属性向前减少"···"个单位, 返回一个新的ZonedDateTime或LocalDateTime对象
```

> ###### DateTimeFormatter

```java
/*获取DateTimeFormatter对象*/
static DateTimeFormatter ofPattern(String pattern); // 自定义日期格式
static DateTimeFormatter ofPattern(String pattern, Locale locale) // 自定义地区日期格式
```

```java
/*常用成员方法*/
String format(TemporalAccessor temporal); // 将实现TemporalAccessor接口的时间类对象转为规定格式的字符串日期
```

```java
注: 常用的设置日期格式的字符可参考"SimpleDateFormat"类;
```

> ###### ChronoUnit

```java
/*获取ChronoUnit对象*/
ChronoUnit.XXX // 获取以"XXX"为单位ChronoUnit对象
```

```java
/*常用成员方法*/
long between(Temporal temporal1Inclusive, Temporal temporal2Exclusive); // 计算两个实现Temporal接口的时间类对象之间以"XXX"为单位的间隔
```

|    常用XXX    |  含义  |
| :--------: | :----: |
|   **YEARS**   |  年数  |
|  **MONTHS**   |  月数  |
|   **WEEKS**   |  周数  |
|   **DAYS**    |  天数  |
|   **HOURS**   |  时数  |
|  **MINUTES**  |  分数  |
|  **SECONDS**  |  秒数  |
|  **MILLIS**   | 毫秒数 |
|  **MICROS**   | 微秒数 |
|   **NANOS**   | 纳秒数 |
| **HALF_DAYS** | 半天数 |
|  **DECADES**  | 十年数 |
| **CENTURIES** | 世纪数 |
| **MILLENNIA** | 千年数 |
|   **ERAS**    | 纪元数 |

---

### 文件类(File)

> ###### 常用构造方法

```java
File(String pathname); // 通过给定文件路径(绝对路径或相对路径)创建File对象
File(String parent, String child); // 通过给定文件的父级路径和子级路径创建File对象
File(File parent, String child); // 通过给定文件的父级路径的File对象和子级路径创建File对象
```

> ###### 常用成员方法

```java
String getParent(); // 获取文件的父级路径
boolean exists(); // 判断路径在系统中是否存在
String getPath(); // 获取创建File对象时使用的路径
boolean mkdir(); // 创建目录结构, 只能创建单层目录
File getParentFile(); // 获取文件父级路径的File对象  
String getAbsolutePath(); // 获取File对象的绝对路径
String getName(); // 获取File对象的文件名, 包含文件后缀
long lastModified(); // 获取文件最后的修改时间(单位毫秒值)
boolean delete(); // 删除已存在的文件或空目录, 不走回收站
boolean isFile(); // 判断File对象是否为文件(不存在则返回false)
boolean isDirectory(); // 判断File对象是否为目录(不存在则返回false)
boolean mkdirs(); // 创建目录结构, 既能用于创单层目录, 又能用于创多层目录
long length(); // 获取File对象的大小(单位字节), 只能用于获取文件(非目录)的大小
boolean createNewFile(); // 创建一个新的空的文件, 只能用于创建文件(非目录), 且要求文件的父级路径已经存在
String[] list(); // 获取File对象所表示的目录下的所有文件的文件名, 若File对象表示的目录不存在或无权访问以及File对象表示为一个文件而非目录时, 返回null
File[] listFiles(); // 获取File对象所表示的目录下的所有文件并将其封装为File对象, 若File对象表示的目录不存在或无权访问以及File对象表示为一个文件而非目录时, 返回null
File[] listFiles(FileFilter filter); // 获取File对象所表示的目录下符合过滤器规则的文件并将其封装为File对象, “filter”是一个重写"FileFilter"接口中"accept"方法的实例化对象(常用匿名内部类), 通过"accept"方法对当前遍历文件的File对象进行判断, 若方法返回值为true, 则保留该文件, 若返回值为false, 则舍弃该文件; 若File对象表示的目录不存在或无权访问以及File对象表示为一个文件而非目录时, 返回null
String[] list(FilenameFilter filter); // 获取File对象所表示的目录下符合过滤器规则的文件的文件名, "filter"是一个重写"FilenameFilter"接口中"accept"方法的实例化对象(常用匿名内部类), "accept"方法的两个参数分别表示当前遍历文件对应父级路径的File对象的和当前遍历文件的文件名, 若方法返回值为true, 则保留该文件, 若返回值为false, 则舍弃该文件; 若File对象表示的目录不存在或无权访问以及File对象表示为一个文件而非目录时, 返回null
File[] listFiles(FilenameFilter filter); // 获取File对象所表示的目录下符合过滤器规则的文件并将其封装为File对象, “filter”是一个重写"FilenameFilter"接口中"accept"方法的实例化对象(常用匿名内部类), "accept"方法的两个参数分别表示当前遍历文件对应父级路径的File对象的和当前遍历文件的文件名, 若方法返回值为true, 则保留该文件, 若返回值为false, 则舍弃该文件; 若File对象表示的目录不存在或无权访问以及File对象表示为一个文件而非目录时, 返回null
```

> 例: 

```java
/*删除文件或目录的方法*/
public static void fileDelete(File src) {
    if (src.exists()) {
        if (src.isFile()) {
            src.delete();
        } else {
            File[] files = src.listFiles();
            for (File file : files) {
                if (file.isFile()) {
                    file.delete();
                } else {
                    fileDelete(file);
                }
            }
            src.delete();
        }
    }
}
```

---

### 输入输出(IO)流

> ###### 顶级父类

|            |  输入流(读)   |   输出流(写)   |
| :--------: | :-----------: | :------------: |
| **字节流** | `InputStream` | `OutputStream` |
| **字符流** |   `Reader`    |    `Writer`    |

```java
注: 字符流的底层也是字节流, 中间有一个将字节编码成字符的过程
```

> ###### 常用子类

|            |      输入流       |       输出流       |
| :--------: | :---------------: | :----------------: |
| **字节流** | `FileInputStream` | `FileOutputStream` |
| **字符流** |   `FileReader`    |    `FileWriter`    |

```java
/*FileInputStream常用构造方法*/
FileInputStream(File file); // 根据File对象创建FileInputStream对象
FileInputStream(String name); // 根据文件路径创建FileInputStream对象
```

```java
/*FileOutputStream常用构造方法*/
FileOutputStream(File file); // 根据File对象创建FileOutputStream对象(默认清空原文件)
FileOutputStream(String name); // 根据文件路径创建FileOutputStream对象(默认清空原文件)
FileOutputStream(File file, boolean append); // 根据File对象创建FileOutputStream对象, 并指定是否向原文件中追加内容而非清空原文件
FileOutputStream(String name, boolean append); // 根据文件路径创建FileOutputStream对象, 并指定是否向原文件中追加内容而非清空原文件
```

```java
/*FileReader常用构造方法*/
FileReader(File file); // 根据File对象创建FileReader对象, 使用默认编码字符集
FileReader(String fileName); // 根据文件路径创建FileReader对象, 使用默认编码字符集
FileReader(File file, Charset charset); // 根据File对象创建FileReader对象, 并指定用于编码字符集
FileReader(String fileName, Charset charset); // 根据文件路径创建FileReader对象, 并指定用于编码字符集
```

```java
/*FileWriter常用构造方法*/
FileWriter(File file); // 根据File对象创建FileWriter对象(默认清空原文件), 使用默认编码字符集
FileWriter(String fileName); // 根据文件路径创建FileWriter对象(默认清空原文件), 使用默认编码字符集
FileWriter(File file, Charset charset); // 根据File对象创建FileWriter对象(默认清空原文件), 并指定编码字符集
FileWriter(String fileName, Charset charset); // 根据文件路径创建FileWriter对象(默认清空原文件), 并指定编码字符集
FileWriter(File file, boolean append); // 根据File对象创建FileWriter对象, 使用默认编码字符集, 并指定是否向原文件中追加内容而非清空原文件
FileWriter(String fileName, boolean append); // 根据文件路径创建FileOutputStream对象, 使用默认编码字符集, 并指定是否向原文件中追加内容而非清空原文件
FileWriter(File file, Charset charset, boolean append); // 根据File对象创建FileWriter对象, 并指定编码字符集以及是否向原文件中追加内容而非清空原文件
FileWriter(String fileName, Charset charset, boolean append); // 根据文件路径创建FileOutputStream对象, 并指定编码字符集以及是否向原文件中追加内容而非清空原文件
```

> ###### 字节输入流(InputStream)

```java
/*常用成员方法*/
int available(); // 获取输入流中可读取的字节数量
void close(); // 关闭输入流并释放与之关联的任何系统资源
int read(); // 从输入流中读取单个字节并向下移动指针, 返回字节在对应的十进制数值, 没有可读取字节时返回"-1"
int read(byte[] b); // 从输入流中读取多个字节并将读取的字节依次存储到字节数组"b"中, 并将指针移动到未读入的字节处, 返回读取到的字节数量, 没有可读取字节时返回"-1"
int read(byte[] b, int off, int len); // 从输入流中读取"len"个字节并将读取的字节依次存储到字节数组"b"中, 从数组的第"off"索引位置开始存储，返回实际读取的字节数, 没有可读取字节时返回"-1"
```

```java
// 列:
public static void main(String[] args) throws IOException {
    // 使用文件名称创建流对象
    FileInputStream fileInputStream = new FileInputStream("Temp.txt");
    // 建立缓冲数组
    byte[] bytes = new byte[3];
    // 循环读取
    int length;
    while ((length = fileInputStream.read(bytes)) != -1) {
        System.out.print(new String(bytes, 0, length));
    }
    //关闭资源
    fileInputStream.close();
}
```

> ###### 字节输出流(OutputStream)

```java
/*常用成员方法*/
void flush(); // 刷新输出流并强制输出缓冲区中的字节
void close(); // 关闭输出流并释放与之关联的任何系统资源
void write(int b); // 将指定的字节(十进制数值)写入输出流
void write(byte[] b); // 将字节从指定的字节数组写入输出流
void write(byte[] b, int off, int len); // 将指定的字节数组从第"off"索引开始的"len"个字节写入输出流
```

```java
// 列:
public static void main(String[] args) throws IOException {
    // 使用文件名称创建流对象
    FileOutputStream fileOutputStream = new FileOutputStream("Temp.txt");
    // 字符串转换为字节数组
    byte[] byteArr = "Test".getBytes();
    // 写出字节数组数据
    fileOutputStream.write(byteArr);
    // 关闭资源
    fileOutputStream.close();
}
```

> ###### 字符输入流(Reader)

```java
/*常用成员方法*/
void close(); // 关闭输入流并释放与之关联的任何系统资源
int read(); // 从输入流中读取单个字符并向下移动指针, 返回字符对应的十进制数字, 没有可读取字符时返回"-1"
int read(char[] cbuf); // 从输入流中读取多个字符并将读取的字符依次存储到字符数组"cbuf"中, 并将指针移动到未读入的字符处, 返回读取到的字符数量, 没有可读取字符时返回"-1"
int read(char[] cbuf, int off, int len); // 从输入流中读取"len"个字符并将读取的字符依次存储到字符数组"cbuf"中, 从数组的第"off"索引位置开始存储，返回实际读取的字符数, 没有可读取字节时返回"-1"
```

```java
// 列:
public static void main(String[] args) throws IOException {
    // 使用文件名称创建流对象
    FileReader fileReader = new FileReader("Temp.txt");
    // 建立缓冲数组
    char[] chars = new char[3];
    // 循环读取
    int length;
    while ((length = fileReader.read(chars)) != -1) {
        System.out.print(new String(chars, 0, length));
    }
    //关闭资源
    fileReader.close();
}
```

> ###### 字符输出流(Writer)

```java
/*常用成员方法*/
void flush(); // 刷新输出流并强制输出缓冲区中的字符
void close(); // 关闭输出流并释放与之关联的任何系统资源
void write(String str); // 将指定的字符串写入输出流
void write(int c); // 将指定的字符(十进制数值)写入输出流
void write(char[] cbuf); // 将字符从指定的字符数组写入输出流
void write(String str, int off, int len); // 将指定的字符串从第"off"索引开始的"len"个字符写入输出流
void write(char[] cbuf, int off, int len); // 将指定的字符数组从第"off"索引开始的"len"个字符写入输出流
```

```java
// 列:
public static void main(String[] args) throws IOException {
    // 使用文件名称创建流对象
    FileWriter fileWriter = new FileWriter("Temp.txt");
    // 字符串转换为字节数组
    char[] charArr = "Test".toCharArray();
    // 写出字节数组数据
    fileWriter.write(charArr);
    // 关闭资源
    fileWriter.close();
}
```

> ###### 转换流(字节流转字符流)

```java
转换流的作用是为了在特定情况下将字节流转化为字符流, 从而可以调用字符流的方法; 
```

```java
/*InputStreamReader常用构造方法*/
InputStreamReader(InputStream in); // 将字节输入流转换为字符输入流
InputStreamReader(InputStream in, String charsetName); // 字节输入流转换为字符输入流，并指定用于编码的字符集
```

```java
/*OutputStreamWriter常用构造方法*/
OutputStreamWriter(OutputStream out); // 将字节输出流转换为字符输出流
OutputStreamWriter(OutputStream out, String charsetName); // 将字节输出流转换为字符输出流，并指定用于编码的字符集
```
> ###### 缓冲流

|            |        输入流         |         输出流         |
| :--------: | :-------------------: | :--------------------: |
| **字节流** | `BufferedInputStream` | `BufferedOutputStream` |
| **字符流** |   `BufferedReader`    |    `BufferedWriter`    |

```java
/*BufferedInputStream常用构造方法*/
BufferedInputStream(InputStream in); // 默认缓冲区大小为8192字节
BufferedInputStream(InputStream in, int size); // 自定义缓冲区的大小(单位字节)
```

```java
/*BufferedOutputStream常用构造方法*/
BufferedOutputStream(OutputStream out); // 默认缓冲区大小为8192字节
BufferedOutputStream(OutputStream out, int size); // 自定义缓冲区的大小(单位字节)
```

```java
/*BufferedReade常用构造方法*/
BufferedReader(Reader in); // 默认缓冲区大小为8192字符
BufferedReader(Reader in, int sz); // 自定义缓冲区的大小(单位字符)
```

```java
/*BufferedWriter常用构造方法*/
BufferedWriter(Writer out); // 默认缓冲区大小为8192字符
BufferedWriter(Writer out, int sz); // 自定义缓冲区的大小(单位字符)
```

```java
/*字符缓冲输入流特有的成员方法*/
String readLine(); // 从输入流中读取一行数据并将指针移动到下一行的起始处, 没有可读取内容时返回"null"
```

```java
/*字符缓冲输出流特有的成员方法*/
void newLine(); // 向输出流中写入一个换行符
```

> ###### 序列化流( ObjectOutputStream)

```java
将实现"Serializable"接口的Java类对象写出到文件; 建议为该类设置固定的序列版本号"serialVersionUID", 该属性是由"private static final"修饰的"long"类型数据; 对于类中不想被序列化的属性, 可以在属性和修饰符之间添加"transient"关键字;
```

```java
/*构造方法*/
ObjectOutputStream(OutputStream out);
```

```java
/*常用成员方法*/
void writeObject(Object obj); // 将对象写入输出流
```

> ###### 序列化流( ObjectOutputStream)

```java
将"ObjectOutputStream"序列化的数据恢复为Java对象; 若在对象被序列化之后对其对应的类进行了修改, 在执行反序列化操作时会因该类的序列版本号与文件中记录的序列版本号不一致而导致失败, 因此一般会为序列化对象对应的类设置一个固定的序列版本号;
```

```java
/*构造方法*/
ObjectInputStream(InputStream in);
```

```java
/*常用成员方法*/
Object readObject(); // 将序列化文件读入为Java对象
```
> ###### 解压流(ZipInputStream)

```java
解压流只能对"zip"格式的压缩文件进行解压;
```

```java
/*常用构造方法*/
ZipInputStream(InputStream in); // 创建解压流对象, 默认使用"UTF_8"编码字符集
ZipInputStream(InputStream in, Charset charset); // 创建解压流对象, 并指定编码字符集
```

```java
/*常用成员方法*/
void closeEntry(); // 关闭当前操作的"ZipEntry"对象, 表示当前条目处理完毕
ZipEntry getNextEntry(); // 获取压缩文件中的下一个条目(ZipEntry对象), 当没有可获取的条目时返回"null"(执行该操作时会自动关闭上一个"ZipEntry"对象)
```

```java
// 例(将压缩文件解压到目标目录中):
public static void unZip(File zipFile, File targetDirectory) throws IOException {
    ZipInputStream zipInputStream = new ZipInputStream(new FileInputStream(zipFile));
    ZipEntry zipEntry  = zipInputStream.getNextEntry();
    while (zipEntry != null) {
        if (zipEntry.isDirectory()) { // 若当前条目为目录, 则在目标文件夹中创建一个同样的文件夹
            File file = new File(targetDirectory, zipEntry.toString());
            file.mkdirs();
        } else { // 若当前条目为文件, 则利用字节流将其写入目标目录中
            FileOutputStream fileOutputStream = new FileOutputStream(new File(targetDirectory, zipEntry.toString()));
            int length;
            byte[] bytes = new byte[1024];
            while ((length = zipInputStream.read(bytes)) != -1) {
                fileOutputStream.write(bytes, 0, length);
            }
            fileOutputStream.close();
        }
        zipInputStream.closeEntry();
        zipEntry = zipInputStream.getNextEntry();
    }
    zipInputStream.close();
}
```
> ###### 压缩流(ZipOutputStream)

```java
压缩流只能将文件压缩为"zip"格式;
```

```java
/*常用构造方法*/
ZipOutputStream(OutputStream out); // 创建压缩流对象, 默认使用"UTF_8"编码字符集
ZipOutputStream(OutputStream out, Charset charset); // 创建压缩流对象, 并指定编码字符集
```

```java
/*常用成员方法*/
void closeEntry(); // 关闭当前操作的"ZipEntry"对象, 表示当前条目处理完毕
void putNextEntry(ZipEntry e); // 将ZipEntry对象放到压缩流对象中, 并在压缩包中创建对应的条目(执行该操作时会自动关闭上一个"ZipEntry"对象)
```

```java
// 例(将文件压缩到目标"zip"文件中):
public static void toZip(File file, String entryName, ZipOutputStream zipOutputStream) throws IOException {
    if (file.isFile()) { // 若File对象为文件, 则在压缩包中创建该文件, 通过字节流将文件写入压缩包
        ZipEntry zipEntry = new ZipEntry(entryName); // "ZipEntry"构造方法中的参数是文件在压缩包中对应的相对路径
        zipOutputStream.putNextEntry(zipEntry);
        FileInputStream fileInputStream = new FileInputStream(file);
        int length;
        byte[] bytes = new byte[1024];
        while ((length = fileInputStream.read(bytes)) >= 0) {
            zipOutputStream.write(bytes, 0, length);
        }
        fileInputStream.close();
        zipOutputStream.closeEntry();
    } else { // 若File对象为目录, 则在压缩包中创建该目录, 并对目录下的文件进行递归操作
        ZipEntry zipEntry = new ZipEntry((entryName.endsWith("/") || entryName.endsWith("\\\\")) ? entryName : entryName + "/");
        zipOutputStream.putNextEntry(zipEntry);
        zipOutputStream.closeEntry();
        File[] childFiles = file.listFiles();
        for (File childFile : childFiles) {
            toZip(childFile, entryName + "/" + childFile.getName(), zipOutputStream);
        }
    }
}
```
> ###### 属性文件(Properties)

```java
"Properties"底层是一个"Map"集合, 通常用于读取和写入属性文件, 属性文件是一种以键值对形式存储配置信息的文本文件, 扩展名通常为".properties", 并且每一行包含一个键值对，以等号"="分隔;
```

```java
/*常用成员方法(与IO流相关)*/
void load(Reader reader); // 通过字符输入流加载配置文件中的信息
void load(InputStream inStream); // 通过字节输入流加载配置文件中的信息
void store(Writer writer, String comments); // 通过字符输出流将配置信息输出至配置文件, “comments”为想在文件头添加的注释信息
void store(OutputStream out, String comments); // 通过字节输出流将配置信息输出至配置文件, “comments”为想在文件头添加的注释信息
```

---

### 多线程相关操作

> ###### Thread

```java
/*常用构造方法*/
Thread(); // 创建Thread对象
Thread(String name); // 创建Thread对象, 并为其指定名称
Thread(Runnable task); // 创建Thread对象, 传递一个实现"Runnable"接口的对象, 启动线程时调用"task"中的"run"方法
Thread(Runnable task, String name); // 创建Thread对象, 并为其指定名称, 传递一个实现"Runnable"接口的对象, 启动线程时调用"task"中的"run"方法
```

```java
/*常用成员方法*/
void start(); // 执行线程
String getName(); // 获取线程的名称
int getPriority(); // 获取线程的优先级
void setName(String name); // 设置线程的名称
static Thread currentThread(); // 获取当前线程对象
static void sleep(long millis); // 然线程休眠指定的时间(毫秒)
void setPriority(int newPriority); // 设置线程的优先级(1-10), 值越大优先级越高, 默认5
void setDaemon(boolean on); // 是否将线程标记为守护线程, 当非守护线程运行结束时, 无论守护线程是否执行完毕, 均会陆续终止运行
```

> ###### 法一: 继承Thread类——无返回值

```java
/*步骤*/
1. 定义一个类继承"Thread"类;
2. 重写"Thread"类的"run"方法;
3. 创建自定义类的对象, 并通过调用"start"方法启动线程
```

```java
// 例:
// 自定义类
public class MyThread extends Thread {
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            System.out.println(getName() + ": " + i);
        }
    }
}
// 测试方法
public static void main(String[] args) throws IOException {
    MyThread myThread1 = new MyThread();
    MyThread myThread2 = new MyThread();
    myThread1.start();
    myThread2.start();
}
```

> ###### 法二: 实现Runnable接口——无返回值

```java
/*步骤*/
1. 定义一个类实现"Runnable"接口;
2. 重写"Runnable"接口的"run"方法;
3. 创建"Thread"类对象, 并向其传递一个自定义类对象, 然后通过调用"start"方法启动线程;
```

```java
// 例:
// 自定义类
public class MyRunnable implements Runnable{
    @Override
    public void run() {
        for (int i = 0; i < 100; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
        }
    }
}
// 测试方法
public static void main(String[] args) throws IOException {
    MyRunnable myRunnable = new MyRunnable();
    Thread thread1 = new Thread(myRunnable);
    Thread thread2 = new Thread(myRunnable);
    thread1.start();
    thread2.start();
}
```

> ###### 法三: 实现Callable接口——有返回值

```java
/*步骤*/
1. 定义一个类实现"Callable<V>"接口; // Callable接口中的形参"V"代表返回值类型
2. 重写"Callable"接口的"call"方法; // call方法的返回值类型与Callable接口中的形参"V"保持一致
3. 创建"Runnable"接口的实现类"FutureTask<V>"对象，并向其传递一个自定义类对象; // "FutureTask<V>"对象中的形参"V"与Callable接口中的形参"V"保持一致
4. 创建"Thread"类对象, 并向其传递创建的"FutureTask<V>"对象, 然后通过调用"start"方法启动线程; // 调用"FutureTask<V>"对象的"get"方法可以获取当前线程"call"方法的返回值
```

```java
// 例:
// 自定义类
public class MyCallable implements Callable<String> {
    @Override
    public String call() throws Exception {
        for (int i = 0; i < 100; i++) {
            System.out.println(Thread.currentThread().getName() + ": " + i);
        }
        return "···";
    }
}
// 测试方法
public static void main(String[] args) throws IOException {
    FutureTask<String> futureTask = new FutureTask<>(new MyCallable());
    Thread thread = new Thread(futureTask);
    thread.start();
    System.out.println(futureTask.get());
}
```

> ###### 同步代码块

```java
当一个线程抢到CPU的执行权后, 不是执行完所有的代码才会释放CPU的执行权, 而是在它执行操作的过程中，随时可能被其他线程夺走CPU的执行权, 因此在多个线程操作共享数据时, 有发生数据错乱的风险; 同步代码块作用相当于对操作共享数据的代码上了一把锁，确保每次只有一个线程执行同步代码块中的操作, 并且只有当一个线程执行完同步代码块中的所有操作后, 其他线程才有机会执行同步代码块中的操作;
```

```java
/*格式*/
synchronized (锁对象) { 
    操作共享数据的代码···
}
```

```java
注: "锁对象"可以是任意的, 但对于操作同一个共享数据的所有线程应该是唯一的, 即所有线程受同一把锁的限制, 可以使用有"static"关键字修饰的成员属性, 一般使用当前类的字节码(Class)对象, 即"当前类.class"; 
```

```java
// 例(模仿多窗口售票场景):
// 自定义类(未使用同步代码块)
public class SellTicket implements Runnable {
    private int tickets = 100; // 共享数据(总票数)
    @Override
    public void run() {
        while (true) {
            if (tickets <= 0) {
                break;
            } else {
                try {
                    Thread.sleep(100);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
                tickets--;
                System.out.println(Thread.currentThread().getName() + "售出一张票, 剩余【" + tickets + "】张票");
            }
        }
    }
}
// 自定义类(使用同步代码块)
public class SellTicket implements Runnable {
    private int tickets = 100; // 共享数据(总票数)
    @Override
    public void run() {
        while (true) {
            synchronized (SellTicket.class) { // 同步代码块
                if (tickets <= 0) {
                    break;
                } else {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    tickets--;
                    System.out.println(Thread.currentThread().getName() + "售出一张票, 剩余【" + tickets + "】张票");
                }
            }
        }
    }
}
// 测试方法
public static void main(String[] args) {
    //创建SellTicket类的对象
    SellTicket sellTicket = new SellTicket();

    //创建三个Thread类的对象, 模拟三个售票口
    Thread thread1 = new Thread(sellTicket, "窗口1");
    Thread thread2 = new Thread(sellTicket, "窗口2");
    Thread thread3 = new Thread(sellTicket, "窗口3");

    //启动线程
    thread1.start();
    thread2.start();
    thread3.start();
}
```

> ###### 同步方法

```java
就是将"synchronized"关键字添加到方法上, 相当于将整个方法的方法体视为一个同步代码块; 需要注意的是同步方法中"synchronized"关键字的"锁对象"不能自己指定, 是由Java规定好的, 若当前方法为非静态方法, 则锁对象默认为"this"关键字, 即方法的调用者; 若当前方法为静态方法, 则锁对象为当前类的字节码(Class)对象, 即"当前类.class";
```

```java
/*格式*/
修饰符 synchronized 返回值类型 方法名(参数···) { 
    ···
}
```

```java
// 例(模仿多窗口售票场景):
// 自定义类(使用同步方法)
public class SellTicket implements Runnable {
    private int tickets = 100; // 共享数据(总票数)

    @Override
    public void run() {
        while (true) {
            if (method()) break;
        }
    }

    private synchronized boolean method() { // 同步方法, 此处"锁对象"为"this"关键字
        if (tickets <= 0) {
            return true;
        } else {
            try {
                Thread.sleep(100);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
            tickets--;
            System.out.println(Thread.currentThread().getName() + "售出一张票, 剩余【" + tickets + "】张票");
        }
        return false;
    }
}
// 测试方法
public static void main(String[] args) {
    //创建SellTicket类的对象
    SellTicket sellTicket = new SellTicket(); // 也是锁对象, 由于三个线程都是使用该对象建立的, 因此对于三个线程来说， 该锁对象是唯一的

    //创建三个Thread类的对象, 模拟三个售票口
    Thread thread1 = new Thread(sellTicket, "窗口1");
    Thread thread2 = new Thread(sellTicket, "窗口2");
    Thread thread3 = new Thread(sellTicket, "窗口3");

    //启动线程
    thread1.start();
    thread2.start();
    thread3.start();
}
```

> ###### Lock锁

```java
"Lock"是显示锁, 可以手动地获取和释放锁; "synchronized"是隐式锁, 它在获取锁和释放锁的过程由JVM自动管理; "Lock"是一个接口, 其常用的实现类是"ReentrantLock"; 对于操作同一个共享数据的所有线程应该共用一个"Lock"锁对象;
```

```java
/*ReentrantLock常用构造方法*/
ReentrantLock(); // 创建一个锁对象
ReentrantLock(boolean fair); // 创建一个锁对象, 并指定是否按照公平策略来控制线程, 若"fair"为"true", 按照先进先出的顺序控制线程获取锁的顺序
```

```java
/*常用成员方法*/
void lock(); // 尝试获取锁, 若锁不可用, 则当前线程会被阻塞, 直到获取到锁; 若获取到锁, 当前线程将持有该锁, 并向下执行相应的操作
void unlock(); // 释放锁, 使得其他线程能够获取到该锁(当前线程必须是持有锁的线程才能成功释放锁)
```

```java
/*格式*/
Lock对象.lock(); // 获取锁
try {
	操作共享数据的代码···
} finally {
    Lock对象.unlock(); // 释放锁
}
```

```java
// 例(模仿多窗口售票场景):
// 自定义类(使用Lock锁)
public class SellTicket implements Runnable {
    private Lock lock = new ReentrantLock(); // 锁对象
    private int tickets = 100; // 共享数据(总票数)
    @Override
    public void run() {
        while (true) {
            lock.lock();
            try {
                if (tickets <= 0) {
                    break;
                } else {
                    try {
                        Thread.sleep(100);
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                    tickets--;
                    System.out.println(Thread.currentThread().getName() + "售出一张票, 剩余【" + tickets + "】张票");
                }
            }finally {
                lock.unlock();
            }
        }
    }
}
// 测试方法
public static void main(String[] args) {
    //创建SellTicket类的对象
    SellTicket sellTicket = new SellTicket();

    //创建三个Thread类的对象, 模拟三个售票口
    Thread thread1 = new Thread(sellTicket, "窗口1");
    Thread thread2 = new Thread(sellTicket, "窗口2");
    Thread thread3 = new Thread(sellTicket, "窗口3");

    //启动线程
    thread1.start();
    thread2.start();
    thread3.start();
}
```

> ###### 等待唤醒机制

```java
等待唤醒机制用于多个线程对共享数据进行不同操作时, 可以确保线程之间可以相互协作, 而不是随机运行; 
```

```java
/*方法(由同一个锁对象调用)*/
void wait(); // 使与当前锁对象绑定的线程进入等待状态
void notify(); // 随机唤醒一个当前锁对象上处于等待状态的线程
void notifyAll(); // 唤醒当前锁对象上处于等待状态的所有线程
```

```java
// 例(顾客与厨师之间的协作):
// 食品类(用于存放共享数据)
public class Food {
    public static int count = 10; // 共享数据(顾客要品尝的糕点总数)
    public static boolean flag = false; // 用于判断当前是否有糕点共顾客品尝
    public static final Object lock = new Object(); // 线程间共享的锁对象
}
// 厨师类
public class Cooker extends Thread {
    @Override
    public void run() {
        while (Food.count > 0) {
            synchronized (Food.lock) {
                if (Food.flag) { // 如果当前已有糕点了就进入等待状态
                    try {
                        Food.lock.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else { // 如果当前没有糕点就制作一份糕点并唤醒顾客品尝
                    System.out.println(Thread.currentThread().getName() + "烹饪了一份糕点, 请顾客品尝;");
                    Food.flag = true;
                    Food.lock.notifyAll();
                }
            }
        }
    }
}
// 顾客类
public class Customer extends Thread {
    @Override
    public void run() {
        while (Food.count > 0) {
            synchronized (Food.lock) {
                if (! Food.flag) { // 如果当前没有糕点了就进入等待状态
                    try {
                        Food.lock.wait();
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                    }
                } else { // 如果当前已有糕点了就吃掉一份糕点并唤醒厨师继续制作糕点
                    Food.count--;
                    Food.flag = false;
                    Food.lock.notifyAll();
                    System.out.println(Thread.currentThread().getName() + "吃了一份糕点, 还需要" + Food.count + "份;");

                }
            }
        }
    }
}
// 测试方法
public static void main(String[] args) {
    Cooker cooker = new Cooker();
    Customer customer = new Customer();
    cooker.setName("厨师");
    customer.setName("顾客");
    cooker.start();
    customer.start();
}
```

> ###### 阻塞队列(BlockingQueue)

```java
阻塞队列是一种特殊的队列数据结构, 它支持在队列为空时获取元素的操作将会被阻塞, 以及在队列已满时存储元素的操作将会被阻塞; 阻塞队列提供了一种线程安全的方式来进行线程间的通信和数据交换; 阻塞队列的的成员方法均采用"Lock"锁的方式对操作进行监控, 因此对阻塞队列的操作不需要自己写锁;
```

```java
"BlockingQueue<E>"是阻塞队列的一个父级接口, 其常用的两个实现类为"ArrayBlockingQueue<E>"和"LinkedBlockingQueue<E>";
```

```java
/*ArrayBlockingQueue<E>常用构造方法*/
ArrayBlockingQueue(int capacity); // 创建一个数组结构的阻塞队列, 并指定队列的容量
ArrayBlockingQueue(int capacity, boolean fair); // 创建一个数组结构的阻塞队列, 指定队列的容量, 同时指定是否按照公平策略来控制线程访问队列, 若"fair"为"true", 那么线程将按照先进先出的顺序获取访问权
ArrayBlockingQueue(int capacity, boolean fair, Collection<? extends E> c); // 创建一个数组结构的阻塞队列, 指定队列的容量, 并指定是否按照公平策略来控制线程访问队列, 若"fair"为"true", 那么线程将按照先进先出的顺序获取访问权, 同时传入一个集合"c"作为初始元素集合
```

```java
/*LinkedBlockingQueue<E>常用构造方法*/
LinkedBlockingQueue(int capacity); // 创建一个链表结构的阻塞队列, 并指定队列的容量
LinkedBlockingQueue(); // 创建一个链表结构的阻塞队列, 容量上限为"Integer.MAX_VALUE"
LinkedBlockingQueue(Collection<? extends E> c); // 创建一个链表结构的阻塞队列, 并传入一个集合"c"作为初始元素集合, 容量上限为"Integer.MAX_VALUE"
```

```java
/*常用成员方法*/
int remainingCapacity(); // 返回队列中剩余的容量, 即可以再添加多少个元素
E take(); // 移除并返回队列头部的元素, 如果队列为空, 则阻塞调用线程, 直到有元素可用
void put(E e); // 将指定元素插入队列尾部, 如果队列已满, 则阻塞调用线程, 直到有空间可用
```

```java
// 例(顾客与厨师之间的协作):
// 食品类(用于存放共享数据)
public class Food {
    public static int count = 10; // 共享数据(顾客要品尝的糕点总数)
}
// 厨师类
public class Cooker extends Thread {
    private ArrayBlockingQueue<String> arrayBlockingQueue;

    public Cooker(ArrayBlockingQueue<String> arrayBlockingQueue) {
        this.arrayBlockingQueue = arrayBlockingQueue;
    }

    @Override
    public void run() {
        while (Food.count > 0) {
            try {
                arrayBlockingQueue.put("糕点");
                System.out.println(Thread.currentThread().getName() + "烹饪了一份糕点, 请顾客品尝;");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }

        }
    }
}
// 顾客类
public class Customer extends Thread {
    private ArrayBlockingQueue<String> arrayBlockingQueue;

    public Customer(ArrayBlockingQueue<String> arrayBlockingQueue) {
        this.arrayBlockingQueue = arrayBlockingQueue;
    }

    @Override
    public void run() {
        while (Food.count > 0) {
            try {
                Food.count--;
                String food = arrayBlockingQueue.take();
                System.out.println(Thread.currentThread().getName() + "吃了一份糕点, 还需要" + Food.count + "份;");
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
}
// 测试方法
public static void main(String[] args) {
    ArrayBlockingQueue<String> arrayBlockingQueue = new ArrayBlockingQueue<>(5);
    Cooker cooker = new Cooker(arrayBlockingQueue);
    Customer customer = new Customer(arrayBlockingQueue);
    cooker.setName("厨师");
    customer.setName("顾客");
    cooker.start();
    customer.start();
}
```

> ###### 线程池

```java
/*通过ThreadPoolExecutor类创建自定义线程池的四种构造方法*/
ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue);
ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, ThreadFactory threadFactory);
ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, RejectedExecutionHandler handler);
ThreadPoolExecutor(int corePoolSize, int maximumPoolSize, long keepAliveTime, TimeUnit unit, BlockingQueue<Runnable> workQueue, ThreadFactory threadFactory, RejectedExecutionHandler handler);
```

|        参数         |                             描述                             |
| :-----------------: | :----------------------------------------------------------: |
|  **corePoolSize**   |          核心线程数量, 线程池始终保持活性的线程数量          |
| **maximumPoolSize** | 最大线程数量, 线程池中最大限度允许同时存在的线程数量, `maximumPoolSize - corePoolSize`为临时线程数量 |
|  **keepAliveTime**  | 临时线程在空闲时的最大存活时间(值), 空闲时间超过此时间的临时线程将被从线程池中移除 |
|      **unit**       | 临时线程在空闲时的最大存活时间(单位), 空闲时间超过此时间的临时线程将被从线程池中移除 |
|    **workQueue**    | 一个阻塞队列, 用于存放待执行的任务, 常用`ArrayBlockingQueue`和`LinkedBlockingQueue` |
|  **threadFactory**  | 线程工厂, 即用于创建线程的方式, 一般使用`Executors.defaultThreadFactory()` |
|     **handler**     | 任务的拒绝策略, 即当"workQueue"排满后, 针对新提交任务的处理方式, 一般使用`new ThreadPoolExecutor.AbortPolicy()`, 即丢弃任务并抛出异常 |

```java
/*使用工具类Executors创建线程池(仅列出常用方法)*/
static ExecutorService newCachedThreadPool(); // 创建一个可缓存线程池, 该线程池中的线程数量可以根据需要自动调整
static ExecutorService newFixedThreadPool(int nThreads); // 创建一个固定大小的线程池，该线程池中的线程数量始终保持不变
```

```java
/*线程池常用成员方法*/
void shutdown(); // 在执行完已提交的任务后, 销毁线程池
Future<?> submit(Runnable task); // 向线程池提交任务, 传递一个实现"Runnable"接口的对象, 启动线程时调用"task"中的"run"方法, 线程运行成功后, 通过"Future<T>"的"get"方法可获取到"null"
<T> Future<T> submit(Callable<T> task); // 向线程池提交任务, 传递一个实现"Callable"接口的对象, 启动线程时调用"task"中的"call"方法, "call"方法的返回结果可通过"Future<T>"的"get"方法获取
<T> Future<T> submit(Runnable task, T result); // 向线程池提交任务, 传递一个实现"Runnable"接口的对象, 启动线程时调用"task"中的"run"方法，并指定线程运行成功后的返回结果"result", 可通过"Future<T>"的"get"方法获取
```

```java
/*线程池的工作原理*/
1. 初始化的线程池是一个空池子, 任务提交时, 线程池中才会开始创建线程;
2. 当核心线程数目达到最大值时, 之后提交的任务就会被加入到等待队列中排队等候;
3. 当核心线程数目达到最大值, 且等待队列也排满时, 再次提交任务会创建临时线程来处理;
4. 当核心线程数目达到最大值, 等待队列排满, 且临时线程的数目也达到最大值时, 再次提交任务会出发任务拒绝策略
```
---

### 反射与动态代理

> ###### 类加载器(ClassLoader)

```java
/*常用成员方法*/
static ClassLoader getSystemClassLoader(); // 获取系统类加载器
InputStream getResourceAsStream(String name); // 根据给定资源文件的路径获取相应的字节输入流(若使用相对路径, 应相对于类路径的根目录, 即"src"目录)
```

> ###### 获取字节码对象(Class)

```java
类名.class; // 法一
对象.getClass(); // 法二
Class.forName("全类名"); // 法三
```

```java
/*常用成员方法*/
String getName(); // 获取该类的全类名
String getSimpleName(); // 获取该类的简单类名
String getPackageName(); // 获取该类所在包的包名
ClassLoader getClassLoader(); // 获取定义该类的类加载器
```

> ###### 获取成员属性(Field)

```java
/*Class类相关成员方法*/
Field[] getFields(); // 获取所有由"public"修饰的成员属性
Field[] getDeclaredFields(); // 获取所有成员属性(包括由非"public"修饰的成员属性)
Field getField(String name); // 根据属性名获取指定的由"public"修饰的成员属性
Field getDeclaredField(String name); // 根据属性名获取指定的成员属性(包括由非"public"修饰的成员属性)
```

```java
/*Field常用成员方法*/
String getName(); // 获取该成员属性的属性名
Class<?> getType(); // 获取该成员属性的数据类型
int getModifiers(); // 获取该成员属性修饰符对应的数字编号
Object get(Object obj); // 获取对象"obj"中该成员属性对应的值
void set(Object obj, Object value); // 设置对象"obj"中该成员属性对应的值
void setAccessible(boolean flag); // 是否取消该成员属性的权限校验, 取消权限校验后通过"get"或"set"方法获取或修改成员属性将不受权限修饰符的限制
```
> ###### 获取构造方法(Constructor)

```java
/*Class类相关成员方法*/
Constructor<?>[] getConstructors(); // 获取所有由"public"修饰的构造方法
Constructor<?>[] getDeclaredConstructors(); // 获取所有的构造方法(包括由非"public"修饰的构造方法)
Constructor<T> getConstructor(Class<?>... parameterTypes); // 根据构造方法的参数获取指定的由"public"修饰的构造方法, 参数中Class对象的顺序要与目标构造方法参数列表的顺序一致
Constructor<T> getDeclaredConstructor(Class<?>... parameterTypes); // 根据构造方法的参数获取指定的构造方法(包括由非"public"修饰的构造方法), 参数中Class对象的顺序要与目标构造方法参数列表的顺序一致
```

```java
/*Constructor常用成员方法*/
int getParameterCount(); // 获取该构造方法中参数的个数
int getModifiers(); // 获取该构造方法修饰符对应的数字编号
Parameter[] getParameters(); // 获取该构造方法各参数信息
Class<?>[] getParameterTypes(); // 获取该构造方法各参数的Class对象
T newInstance(Object ... initargs); // 使用该构造方法创建对象, 传递的参数要与构造方法的参数列表保持一致
void setAccessible(boolean flag); // 是否取消该构造方法的权限校验, 取消权限校验后通过"newInstance"方法执行构造方法将不受权限修饰符的限制
```

> ###### 获取成员方法(Method)

```java
/*Class类相关成员方法*/
Method[] getMethods(); // 获取所有由"public"修饰的成员方法
Method[] getDeclaredMethods(); // 获取所有成员方法(包括由非"public"修饰的成员方法)
Method getMethod(String name, Class<?>... parameterTypes); // 根据方法名和方法的参数获取指定的由"public"修饰的成员方法, 参数中Class对象的顺序要与目标成员方法参数列表的顺序一致
Method getDeclaredMethod(String name, Class<?>... parameterTypes); // 根据方法名和方法的参数获取指定的成员方法(包括由非"public"修饰的成员方法), 参数中Class对象的顺序要与目标成员方法参数列表的顺序一致
```

```java
/*Method常用成员方法*/
String getName(); // 获取该成员方法的方法名
int getParameterCount(); // 获取该成员方法中参数的个数
Class<?> getReturnType(); // 获取该成员方法的返回值类型
int getModifiers(); // 获取该成员方法修饰符对应的数字编号
Parameter[] getParameters(); // 获取该成员方法各参数信息
Class<?>[] getParameterTypes(); // 获取该成员方法各参数的Class对象
Object invoke(Object obj, Object... args); // 调用对象"obj"中的该成员方法, 传递的参数要与成员方法的参数列表保持一致 
void setAccessible(boolean flag); // 是否取消该成员属性的权限校验, 取消权限校验后可以通过"invoke"方法调用该成员方法时将不受权限修饰符的限制
```

> ###### 动态代理(Proxy)

```java
代理对象可以无侵入式的给被代理对象增强其他的功能, 代理对象可以在被代理对象执行相关方法的前后增加一些其他的操作; 简单来说, 代理对象监控的就是被代理对象要执行的方法, 这一过程是通过接口作为桥梁来实现的, 即代理对象和被代理对象要实现相同的接口, 从而监视接口中的方法;
```

```java
/*成员方法(用于创建代理对象)*/
static Object newProxyInstance(ClassLoader loader, Class<?>[] interfaces, InvocationHandler h);
```

|      参数      |                             描述                             |
| :------------: | :----------------------------------------------------------: |
|   **loader**   | 一个类加载器对象, 用于加载生成的代理类, 一般使用被代理对象的类加载器作为参数 |
| **interfaces** | 一个接口数组, 表示要由代理类实现的接口列表, 代理对象会实现这些接口中的方法, 并将方法调用转发给`InvocationHandler`对象处理 |
|     **h**      | 一个`InvocationHandler`接口的实例化对象(常用匿名内部类), `InvocationHandler`接口的`invoke()`方法用于处理代理对象的方法调用 |

```java
// 例:
// 接口
public interface Star {
    void sing(String name);
    void dance(String name);
}
// 实现类
class BigStar implements Star{
    @Override
    public void sing(String name) {
        System.out.println("艺人在舞台上演唱了一首【" + name + "】···");
    }

    @Override
    public void dance(String name) {
        System.out.println("艺人在舞台上跳了一支【" + name + "】···");
    }
}
// 测试方法
public static void main(String[] args){
    BigStar bigStar = new BigStar();
    Star starProxy = (Star) Proxy.newProxyInstance(bigStar.getClass().getClassLoader(), new Class[]{Star.class}, new InvocationHandler() {
        @Override
        public Object invoke(Object proxy, Method method, Object[] args) throws Throwable {
            System.out.println("艺人受邀进行【" + method.getName() + "】表演, 代理人正在进行相关的准备工作···");
            method.invoke(bigStar, args); // 利用反射
            System.out.println("艺人演出结束, 代理人正在进行相关的善后工作···");
            return null;
        }
    });
    starProxy.sing("摇篮曲");
    starProxy.dance("民族舞");
}
```
---

### 常用类及其常用方法

> ###### Object(祖宗类)

```java
String toString(); // 返回对象的字符串表示形式, 默认返回地址值, 一般对该方法进行重写来返回特定内容
int hashCode(); // 计算对象的哈希值, 默认使用对象的地址值进行计算, 一般对该方法进行重写来根据特定的内容计算哈希值
boolean equals(Object obj); // 判断两个对象是否相等("null"无法调用), 默认比较的是地址值, 一般对该方法进行重写来比较特定内容
Object clone(); // 创建并对象的副本, 对象类必须对该方法进行重写后才能调用, 一般重写该方法的类要实现"Cloneable"接口标识该类的实例对象可被克隆
```

```java
注: "Object.clone()"的重写方法中"super.clone()"执行的是浅克隆, 即对于对象中引用数据类型的成员属性, 被克隆的是原对象中成员属性的地址值, 若之后原对象或副本对象的成员属性被更改, 另一个对象的成员属性也会随之改变, 因此在重写该方法时, 可以将引用数据类型的成员属性重新创建并赋值, 之后再将其替换到副本对象中;
```

> ###### Objects

```java
static boolean isNull(Object obj); // 判断对象是否为"null"
static boolean nonNull(Object obj); // 判断对象是否不为"null"
static boolean equals(Object a, Object b); // 判断两个对象是否相等, 先判断对象a是否为null, 若不为null则调"a.equals(b)"
```

> ###### Math

```java
static double ceil(double a); // 向上取整
static double floor(double a); // 向下取整
static double sqrt(double a); // 计算平方根
static double cbrt(double a); // 计算立方根
static int|long round(int|long a); // 四舍五入
static double random(); // 获取[0,1]之间的随机数
static double log(double a); // 计算以e为底的对数
static double log10(double a); // 计算以10为底的对数
static double pow(double a, double b) // 计算a的b次幂
static int|long|float|double abs(int|long|float|double a); // 取绝对值
static int|long|float|double min(int|long|float|double a,  int|long|float|double b); // 取最小值
static int|long|float|double max(int|long|float|double a,  int|long|float|double b); // 取最大值
```

> ###### System

```java
static void exit(int status); // 终止当前虚拟机, 一般"0"表示正常退出, 非"0"表示异常终止
static long currentTimeMillis(); // 获取自标准基准时间(1970年1月1日00:00:00 GMT)以来到当前的毫秒数
static void arraycopy(Object src, int srcPos, Object dest, int destPos, int length); // 数组拷贝, 表示将源数组"src"中第"srcPos"个索引开始的"length"个元素的拷贝到目标数组"dest"中从第"destPos"个索引开始的"length"个元素上
```

> ######  Arrays

```java
static String toString(Object[] a); // 将数组拼接成字符串
static void sort(Object[] a); // 对数组中的元素由小到大进行排序
static <T> Stream<T> stream(T[] array); // 获取数组"array"作为源的Stream对象
static <T> T[] copyOfRange(T[] original, int from, int to); // 拷贝数组, 从数组"original"中拷贝索引"from"至索引"to - 1"的元素
static <T> T[] copyOf(T[] original, int newLength); // 拷贝数组, 从数组"original"中拷贝前"newLength"个元素, 若"newLength"小于数组"original"的长度, 则用"T"数据类型的默认值补全
static <T> void sort(T[] a, Comparator<? super T> c); // 按照指定规则"c"对数组"a"进行排序; 采用插入排序与二分查找结合的方式, 默认把0索引的数据当做是有序序列, 1索引到最后认为是无序序列; 遍历无序的序列得到里面的每一个元素, 利用二分查找确定当前遍历元素在有序序列中的插入点, 然后将遍历元素和插入点元素进行比较; "c"是一个重写"Comparator"接口中"compare"方法的实例化对象(常用匿名内部类), "compare"方法的两个参数分别指当前遍历元素与插入点元素, 若方法的返回值是负数则认为当前遍历元素应该位于插入点元素之前; 若方法的返回值是非负数则认为当前遍历元素应该位于插入点元素之后
static void sort(Object[] a); // 按照默认规则对数组"a"进行排序; 数组的数据类型要实现"Comparable"接口并重写其中的"compareTo"方法定义默认的比较规则, 采用插入排序与二分查找结合的方式, 默认把0索引的数据当做是有序序列, 1索引到最后认为是无序序列; 遍历无序的序列得到里面的每一个元素, 利用二分查找确定当前遍历元素在有序序列中的插入点, 然后将遍历元素和插入点元素进行比较; "compareTo"方法中的参数指插入点元素, 可以用"this"关键字表示当前遍历元素; 若方法的返回值是负数则认为当前遍历元素应该位于插入点元素之前; 若方法的返回值是非负数则认为当前遍历元素应该位于插入点元素之后
```
```java
// 例(指定规则排序, 由小到大):
Integer[] array = new Integer[]{2, 3, 1, 8, 10, 7, 5, 9, 4, 6};
Arrays.sort(array, new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
        return o1 - o2;
    }
});
System.out.println(Arrays.toString(array));
```

```java
// 例(指定规则排序, 由大到小):
Integer[] array = new Integer[]{2, 3, 1, 8, 10, 7, 5, 9, 4, 6};
Arrays.sort(array, new Comparator<Integer>() {
    @Override
    public int compare(Integer o1, Integer o2) {
        return o2 - o1;
    }
});
System.out.println(Arrays.toString(array));
```

> ###### Runtime

```java
/*获取Runtime对象*/
Runtime Runtime.getRuntime(); // 获取当前Java应用程序关联的Runtime对象
```

```java
long maxMemory(); // 获取虚拟机可用的最大内存量(单位byte)
long totalMemory(); // 获取虚拟机当前的内存总量(单位byte)
long freeMemory(); // 获取虚拟机当前的内存剩余量(单位byte)
int availableProcessors(); // 获取虚拟机可用的CPU线程数量
Process exec(String command); // 调用外部可执行程序或系统命令
void exit(int status); // 终止当前虚拟机, 一般"0"表示正常退出, 非"0"表示异常终止
```

> ######  BigDecimal

```java
/*常用构造方法*/
BigDecimal(String val); // 将字符串转换为BigDecimal
BigDecimal(double val); // 将double类型的小数转换为BigDecimal
```

```java
BigDecimal add(BigDecimal augend); // 相加
BigDecimal subtract(BigDecimal subtrahend); // 相减
BigDecimal multiply(BigDecimal multiplicand); // 相乘
BigDecimal divide(BigDecimal divisor, int scale, RoundingMode roundingMode); // 相除, "scale"表示小数点后保留的位数, "roundingMode"表示舍入模式(BigDecimal规定的舍入模式)
```

```java
/*BigDecimal规定的舍入模式*/
BigDecimal.UP // 向远离零的方向舍入
BigDecimal.DOWN // 向靠近零的方向舍入
BigDecimal.FLOOR // 向负无穷的方向舍入
BigDecimal.CEILING // 向正无穷的方向舍入
BigDecimal.HALF_UP // 四舍五入, 大于等于5入, 小于五舍
BigDecimal.HALF_DOWN // 四舍五入, 大于5入, 小于等于五舍
BigDecimal.HALF_EVEN // 四舍五入, 大于零的数(大于等于5入, 小于五舍), 小于零的数(大于5入, 小于等于五舍)
```

```java
注: "BigDecimal"主要用于小数的精确计算, 由于java中"float"和"double"类型的小数在计算过程中有一个二进制的转换过程,同时由于底层字节数的限制会导致小数部分转换后的二进制被舍弃部分字节, 从而会造成不精确的计算(如: 0.01 + 0.09), 而"BigDecimal"可以避免这一问题;
```

> ###### Collections

```java
static void shuffle(List<?> list); // 随机打乱集合中的元素
static void reverse(List<?> list; // 颠倒集合中的元素的顺序
static <T> List<T> unmodifiableList(List<? extends T> list); // 将集合变为不可变集合
static <T> boolean addAll(Collection<? super T> c, T... elements); // 向集合中批量添加元素
static <T> void sort(List<T> list, Comparator<? super T> c); // 按照指定规则"c"对数组"a"进行排序; 采用插入排序与二分查找结合的方式, 默认把0索引的数据当做是有序序列, 1索引到最后认为是无序序列; 遍历无序的序列得到里面的每一个元素, 利用二分查找确定当前遍历元素在有序序列中的插入点, 然后将遍历元素和插入点元素进行比较; "c"是一个重写"Comparator"接口中"compare"方法的实例化对象(常用匿名内部类), "compare"方法的两个参数分别指当前遍历元素与插入点元素, 若方法的返回值是负数则认为当前遍历元素应该位于插入点元素之前; 若方法的返回值是非负数则认为当前遍历元素应该位于插入点元素之后
static <T extends Comparable<? super T>> void sort(List<T> list); // 按照默认规则对数组"a"进行排序; 集合的数据类型要实现"Comparable"接口并重写其中的"compareTo"方法定义默认的比较规则, 采用插入排序与二分查找结合的方式, 默认把0索引的数据当做是有序序列, 1索引到最后认为是无序序列; 遍历无序的序列得到里面的每一个元素, 利用二分查找确定当前遍历元素在有序序列中的插入点, 然后将遍历元素和插入点元素进行比较; "compareTo"方法中的参数指插入点元素, 可以用"this"关键字表示当前遍历元素; 若方法的返回值是负数则认为当前遍历元素应该位于插入点元素之前; 若方法的返回值是非负数则认为当前遍历元素应该位于插入点元素之后
```


---

