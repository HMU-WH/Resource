<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>
# <center>CSS</center>
---
---
---
### 选择器

> ###### 层次选择器

```css
空格 /*后代选择器*/
> /*子元素选择器*/
+ /*相邻兄弟选择器*/
~ /*普通兄弟选择器*/
```

> ###### 属性选择器

```css
tagName[attribute] /*筛选包含属性attribute的标签tagName*/
tagName[attribute^=?]: /*筛选属性attribute以“?”开头的的标签tagName*/
tagName[attribute$=?]: /*筛选属性attribute以“?”结尾的的标签tagName*/
tagName[attribute*=?]: /*筛选属性attribute中包含“?”的的标签tagName*/
```

---

### 滚动条

```css
::-webkit-scrollbar /*滚动条整体部分*/
::-webkit-scrollbar-thumb /*滚动条里面的小方块, 能向上向下移动(或往左往右移动, 取决于是垂直滚动条还是水平滚动条)*/
::-webkit-scrollbar-track /*滚动条的轨道*/
::-webkit-scrollbar-button /*滚动条的轨道的两端按钮, 允许通过点击微调小方块的位置*/
::-webkit-scrollbar-track-piece /*内层轨道, 滚动条中间部分(除去)*/
::-webkit-scrollbar-corner /*边角, 即两个滚动条的交汇处*/
::-webkit-resizer /*两个滚动条的交汇处上用于通过拖动调整元素大小的小控件*/
```

```css
注: 该方法制作的滚动条不适用于IE、火狐览器
```

---

### CSS动画

> ###### 定义动画

```css
/*方式一：从"from"中设置的状态变换到"to"中设置的变换状态*/
@keyframes keyframeName
{
    from {
        css属性设置...
    }
    to {
        css属性设置...
    }
}
```

```css
/*方式二：从"0%"中设置的状态变换到"100%"中设置的变换状态(可以在0%~100%之间设置其他状态的过度)*/
@keyframes keyframeName
{
    0% {
        css属性设置...
    }
    /*可以设置其他在0%~100%之间的过度*/
    100% {
        css属性设置...
    }
}
```

> ###### 动画的调用与设置

```css
通过对目标组件添加相应的css属性进行动画的调用, 调用与设置动画的属性如下：
animation: 所有动画属性的简写属性, 设置顺序"name duration timing-function delay iteration-count direction fill-mode play-state";
animation-name: 指定调用动画的名称, 即@keyframes后设置的"keyframeName"
animation-duration: 指定动画播放完成花费的时间, 以秒(s)或毫秒(ms)为单位, 默认值为0, 意味着没有动画效果
animation-timing-function: 指定动画将如何完成一个周期, "[ease(默认,以低速开始, 然后加快, 在结束前变慢)|linear(匀速)|...]"
animation-delay: 定义动画开始前等待的时间, 以秒(s)或毫秒(ms)为单位, 默认值为0, 意味着立即开始动画效果
animation-iteration-count: 指定动画的播放次数, "[n(指定一个数字)|infinite(无限次)]"
animation-direction: 指定是否循环交替反向播放动画, "[normal(默认值, 正常播放)|reverse(反向播放)|alternate(奇数次正常播放, 偶数次反向播放)|alternate-reverse(奇数次正常播放, 偶数次反向播放)|...]"
animation-fill-mode: 指定当动画不播放时（当动画完成时, 或当动画有一个延迟未开始播放时）目标组件的状态, "[none(默认值, 动画在动画执行之前和之后不会影响组件原本的样式)|forwards(在动画结束后, 将动画最后一帧的效果样式赋给目标组件)|backwards(目标组件在animation-delay规定的时间内, 保持动画第一帧的效果样式)|both(同时遵循forwards和backwards的规则)|...]"
animation-play-state: 指定动画的状态, "[paused(暂停动画)|running(运行动画)]"
```
---

### CSS可用函数

```css
attr(...) /*返回选择元素的属性值*/
例: a:after {content: "(" attr(href) ")";} /*在每个链接后面插入内容"(链接字符串)"*/
```
```css
calc(...) /*用于动态计算长度值, 支持 "+"、 "-"、"*"、"/" 运算("运算符前后都需要保留一个空格")*/
例: div {width: calc(100% - 10px);}
```

```css
hsl(...,...,...) /*使用色相、饱和度、亮度来定义颜色*/
hsla(...,...,...,...) /*使用色相、饱和度、亮度、透明度来定义颜色*/
/* 参数(按顺序)
色相(hue): 取值范围为(0-360), 0或 360为红色、120为绿色、240为蓝色
饱和度(saturation): 取值范围为(0-100%), 0%为灰色、100%为全色
亮度(lightness): 取值范围为(0-100%), 0%为暗、50%为普通、100%为白
透明度(alpha): 取值范围为(0-1), 0为透完全透明、1为完全不透明
*/
```

```css
rgb(...,...,...) /*使用红、绿、蓝三个颜色的叠加来生成各式各样的颜色*/
rgba(...,...,...,...) /*使用红、绿、蓝、透明度三个颜色的叠加来生成各式各样的颜色*/
/* 参数(按顺序)
红色值(red): 取值范围为(0-255), 也可以使用百分比(0%-100%)
绿色值(green): 取值范围为(0-255), 也可以使用百分比(0%-100%)
蓝色值(blue): 取值范围为(0-255), 也可以使用百分比(0%-100%)
透明度(alpha): 取值范围为(0-1), 0为透完全透明, 1为完全不透明
*/
```







---

### CSS元素隐藏

```css
display:none; /*隐藏元素且不占用任何空间*/
visibility:hidden; /*隐藏元素但仍需占用与未隐藏之前一样的空间*/
```

---

### CSS元素定位(position)

```css
static /*默认值, 即没有定位, 遵循正常的文档流*/
fixed /*相对于浏览器窗口对元素进行定位*/
absolute /*位置相对于最近的已定位父元素对元素进行定位*/
relative /*相对元素正常位置移动元素, 但它原本所占的空间不会改变*/
sticky /*基于页面的滚动位置来定位, 它的行为就像"relative"; 而当页面滚动超出目标区域时, 它的表现就像"fixed", 将元素固定在目标位置*/
```

---

