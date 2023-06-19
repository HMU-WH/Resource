<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>
# <center>Python</center>

---

---

---

### 数据类型

> ###### 基本数据类型

|    数据类型    | 是否可迭代 |                             描述                             |
| :------------: | :--------: | :----------------------------------------------------------: |
|    **Str**     |     ✔      |                            字符串                            |
|    **Set**     |     ✔      |                   无序、不重复、可变的集合                   |
|    **List**    |     ✔      |                   有序、可重复、可变的集合                   |
|   **Tuple**    |     ✔      |                  有序、可重复、不可变的集合                  |
|   **Number**   |     ❌      | 包括: int(整数)、float(浮点数)、complex(复数)、bool(布尔值)  |
| **Dictionary** |     ✔      | 用键值对存储数据的集合, 如: `{"name1":value1, "name2":value2}` |

> 注:
```python
字符串作为可迭代对象是在迭代时会自动将其拆分为单个字符进行迭代;
```

---

### 判断语句

> ###### if语句

```python
if 关系表达式:
    ···
elif 关系表达式:
    ···
···
else:
    ···
```

---

### 循环语句

> ###### for循环

```python
for 变量 in 可迭代对象:
    ···
```

```python
# 例:
for num in range(5):
    print(num)
```

> ###### while循环

```python
初始化语句
while 条件判断语句:
    ···
    条件控制语句
```

```python
# 例:
i = 1
while i <= 5:
    print(i)
    i += 1
```

> 注：

```python
在循环体中执行"break"表示结束整个循环操作; 执行"continue"表示跳出本次循环操作继续执行下一次循环操作;
```

---

### 类

> ###### 类的封装

```python
class 类名: # 建议类名的首字母大写
    设置成员属性; # 属性名=属性值(默认值)
    ···
    设置成员方法; # 使用"def 函数名 (self, 参数1, 参数2, ···):"定义方法
    ···
```

```python
注: 成员方法中"self"关键字代表当前类对象自身, 可通过其访问成员属性, 调用时可以当作该参数不存在;
```

> ###### 私有成员

```python
只要成员属性的属性名或成员方法的方法名以"__"开头, 即可成为私有成员;
```

```python
注: 私有成员只能在类内部访问, 无法从类的外部直接访问;
```

> ###### 常用内置方法

```python
def __init__(self, 参数1, 参数2, ···): # 定义构造方法
    ···
```

```python
def __str__(self): # 定义对象的字符串表示形式, 返回字符串
    ···
```

```python
def __lt__(self, other): # 定义小于号"<"在两个对象之间的比较行为, 返回布尔值
    ···
```

```python
def __eq__(self, other): # 定义相等号"=="在两个对象之间的比较行为, 返回布尔值
    ···
```

```python
def __le__(self, other): # 定义小于等于号"<="在两个对象之间的比较行为, 返回布尔值
    ···
```

```python
def __len__(self): # 定义对象长度的计算方式, 通常与内置函数"len()"一起使用, 返回整数
    ···
```

> ###### 创建对象

```python
对象名 = 类名(···) # 调用"__init__"构造方法
```

> ###### 设置成员属性

```python
对象.成员属性=属性值
```

> ###### 调用成员方法

```python
对象.成员方法(···)
```

> 例:

```python
class Person:
    age = None
    name = None

    def __init__(self, age, name):
        self.age = age
        self.name = name

    def __str__(self):
        return f"age: {self.age}; name: {self.name}"


person = Person(18, "张三")
print(person)
print(person.age)
print(person.name)
```

---

### 继承

> ###### 格式

```python
class 类名(父类1, 父类2, ···):
    设置成员属性; # 属性名=属性值(默认值)
    ···
    设置成员方法; # 使用"def 函数名 (self, 参数1, 参数2, ···):"定义方法
    ···
```

```python
注: 未声明父类的类默认继承"object"类, 因此可以将"object"类看作是一切类的祖宗类;
```

```python
注: 若多个父类中存在同名的成员属性或成员方法, 则按照继承顺序, 优先级依次递减; 子类可以对父类的成员属性和成员方法进行重写覆盖;
```

> ###### 访问父类成员

```python
# 法一: 通过父类调用
父类.成员属性
父类.成员方法(self, ···)
```

```python
# 法二: 通过super方法调用
super().成员属性
super().成员方法(···)
```

```python
注: 法一可以访问指定父类的成员属性或成员方法, 法二只能访问继承优先级最高的父类中的成员属性或成员方法
```

```python
注: 若子设置了构造方法, 需在子类的构造方法中调用"super().__init__(···)"或"父类.__init__(self, ···)"来对从父类继承的属性和方法进行必要初始化
```

> ###### 继承的优先级

```python
类.__mro__ # 查看类的继承继承顺序列(包含类自身)
```

```python
子类的成员优先于父类的成员; 如果一个类存在多个父类, 优先选择第一个继承的类; 子类的优先级大于父类, 父类的优先级大父类的父类, 以此类推;
```

```python
# 例:
class A:
    def method(self):
        print("A's method")

class B(A):
    def method(self):
        print("B's method")
        super().method()

class C(A):
    def method(self):
        print("C's method")
        super().method()

class D(B, C):
    def method(self):
        print("D's method")
        super().method()

D().method() # 输出顺序: D's method - B's method - C's method - A's method
```

> ###### 利用继承实现多态

```python
多态性使得代码更具灵活性和可扩展性, 使得我们可以编写更通用的代码, 提高代码的可重用性和可维护性, Python可以通过类的继承和方法的重写实现多态;
```

```python
# 列:
# 父类
class Animal:
    # 父类方法
    def speak(self):
        raise NotImplementedError("子类没有重写改方法 ...")
# 子类1
class Dog(Animal):
    # 重写父类方法
    def speak(self):
        return "汪汪汪"
# 子类2
class Cat(Animal):
    # 重写父类方法
    def speak(self):
        return "喵喵喵"

def make_animal_speak(animal):
    print(animal.speak())

dog = Dog()
cat = Cat()

make_animal_speak(dog)
make_animal_speak(cat)
```

---

### 闭包

> ###### 定义

```python
闭包是指在一个内层函数中引用了外层函数的变量, 并且该内层函数可以在外层函数调用结束后仍然访问到那些变量; 闭包的一个重要特点是它可以记住它被定义时的环境, 即使外层函数已经执行结束, 闭包仍然可以访问到外层函数的变量;
```

> ###### 格式

```python
def 外层函数(参数1, 参数2, ···):
    ... # 可以定义变量
    def 内层函数(参数1, 参数2, ···):
        ··· # 可以访问外层函数的变量(外层函数的参数对于内层函数来说也属于外层函数的变量)
        return 返回值
	return 内层函数
```

```python
# 例:
def outer_function(x):
    def inner_function(y):
        return x + y
    return inner_function

test = outer_function(10)
print(test(5))  # 输出 15
```

> ###### 更改外层函数的变量

```python
nonlocal 外层函数的变量 # 需在内层函数中使用"nonlocal"关键字对外层函数的变量进行声明
```

```python
# 例:
def outer_function(x):
    def inner_function():
        nonlocal x
        x += 5
        return x
    return inner_function

test = outer_function(5)
print(test())  # 输出 10
print(test())  # 输出 15
print(test())  # 输出 20
```

---

### 函数

> ###### 函数的定义

```python
def 函数名 (参数1, 参数2, ···): # 可以通过"参数 = ···"的方式为参数设置默认值
    ···
    return 返回值 # 未设置返回值时默认返回"None"
```

```python
注: "None"表示空的、无意义的内容, 在"if"判断中等同于"False";
```

```python
注: 可以通过"参数=···"的方式为参数设置默认值, 且有默认值的参数必须排在无默认值参数的后面
```

> ###### 类型注解

```python
def 函数名 (参数1: 类型, 参数2: 类型, ···) -> 返回值类型: # 可以通过"参数: 类型 = ···"的方式为参数设置默认值
    ···
    return 返回值 # 未设置返回值时默认返回"None"
```

```python
注: 类型注解是可选的，Python解释器不会在运行时强制执行这些类型注解; 它们只是一种对代码的提示, 可以帮助开发者更好地理解和维护代码, 以及便于一些开发工具(PyCharm)识别
```

> ###### 函数的调用

```python
# 位置传参
调用函数时根据定义的参数位置传递参数, 要求传递的参数和定义的参数的顺序以及个数要保持一致
```

```python
# 关键字传参
调用函数时通过"参数名 = 参数值"的形式传递参数, 该方式不要求传递的参数和定义的参数的顺序保持一致
```

```python
# 混合传参
调用函数时混合使用位置传参和关键字传参的方式传递参数, 要求位置参数必须在关键字参数的前面, 会先按位置参数与函数中的参数进行匹配然后再匹配关键字参数
```

```python
# 例:
def temp_method(name, age, gender):
    print(f"名字是: {name}, 年龄是: {age}, 性别是: {gender}")

temp_method("Tom", 18, "Male") # 位置传参
temp_method(gender="Male", name="Tom", age=18) # 关键字传参
temp_method("Tom", gender="Male", age=18) # 混合传参
```

> ###### 可变参数

```python
# 位置传参
*args # 该方式定义的可变参数, 会将位置传参中多余的参数封装到一个元组中，"args"可以替换为其他名字
```

```python
# 关键字传参
**kwargs # 该方式定义的可变参数, 会将关键字传参中多余的参数封装到一个字典中，"kwargs"可以替换为其他名字
```

```python
# 例:
def temp_method(name, age, gender, *args, **kwargs):
    print(f"名字是: {name}, 年龄是: {age}, 性别是: {gender}; args: {args}; kwargs: {kwargs}")

temp_method("Tom", 18, "Male", "otherArg1", "otherArg3", height="180cm", weight="60kg") # 输出: 名字是: Tom, 年龄是: 18, 性别是: Male; args: ('otherArg1', 'otherArg3'); kwargs: {'height': '180cm', 'weight': '60kg'}
```

> ###### 操作全局变量

```python
global 变量名 # 表示后续操作针对的是全局变量(该变量必须已将包含在全局环境中)
```

```python
# 例:
num = 0

def temp_method():
    global num
    num += 1

temp_method()
print(num) # 输出: 1
```

> ###### 多返回值

```java
def 函数名 (参数1, 参数2, ···): 
    ···
    return 返回值1, 返回值2, ··· 
```

```python
注: 调用多返回值的函数时, 若使用单变量接收返回结果, 多返回值会被封装到一个元组中进行返回; 如果使用多变量接收返回结果, 则用于接收结果的变量数目要与返回值的数目相同, 且各变量之间用","间隔;
```

```python
# 例: 
def temp_method():
    return 1, "Hello"

x = temp_method()
y, z = temp_method()
print(x) # 输出: (1, 'Hello')
print(y) # 输出: 1
print(z) # 输出: Hello
```

> ###### 匿名函数

```python
lambda 参数1, 参数2, ···: 函数体(一行代码)
```

```python
注: 匿名函数用于临时构建一个函数, 只使用一次的场景, 常用于需要函数作为参数的函数调用中;
```

```python
# 例: 
def temp_method(x, y, method):
    return method(x, y)

def other_method(x, y):
    return x + y

print(temp_method(1, 2, other_method))			# 输出: 3
print(temp_method(1, 2, lambda x, y: x + y))	# 输出: 3
```

---

### 异常

> ###### 异常的抛出

```python
raise 异常类类名("···")
```

```python
raise NameError("访问的变量未定义 ...")
```

> ###### 异常的捕获

```python
try:
    ···(可能发生异常代码)
except 异常类型 as 变量名:
    ···(捕获异常后的操作)
eles:
    ···(未捕获到异常执行的操作)
finally:
    ···(最终要执行的操作) # 常用于关闭资源
```

```python
注: 变量名一般使用字母"e"表示; 可以采用"except (异常类型1, 异常类型2, ···) as 变量名"的方式一次捕获多种异常, 适用于对多种异常采取相同操作的情形; 若异常类型为"Exception"表示捕获所有类型的异常;
```
---

### 序列

> ###### 定义

```python
序列是一种有序且可迭代的对象, 常见的序列包括字符串(Str)、列表(List)、元组(Tuple)等;
```

> ###### 索引访问

```python
序列[index] # 可以通过索引值访问序列中的单个元素, 正向索引是从"0"开始的, 反向索引是从"-1"开始的
```

```python
# 例:
temp_list = [0, 1, 2, 3]
temp_string = "Hello World!"
print(temp_list[0])		# 输出: 1
print(temp_list[-1])	# 输出: 3
print(temp_string[4])	# 输出: o
```

> ###### 切片操作

```python
序列[start:stop:step] # 获取子序列, "start"表示起始索引(包含, 默认包含从头), "stop"表示结束索引(不包含, 默认包含至尾), "step"表示步长(默认为1); 
```

```python
# 例:
temp_list = [0, 1, 2, 3]
print(temp_list[::2])		# 输出: [0, 2]
print(temp_list[1:3])		# 输出: [1, 2, 3]
print(temp_list[3:1:-1])	# 输出: [3, 2]
print(temp_list[::-1])		# 输出: [3, 2, 1, 0]
```

> ###### 连接操作

```python
序列1 + 序列2 # 可以使用"+"运算符将两个同类型的序列连接起来
```

```python
# 例:
temp_list1 = [0, 1, 2, 3]
temp_list2 = [4, 5, 6, 7]
print(temp_list1 + temp_list2) # 输出: [0, 1, 2, 3, 4, 5, 6, 7]
```

> ###### 重复操作

```python
序列 * Num # 可以使用"*"运算符将序列重复"Num"次
```

```python
# 例:
temp_list = [0, 1, 2, 3]
temp_string = "Hello World!"
print(temp_list * 3)	# 输出: [0, 1, 2, 3, 0, 1, 2, 3, 0, 1, 2, 3]
print(temp_string * 3)	# 输出: Hello World!Hello World!Hello World!
```

> ###### 成员关系判断

```python
element in 序列 # 判断元素是否存在于序列
element not in 序列 # 判断元素是否不存在于序列
```

```python
# 例:
temp_list = [0, 1, 2, 3]
temp_string = "Hello World!"
print(1 in temp_list)		# 输出: True
print("l" in temp_string)	# 输出: True
print("lo" in temp_string)	# 输出: True
```
---

### 容器

> ###### 集合(Set)

```python
# 定义空集合
setObj = set()
```

```python
# 定义包含元素的集合
setObj = {element1, element2, element3, element4, element5, ···}
```

> ###### 集合(Set)常用方法

```python
setObj.clear() # 清空集合中的所有元素
setObj.add(element) # 向集合中添加一个元素
setObj.pop() # 从集合中随机移除一个元素并返回该元素
setObj.remove(element) # 从集合中移除指定元素, 若集合中不存在该元素则报错
setObj.discard(element) # 从集合中移除指定元素, 即使集合中不存在该元素也不会报错
setObj.union(otherSetObj) # 对两个集合取并集, 效果等同于"setObj | otherSetObj"
setObj.intersection(otherSetObj) # 对两个集合取交集, 效果等同于"setObj & otherSetObj"
setObj.difference(otherSetObj) # 对两个集合取差集(存在于setObj而不存在于otherSetObj), 效果等同于"setObj - otherSetObj"
```

> ###### 列表(List)

```python
# 定义空列表
listObj = [] # 法一
listObj = list() # 法二
```

```python
# 定义包含元素的列表
listObj = [element1, element2, element3, element4, element5, ···]
```

> ###### 列表(List)常用方法

```python
listObj.clear() # 清空列表中的所有元素
listObj.reverse() # 对列表进行逆序排列
listObj.append(element) # 在列表尾部追加元素
del listObj[index] # 移除列表中指定索引位置的元素
listObj.count(element) # 统计元素在列表中出现的次数
listObj.extend(iterable) # 将可迭代对象中的元素逐一添加到列表的末尾
listObj.index(element) # 查找元素在列表中的正向索引, 若列表中不存在该元素则报错
listObj.remove(element) # 移除列表中第一次出现的元素, 若列表中不存在该元素则报错
listObj.pop(index) # 移除并返回列表中指定索引位置的元素(如果未指定索引, 则默认移除并返回最后一个元素)
listObj.insert(index, element) # 在列表中指定的索引位置插入元素, 原索引位置上的元素及其之后的元素向后移动
listObj.sort(key=None, reverse=False) # 对列表中的元素进行排序, "reverse"用于指定是否按降序排序, 默认"False"; "key"用于指定一个函数, 该函数将应用于列表中的每个元素, 依据该函数生成的值进行排序
```

> ###### 元组(Tuple)

```python
# 定义空元组
tupleObj = () # 法一
tupleObjtupleObj = tuple() # 法二
```

```python
# 定义包含单个元素的元组
tupleObj = (element1, ) # 注意此处有个","
```

```python
# 定义包含多个元素的元组
tupleObj = (element1, element2, element3, element4, element5, ···)
```

> ###### 元组(Tuple)常用方法

```python
tupleObj.count(element) # 统计元素在元组中出现的次数
tupleObj.index(element) # 查找元素在元组中的正向索引, 若元组中不存在该元素则报错
```

> ###### 字典(Dictionary)

```python
# 定义空字典
dictObj = {} # 法一
dictObj = dict() # 法二
```

```python
# 定义包含元素的字典
dictObj = {key1: value1, key2: value3, key3: value3, ···}
```

```python
# 值的获取与更新
dictObj[Key] # 获取字典中指定"key"对应的值, 若字典中不存在该"key"则报错
dictObj[Key] = value # 修改字典中指定"key"对应的值, 若字典中不存在该"key"则向字典中新增数据
```

> ###### 字典(Dictionary)常用方法

```python
dictObj.clear() # 清空字典中的所有键值对
dictObj.keys() # 获取字典中所有的键, 返回一个列表
dictObj.values() # 获取字典中所有的值, 返回一个列表
dictObj.items() # 获字典中所有键值对, 返回一个元组列表
dictObj.get(key, default) # 获取指定键的值, 如果键不存在, 则返回指定的默认值"default"(默认为"None")
dictObj.pop(key, default) # 根据指定的键移除并返回对应的值, 如果键不存在, 则返回指定的默认值"default"(未设置"default"将会报错)
```

> ###### 通用方法(常用)

```python
set(iterObj) # 将可迭代对象转为集合
list(iterObj) # 将可迭代对象转为列表
tuple(iterObj) # 将可迭代对象转为元组
len(iterObj) # 获取可迭代对象的长度(包含元素的个数)
min(iterObj) # 获取迭代对象中元素的最小值, 对于字典是针对键进行操作
max(iterObj) # 获取迭代对象中元素的最大值, 对于字典是针对键进行操作
sorted(iterObj, key=None, reverse=False) # 对可迭代对象进行排序并返回排序后的列表, "reverse"用于指定是否按降序排序, 默认"False";; "key"用于指定一个函数, 该函数将应用于可迭代对象的每个元素, 依据该函数生成的值进行排序; 对于字典是针对键进行操作
```

---

### 字符串

> ###### 字符串拼接

```python
# 法一: 通过"+"拼接
"字符串1" + "字符串2" + "字符串3" + ···
```

```python
# 法二: 通过语法进行拼接
f"···{ 变量1 }···{ 变量2 }···{ 变量3 }···"
```

```java
# 法三: 通过占位符拼接
"···占位符1···占位符2···占位符3···" % (变量1, 变量2, 变量3, ···)
```

| 常用占位符 |                             描述                             |
| :--------: | :----------------------------------------------------------: |
|   **%d**   |                将内容转换为整数, 放入占位位置                |
|   **%f**   |               将内容转换为浮点数, 放入占位位置               |
|   **%s**   |               将内容转换为字符串, 放入占位位置               |
|  **%.nf**  | 将内容转换为浮点数, 其中 `n` 是希望保留的小数位数, 放入占位位置 |

> ###### 字符串(String)常用方法
```python
stringObj.lower() # 将字符串转换为小写, 返回一个新的字符串
stringObj.upper() # 将字符串转换为大写, 返回一个新的字符串
stringObj.count(subString) # 统计子串在字符串中出现的次数
stringObj.strip() # 除字符串两端的空白字符, 返回一个新的字符串
stringObj.endswith(suffix) # 判断字符串是否以指定的后缀结束, 返回布尔值
stringObj.startswith(prefix) # 判断字符串是否以指定的前缀开始, 返回布尔值
stringObj.split(separator) # 根据指定的分隔符将字符串拆分为子串, 并返回一个列表
stringObj.replace(old, new) # 将字符串中的旧子串替换为新子串, 返回一个新的字符串
stringObj.join(iterable) # 将可迭代对象中的字符串元素连接起来, 返回一个新的字符串
stringObj.index(subString) # 获取子串在字符串中的起始索引, 若字符串中不存在该子串则报错
stringObj.find(substring) # 在字符串中查找子串第一次出现的位置, 返回索引值(若找不到则返回-1)
```

---

### 文件读写

> ###### 建立连接

```python
open(file, mode='rt', buffering=None, encoding=None, errors=None, newline=None, closefd=True) # 返回一个文件对象
```

| 常用参数      | 描述                                                         |
| ------------- | ------------------------------------------------------------ |
| **file**      | 文件路径: 绝对路径或相对路径(相对于当前工作目录)             |
| **mode**      | 文件打开的模式：<br>		`"r"`只读模式;<br/>		`"t"`文本模式; <br/>		`"+"`读写模式;<br/>		`"b"`二进制模式; <br/>		`"w"`写入模式, 如果文件存在则覆盖, 如果文件不存在则创建;  <br/>		`"a"`追加模式, 如果文件存在则在末尾追加, 如果文件不存在则创建 |
| **buffering** | 缓冲策略:  <br/>		`-1`表示默认缓冲策略;  `0` 表示无缓冲; `1` 表示行缓冲; <br/>		通过指定一个整数值可以自定义缓冲区的大小(以字符或字节为单位) |
| **encoding**  | 文件的编码格式: 默认使用系统默认的编码格式                   |

> ###### 读取文件

```python
fileObj.readline() # 一次读取一行数据, 并将指针移动至下一行
fileObj.readlines() # 读取文件的全部行, 并将读取内容封装到一个列表中
fileObj.read(size) # 读取指定数量的字节或字符, 并将指针向下移动定数量的字节或字符(默认读取文件中的全部内容)
```
> ###### 写入文件

```python
fileObj.write(str) # 将字符串写入缓冲区
fileObj.write(bytes) # 将一个字节字符串或字节数组写入缓冲区
fileObj.flush() # 刷新缓冲区, 将数据写入文件(操作系统一般会在适当的时机自动执行该操作, 将数据从缓冲区写入文件)
```

> ###### 关闭连接

```python
fileObj.close() # 关闭连接, 释放资源(在关闭资源前会先执行刷新缓冲区的操作)
```

> ###### 按行遍历

```python
for line in fileObj: # "line"表示当前行
    ···
```

```python
# 例:
file = open("···", encoding="UTF-8")
for line in file:
    print(f"当前行内容: {line}")
fileObj.close()
```

> ###### with open 语法

```python
with open(···) as fileObj: # 该方式不需要手动关闭连接, 对文件的操作执行完毕后会自动关闭连接
    ···
```

```python
# 例:
with open("···", encoding="UTF-8") as file:
    for line in file:
        print(f"当前行内容:  {line}")
```

---

### 模块与包

> ###### 定义

```python
模块(Module)就是一个Python文件, 其中定义了类、函数、变量等内容;
```

```python
包(Package)就是一个包含多个模块的目录, 包目录中必须包含一个名为"__init__.py"的文件, 该文件可以是一个空文件或包含初始化包的代码;
```

> ###### 功能的导入

```python
# 导入包
import 包名 # 法一
import 包名 as 别名 # 法二
```

```python
# 导入模块
import 模块名 # 法一
import 包名.模块名 # 法二
import 模块名 as 别名  # 法三
import 包名.模块名 as 别名  # 法四
from 包名 import [模块名|*] # 法五
from 包名 import 模块名 as 别名 # 法六
```

```python
# 导入功能
from 模块名 import [类|函数|变量|*] # 法一
from 包名.模块名 import [类|函数|变量|*] # 法二
from 模块名 import [类|函数|变量] as 别名 # 法三
from 包名.模块名 import [类|函数|变量] as 别名 # 法四
```

> ###### main变量

```python
if __name__ == '__main__':
    ···（测试代码）
```

```python
注: 该方式用于在自定义模块文件中进行测试操作, 写在此处的测试代码在模块被导入时不会被执行
```

> ###### all变量

```python
__all__ = ["模块名1", "模块名2", ···] # 包变量
__all__ = ["功能名1", "功能名2", ···] # 模块变量
```

```python
注: 模块"all"变量可以控制使用"from 模块名 import *"时模块中的哪些功能可以被导入, 默认导入所有功能
```

```python
注: 包"all"变量可以控制使用"from 包名 import *"时包中的哪些模块可以被导入, 默认导入所有模块, 包"all"变量只能在包目录的"__init__.py"文件中声明
```

---

### 正则表达式

> ###### 符号

|    符号     |                          含义                          |
| :---------: | :----------------------------------------------------: |
|    **^**    |                          开头                          |
|    **$**    |                          结尾                          |
|   **\|**    |                         逻辑或                         |
|  **[···]**  |                        取单字符                        |
|  **(···)**  |                        分组符号                        |
| **[^···]**  |                        表示取反                        |
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

```python
? # 一次或零次
* # 零次或多次
+ # 一次或多次
{n} # 正好n次
{n,} # 至少n次
{n,m} # 至少n次但不超过m次
```

> ###### 单字符匹配

```python
[···] # 匹配"···"中的任意字符, 如"[abc]"即匹配"a"或"b"或"c"
[^···] # 匹配除"···"以外的任意字符, 如"[^abc]"即匹配"a"、"b"、"c"以外的任意字符
[···-···] # 匹配字符"···至字符"···"之间的任意字符, 如[a-z]即匹配任意小写字母
[···[···]] # 匹配两个"···"之间的并集部分, 如[a-z[A-Z]]即匹配任意大小写字母, 等同于[a-zA-Z]
[···&&[···]] # 匹配两个"···"之间的交集部分, 如[a-z&&[^m-p]]即匹配除"m"至"p"以外的任意小写字母, 等同于[a-lq-z]
```

> ###### 捕获分组

```python
\Number  # "Number"为组别的编号, 从左到右按"("出现的顺序从1开始编号
```

```python
# 不参与捕获分组的括号
(?!···) # 表示后方跟随的内容不为"···"
(?:···) # 表示后方跟随的内容为"···", 获取数据时连同"···"内容一起获取
(?=···) # 表示后方跟随的内容为"···", 获取数据时不包含"···"代表的内容
```

```python
# 例:
print(re.sub("(.)\\1+", "\\1", "ABBCCCDDDD"))		# 输出: ABCD
print(re.fullmatch("((.)\\2*).*\\1", "AA123AAB"))	# 输出: None
print(re.fullmatch("((.)\\2*).*\\1", "AAA123AAA"))	# 输出: <re.Match object; span=(0, 9), match='AAA123AAA'>
```

> ###### 忽略大小写

```python
(?i)··· # 匹配时忽略"(?i)"右侧内容的大小写, "(?i)"不参与捕获分组
```

```python
// 例:
print(re.fullmatch("(?i)abc", "ABC")) # 输出: <re.Match object; span=(0, 3), match='ABC'>
```

> ###### 导入模块

```python
import re
```

> ###### 常用方法

```python
match(pattern, string, flags=0) # 从头匹配, 匹配成功返回一个"Match"对象, 匹配失败返回"None"
fullmatch(pattern, string, flags=0) # 完整匹配, 匹配成功返回一个"Match"对象, 匹配失败返回"None"
finditer(pattern, string) # 查找所有匹配到的子字符串返回一个迭代器对象, 迭代器对象包含多个"Match"对象
search(pattern, string, flags=0) # 查找第一个匹配到的子字符串, 若找到匹配项返回一个"Match"对象, 未找到匹配失败返回"None"
findall(pattern, string, flags=0) # 查找并返回所有匹配到的子字符串, 若找到匹配项返回一个包含所有匹配子字符串的列表, 未找到匹配项返回一个空列表(如果正则表达式中使用了分组, 会将每一个分组匹配到的内容封装到一个元组中再存放到列表中)
```

| **参数**    | **描述**                                                     |
| ----------- | ------------------------------------------------------------ |
| **pattern** | **正则表达式**                                               |
| **string**  | **要匹配的字符串**                                           |
| **flags**   | 用于控制正则表达式的匹配行为:<br>        默认值`0`表示没有设置任何标志<br/>        `re.IGNORECASE` 或 `re.I`: 忽略大小写<br/>        `re.DOTALL` 或 `re.S`: 点号 `.` 可以匹配包括换行符在内的任意字符<br/>        `re.MULTILINE` 或 `re.M`: 多行模式, 使 `^` 和 `$` 可以匹配每一行的开头和结尾<br/>        `re.VERBOSE` 或 `re.X`：详细模式, 可以在正则表达式中使用空白和注释, 增加可读性<br/>        `re.UNICODE` 或 `re.U`: 启用Unicode匹配模式, 使 `\w`, `\W`, `\b`, `\B` 等模式可以匹配 Unicode 字符<br/>可以使用 `|` 将多个标志常量组合在一起: 若要同时启用忽略大小写和多行模式，可以使用 `re.IGNORECASE | re.MULTILINE` |

> ###### Match对象的常用方法

```python
group() # 返回匹配到的完整字符串
end() # 返回匹配到的子字符串的结束索引位置
start() # 返回匹配到的子字符串的起始索引位置
group(n) # 返回指定编号的分组捕获的内容(编号从1开始)
span() # 返回一个元组，包含匹配到的子字符串的起始和结束索引位置
groups() # 返回一个元组，包含所有分组捕获的内容(若正则表达式未设置分组则返回一个空元组)
```

```python
# 例:
import re

input_string = "Hello, my name is WH. Nice to meet you."

matches = re.finditer(r"(\w+\s)(\w+\s)", input_string)

for match in matches:
    print("Match start:", match.start())
    print("Match end:", match.end())
    print("Match span:", match.span())
    print("Match group:", match.group())
    print("Match groups:", match.groups())
    print("Match group1:", match.group(1))
    print("Match group2:", match.group(2))
    print()
```

---

### 多线程相关操作

> ###### 导入模块

```python
import threading
```

> ###### 创建Thread对象

```python
threadObj = threading.Thread(self, group=None, target=None, name=None, args=(), kwargs=None, daemon=None)
```

|    参数    |                             描述                             |
| :--------: | :----------------------------------------------------------: |
| **group**  |                线程组参数, 未来功能的预留参数                |
| **target** |                   指定线程要执行的目标函数                   |
|  **name**  |     指定线程的名称(若不指定, 系统会自动为其分配一个名称)     |
|  **args**  |     一个元组或列表, 用于传递给目标函数`target`的位置参数     |
| **kwargs** |       一个字典, 用于传递给目标函数`target`的关键字参数       |
| **daemon** | 一个布尔值, 指定线程是否为守护线程; 默认继承当前线程的`daemon`属性 |

> ###### 获取当前线程

```python
threading.current_thread()
```

> ###### 线程对象的常用方法

```python
name # 获取线程名
start() # 执行线程
is_alive() # 判断线程是否仍在运行
isDaemon() # 判断线程是否为守护线程
run() # 调用线程的执行逻辑(由"target、args、kwargs"参数传递而来)
join(timeout=None) # 用于设置阻塞当前线程的时间，直到被调用的线程执行完毕或超过指定的超时时间; 默认一直阻塞当前线程，直到被调用的线程执行完毕
```

> ###### 自定义线程类

```python
class 类名(threading.Thread): # 继承"Thread"类
    def run(self): # 重写"run"方法
        ...
```

> 例:

```python
# 常规方式
import threading

def temp_method(msg):
    for i in range(100):
        print(f"{threading.current_thread().name}: {msg}, 正在执行第{i}次操作")

thread1 = threading.Thread(target=temp_method, args=["我是线程1"], )
thread2 = threading.Thread(target=temp_method, kwargs={"msg": "我是线程2"})
thread1.start()
thread2.start()
```

```python
# 自定义线程类方式
import threading

class MyThread(threading.Thread):
    def __init__(self, msg):
        super().__init__()
        self.msg = msg

    def run(self):
        for i in range(100):
            print(f"{threading.current_thread().name}: {self.msg}, 正在执行第{i}次操作")

def temp_method(msg):
    for i in range(100):
        print(f"{threading.current_thread().name}: {msg}, 正在执行第{i}次操作")

thread1 = MyThread("我是线程1")
thread2 = MyThread("我是线程2")
thread1.start()
thread2.start()
```

---

