<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>
# <center>JAVA SCRIPT</center>

---
---
---
### 元素查找

> ###### DOM

   ```JS
   document.getElementById("id"); // 通过元素 id 来查找元素
   document.getElementsByTagName("tagname"); // 通过标签名来查找元素(返回一个数组)
   document.getElementsByClassName("classname"); // 通过类名来查找元素(返回一个数组)
   document.querySelector("CSS选择器"); // 返回文档中匹配指定CSS选择器的一个元素
   document.querySelectorAll("CSS选择器"); // 返回文档中匹配指定CSS选择器的所有元素(返回一个数组)
   ```
> ###### jQuery

   ```js
/*查找元素*/
$("CSS选择器"); // 返回文档中匹配指定CSS选择器的所有元素
/*查找子元素*/
element.children("CSS选择器"); // 返回被选元素的所有符合要求的"直接"子元素
element.find("CSS选择器"); // 沿DOM树向下遍历, 返回被选元素的所有符合要求的子元素
/*查找兄弟元素*/
element.siblings("CSS选择器"); // 返回被选元素同一父元素下的所有符合要求的兄弟元素
/*查找父元素*/
element.closest("CSS选择器"); // 沿DOM树向上遍历, 并返回匹配符合要求的第一个祖先元素
   ```
> ###### D3

   ```js
element.select("CSS选择器")——返回文档中匹配指定CSS选择器的一个元素
element.selectAll("CSS选择器")——返回文档中匹配指定CSS选择器的所有元素(返回一个数组)
   ```
> ###### 区别

```js
1.DOM查找的多个同类元素不能同时进行操作, 须通过索引对单一元素进行操作, 而jQuery与D3查找到的多个同类元素同时进行操作
2.DOM与D3可以进行连续查找(查找完父级元素后在查找子元素), jQuery只能一次性查找或通过“.children(...)或.find(...)”继续向下查找子元素
```

---

### 设置或更该属性样式

> ###### DOM

   ```JS
   element.attribute = new value; // 设置或更改元素DOM属性
   element.setAttribute(attribute, value); // 设置或更改元素DOM属性
   element.style.property = new style; // 设置或更改元素CSS样式, 此处property为css属性名的驼峰形式写法
   element.style.setProperty(property, new style); // 设置或更改元素CSS样式
   ```
> ###### jQuery

   ```js
   element.attr(attribute, value); // 设置或更改元素DOM属性
   element.css(property, new style); // 设置或更改元素CSS样式
   ```
> ###### D3

   ```js
   element.attr(attribute, value); // 设置或更改元素DOM属性
   element.style(property, new style); // 设置或更改元素CSS样式
   ```
> ###### 区别

  ``` js
DOM与D3每次只能设置更改一个属性或样式, 而jQuery可以通过.attr({attribute1 : value1,attribute2 : value2,…})的方式(.css({ })同理)同时设置更改多个属性样式
  ```

---

### 设置或更改元素内容

> ###### DOM

   ```JS
   element.innerText = "···"; // 设置纯文本内容
   element.innerHTML = "···"; // 可识别内容中包含html标签
   element.value = "···"; // 设置输入框中的值, 主要应用于input和textarea标签
   ```
> ###### jQuery

   ```js
   element.text("···"); //设置纯文本内容
   element.html("···"); //可识别内容中包含html标签
   element.val("···"); //设置输入框中的值, 主要应用于input和textarea标签
   ```
> ###### D3

   ```js
   element.text("···"); //设置纯文本内容
   element.html("···"); //可识别内容中包含html标签
   ```

---

### 动画

> ###### [jQuery](https://www.w3school.com.cn/jquery/jquery_animate.asp)

   ```JS
   element.animate({params}, speed, callback);
   /*
   params: 定义形成动画的CSS属性
   speed: 参数规定效果的时长, 以取"slow"、"fast"或毫秒数
   callback: 参数是动画完成后所执行的函数
   */
   ```
> ###### [D3](https://github.com/xswei/d3-transition/blob/master/README.md#transition_each)

   ```js
   element.transition().delay(speed).duration(speed).ease(typeFunction); // 预示动画的开始
   /*
   .delay(speed): 设置动画的延迟时长
   .duration(speed): 设置动画时长
   .ease(typeFunction): 设置动画效果类型
   speed: 毫秒数
   typeFunction: 动画的效果类型
   */
   ```

---

### 添加事件

> ###### [DOM](https://www.w3school.com.cn/js/js_htmldom_eventlistener.asp)

   ```JS
   element.onEvent = function;
   element.addEventListener(event, function, useCapture)
   /*
   event: 事件的类型(如"click")
   function: 当事件发生时我们需要调用的函数(一般使用匿名函数的形式)
   useCapture: 指定使用事件冒泡还是事件捕获(布尔值), 默认值为false, 即冒泡传递
   */
   ```
> ###### [jQuery](https://www.w3school.com.cn/jquery/jquery_ref_events.asp)

   ```js
element.event(function); // 该方式不能为后添加的元素绑定事件
parentElement.on(event, childElement, function); // 该方法可以通过将事件从已经存在的父元素赋给子元素, 来为后添加的子元素绑定事件
/*
event: 事件的类型(如"click")
function: 当事件发生时我们需要调用的函数(一般使用匿名函数的形式)
*/
   ```
> ###### [D3:](https://github.com/xswei/d3-transition/blob/master/README.md#transition_each)

   ```js
   element.on(event, function)
   /*
   event: 事件的类型(如"click")
   function: 当事件发生时我们需要调用的函数(一般使用匿名函数的形式)
   */
   ```

---

### 读取并使用服务器上的文件

> ###### [DOM](https://www.w3school.com.cn/js/js_ajax_http.asp)

   ```JS
   const xhttp = new XMLHttpRequest(); // 创建XMLHttpRequest请求对象
   xhttp.onreadystatechange = function() { // 定义当readyState属性发生变化时被调用的函数
       if (this.readyState == 4 && this.status == 200) { // 若请求成功进行的操作
       /*this指XMLHttpRequest请求对象即xhttp, 其属性包括: 
       onreadystatechange: 定义当readyState属性发生变化时被调用的函数
       readyState: 存有XMLHttpRequest的状态, 从0到4发生变化
       responseText: 以字符串返回响应数据
       responseXML: 以XML数据返回响应数据
       status: 返回请求的状态号
       statusText: 返回状态文本
       */
       }
   };
   xhttp.open(method, url, async, user, psw); // 规定请求内容
       /*
       method: 请求类型(GET或POST)
       url: 文件位置
       async: true(异步)或false(同步)
       user: 可选的用户名称
       psw: 可选的密码
       */
   xhttp.send(); // 发送请求
   ```
 ### jQuery:

  [jQuery-Ajax](https://www.runoob.com/jquery/ajax-ajax.html)         [Get方法](https://www.w3school.com.cn/jquery/ajax_get.asp)         [Post方法](https://www.w3school.com.cn/jquery/ajax_post.asp)

  ```js
  $.ajax({settings}); // settings是一些列键值对儿, 具体可通过连接查看
  $.get(url,data, function(response,status,xhr){ },dataType);
  $.post(url,data, function(response, status, xhr){ },dataType);
  /*
  url: 文件在服务器中的存储路径
  data: 可选, 规定连同请求发送到服务器的数据(对象格式)
  function(response,status,xhr){ }: 规定当请求成功时运行的函数
      response: 包含来自请求的结果数据
      status: 包含请求的状态
      xhr: 包含 XMLHttpRequest 对象
  dataType: 可选, 规定预计的服务器响应的数据类型, jQuery可以智能判断
  */
  ```
> ###### D3

  [获取csv文件](https://github.com/xswei/d3-fetch/blob/master/README.md#csv)         [获取json文件](https://github.com/xswei/d3-fetch/blob/master/README.md#json)

   ```js
   d3.csv(filePath,function(d){ }).then(function(d){ })
   /*
   filePath: 文件在服务器中的存储路径。
   function(d){ }: 此时d为将csv每一行读入为一个对象(key为列名, value为对应的值), 可通过该函数可对每个对象做统一处理, 不需处理可省略该函数。
   .then(function(d){ }: 此时d为经上一步处理后输出的整体数据, 一个对象数组; 可通过该函数对整体数据进行操作。
   */
   ```

```js
d3.json(filePath).then(function(d){ })
/*
filePath: 文件在服务器中的存储路径。
function(d){ }: 此时d为将json文件读入并转换为js可识别的整体数据(对象或数组), 可通过该函数可对每个对象做统一处理。
*/
```

---









