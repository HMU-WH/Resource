<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>
# <center>HTML</center>
---
---
---
### 表单

```html
<form>：
<!--属性:
 method = "Post/Get" 定义表单提交的方法
 action: 用于处理表单的服务器端页面（以URL 形式表示）
 enctype = "multipart/form-data" 防止上传的文件发生乱码
-->
  <input/>:
   <!--属性:
    size : 设置输入框的显示长度
    malength : 定义输入框可输入的最大长度
    size : 设置输入框的显示长度
    pattern : 通过正则表达式对输入内容进行限制
    required : 添加该字符的目的是告知该输入框为"必填"项
    disabled = "disabled"  禁用按钮，适用于type = "submit/button"
    placeholder : 设置输入框中的输入字段为空时显示的内容
    autocomplete = "on/off" 设置该输入框是否有历史记录功能
   -->
</form>
```

---

### 媒体

> ###### 视频

```html
<video>
<!--属性:
controls : 微视频添加控制控制按钮、进度条等
autoplay : 使网页打开时视频自动播放
-->
    <source/>:
    <!--属性:
    src : 为视频文件的路径
    type : 告知浏览器当前视频文件的格式，如——type="video/mp4"
    -->
    // 一个<video>标签内部可以有很多<source/>标签，各标签为同一视频的不同格式文件，会按添加的顺序自动识别可播放的视频类型；  
</video>
```

> ###### 音频

```html
<audio>
<!--属性:
controls : 为音频添加控制控制按钮、进度条等
autoplay : 使网页打开时音频自动播放
-->
    <source/>:
    <!--属性:
    src : 音频文件的路径
    type : 告知浏览器当前音频文件的格式，如——type="audio/mpeg"
    -->
    // 一个<video>标签内部可以有很多<source/>标签，各标签为同一音频的不同格式文件，会按添加的顺序自动识别可播放的音频类型；
</audio>
```

---

### 页面布局

``` html
<header> 网页头部 </header>
<nav> 网页导航栏 </nav>
<section> 网页中的某一区域 </section>
<article> 网页文章 </article>
<aside> 网页的侧边栏 </aside>
<footer> 网页的底部 </footer>
```

```html
注: 以上标签的目的是为了规范代码，便于开发！
```

---

