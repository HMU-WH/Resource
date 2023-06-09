##############################函数描述##############################
# "Gatk.GetSampleName"通过R函数传参调用Gatk GetSampleName获取SAM/BAM/CRAM的样本名[文件头标签@RG的SM值]
# "Gatk.Mutect2"通过R函数传参调用Gatk Mutect2进行体突变的识别
# "Gatk.LearnReadOrientationModel"通过R函数传参调用Gatk LearnReadOrientationModel进行模型学习, 估计方向偏差参数(先验概率)
# "Gatk.GetPileupSummaries"通过R函数传参调用Gatk GetPileupSummaries总结样本在已知变异位点集上的reads支持情况(堆积指标)[肿瘤样本与正常样本单独使用]
# "Gatk.CalculateContamination"通过R函数传参调用Gatk CalculateContamination评估交叉样本污染reads分数
# "Gatk.FilterMutectCalls"通过R函数传参调用Gatk FilterMutectCalls过滤由Gatk Mutect2识别的体突变
####################################################################


##' @description 通过R函数传参调用Gatk GetSampleName获取SAM/BAM/CRAM的样本名[文件头标签@RG的SM值]
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param AM.Input character 要读取的SAM/BAM/CRAM文件
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等; 默认NULL
##' @return character SAM/BAM/CRIM文件记录的样本名
Gatk.GetSampleName <- function(Gatk.Local.Jar, AM.Input, System.Java.Alias = "java", Java.Options.Settings = NULL){
  
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.GetSampleName.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为NULL或单一的character值 ...")
    }
  }else{
    Gatk.GetSampleName.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.GetSampleName.Command <- sprintf("%s -jar \"%s\" GetSampleName", Gatk.GetSampleName.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置AM.Input[--input / -I]
  AM.Input <- as.character(AM.Input)
  if(length(AM.Input) == 1 && file.exists(AM.Input)){
    Gatk.GetSampleName.Command <- sprintf("%s --input \"%s\"", Gatk.GetSampleName.Command, normalizePath(AM.Input, winslash = "/", mustWork = TRUE))
  }else{
    stop("'AM.Input'应为单一且存在的文件路径 ...")
  }
  
  # 配置临时输出文件[--output / -O]
  Sample.Temp.Output <- tempfile(tmpdir = getwd(), pattern = "Gatk.GetSampleName[", fileext = "]")
  on.exit(expr = {unlink(Sample.Temp.Output, force = TRUE)}, add = TRUE)
  Gatk.GetSampleName.Command <- sprintf("%s --output \"%s\"", Gatk.GetSampleName.Command, Sample.Temp.Output)
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.GetSampleName.Command)
  
  # 返回获取的样本名称
  return(readLines(Sample.Temp.Output, warn = FALSE))
}


##' @description 通过R函数传参调用Gatk Mutect2进行体突变的识别
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param Genome.Refence character 参考基因组文件[fasta格式, 且要求所在目录下同时含有对应的索引文件与序列字典文件]
##' @param AM.Input character[] 要读取的SAM/BAM/CRAM文件集合[来自同一个体，且要求所在目录下同时含有对应的索引文件]
##' @param Genome.Intervals character 限制对基因组区域的子集进行操作的基因组区间文件(支持Bed格式与Picard格式), 对于靶向测序应该设置该参数; 默认NULL
##' @param Intervals.Padding numeric 在Genome.Intervals中包含的各区间两侧添加一定的填充, 以包括侧翼区域(以bp为单位); 默认0
##' @param Output.Prefix character 结果文件(vcf格式)前缀[可携带路径]; 默认NULL, 即当前工作目录下的"Gatk.Mutect2"
##' @param Output.Compressed logical 是否对结果文件进行压缩处理[Xxx.vcf.gz]; 默认FALSE
##' @param With.F1R2.Counts character 是否为肿瘤样本统计F1R2计数[将输出一个Xxx.tar.gz文件, 可用于后续模型方向偏差参数的估计], 主要用于测序前在单链上发生取代错误的样本(FFPE肿瘤样本); 默认FALSE
##' @param Keep.Diff.Contig.Reads logical 是否禁用过滤器"MateOnSameContigOrNoMappedMateReadFilter", 保留匹配到不同重叠群(contig)的的paired reads; 默认FALSE
##' @param Normal.Samples character[] 指定正常样本SAM/BAM/CRIM文件对应的样本名[文件头标签@RG的SM值], 可通过Gatk GetSampleName功能提取; 默认NULL
##' @param Normal.Panel character 指定由正常组织数据(不同个体)构建的PON参考文件[vcf格式(支持.gz压缩格式), 且要求所在目录下同时含有对应的索引文件], 有助于过滤掉常见的种系突变位点(“正常”是指源自健康组织，被认为没有任何体细胞变化; 样本应来自年轻且健康的受试者, 通常来自血液样本); 默认NULL
##' @param Germline.Resource character 指定群体种系资源参考文件[vcf格式(支持.gz压缩格式), 且要求所在目录下同时含有对应的索引文件], 用于获取种群中变异等位基因的频率，从而提供样本在种系中携带变异等位基因的先验概率(种系资源必须包含等位特异频率，因此必须在INFO字段中包含AF注释); 默认NULL
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认为"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等; 默认NULL
##' @param Other.Options.Settings character 其他参数的设置, 将被拼接到指令中进行调用; 默认NULL
Gatk.Mutect2 <- function(Gatk.Local.Jar, 
                         Genome.Refence, AM.Input, 
                         Genome.Intervals = NULL, Intervals.Padding = 0,
                         Output.Prefix = NULL, Output.Compressed = FALSE, 
                         With.F1R2.Counts = FALSE, Keep.Diff.Contig.Reads = FALSE, 
                         Normal.Samples = NULL,  Normal.Panel = NULL, Germline.Resource = NULL, 
                         System.Java.Alias = "java", Java.Options.Settings = NULL, Other.Options.Settings = NULL){
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.Mutect2.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为NULL或单一的character值 ...")
    }
  }else{
    Gatk.Mutect2.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.Mutect2.Command <- sprintf("%s -jar \"%s\" Mutect2", Gatk.Mutect2.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置Genome.Refence[--reference / -R]
  Genome.Refence <- as.character(Genome.Refence)
  if(length(Genome.Refence) == 1 && file.exists(Genome.Refence)){
    Gatk.Mutect2.Command <- sprintf("%s --reference \"%s\"", Gatk.Mutect2.Command, normalizePath(Genome.Refence, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Genome.Refence'应为单一且存在的文件路径 ...")
  }
  
  # 配置AM.Input[--input / -I]
  AM.Input <- as.character(AM.Input)
  if(length(AM.Input) > 0){
    Gatk.Mutect2.Command <- sprintf("%s %s", Gatk.Mutect2.Command, paste0(sprintf("--input \"%s\"", normalizePath(AM.Input, winslash = "/", mustWork = TRUE)), collapse = " "))
  }else{
    stop("'AM.Input'应为至少包含一个元素的文件集合, 且各文件应已经存在 ...")
  }
  
  # 配置Genome.Intervals[--intervals / -L]
  Genome.Intervals<- as.character(Genome.Intervals)
  if(length(Genome.Intervals) > 0){
    if(length(Genome.Intervals) == 1 && file.exists(Genome.Intervals)){
      Gatk.Mutect2.Command <- sprintf("%s --intervals \"%s\"", Gatk.Mutect2.Command, normalizePath(Genome.Intervals, winslash = "/", mustWork = TRUE))
    }else{
      stop("'Genome.Intervals'应为NULL或单一且存在的文件路径 ...")
    }
  }
  
  # 配置Intervals.Padding[--interval-padding / -ip]
  Intervals.Padding <- as.numeric(Intervals.Padding)
  if(length(Intervals.Padding) > 0 && Intervals.Padding >= 0 && Intervals.Padding %% 1 == 0){
    Gatk.Mutect2.Command <- sprintf("%s --interval-padding %s", Gatk.Mutect2.Command, Intervals.Padding)
  }else{
    stop("'Intervals.Padding'应为单一的大于等于0的整型numeric值 ...")
  }
  
  # 配置Normal.Samples[--normal-sample / -normal]
  Normal.Samples <- as.character(Normal.Samples)
  if(length(Normal.Samples) > 0){
    Gatk.Mutect2.Command <- sprintf("%s %s", Gatk.Mutect2.Command, paste0(sprintf("--normal-sample \"%s\"", Normal.Samples), collapse = " "))
  }
  
  # 配置Normal.Panel[--panel-of-normals / -pon]
  Normal.Panel <- as.character(Normal.Panel)
  if(length(Normal.Panel) > 0){
    if(length(Normal.Panel) == 1 && file.exists(Normal.Panel)){
      Gatk.Mutect2.Command <- sprintf("%s --panel-of-normals \"%s\"", Gatk.Mutect2.Command, normalizePath(Normal.Panel, winslash = "/", mustWork = TRUE))
    }else{
      stop("'Normal.Panel'应为NULL或单一且存在的文件路径 ...")
    }
  }
  
  # 配置Germline.Resource[--germline-resource]
  Germline.Resource <- as.character(Germline.Resource)
  if(length(Germline.Resource) > 0){
    if(length(Germline.Resource) == 1 && file.exists(Germline.Resource)){
      Gatk.Mutect2.Command <- sprintf("%s --germline-resource \"%s\"", Gatk.Mutect2.Command, normalizePath(Germline.Resource, winslash = "/", mustWork = TRUE))
    }else{
      stop("'Germline.Resource'应为NULL或单一且存在的文件路径 ...")
    }
  }
  
  # 配置Keep.Diff.Contig.Reads[--disable-read-filter / -DF]
  Keep.Diff.Contig.Reads <- as.logical(Keep.Diff.Contig.Reads)
  if(length(Keep.Diff.Contig.Reads) == 1){
    if(Keep.Diff.Contig.Reads){
      Gatk.Mutect2.Command <- sprintf("%s --disable-read-filter MateOnSameContigOrNoMappedMateReadFilter", Gatk.Mutect2.Command)
    }
  }else{
    stop("'Keep.Diff.Contig.Reads'应为单一的logical值 ...")
  }
  
  # 配置Other.Options.Settings[其他参数]
  Other.Options.Settings <- as.character(Other.Options.Settings)
  if(length(Other.Options.Settings) > 0){
    if(length(Other.Options.Settings) == 1){
      Gatk.Mutect2.Command <- sprintf("%s %s", Gatk.Mutect2.Command, trimws(Other.Options.Settings))
    }else{
      stop("'Other.Options.Settings'应为NULL或单一的character值 ...")
    }
  }
  
  # 配置Output.Prefix
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Gatk.Mutect2", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(Output.Prefix, winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为NULL或单一的character值 ...")
  }
  
  # 配置With.F1R2.Counts[--f1r2-tar-gz]
  With.F1R2.Counts <- as.logical(With.F1R2.Counts)
  if(length(With.F1R2.Counts) == 1){
    if(With.F1R2.Counts){
      Mutect2.F1R2.Output <- sprintf("%s.f1r2.tar.gz", Output.Prefix)
      file.create(Mutect2.F1R2.Output, showWarnings = FALSE)
      Gatk.Mutect2.Command <- sprintf("%s --f1r2-tar-gz \"%s\"", Gatk.Mutect2.Command, normalizePath(Mutect2.F1R2.Output, winslash = "/", mustWork = TRUE))
    }
  }else{
    stop("'With.F1R2.Counts'应为单一的logical值 ...")
  }
  
  # 配置Output.Compressed[--output / -O]
  Output.Compressed <- as.logical(Output.Compressed)
  if(length(Output.Compressed) == 1){
    Mutect2.Calling.Output <- sprintf("%s.%s", Output.Prefix, ifelse(Output.Compressed, "vcf.gz", "vcf"))
    file.create(Mutect2.Calling.Output, showWarnings = FALSE)
    Mutect2.Calling.Output <- normalizePath(Mutect2.Calling.Output, winslash = "/", mustWork = TRUE)
    Gatk.Mutect2.Command <- sprintf("%s --output \"%s\"", Gatk.Mutect2.Command, Mutect2.Calling.Output)
  }else{
    stop("'Output.Compressed'应为单一的logical值 ...")
  }
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.Mutect2.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", Mutect2.Calling.Output))
}


##' @description 通过R函数传参调用Gatk LearnReadOrientationModel进行模型学习, 估计方向偏差参数(先验概率)
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param F1R2.Counts.Input character[] 由Gatk Mutect2输出的肿瘤样本F1R2计数文件[来自同一个体]
##' @param Output.Prefix character 结果文件前缀[可携带路径]; 默认NULL, 即当前工作目录下的"Gatk.LearnReadOrientationModel"
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认为"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等; 默认NULL
##' @param Other.Options.Settings character 其他参数的设置, 将被拼接到指令中进行调用; 默认NULL
Gatk.LearnReadOrientationModel <- function(Gatk.Local.Jar, 
                                           F1R2.Counts.Input, Output.Prefix = NULL, 
                                           System.Java.Alias = "java", Java.Options.Settings = NULL, Other.Options.Settings = NULL){
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.LearnReadOrientationModel.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为NULL或单一的character值 ...")
    }
  }else{
    Gatk.LearnReadOrientationModel.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.LearnReadOrientationModel.Command <- sprintf("%s -jar \"%s\" LearnReadOrientationModel", Gatk.LearnReadOrientationModel.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置F1R2.Counts.Input[--input / -I]
  F1R2.Counts.Input <- as.character(F1R2.Counts.Input)
  if(length(F1R2.Counts.Input) > 0){
    Gatk.LearnReadOrientationModel.Command <- sprintf("%s %s", Gatk.LearnReadOrientationModel.Command, paste0(sprintf("--input \"%s\"", normalizePath(F1R2.Counts.Input, winslash = "/", mustWork = TRUE)), collapse = " "))
  }else{
    stop("'F1R2.Counts.Input'应为至少包含一个元素的文件集合, 且各文件应已经存在 ...")
  }
  
  # 配置Other.Options.Settings[其他参数]
  Other.Options.Settings <- as.character(Other.Options.Settings)
  if(length(Other.Options.Settings) > 0){
    if(length(Other.Options.Settings) == 1){
      Gatk.LearnReadOrientationModel.Command <- sprintf("%s %s", Gatk.LearnReadOrientationModel.Command, trimws(Other.Options.Settings))
    }else{
      stop("'Other.Options.Settings'应为NULL或单一的character值 ...")
    }
  }
  
  # 配置Output.Prefix[--output / -O]
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Gatk.LearnReadOrientationModel", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(Output.Prefix, winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为NULL或单一的character值 ...")
  }
  Orientation.Model.Output <- sprintf("%s.tar.gz", Output.Prefix)
  file.create(Orientation.Model.Output, showWarnings = FALSE)
  Orientation.Model.Output <- normalizePath(Orientation.Model.Output, winslash = "/", mustWork = TRUE)
  Gatk.LearnReadOrientationModel.Command <- sprintf("%s --output \"%s\"", Gatk.LearnReadOrientationModel.Command, Orientation.Model.Output)
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.LearnReadOrientationModel.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", Orientation.Model.Output))
}


##' @description 通过R函数传参调用Gatk GetPileupSummaries总结样本在已知变异位点集上的reads支持情况(堆积指标)[肿瘤样本与正常样本单独使用]
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param AM.Input character[] 要读取的SAM/BAM/CRAM文件集合[来自同一个体同一类型，且要求所在目录下同时含有对应的索引文件]
##' @param Germline.Variant.Sites character 一个通用的种系变异位点参考文件[vcf格式(支持.gz压缩格式), 且要求所在目录下同时含有对应的索引文件], 此资源必须只包含双等位SNP, 且必须在INFO字段中包含AF注释
##' @param Output.Prefix character 结果文件前缀[可携带路径]; 默认NULL, 即当前工作目录下的"Gatk.GetPileupSummaries"
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认为"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等; 默认NULL
##' @param Other.Options.Settings character 其他参数的设置, 将被拼接到指令中进行调用; 默认NULL
Gatk.GetPileupSummaries <- function(Gatk.Local.Jar, 
                                    AM.Input, Germline.Variant.Sites, Output.Prefix = NULL, 
                                    System.Java.Alias = "java", Java.Options.Settings = NULL, Other.Options.Settings = NULL){
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.GetPileupSummaries.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为NULL或单一的character值 ...")
    }
  }else{
    Gatk.GetPileupSummaries.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.GetPileupSummaries.Command <- sprintf("%s -jar \"%s\" GetPileupSummaries", Gatk.GetPileupSummaries.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置AM.Input[--input / -I]
  AM.Input <- as.character(AM.Input)
  if(length(AM.Input) > 0){
    Gatk.GetPileupSummaries.Command <- sprintf("%s %s", Gatk.GetPileupSummaries.Command, paste0(sprintf("--input \"%s\"", normalizePath(AM.Input, winslash = "/", mustWork = TRUE)), collapse = " "))
  }else{
    stop("'AM.Input'应为至少包含一个元素的文件集合, 且各文件应已经存在 ...")
  }
  
  # 配置Germline.Variant.Sites[--variant / -V][--intervals / -L]
  Germline.Variant.Sites <- as.character(Germline.Variant.Sites)
  if(length(Germline.Variant.Sites) == 1 && file.exists(Germline.Variant.Sites)){
    Gatk.GetPileupSummaries.Command <- sprintf("%s --variant \"%s\" --intervals \"%s\" ", Gatk.GetPileupSummaries.Command, normalizePath(Germline.Variant.Sites, winslash = "/", mustWork = TRUE), normalizePath(Germline.Variant.Sites, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Germline.Variant.Sites'应为单一且存在的文件路径 ...")
  }
  
  # 配置Other.Options.Settings[其他参数]
  Other.Options.Settings <- as.character(Other.Options.Settings)
  if(length(Other.Options.Settings) > 0){
    if(length(Other.Options.Settings) == 1){
      Gatk.GetPileupSummaries.Command <- sprintf("%s %s", Gatk.GetPileupSummaries.Command, trimws(Other.Options.Settings))
    }else{
      stop("'Other.Options.Settings'应为NULL或单一的character值 ...")
    }
  }
  
  # 配置Output.Prefix[--output / -O]
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Gatk.GetPileupSummaries", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(Output.Prefix, winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为NULL或单一的character值 ...")
  }
  Pileup.Table.Output <- sprintf("%s.table", Output.Prefix)
  file.create(Pileup.Table.Output, showWarnings = FALSE)
  Pileup.Table.Output <- normalizePath(Pileup.Table.Output, winslash = "/", mustWork = TRUE)
  Gatk.GetPileupSummaries.Command <- sprintf("%s --output \"%s\"", Gatk.GetPileupSummaries.Command, Pileup.Table.Output)
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.GetPileupSummaries.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", Pileup.Table.Output))
}


##' @description 通过R函数传参调用Gatk CalculateContamination评估交叉样本污染reads分数
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param Tumor.Pileup.Input character 由Gatk GetPileupSummaries针对肿瘤样本统计的堆积指标文件
##' @param Normal.Pileup.Input character 由Gatk GetPileupSummaries针对正常样本[与肿瘤样本来自同一个体]统计的堆积指标文件
##' @param With.Segmentation.Table logical 是否输出按次等位基因分数划分的肿瘤样本区段; 默认FALSE
##' @param Output.Prefix character 结果文件前缀[可携带路径]; 默认为当前工作目录下的"Gatk.CalculateContamination"
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认为"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等
##' @param Other.Options.Settings character 其他参数的设置, 将被拼接到指令中进行调用
Gatk.CalculateContamination <- function(Gatk.Local.Jar, 
                                        Tumor.Pileup.Input, Normal.Pileup.Input = NULL, With.Segmentation.Table = FALSE, 
                                        Output.Prefix = NULL,System.Java.Alias = "java", Java.Options.Settings = NULL, Other.Options.Settings = NULL){
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.CalculateContamination.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为Null或单一的character值 ...")
    }
  }else{
    Gatk.CalculateContamination.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.CalculateContamination.Command <- sprintf("%s -jar \"%s\" CalculateContamination", Gatk.CalculateContamination.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置Tumor.Pileup.Input[--input / -I]
  Tumor.Pileup.Input <- as.character(Tumor.Pileup.Input)
  if(length(Tumor.Pileup.Input) == 1 && file.exists(Tumor.Pileup.Input)){
    Gatk.CalculateContamination.Command <- sprintf("%s --input \"%s\"", Gatk.CalculateContamination.Command, normalizePath(Tumor.Pileup.Input, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Tumor.Pileup.Input'应为单一且存在的文件路径 ...")
  }
  
  # 配置Normal.Pileup.Input[--matched-normal / -matched]
  Normal.Pileup.Input <- as.character(Normal.Pileup.Input)
  if(length(Normal.Pileup.Input) > 0){
    if(length(Normal.Pileup.Input) == 1 && file.exists(Normal.Pileup.Input)){
      Gatk.CalculateContamination.Command <- sprintf("%s --matched-normal \"%s\"", Gatk.CalculateContamination.Command, normalizePath(Normal.Pileup.Input, winslash = "/", mustWork = TRUE))
    }else{
      stop("'Normal.Pileup.Input'应为NULL或单一且存在的文件路径 ...")
    }
  }
  
  # 配置Other.Options.Settings[其他参数]
  Other.Options.Settings <- as.character(Other.Options.Settings)
  if(length(Other.Options.Settings) > 0){
    if(length(Other.Options.Settings) == 1){
      Gatk.CalculateContamination.Command <- sprintf("%s %s", Gatk.CalculateContamination.Command, trimws(Other.Options.Settings))
    }else{
      stop("'Other.Options.Settings'应为Null或单一的character值 ...")
    }
  }
  
  # 配置Output.Prefix
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Gatk.CalculateContamination", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(Output.Prefix, winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为Null或单一的character值 ...")
  }
  
  # 配置With.Segmentation.Table[--tumor-segmentation / -segments]
  With.Segmentation.Table <- as.logical(With.Segmentation.Table)
  if(length(With.Segmentation.Table) == 1){
    if(With.Segmentation.Table){
      Segmentation.Table.Output <- sprintf("%s.segmentation.table", Output.Prefix)
      file.create(Segmentation.Table.Output, showWarnings = FALSE)
      Gatk.CalculateContamination.Command <- sprintf("%s --tumor-segmentation %s", Gatk.CalculateContamination.Command, normalizePath(Segmentation.Table.Output, winslash = "/", mustWork = TRUE))
    }
  }else{
    stop("'With.Segmentation.Table'应为单一的logical值 ...")
  }
  
  # 配置Contamination.Table.Output[--output / -O]
  Contamination.Table.Output <- sprintf("%s.table", Output.Prefix)
  file.create(Contamination.Table.Output, showWarnings = FALSE)
  Contamination.Table.Output <- normalizePath(Contamination.Table.Output, winslash = "/", mustWork = TRUE)
  Gatk.CalculateContamination.Command <- sprintf("%s --output \"%s\"", Gatk.CalculateContamination.Command, Contamination.Table.Output)
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.CalculateContamination.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", Contamination.Table.Output))
}


##' @description 通过R函数传参调用Gatk FilterMutectCalls过滤由Mutect2识别的体突变
##' @author HMU-WH
##' @param Gatk.Local.Jar character "gatk-package-Xxx-local.jar"文件路径(存在于gatk安装目录中)
##' @param Genome.Refence character 参考基因组文件[fasta格式, 且要求同所在目录下同时含有对应的索引文件与序列字典文件]
##' @param Mutect2.Calling.Result character 由Gatk Mutect2识别的体突变结果文件[vcf格式(支持.gz压缩格式), 且要求所在目录下同时含有对应的索引文件以及stas文件]
##' @param Output.Prefix character 结果文件(vcf格式)前缀[可携带路径]; 默认NULL, 即当前工作目录下的"Gatk.FilterMutectCalls"
##' @param Output.Compressed logical 是否对结果文件进行压缩处理[Xxx.vcf.gz]; 默认FALSE
##' @param Orientation.Models character[] 由Gatk LearnReadOrientationModel针对肿瘤样进行模型学习的结果文件[来自同一个体]; 默认NULL
##' @param Contamination.Tables character[] 由Gatk CalculateContamination针对肿瘤样本计算的来自交叉样本污染的reads分数文件[来自同一个体]; 默认NULL
##' @param Tumor.Segmentations character[] 由Gatk CalculateContamination针对肿瘤样本按次等位基因分数划分区段文件[来自同一个体]; 默认NULL
##' @param System.Java.Alias character java软件在系统中的可执行命令名; 默认为"java"
##' @param Java.Options.Settings character Java运行环境参数配置, 如设置JVM内存大小(-Xms...、-Xmx...)、并发GC线程数(-XX:ParallelGCThreads=...)等; 默认NULL
##' @param Other.Options.Settings character 其他参数的设置, 将被拼接到指令中进行调用; 默认NULL
Gatk.FilterMutectCalls <- function(Gatk.Local.Jar, 
                                   Genome.Refence, Mutect2.Calling.Result,  
                                   Output.Prefix = NULL, Output.Compressed = FALSE, 
                                   Orientation.Models = NULL, Contamination.Tables = NULL, Tumor.Segmentations = NULL,
                                   System.Java.Alias = "java", Java.Options.Settings = NULL, Other.Options.Settings = NULL){
  
  # 检查并判断System.Java.Alias在系统中是否存在
  System.Java.Alias <- as.character(System.Java.Alias)
  if(length(System.Java.Alias) == 1){
    if(nchar(Sys.which(System.Java.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Java.Alias))
    }
  }else{
    stop("'System.Java.Alias'应为单一的character值 ...")
  }
  
  # 配置Java.Options.Settings[Java运行环境设置]
  Java.Options.Settings <- as.character(Java.Options.Settings)
  if(length(Java.Options.Settings) > 0){
    if(length(Java.Options.Settings) == 1){
      Gatk.FilterMutectCalls.Command <- sprintf("\"%s\" %s", System.Java.Alias, trimws(Java.Options.Settings))
    }else{
      stop("'Java.Options.Settings'应为NULL或单一的character值 ...")
    }
  }else{
    Gatk.FilterMutectCalls.Command <- sprintf("\"%s\"", System.Java.Alias)
  }
  
  # 配置Gatk.Local.Jar[指定Gatk本地jar包]
  Gatk.Local.Jar <- as.character(Gatk.Local.Jar)
  if(length(Gatk.Local.Jar) == 1 && file.exists(Gatk.Local.Jar)){
    Gatk.FilterMutectCalls.Command <- sprintf("%s -jar \"%s\" FilterMutectCalls", Gatk.FilterMutectCalls.Command, normalizePath(Gatk.Local.Jar, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Gatk.Local.Jar'应为单一且存在的文件路径 ...")
  }
  
  # 配置Genome.Refence[--reference / -R]
  Genome.Refence <- as.character(Genome.Refence)
  if(length(Genome.Refence) == 1 && file.exists(Genome.Refence)){
    Gatk.FilterMutectCalls.Command <- sprintf("%s --reference \"%s\"", Gatk.FilterMutectCalls.Command, normalizePath(Genome.Refence, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Genome.Refence'应为单一且存在的文件路径 ...")
  }
  
  # 配置Mutect2.Calling.Result[--variant / -V]
  Mutect2.Calling.Result <- as.character(Mutect2.Calling.Result)
  if(length(Mutect2.Calling.Result) == 1 && file.exists(Mutect2.Calling.Result)){
    Gatk.FilterMutectCalls.Command <- sprintf("%s --variant %s", Gatk.FilterMutectCalls.Command, normalizePath(Mutect2.Calling.Result, winslash = "/", mustWork = TRUE))
  }else{
    stop("'Mutect2.Calling.Result'应为单一且存在的文件路径 ...")
  }
  
  # 配置Orientation.Models[--orientation-bias-artifact-priors / -ob-priors]
  Orientation.Models <- as.character(Orientation.Models)
  if(length(Orientation.Models) > 0){
    Gatk.FilterMutectCalls.Command <- sprintf("%s %s", Gatk.FilterMutectCalls.Command, paste0(sprintf("--orientation-bias-artifact-priors \"%s\"", normalizePath(Orientation.Models, winslash = "/", mustWork = TRUE)), collapse = " "))
  }
  
  # 配置Contamination.Tables[--contamination-table]
  Contamination.Tables <- as.character(Contamination.Tables)
  if(length(Contamination.Tables) > 0){
    Gatk.FilterMutectCalls.Command <- sprintf("%s %s", Gatk.FilterMutectCalls.Command, paste0(sprintf("--contamination-table \"%s\"", normalizePath(Contamination.Tables, winslash = "/", mustWork = TRUE)), collapse = " "))
  }
  
  # 配置Tumor.Segmentations[--tumor-segmentation]
  Tumor.Segmentations <- as.character(Tumor.Segmentations)
  if(length(Tumor.Segmentations) > 0){
    Gatk.FilterMutectCalls.Command <- sprintf("%s %s", Gatk.FilterMutectCalls.Command, paste0(sprintf("--tumor-segmentation \"%s\"", normalizePath(Tumor.Segmentations, winslash = "/", mustWork = TRUE)), collapse = " "))
  }
  
  # 配置Other.Options.Settings[其他参数]
  Other.Options.Settings <- as.character(Other.Options.Settings)
  if(length(Other.Options.Settings) > 0){
    if(length(Other.Options.Settings) == 1){
      Gatk.FilterMutectCalls.Command <- sprintf("%s %s", Gatk.FilterMutectCalls.Command, trimws(Other.Options.Settings))
    }else{
      stop("'Other.Options.Settings'应为NULL或单一的character值 ...")
    }
  }
  
  # 配置Output.Prefix
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Gatk.FilterMutectCalls", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(Output.Prefix, winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为NULL或单一的character值 ...")
  }
  
  # 配置Filter.Output.Compressed[--output / -O]
  Output.Compressed <- as.logical(Output.Compressed)
  if(length(Output.Compressed) == 1){
    Mutect2.Filter.Output <- sprintf("%s.%s", Output.Prefix, ifelse(Output.Compressed, "vcf.gz", "vcf"))
    file.create(Mutect2.Filter.Output, showWarnings = FALSE)
    Mutect2.Filter.Output <- normalizePath(Mutect2.Filter.Output, winslash = "/", mustWork = TRUE)
    Gatk.FilterMutectCalls.Command <- sprintf("%s --output \"%s\"", Gatk.FilterMutectCalls.Command, Mutect2.Filter.Output)
  }else{
    stop("'Filter.Output.Compressed'应为单一的logical值 ...")
  }
  
  # 运行指令
  System.Command.Run(System.Command = Gatk.FilterMutectCalls.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", Mutect2.Filter.Output))
}