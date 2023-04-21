##############################函数描述##############################
# "Venn.View"绘制venn图(最多支持七个集合)
# "Genome.View"对基因组上的信号特征(点和线段)进行可视化
# "Genome.Allele.CN.View"基因组等位特异拷贝数信息可视化
####################################################################


##' @description 绘制venn图(最多支持七个集合)
##' @author Xteam.Wh
##' @param ... character[] 每个向量为一个集合
##' @param Sets.List list 集合列表, 每一个元素为一个向量
##' @param Show.Set.Total logical 设置是否统计各集合的元素数量并显示在集合标签尾部; 默认FALSE
##' @param Show.Percentage logical 设置是否计算各交集元素所占总元素数量的百分比并标注在交集标签下方; 默认FALSE
##' @param Sets.Name character[] 设置每个集合名称的向量, 用于设置集合标签; 默认NULL
##' @param Sets.Fill.Colour character[] 设置每个集合填充颜色的向量; 默认NULL
##' @param Sets.Fill.Opacity numeric 设置集合的填充颜色的透明度; 默认0.5
##' @param Sets.Name.Size numeric 设置集合标签的尺寸; 默认5
##' @param Sets.Name.Colour character 设置集合标签的颜色; 默认"#2F4F4F"
##' @param Sets.Name.Opacity numeric 设置集合标签颜色的透明的; 默认1
##' @param Sets.Stroke.Size numeric 设置集合边缘线的尺寸; 默认1
##' @param Sets.Stroke.Colour numeric 设置集合边缘线的颜色; 默认NULL
##' @param Sets.Stroke.Opacity numeric 设置集合边缘线颜色的透明的; 默认1
##' @param Sets.Stroke.Linetype character 设置集合边缘线的线型; 默认"solid"
##' @param Intersection.Label.Size numeric 设置交集标签的尺寸; 默认3
##' @param Intersection.Label.Colour numeric 设置交集标签的颜色; 默认"#2F4F4F"
##' @param Intersection.Label.Opacity numeric 设置交集标签颜色的透明的; 默认1
##' @return 返回venn图的绘图信息
Venn.View <- function(..., Sets.List = NULL, 
                      Show.Set.Total = FALSE, Show.Percentage = FALSE, 
                      Sets.Name = NULL, Sets.Fill.Colour = NULL, Sets.Fill.Opacity = 0.5,
                      Sets.Name.Size = 5, Sets.Name.Colour = "#2F4F4F", Sets.Name.Opacity = 1, 
                      Sets.Stroke.Size = 1, Sets.Stroke.Colour = NULL, Sets.Stroke.Opacity = 1, Sets.Stroke.Linetype = "solid", 
                      Intersection.Label.Size = 3, Intersection.Label.Colour = "#2F4F4F", Intersection.Label.Opacity = 1){
  # 集合数据的整合
  Sets.List <- lapply(c(list(...), as.list(Sets.List)), function(Set){ return(unique(as.character(Set))) })
  Sets.List.Num <- length(Sets.List)
  Sets.List.Member.Num <- length(unique(unlist(Sets.List)))
  if(Sets.List.Num > 7){ stop("集合数目不应超过【7】个 ...", call. = FALSE) }
  # 参数判断
  Sets.Name <- as.character(Sets.Name)
  Show.Set.Total <- as.logical(Show.Set.Total)
  Sets.Name.Size <- as.numeric(Sets.Name.Size)
  Show.Percentage <- as.logical(Show.Percentage)
  Sets.Stroke.Size <- as.numeric(Sets.Stroke.Size)
  Sets.Fill.Colour <- as.character(Sets.Fill.Colour)
  Sets.Fill.Opacity <- as.numeric(Sets.Fill.Opacity)
  Sets.Name.Colour <- as.character(Sets.Name.Colour)
  Sets.Name.Opacity <- as.numeric(Sets.Name.Opacity)
  Sets.Stroke.Colour <- as.character(Sets.Stroke.Colour)
  Sets.Stroke.Opacity <- as.numeric(Sets.Stroke.Opacity)
  Sets.Stroke.Linetype <- as.character(Sets.Stroke.Linetype)
  Intersection.Label.Size <- as.numeric(Intersection.Label.Size)
  Intersection.Label.Colour <- as.character(Intersection.Label.Colour)
  Intersection.Label.Opacity <- as.numeric(Intersection.Label.Opacity)
  stopifnot(
    length(Show.Set.Total) == 1, 
    length(Sets.Stroke.Opacity) == 1, 
    length(Show.Percentage) == 1, 
    length(Sets.Name.Colour) == 1, 
    length(Intersection.Label.Colour) == 1, 
    length(Sets.Stroke.Size) == 1 && Sets.Stroke.Size > 0, 
    length(Sets.Name.Size) == 1 && Sets.Name.Size > 0, 
    length(Intersection.Label.Size) == 1 && Intersection.Label.Size > 0, 
    length(Sets.Stroke.Opacity) == 1 && Sets.Stroke.Opacity >= 0 && Sets.Stroke.Opacity <= 1, 
    length(Sets.Fill.Opacity) == 1 && Sets.Fill.Opacity >= 0 && Sets.Fill.Opacity <= 1, 
    length(Sets.Name.Opacity) == 1 && Sets.Name.Opacity >= 0 && Sets.Name.Opacity <= 1,  
    length(Intersection.Label.Opacity) == 1 && Intersection.Label.Opacity >= 0 && Intersection.Label.Opacity <= 1)
  # 设置Sets.Name
  if(length(Sets.Name) == 0){
    Sets.Name <- names(Sets.List)
    if(is.null(Sets.Name)){ Sets.Name <- sprintf("Set_%s", 1:Sets.List.Num)}
  }else if(length(Sets.Name) != Sets.List.Num){
    stop(sprintf("Sets.Name: 需要的标签数目为【%s】, 给定的标签数目为【%s】 ...", length(Sets.Name), Sets.List.Num))
  }
  # 设置Sets.Fill.Colour
  if(length(Sets.Fill.Colour) == 0){
    Sets.Fill.Colour <- RColorBrewer::brewer.pal(7, "Set2")[1:Sets.List.Num]
  }else if(length(Sets.Fill.Colour) != Sets.List.Num){
    stop(sprintf("Sets.Fill.Colour: 需要的颜色数目为【%s】, 给定的颜色数目为【%s】 ...", length(Sets.Fill.Colour), Sets.List.Num))
  }
  # 设置Sets.Stroke.Colour
  if(length(Sets.Stroke.Colour) == 0){
    Sets.Stroke.Colour <- Sets.Fill.Colour
  }else if(length(Sets.Stroke.Colour) == 1){
    Sets.Stroke.Colour <- rep(Sets.Stroke.Colour, Sets.List.Num)
  }else if(length(Sets.Fill.Colour) != Sets.List.Num){
    stop(sprintf("Stroke.Colour: 需要的颜色数目为【%s】, 给定的颜色数目为【%s】 ...", length(Sets.Stroke.Colour), Sets.List.Num))
  }
  # 获取ggplot格式的venn图信息并对其进行修改
  Venn.Plot <- venn::venn(Sets.List, zcolor = Sets.Fill.Colour, ilabels = TRUE, opacity = Sets.Fill.Opacity, box = FALSE, ggplot = TRUE)
  Layers.Num <- length(Venn.Plot$layers)
  Layers.Fill.Index <- 1:Sets.List.Num + 1
  Layers.Name.Index <- tail(1:Layers.Num, Sets.List.Num)
  Layers.Stroke.Index <- Layers.Fill.Index + Sets.List.Num
  Layers.Intersection.Index <- (tail(Layers.Stroke.Index, 1) + 1):(head(Layers.Name.Index, 1) - 1)
  Venn.Plot$layers <- lapply(1:Layers.Num, function(Index){
    Layer <- Venn.Plot$layers[[Index]]
    if(Index %in% Layers.Name.Index){
      Layer$aes_params$size <- Sets.Name.Size
      Layer$aes_params$label <- Sets.Name[Layers.Name.Index == Index]
      Layer$aes_params$colour <- scales::alpha(Sets.Name.Colour, Sets.Name.Opacity)
      if(Show.Set.Total){ Layer$aes_params$label <- sprintf("%s(%s)", Layer$aes_params$label, length(Sets.List[[which(Layers.Name.Index == Index)]])) }
    }else if(Index %in% Layers.Stroke.Index){
      Layer$aes_params$size <- Sets.Stroke.Size
      Layer$aes_params$linetype <- Sets.Stroke.Linetype
      Layer$aes_params$colour <- scales::alpha(Sets.Stroke.Colour[Layers.Stroke.Index == Index], Sets.Stroke.Opacity)
    }else if(Index %in% Layers.Intersection.Index){
      Layer$aes_params$size <- Intersection.Label.Size
      Layer$aes_params$colour <- scales::alpha(Intersection.Label.Colour, Intersection.Label.Opacity)
      if(Show.Percentage){ Layer$aes_params$label <- sprintf("%s\n%s%%", Layer$aes_params$label, round(as.numeric(Layer$aes_params$label)/Sets.List.Member.Num, 5)*100) }
    }
    return(Layer)
  })
  # 返回修改后的绘图结果
  return(Venn.Plot)
}


##' @description 对基因组上的信号特征(点和线段)进行可视化
##' @author Xteam.Wh
##' @param ... list 每个list包含以下元素(其中至少要包含Point.Data与Segment.Data其中的一项, 否则将被从队列中移除): 
############' $Feature.Name character 特征名, 将作为对应的纵坐标title属性; 默认NULL
############' $Point.Data data.frame 包含必要列[SeqName(序列名)、Position(所在序列的位点)、Feature.Value(特征信号值)], 可选列[Feature.Type(特征信号所属类别)]
############' $Segment.Data data.frame 包含必要列[SeqName(序列名)、Position.Start(所在序列的起始位点)、Position.End(所在序列的结束位点)、 Feature.Value(特征信号值)], 可选列[Feature.Type(特征信号所属类别)]
########################' 注意: SeqName信息要与选择的Genome.Version保持一致
############' $Point.Size numeric 设置点的尺寸; 默认1
############' $Point.Shape numeric | character 设置点型; 默认20
############' $Point.Alpha numeric 设置点的透明度; 默认0.66
############' $Point.Colour character 设置点的颜色; 默认"#2F4F4F"
############' $Point.Fill character 设置点的填充色; 默认"#2F4F4F"
############' $Point.Stroke numeric 设置点的边缘线尺寸; 默认1
############' $Segment.Size numeric 设置线段的尺寸; 默认1
############' $Segment.Alpha numeric 设置线段的透明度; 默认0.66
############' $Segment.Colour character 设置线段的颜色; 默认如果包含Point.Data设置为"OrangeRed", 不包含Point.Data设置"#2F4F4F", 
############' $Segment.LineType numeric | character 设置线段的线型; 默认"solid"
############' $Colour.Map characte[] 设置颜色映射集合, 与"Feature.Type"包含的元素种类相对应; 默认NULL
##' @param Feature.Data.List list 特征list数据集合, 每个特征信号对应一个list, 每个list包含的元素与可变参数(...)传入的每个list一致
##' @param Auto.Marge logical 设置是否自动对各图表进行合并; 默认TRUE
##' @param SeqName.Ratio numeric 设置组合图片中基因组条带图所占的比例, 当且仅当Auto.Marge = TRUE时生效; 默认0.125
##' @param Feature.Name.Aligned logical 设置各图表纵坐标title是否保持对齐, 当且仅当Auto.Marge = TRUE时生效; 默认FALSE
##' @param Genome.Version character 设置基因组版本号, 可选unique(c(GenomeInfoDb::registered_UCSC_genomes()$genome, GenomeInfoDb::registered_NCBI_assemblies()$assembly))
##' @return 若Auto.Marge = TRUE, 则返回组合后的绘图信息; 若Auto.Marge = FALSE, 则返回标题文本绘图信息、基因组条带绘图信息以及每个特征信号的绘图信息
Genome.View <- function(..., 
                        Feature.Data.List = NULL,
                        Auto.Marge = TRUE, SeqName.Ratio = 0.125, Feature.Name.Aligned = FALSE,
                        Genome.Version = unique(c(GenomeInfoDb::registered_UCSC_genomes()$genome, GenomeInfoDb::registered_NCBI_assemblies()$assembly))){
  
  library(ggplot2)
  # 参数判断
  Auto.Marge <- as.logical(Auto.Marge)
  SeqName.Ratio <- as.numeric(SeqName.Ratio)
  Genome.Version <- match.arg(Genome.Version)
  Feature.Name.Aligned <- as.logical(Feature.Name.Aligned)
  Feature.Data.List <- c(list(...), as.list(Feature.Data.List))
  stopifnot(length(Auto.Marge) == 1, length(Feature.Name.Aligned) == 1, length(SeqName.Ratio) == 1 && SeqName.Ratio > 0 && SeqName.Ratio < 1)
  # 查询基因组版本对应的基因组序列信息(名称、长度、...)
  Genome.Seqinfo <- GenomeInfoDb::Seqinfo(genome = Genome.Version)
  Genome.Seqinfo.SeqName <- Genome.Seqinfo@seqnames
  Genome.Seqinfo.SeqLength <- Genome.Seqinfo@seqlengths
  # 提取特征信号数据中包含的基因组序列名称, 并判断这些序列是否存在与所选取的基因组版本中
  Common.SeqName <- unique(
    unlist(
      lapply(Feature.Data.List, function(Feature.Data){
        return(unique(c(as.list(Feature.Data)$Point.Data$SeqName, as.list(Feature.Data)$Segment.Data$SeqName)))
      })
    )
  )
  if(!is.null(Common.SeqName) && any(! Common.SeqName %in% Genome.Seqinfo.SeqName)){
    stop(sprintf("'Point.Data'或'Segment.Data'的'SeqName'不能为Null且元素应均存在于(%s)", paste0(Genome.Seqinfo.SeqName, collapse = ", ")))
  }
  # 提取特征数据与参考基因组共有的序列信息
  Common.SeqName.Info <- data.frame(SeqName = Genome.Seqinfo.SeqName[Genome.Seqinfo.SeqName %in% Common.SeqName], SeqLength = Genome.Seqinfo.SeqLength[Genome.Seqinfo.SeqName %in% Common.SeqName])
  # 将共有序列的长度累加, 用于后面绘制横坐标的位点信息
  Common.SeqName.Info$Accumulate.SeqLength  <- cumsum(as.numeric(Common.SeqName.Info$SeqLength))
  # 计算序列名称在横坐标的标记位点
  Common.SeqName.Info$Label.Position <- (2*Common.SeqName.Info$Accumulate.SeqLength - Common.SeqName.Info$SeqLength)/2
  # 建立一个序列长度映射, 用于后面计算特这数据的横坐标
  Common.SeqName.Accumulate.Before.Map <- setNames(object = Common.SeqName.Info$Accumulate.SeqLength - Common.SeqName.Info$SeqLength, nm = Common.SeqName.Info$SeqName)
  # 格式化绘图数据基因组位置信息, 以及美学映射信息
  Feature.Data.List  <- lapply(Feature.Data.List, function(Feature.Data){
    Feature.Data <- as.list(Feature.Data)
    if((is.null(Feature.Data$Point.Data) || nrow(as.data.frame(Feature.Data$Point.Data)) == 0) && (is.null(Feature.Data$Segment.Data) || nrow(as.data.frame(Feature.Data$Segment.Data)) == 0)){
      warning("当前数据不存在'Point.Data'或'Segment.Data', 不符合要求, 请将其从队列中移 ...", call. = FALSE)
      return(NA)
    }else{
      if(is.null(Feature.Data$Feature.Name)){
        Feature.Data$Feature.Name <- NULL
        warning("当前数据未设置'Feature.Name'属性, 该属性将作为纵坐标title属性 ...", call. = FALSE)
      }
      if(! is.null(Feature.Data$Point.Data)){
        Feature.Data$Point.Data <- as.data.frame(Feature.Data$Point.Data)
        if(all(c("SeqName", "Position", "Feature.Value") %in% colnames(Feature.Data$Point.Data))){
          if(is.null(Feature.Data$Point.Size)){ Feature.Data$Point.Size = 1 }
          if(is.null(Feature.Data$Point.Shape)){ Feature.Data$Point.Shape = 20 }
          if(is.null(Feature.Data$Point.Stroke)){ Feature.Data$Point.Stroke = 1 }
          if(is.null(Feature.Data$Point.Alpha)){ Feature.Data$Point.Alpha = 0.66 }
          if(is.null(Feature.Data$Point.Colour)){ Feature.Data$Point.Colour = "#2F4F4F" }
          if(is.null(Feature.Data$Point.Fill)){ Feature.Data$Point.Fill = Feature.Data$Point.Colour }
          Feature.Data$Point.Data$Position  <- Feature.Data$Point.Data$Position + Common.SeqName.Accumulate.Before.Map[Feature.Data$Point.Data$SeqName]
        }else{
          stop("'Point.Data'应至少包含[SeqName(序列名)、Position(所在序列的位点)、Feature.Value(特征信号值)]三列信息, 可选信息[Feature.Type(特征信号所属类别)] ...")
        }
      }
      if(! is.null(Feature.Data$Segment.Data)){
        Feature.Data$Segment.Data <- as.data.frame(Feature.Data$Segment.Data)
        if(all(c("SeqName", "Position.Start", "Position.End", "Feature.Value") %in% colnames(Feature.Data$Segment.Data))){
          if(is.null(Feature.Data$Segment.Size)){ Feature.Data$Segment.Size = 1 }
          if(is.null(Feature.Data$Segment.Alpha)){ Feature.Data$Segment.Alpha = 0.66 }
          if(is.null(Feature.Data$Segment.LineType)){ Feature.Data$Segment.LineType = "solid" }
          if(is.null(Feature.Data$Segment.Colour)){ Feature.Data$Segment.Colour = ifelse(is.null(Feature.Data$Point.Data), "#2F4F4F", "OrangeRed") }
          Feature.Data$Segment.Data$Position.End  <- Feature.Data$Segment.Data$Position.End + Common.SeqName.Accumulate.Before.Map[Feature.Data$Segment.Data$SeqName]
          Feature.Data$Segment.Data$Position.Start  <- Feature.Data$Segment.Data$Position.Start + Common.SeqName.Accumulate.Before.Map[Feature.Data$Segment.Data$SeqName]
        }else{
          stop("'Segment.Data'应至少包含[SeqName(序列名), Position.Start(所在序列的起始位点), Position.End(所在序列的结束位点), Feature.Value(特征信号值)]四列信息, 可选信息[Feature.Type(特征信号所属类别)] ...")
        }
      }
      return(Feature.Data)
    }
  })
  # 绘制基因组序列条带(上下两条)
  SeqName.Plots <- lapply(c(top = "top", bottom = "bottom"), function(Postion){
    Common.SeqName.Info.Num <- nrow(Common.SeqName.Info)
    if(Common.SeqName.Info.Num == 1){
      Label.Position.Index <- 1
    }else{
      Label.Position.Index <- switch(Postion, top = seq(1, Common.SeqName.Info.Num, 2), bottom = seq(2, Common.SeqName.Info.Num, 2))
    }
    return(
      ggplot() +
        geom_rect(data = Common.SeqName.Info, aes(xmin = Accumulate.SeqLength - SeqLength + 1, xmax = Accumulate.SeqLength, ymin = -Inf, ymax = Inf, fill = SeqName), alpha = 0.5, show.legend = FALSE) + 
        scale_y_continuous(limits = c(-1, 1), expand = expansion()) +
        scale_fill_manual(values = setNames(object = ifelse((1:nrow(Common.SeqName.Info)) %% 2 == 0, "gray", "black"), nm = Common.SeqName.Info$SeqName)) +
        scale_x_continuous(limits = c(1, max(Common.SeqName.Info$Accumulate.SeqLength)), breaks = Common.SeqName.Info$Label.Position[Label.Position.Index], labels = Common.SeqName.Info$SeqName[Label.Position.Index], expand = expansion(), position = Postion) + 
        theme_test() +
        theme(
          axis.title = element_blank(),
          axis.line.y = element_blank(),
          axis.text.y = element_blank(),
          axis.ticks.y = element_blank(),
          axis.text.x = element_text(face = "bold"), 
          legend.key = element_rect(colour = NA, fill = "transparent"),
          plot.background = element_rect(colour = NA, fill = "transparent"), 
          panel.background = element_rect(colour = NA, fill = "transparent"),
          legend.background = element_rect(colour = NA, fill = "transparent"),
          legend.box.background = element_rect(colour = NA, fill = "transparent"), 
          plot.margin = margin(t = switch(Postion, top = 10, bottom = 2.5), r = 10, b = switch(Postion, top = 2.5, bottom = 10), l = 10)
        )
    )
  })
  # 绘制各特征信号(点、线段)
  Feature.Plots <- lapply(Feature.Data.List[!is.na(Feature.Data.List)], function(Feature.Data){
    Point.Data <- Feature.Data$Point.Data
    Segment.Data <- Feature.Data$Segment.Data
    Common.SeqName.Info.Num <- nrow(Common.SeqName.Info)
    if(Common.SeqName.Info.Num == 1){
      Top.Position.Index <- 1
      Bottom.Position.Index <- 1
    }else{
      Top.Position.Index <- seq(1, Common.SeqName.Info.Num, 2)
      Bottom.Position.Index <- seq(2, Common.SeqName.Info.Num, 2)
    }
    Feature.Plot <- ggplot() +
      geom_rect(data = Common.SeqName.Info, aes(xmin = Accumulate.SeqLength - SeqLength + 1, xmax = Accumulate.SeqLength, ymin = -Inf, ymax = Inf, fill = SeqName), alpha = 0.05, show.legend = FALSE) +
      scale_fill_manual(values = setNames(object = ifelse((1:nrow(Common.SeqName.Info)) %% 2 == 0, "gray", "black"), nm = Common.SeqName.Info$SeqName)) +
      scale_x_continuous(limits = c(1, max(Common.SeqName.Info$Accumulate.SeqLength)), breaks = Common.SeqName.Info$Label.Position[Bottom.Position.Index], labels = Common.SeqName.Info$SeqName[Bottom.Position.Index], expand = expansion(), sec.axis = dup_axis(breaks = Common.SeqName.Info$Label.Position[Top.Position.Index], labels = Common.SeqName.Info$SeqName[Top.Position.Index]))
    if(! is.null(Point.Data)){
      if(is.null(Point.Data$Feature.Type)){
        Feature.Plot <- Feature.Plot + geom_point(data = Point.Data, aes(x = Position, y = Feature.Value), colour = Feature.Data$Point.Colour, shape = Feature.Data$Point.Shape, fill = Feature.Data$Point.Fill, stroke = Feature.Data$Point.Stroke, size = Feature.Data$Point.Size, alpha = Feature.Data$Point.Alpha)
      }else{
        Feature.Plot <- Feature.Plot + geom_point(data = Point.Data, aes(x = Position, y = Feature.Value, colour = Feature.Type), shape = Feature.Data$Point.Shape, fill = Feature.Data$Point.Fill, stroke = Feature.Data$Point.Stroke, size = Feature.Data$Point.Size, alpha = Feature.Data$Point.Alpha)
      }
    }
    if(! is.null(Segment.Data)){
      if(is.null(Segment.Data$Feature.Type)){
        Feature.Plot <- Feature.Plot + geom_segment(data = Segment.Data, aes(x = Position.Start, y = Feature.Value, xend = Position.End, yend = Feature.Value), colour = Feature.Data$Segment.Colour, size = Feature.Data$Segment.Size, alpha = Feature.Data$Segment.Alpha, linetype = Feature.Data$Segment.LineType)
      }else{
        Feature.Plot <- Feature.Plot + geom_segment(data = Segment.Data, aes(x = Position.Start, y = Feature.Value, xend = Position.End, yend = Feature.Value, colour = Feature.Type), size = Feature.Data$Segment.Size, alpha = Feature.Data$Segment.Alpha, linetype = Feature.Data$Segment.LineType)
      }
    }
    if(! is.null(Feature.Data$Colour.Map) && ! (is.null(Point.Data$Feature.Type) && is.null(Segment.Data$Feature.Type))){
      if("character" %in% class(Feature.Data$Colour.Map) && length(Feature.Data$Colour.Map) == length(unique(c(Point.Data$Feature.Type, Segment.Data$Feature.Type)))){
        Feature.Plot <- Feature.Plot + scale_colour_manual(values = Feature.Data$Colour.Map)
      }else{
        stop("当前数据'Colour.Map'应为NULL或与‘Feature.Type’包含的元素种类相对应的character向量 ...")
      }
    }
    return(Feature.Plot + labs(x = NULL, y = Feature.Data$Feature.Name) + theme_test() +theme(legend.key = element_rect(colour = NA, fill = "transparent"), plot.background = element_rect(colour = NA, fill = "transparent"), panel.background = element_rect(colour = NA, fill = "transparent"), legend.background = element_rect(colour = NA, fill = "transparent"), legend.box.background = element_rect(colour = NA, fill = "transparent")))
  })
  # 格式化返回的可视化结果
  if(Auto.Marge){
    Feature.Plots <- lapply(Feature.Plots, function(Feature.Plot){
      return(Feature.Plot + theme(axis.line.x = element_blank(), axis.text.x = element_blank(), axis.ticks.x = element_blank(), axis.title.x = element_blank(), axis.ticks.length.x = unit(0, "pt"), legend.title = element_blank(), plot.margin = margin(t = 2.5, r = 10, b = 2.5, l = 10))
      )
    })
    return(cowplot::plot_grid(plotlist = c(SeqName.Plots[1], Feature.Plots, SeqName.Plots[2]), ncol = 1, rel_heights = c(SeqName.Ratio/2, rep((1 - SeqName.Ratio)/length(Feature.Plots), length(Feature.Plots)), SeqName.Ratio/2), align = "v", axis = "lr", greedy = Feature.Name.Aligned))
  }else{
    return(list(Title.Plot = Title.Plot, SeqName.Plots = SeqName.Plots, Feature.Plots = Feature.Plots))
  }
}

##' @description 基因组等位特异拷贝数信息可视化
##' @author Xteam.Wh
##' @param Data data.frame data.frame 包含必要列[SeqName(序列名)、Position.Start(所在序列的起始位点)、Position.End(所在序列的终止位点)、CN.Major(主拷贝数)、 CN.Minor(次拷贝数)]
############' 注意: SeqName信息要与选择的Genome.Version保持一致
##' @param Plot.Title character 设置图片标题, 将被添加到图片的正上方; 默认NULL
##' @param Minor.Colour character CN.Minor所显示的颜色; 默认"#696969"
##' @param Major.Colour character CN.Major所显示的颜色; 默认"#2F4F4F"
##' @param Genome.Version character 设置基因组版本号, 可选unique(c(GenomeInfoDb::registered_UCSC_genomes()$genome, GenomeInfoDb::registered_NCBI_assemblies()$assembly))
##' @return ggplot格式的绘图信息
Genome.Allele.CN.View <- function(Data,
                                  Plot.Title = NULL,
                                  Minor.Colour = "#696969", Major.Colour = "#2F4F4F",
                                  Genome.Version = unique(c(GenomeInfoDb::registered_UCSC_genomes()$genome, GenomeInfoDb::registered_NCBI_assemblies()$assembly))){
  library(ggplot2)
  # 参数判断
  Data <- as.data.frame(Data)
  Plot.Title <- as.character(Plot.Title)
  Minor.Colour <- as.character(Minor.Colour)
  Major.Colour <- as.character(Major.Colour)
  Genome.Version <- match.arg(Genome.Version)
  stopifnot(length(Plot.Title) <= 1, length(Minor.Colour) == 1, length(Major.Colour) == 1, all(c("SeqName", "Position.Start", "Position.End", "CN.Major", "CN.Minor") %in% colnames(Data)))
  # 查询基因组版本对应的基因组序列信息(名称、长度、...)
  Genome.Seqinfo <- GenomeInfoDb::Seqinfo(genome = Genome.Version)
  Genome.Seqinfo.SeqName <- Genome.Seqinfo@seqnames
  Genome.Seqinfo.SeqLength <- Genome.Seqinfo@seqlengths
  # 格式化需要绘制的基因组序列相关的位置信息
  if(all(unique(Data$SeqName) %in% Genome.Seqinfo.SeqName)){
    # 提取特征数据与参考基因组共有的序列信息
    Common.SeqName.Info <- data.frame(SeqName = Genome.Seqinfo.SeqName[Genome.Seqinfo.SeqName %in% unique(Data$SeqName)], SeqLength = Genome.Seqinfo.SeqLength[Genome.Seqinfo.SeqName %in% unique(Data$SeqName)])
    # 将共有序列的长度累加, 用于后面绘制横坐标的位点信息
    Common.SeqName.Info$Accumulate.SeqLength  <- cumsum(as.numeric(Common.SeqName.Info$SeqLength))
    # 计算序列名称在横坐标的标记位点
    Common.SeqName.Info$Label.Position <- (2*Common.SeqName.Info$Accumulate.SeqLength - Common.SeqName.Info$SeqLength)/2
    # 建立一个序列长度映射, 用于后面计算特这数据的横坐标
    Common.SeqName.Accumulate.Before.Map <- setNames(object = Common.SeqName.Info$Accumulate.SeqLength - Common.SeqName.Info$SeqLength, nm = Common.SeqName.Info$SeqName)
    
    # 格式化特征数据的基因组坐标绘图信息
    Data$Position.Start <- Data$Position.Start + Common.SeqName.Accumulate.Before.Map[Data$SeqName]
    Data$Position.End <- Data$Position.End + Common.SeqName.Accumulate.Before.Map[Data$SeqName]
  }else{
    stop(sprintf("'Data'的'SeqName'元素应均存在于(%s)", paste0(Genome.Seqinfo.SeqName, collapse = ", ")))
  }
  # 格式化绘图信息
  Data <- Reduce(rbind, apply(Data, 1, function(Row.Data){
    SeqName <- as.character(Row.Data[1])
    Position.Start <- as.numeric(Row.Data[2])
    Position.End <- as.numeric(Row.Data[3])
    CN.Major <- as.numeric(Row.Data[4])
    CN.Minor <- as.numeric(Row.Data[5])
    if(CN.Major > 0){
      Y.Min <- 0:(CN.Major - 1)
      Y.Max <- 1:CN.Major
      CN.Type <- rep("CN.Major", CN.Major)
    }else{
      return(NULL)
    }
    if(CN.Minor > 0){
      Y.Min <- c(Y.Min, CN.Major:(CN.Major + CN.Minor - 1))
      Y.Max <- c(Y.Max, (CN.Major + 1):(CN.Major + CN.Minor))
      CN.Type <- c(CN.Type, rep("CN.Minor", CN.Minor))
    }
    return(
      data.frame(SeqName = SeqName, X.Min = Position.Start, X.Max = Position.End, Y.Min = Y.Min, Y.Max = Y.Max, CN.Type = factor(CN.Type, levels = c("CN.Minor", "CN.Major")))
    )
  }))
  # 返回绘图结果
  return(
    ggplot() + 
      geom_rect(data = Data, aes(xmin = X.Min, xmax = X.Max, ymin = Y.Min, ymax = Y.Max, fill = CN.Type), colour = "white", lwd = 0.01) +
      geom_text(aes(x = Common.SeqName.Info$Label.Position, y = -0.25, label = Common.SeqName.Info$SeqName), colour = "#BDB76B", fontface = "bold", vjust = 1, check_overlap = TRUE) +
      geom_hline(yintercept = 0, color = "black") +
      geom_linerange(data = NULL, aes(x = 1, ymin = 0, ymax = Inf), color = "black") + 
      geom_linerange(data = NULL, aes(x = Common.SeqName.Info$Accumulate.SeqLengt[-nrow(Common.SeqName.Info)], ymin = -Inf, ymax = 0), color = "black") +
      scale_y_continuous(limits = c(-1, max(Data$Y.Max) + 0.25), expand = expansion(), breaks = c(0:max(Data$Y.Max)), labels = sapply(0:max(Data$Y.Max), function(Y.Value){ifelse(Y.Value %% 2 == 0, Y.Value, "")})) + 
      scale_x_continuous(limits = c(1, max(Common.SeqName.Info$Accumulate.SeqLength)), expand = expansion(), breaks = NULL) +
      scale_fill_manual(values = setNames(object = c(Minor.Colour, Major.Colour), nm = c("CN.Minor", "CN.Major"))) +
      labs(x = NULL, y = NULL, fill = NULL, subtitle = Plot.Title) +
      coord_cartesian(clip = "off") + 
      theme_classic() + 
      theme(
        axis.line.y.left = element_blank(),
        axis.line.x.bottom = element_blank(),
        axis.ticks.y = element_line(colour = "black"),
        axis.text.y.left = element_text(face = "bold"),
        plot.subtitle = element_text(size = 12, face = "bold", colour = "#2F4F4F", hjust = 0.5)
      )
  )
}