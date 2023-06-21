<style>
    a {text-decoration: none;}
    h1 {border-bottom: none; margin-top: auto;}
</style>

# <center>[GGPLOT2 ](https://ggplot2-book.org/)</center>

---

---

---

### 几何对象

> ###### geom_xxx( ··· )

![Geom](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Geom.png)

---

### 统计变换

> ###### stat_xxx( ··· )

![Stat](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Stat.png)

---

### 图形属性

![GeomStatMap](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/GeomStatMap.png)

---

### 复合标度

> ###### scale_xxx_xxx( ··· )

```R
8个系统默认的标度: scale_continuous/discrete/color/fill/shape/linetype/size/alpha_identity( ··· )
```

![Scale](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Scale.png)

---
### 美学导向

> ###### 设置方式

```R
1. 通过scale_xxx_xxx(guide = guide_axis/legend/colorbar/colourbar( ··· ))进行设置
2. 先通过scale_xxx_xxx(guide = "axis/legend/colourbar")指定guide类型, 之后通过guides(fill/color/shape/size/··· = guide_axis/legend/colorbar/colourbar( ··· ))函数对相应美学元素的图例进行设置
```

![Guides](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Guides.png)

> ###### Tip:

```R
1. guide_legend()适用于离散变量的图例
2. guide_colorbar/colourbar()适用于连续变量的图例
3. 有时涉及"bin"的美学映射还会使用"guide_bins()——离散"与"guide_coloursteps()——连续"两种guide对象
```

> ###### 隐藏图例

```R
1. 通过theme(legend.position = 'none')隐藏全局图列
2. 通过geom_xxx(show.legend = FALSE)隐藏对应图层产生的图列
3. 通过scale_xxx_xxx(guide = FALSE)隐藏对应复合标度产生的图列
4. 通过guides(fill/color/shape/size/··· = FALSE)隐藏相应的美学的图列
```

---
### 坐标系统

![Coord](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Coord.png)

> ###### Tip：

```R
1. x/ylim()及scale_x/y_continuous()中参数"limits = " ——> 针对数据, 可理解为对数据进行筛选后进行绘图
2. coord_cartesian()中的参数"x/ylim = "与expand_limits( ··· ) ——> 针对坐标系, 可理解为对原始数据绘制的图片进行截取缩放
```

---
### 数据转换

![Trans](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Trans.png)

> ###### Tip：

```R
1. 适用于scale_xxx_xxx()中的"trans"参数与coord_cartesian()中的"x/y"参数
        # 应用于scale_xxx_xxx()相当于先对数据进行转换, 之后对转换后的数据进行一系列处理(如对数据进行回归拟合操作)
        # 应用于coord_cartesian()相当于先使用原始数据进行一系列的处理(如对数据进行回归拟合操作), 之后对数据进行转换
2. 不论如何使用数据转换, 坐标轴始终显示的是原始数据值, 相当于构建了一个原始数据与转换数据相对应的比例尺
```

---
### 内置主题

![Theme](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Theme.png)

> ###### Tip：

```R
1. 默认主题为theme_grey( ··· )
3. 更改默认主题并将原默认主题赋给其他变量使用theme_set(theme_xxx( ··· ))
```

---

### 主题编辑

![ThemeEdit](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/ThemeEdit.png)

> ###### Tip：

```R
1. 通过 + theme(主题元素 = 所属对象的对应函数, ···) 对主题元素进行设置
2. "element_blank()"表示除去该主题元素
```

---

### 位置调整

![Position](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Position.png)

> ###### 设置方式

```R
通过geom_xxx(position = position_xxx( ··· ))进行设置
```

---

### 元素类别

> ###### 点型(shape)

![Shape](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Shape.png)

> ###### 线型(lty/linetype)

![Line](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Line.png)

> ###### 字体(family)字型(fontface)

![Font](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Font.png)

---

### 分面系统

![Facet](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/Facet.png)

---

### 子母结构

```R
用到的主要函数为"grid"包下的"viewport( ··· )"函数
```

| 参数              | 用途                                                         |
| ----------------- | ------------------------------------------------------------ |
| **x, y**          | 指定子图绘图面板相对于母图的位置的数字矢量[0-1]或单位对象[unit( ··· )] |
| **width, height** | 指定子图绘图面板相对于母图的尺寸的数字矢量[0-1]或单位对象[unit( ··· )] |
| **default.units** | 指定使用的单位名称, 默认为"npc"                              |
| **just**          | 指定子图绘图面板的参照锚点位置("center", "left", "right", "centre", "bottom", "top"); 或使用一个二元[0-1]的向量指定 |
| **angle**         | 指定子图绘图面板的旋转角度(逆时针)                           |
| **gp**            | 通过函数gpar( ··· )设置基本的图形参数                        |

> ###### 应用方式

```R
Main.Plot <- ···
Sub.Plot <- ···
vp <- viewport( ··· )
print(Main.Plot)
print(Sub.Plot, vp=vp)
```

> ###### Tip:

```R
viewport( ··· )的功能十分强大, 本笔记进展示其用于子母图绘制的应用
```

---

### 多图排列

> ###### 可用函数

| 函数                             | 所在包    |
| -------------------------------- | --------- |
| plot_grid( ··· )                 | cowplot   |
| ggarrange( ··· )                 | ggpubr    |
| arrangeGrob( ··· )               | gridExtra |
| ggdraw( ··· ) + draw_plot( ··· ) | cowplot   |

> ###### 应用方式

```R
# plot_grid( ··· )、ggarrange( ··· )、arrangeGrob( ··· )三者的使用方式相似
1. 将需要排列的各图表封装为一个list中整体传入, 或依次传入由函数的可变参数进行接收
2. 均是通过nrow, ncol 设置图形排列的行数列数
3. 其余功能和参数请自行查询
```

```R
# ggdraw( ··· ) + draw_plot( ··· )的使用方式
1. 先通过ggdraw( ··· )初始化一个绘图面板
2. 之后结合函数draw_plot(···)依次对需要排列的各图表进行设置, 将其添加到绘图面板的指定位置; 其中主要参数: plot指定当前需要添加到绘图面板的图表, x/y指定当前图表的参照锚点相对于绘图面板的位置[0-1], width/height指定当前图表相对于绘图面板宽度高度[0-1]
3. 格式: ggdraw() + draw_plot(plot1, ···) + draw_plot(plot2, ···) + ···
```

---

### 颜色调用

> ###### RColorBrewe包

![RColorBrewer](https://hmu-wh.github.io/MyNote/GGPLOT2/Image/RColorBrewer.png)

> ###### 调用方式

```R
brewer.pal(颜色需要量, "方案") ——> 从配色方案中按顺序提取所需数量的颜色
```

---

### 图表的存储

| 方式                                        | 描述                                                      |
| ------------------------------------------- | --------------------------------------------------------- |
| ggsave( ··· )                               | 可根据文件扩展名, 自动选择存储方式, 单一图片存储          |
| pdf( ··· ) ··· dev.off( )                   | 将图片输出至PDF文件, 支持多图片存储                       |
| bmp/jpeg/png/svg/tiff( ··· ) ··· dev.off( ) | 用于BMP, JPEG, PNG, SVG和TIFF格式文件的存储, 单一图片存储 |

---

