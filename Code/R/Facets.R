##############################函数描述##############################
# “Facets.SNP.Pileup”通过R函数传参调用SNP Pileup统计各样本在SNP位点处的[参考、变异、错误、缺失]碱基的read数
# "Facets.CNV.Calling"通过Facets包从SNP Pileup结果中推断等位特异拷贝数
####################################################################


##' @description 通过R函数传参调用SNP Pileup统计各样本在SNP位点处的[参考、变异、错误、缺失]碱基的read数
##' @author HMU-WH
##' @param BAM.Set character[] BAM文件集合(各文件需提前进行coordinate排序处理)
##' @param Common.Vcf character 常见的多态SNP的VCF文件(一个很好的来源是dbSNP的common_all.vcf.gz, 需提前进行与BAM文件进行一致的coordinate排序处理)
##' @param System.Pileup.Alias character SNP Pileup软件在系统中的可执行命令名, 默认"snp-pileup"
##' @param Output.Prefix character 结果文件(csv格式)前缀[可携带路径]; 默认NULL, 即前工作目录下的"Facets.SNP-Pileup"
##' @param Sort.Operation character 设置对BAM.Set中的文件以及Common.Vcf进行排序操作的方式, 可选("Auto", "Sort", "None"); 默认"Auto"
##' @param Compress.Output logical 设置是否对对结果文件进行压缩(csv.gz格式); 默认TRUE
##' @param Show.Progress logical 设置是否显示SNP Pileup的进度条(需要先统计SNP数量, 增加程序的运行时间); 默FALSE
##' @param Skip.Anomalous logical 设置是否跳过异常的异常读取对; 默认TRUE
##' @param Check.Overlaps logical 设置是否启用读取对重叠检测; 默认TRUE
##' @param Max.Depth numeric 设置最大深度, 即每个位点在各文件中允许的最大read数; 默认4000
##' @param Pseudo.Snps numeric 设置虚拟SNP间隔, 即若每Pseudo.Snps个碱基位置上没有SNP则插入一个标记该区间总read数的空记录; 默认0
##' @param Min.Map.Quality numeric 设置比对质量的最小阈值(针对MAPQ信息); 默认0
##' @param Min.Base.Quality numeric 设置序列质量的最小阈值(针对QUAL信息); 默认0
##' @param Min.Read.Counts numeric[] 设置输出位点在各样本中最小read数(设置单个值时将应用于所有样本); 默认0
Facets.SNP.Pileup <- function(BAM.Set, Common.Vcf, System.Pileup.Alias = "snp-pileup", Output.Prefix = NULL, 
                              Compress.Output = TRUE, Show.Progress = FALSE, Skip.Anomalous = TRUE, Check.Overlaps = TRUE, 
                              Max.Depth = 4000, Pseudo.Snps = 0, Min.Map.Quality = 0, Min.Base.Quality = 0, Min.Read.Counts = 0){
  # 检查并判断System.Pileup.Alias在系统中是否存在
  System.Pileup.Alias <- as.character(System.Pileup.Alias)
  if(length(System.Pileup.Alias) == 1){
    if(nchar(Sys.which(System.Pileup.Alias)) == 0){
      stop(sprintf("非系统的可执行命令'%s' ...", System.Pileup.Alias))
    }
  }else{
    stop("'System.Pileup.Alias'应为单一的character值 ...")
  }
  
  # 文件参数的判断
  BAM.Set <- as.character(BAM.Set)
  Common.Vcf <- as.character(Common.Vcf)
  if(length(BAM.Set) >= 1){
    BAM.Set <- normalizePath(BAM.Set, winslash = "/", mustWork = TRUE)
  }else{
    stop("'BAM.Set'应为至少包含一个元素的文件集合, 且各文件应已经存在 ...")
  }
  if(length(Common.Vcf) == 1 && file.exists(Common.Vcf)){
    Common.Vcf <- normalizePath(Common.Vcf, winslash = "/", mustWork = TRUE)
  }else{
    stop("'Common.Vcf'应为单一且存在的文件路径 ...")
  }
  
  # 初始化SNP Pileup指令
  SNP.Pileup.Command <- sprintf("\"%s\"", System.Pileup.Alias)
  
  # 配置Compress.Output[--gzip / -g]
  Compress.Output <- as.logical(Compress.Output)
  if(length(Compress.Output) == 1){
    if(Compress.Output){ SNP.Pileup.Command <- sprintf("%s --gzip", SNP.Pileup.Command) } 
  }else{
    stop("'Compress.Output'应为单一的logical值 ...")
  }
  
  # 配置Show.Progress[--progress / -p]
  Show.Progress <- as.logical(Show.Progress)
  if(length(Show.Progress) == 1){
    if(Show.Progress){ SNP.Pileup.Command <- sprintf("%s --progress", SNP.Pileup.Command) } 
  }else{
    stop("'Show.Progress'应为单一的logical值 ...")
  }
  
  # 配置Skip.Anomalous[--count-orphans / -A]
  Skip.Anomalous <- as.logical(Skip.Anomalous)
  if(length(Skip.Anomalous) == 1){
    if(! Skip.Anomalous){ SNP.Pileup.Command <- sprintf("%s --count-orphans", SNP.Pileup.Command) } 
  }else{
    stop("'Skip.Anomalous'应为单一的logical值 ...")
  }
  
  # 配置Check.Overlaps[--ignore-overlap / -x]
  Check.Overlaps <- as.logical(Check.Overlaps)
  if(length(Check.Overlaps) == 1){
    if(! Check.Overlaps){ SNP.Pileup.Command <- sprintf("%s --ignore-overlap", SNP.Pileup.Command) } 
  }else{
    stop("'Check.Overlaps'应为单一的logical值 ...")
  }
  
  # 配置Max.Depth[--max-depth / -d]
  Max.Depth <- as.numeric(Max.Depth)
  if(length(Max.Depth) == 1 && Max.Depth > 0 && Max.Depth %% 1 == 0){
    SNP.Pileup.Command <- sprintf("%s --max-depth %s", SNP.Pileup.Command, Max.Depth)
  }else{
    stop("'Max.Depth'应为单一的大于0的整型numeric值 ...")
  }
  
  # 配置Pseudo.Snps[--pseudo-snps / -P]
  Pseudo.Snps <- as.numeric(Pseudo.Snps)
  if(length(Pseudo.Snps) == 1 && Pseudo.Snps >= 0 && Pseudo.Snps %% 1 == 0){
    SNP.Pileup.Command <- sprintf("%s --pseudo-snps %s", SNP.Pileup.Command, Pseudo.Snps)
  }else{
    stop("'Pseudo.Snps'应为单一的大于等于0的整型numeric值 ...")
  }
  
  # 配置Min.Map.Quality[--min-map-quality / -q]
  Min.Map.Quality <- as.numeric(Min.Map.Quality)
  if(length(Min.Map.Quality) == 1 && Min.Map.Quality >= 0 && Min.Map.Quality %% 1 == 0){
    SNP.Pileup.Command <- sprintf("%s --min-map-quality %s", SNP.Pileup.Command, Min.Map.Quality)
  }else{
    stop("'Min.Map.Quality'应为单一的大于等于0的整型numeric值 ...")
  }
  
  # 配置Min.Base.Quality[--min-base-quality / -Q]
  Min.Base.Quality <- as.numeric(Min.Base.Quality)
  if(length(Min.Base.Quality) == 1 && Min.Base.Quality >= 0 && Min.Base.Quality %% 1 == 0){
    SNP.Pileup.Command <- sprintf("%s --min-base-quality %s", SNP.Pileup.Command, Min.Base.Quality)
  }else{
    stop("'Min.Base.Quality'应为单一的大于等于0的整型numeric值 ...")
  }
  
  # 配置Min.Read.Counts[--min-read-counts / -r]
  Min.Read.Counts <- as.numeric(Min.Read.Counts)
  if(all(Min.Read.Counts >= 0) && all(Min.Read.Counts %% 1 == 0) && (length(Min.Read.Counts) == 1 || length(Min.Read.Counts) == length(BAM.Set))){
    if(length(Min.Read.Counts) == 1){
      Min.Read.Counts <- rep(Min.Read.Counts, length(BAM.Set))
    }
    SNP.Pileup.Command <- sprintf("%s --min-read-counts %s", SNP.Pileup.Command, paste0(Min.Read.Counts, collapse = ","))
  }else{
    stop("'Min.Read.Counts'应为单一大于等于0的整型numeric值或与'BAM.Set'等长的numeric向量 ...")
  }
  
  # 配置Output.Prefix
  Output.Prefix <- as.character(Output.Prefix)
  if(length(Output.Prefix) == 0){
    Output.Prefix <- sprintf("%s/Facets.SNP-Pileup", getwd())
  }else if(length(Output.Prefix) == 1){
    Output.Prefix <- normalizePath(sub(pattern = "(\\\\*/*|/*\\\\*)$", replacement = "", x = trimws(Output.Prefix)), winslash = "/", mustWork = FALSE)
    dir.create(dirname(Output.Prefix), recursive = TRUE, showWarnings = FALSE)
  }else{
    stop("'Output.Prefix'应为Null或单一的character值 ...")
  }
  unlink((SNP.Pileup.Output <- sprintf("%s.%s", Output.Prefix, ifelse(Compress.Output, "csv.gz", "csv"))), force = TRUE)
  
  # 完成最终指令的拼接
  SNP.Pileup.Command <- sprintf("%s \"%s\" \"%s.csv\" %s", SNP.Pileup.Command, Common.Vcf, Output.Prefix, paste0(sprintf("\"%s\"", BAM.Set), collapse = " "))
  
  # 运行指令
  System.Command.Run(System.Command = SNP.Pileup.Command, Success.Message = sprintf("结果已输出至文件'%s' ...", normalizePath(SNP.Pileup.Output, winslash = "/", mustWork = FALSE)))
}


##' @description 通过Facets包从SNP Pileup结果中推断等位特异拷贝数
##' @author HMU-WH
##' @param SNP.Pileup.Res character SNP Pileup的结果文件, 可通过函数Facets.SNP.Pileup(正常样本在前, 肿瘤样本在后)获得
##' @param Tumor.Normal.Matched logical 设置SNP.Pileup.Res中正常样本和肿瘤样本是否来自同一个体(影响杂合性SNP的判定); 默认TRUE
##' @param LogOR.Powerful logical 设置LogOR是否应在分段和聚类的过程中占据更多权重(增加检测杂合性SNP少的区域的等位基因失衡的能力); 默认TRUE
##' @param Show.Plot logica 设置是否绘制基因组图示(包括LogR、LogOR、CNV); 默认TRUE
##' @param Genome.Assemblies character 设置基因组版本号, 可选("hg18", "hg19", "hg38", "mm9", "mm10", "udef"); 默认"hg18"
##' @param Udef.GC.List list 设置基因组GC含量列表(当且仅当Genome.Assemblies为"udef"时生效), 其名称与它来自的序列(染色体)相对应, 数字向量给出了步长为100bp窗口大小为1000bp的GC含量; 默认NULL
##' @param Err.Thresh numeric 设置SNP位点发生错误替代的read计数阈值, SNP Pileup结果中超过该值的记录将被去除; 默认Inf
##' @param Del.Thresh numeric 设置SNP位点发生缺失的read计数阈值, SNP Pileup结果中超过该值的记录将被去除; 默认Inf
##' @param Min.Depth numeric 设置最小深度, 数据预处理时总read计数小于该值的记录将被去除; 默认35
##' @param Max.Depth numeric 设置最大深度, 数据预处理时总read计数大于该值的记录将被去除; 默认1000
##' @param SNP.Het.VAF numeric 设置SNP位点被判定为杂合位点的阈值, 正常样本VAF介于(SNP.Het.VAF, 1 - SNP.Het.VAF)之间的SNP被判定为杂合; 若Tumor.Normal.Matched为FALSE, 该值应小于等于0.1, 此时肿瘤样本VAF介于(SNP.Het.VAF, 1 - SNP.Het.VAF)之间且总read数大于等于50的SNP被判定为杂合; 默认0.25
##' @param Bin.Size numeric 设置窗口大小, 每个窗口将随机选择一个SNP位点(优先选择杂合位点)进行后续分析(基因组中的SNP不是均匀分布的, 使用所有位点将导致数据中的序列相关); 默认250
##' @param Segmentation.Critical.Value numeric[] 设置片段分割过程中断点识别的T2临界值以及后期用于断点筛选的T2临界值, 该值越小识别和筛选的断点数目越多, 即片段更多; 默认c(25, 150)
##' @param Segment.Min.Het numeric 设置分析次拷贝数时基因组片段至少应该具有的杂合性SNP位点的数量(当一个片段的杂合性SNP少于Segment.Min.Het时, 可能无法有效地估计次要拷贝数, 因此将返回NA); 默认15
##' @param EM.Max.Iter numeric 设置期望最大化算法最大的迭代次数; 默认10
##' @param EM.Con.Thresh numeric 设置在EM.Max.Iter内达到终止条件的收敛阈值; 默认0.001
##' @return list 包含肿瘤纯度[Purity]、倍性[Ploidy]、位点的估计信息[SeqName、Position、LogR、LogOR]以及片段的估计信息[SeqName、Position.Start、Position.End、LogR、LogOR.Square、CN.Total、CN.Minor、Cell.Fraction]
Facets.CNV.Calling <- function(SNP.Pileup.Res, 
                               Tumor.Normal.Matched = TRUE, LogOR.Powerful = TRUE, Show.Plot = TRUE, 
                               Genome.Assemblies = c("hg18", "hg19", "hg38", "mm9", "mm10", "udef"), Udef.GC.List = NULL, Err.Thresh = Inf, Del.Thresh = Inf, 
                               Min.Depth = 35, Max.Depth = 1000, SNP.Het.VAF = 0.25, Bin.Size = 250, Segmentation.Critical.Value = c(25, 150), Segment.Min.Het = 15, EM.Max.Iter = 10, EM.Con.Thresh = 0.001){
  library(facets)
  # 参数判断
  Bin.Size <- as.numeric(Bin.Size)
  Show.Plot <- as.logical(Show.Plot)  
  Min.Depth <- as.numeric(Min.Depth)
  Max.Depth <- as.numeric(Max.Depth)
  Err.Thresh <- as.numeric(Err.Thresh)
  Del.Thresh <- as.numeric(Del.Thresh)
  SNP.Het.VAF <- as.numeric(SNP.Het.VAF)
  EM.Max.Iter <- as.numeric(EM.Max.Iter)
  EM.Con.Thresh <- as.numeric(EM.Con.Thresh)
  LogOR.Powerful <- as.logical(LogOR.Powerful)
  SNP.Pileup.Res <- as.character(SNP.Pileup.Res)
  Segment.Min.Het <- as.numeric(Segment.Min.Het)
  Tumor.Normal.Matched <- as.logical(Tumor.Normal.Matched)
  Segmentation.Critical.Value <- as.numeric(Segmentation.Critical.Value)
  stopifnot(length(Show.Plot) == 1, 
            length(LogOR.Powerful) == 1, 
            length(EM.Con.Thresh) == 1 && EM.Con.Thresh > 0, 
            length(SNP.Pileup.Res) == 1 && file.exists(SNP.Pileup.Res), 
            length(Bin.Size) == 1 && Bin.Size >= 0 && Bin.Size %% 1 == 0, 
            length(Min.Depth) == 1 && Min.Depth >= 0 && Min.Depth %% 1 == 0, 
            length(SNP.Het.VAF) == 1 && SNP.Het.VAF >= 0 && SNP.Het.VAF < 0.5, 
            length(EM.Max.Iter) == 1 && EM.Max.Iter >= 0 && EM.Max.Iter %% 1 == 0, 
            length(Segment.Min.Het) == 1 && Segment.Min.Het > 0 && Segment.Min.Het %% 1 == 0, 
            length(Max.Depth) == 1 && (is.infinite(Max.Depth) || (Max.Depth >= 0 && Max.Depth %% 1 == 0)), 
            length(Err.Thresh) == 1 && (is.infinite(Err.Thresh) || (Err.Thresh >= 0 && Err.Thresh %% 1 == 0)), 
            length(Del.Thresh) == 1 && (is.infinite(Del.Thresh) || (Del.Thresh >= 0 && Del.Thresh %% 1 == 0)), 
            length(Tumor.Normal.Matched) == 1 && (Tumor.Normal.Matched || (!Tumor.Normal.Matched && SNP.Het.VAF <= 0.1)), 
            length(Segmentation.Critical.Value) == 2 && all(Segmentation.Critical.Value >= 0) && Segmentation.Critical.Value[2] >= Segmentation.Critical.Value[1])
  # 读取Snp Pileup生成的read矩阵, 统计每个SNP位点在正常样本和肿瘤样本中覆盖到的总read数(参考+变异)以及比对到参考基因组的read数
  SNP.Pileup.Res <- normalizePath(SNP.Pileup.Res, winslash = "/", mustWork = TRUE)
  SNP.Read.Mtr <- readSnpMatrix(SNP.Pileup.Res, err.thresh = Err.Thresh, del.thresh = Del.Thresh)
  Chrom.Is.Numeric <- grepl("^\\d*$", SNP.Read.Mtr$Chromosome)
  Mtr.Chrom.Numeric <- SNP.Read.Mtr[Chrom.Is.Numeric, ]
  Mtr.Chrom.Character <- SNP.Read.Mtr[! Chrom.Is.Numeric, ]
  SNP.Read.Mtr <- rbind(Mtr.Chrom.Numeric[order(as.numeric(Mtr.Chrom.Numeric$Chromosome)), ], Mtr.Chrom.Character[order(Mtr.Chrom.Character$Chromosome), ])
  # 数据预处理(SNP位点的杂合性判断与筛选, LogR与LogOR值的计算, SNP位点片段化)
  Mtr.Processes <- preProcSample(SNP.Read.Mtr, gbuild = match.arg(Genome.Assemblies), ugcpct = as.list(Udef.GC.List), unmatched = !Tumor.Normal.Matched, ndepth = Min.Depth, ndepthmax = Max.Depth, het.thresh = SNP.Het.VAF, snp.nbhd = Bin.Size, hetscale = LogOR.Powerful, cval = Segmentation.Critical.Value[1])
  # 为EM算法估计初始的参数值(片段重选, 片段聚类, 估计二倍体状态LogR, 估计拷贝数状态、细胞分数等参数)
  NV.Fit <- procSample(Mtr.Processes, cval = Segmentation.Critical.Value[2], min.nhet = Segment.Min.Het)
  # 基于期望最大化(EM)算法估计最终参数(纯度、倍性、拷贝数状态、细胞分数)
  EM.Fit <- emcncf(NV.Fit, min.nhet = Segment.Min.Het, maxiter = EM.Max.Iter, eps = EM.Con.Thresh)
  # 绘图
  if(Show.Plot){
    plotSample(x = NV.Fit, emfit = EM.Fit)
  }
  # 结果封装
  return(
    list(
      Purity = EM.Fit$purity,
      Ploidy = EM.Fit$ploidy,
      Point.Data = data.frame(SeqName = NV.Fit$jointseg$chrom, Position = NV.Fit$jointseg$maploc, LogR = NV.Fit$jointseg$cnlr - NV.Fit$dipLogR, LogOR = NV.Fit$jointseg$valor),
      Segment.Data = data.frame(SeqName = EM.Fit$cncf$chrom,  Position.Start = EM.Fit$cncf$start, Position.End = EM.Fit$cncf$end, LogR = EM.Fit$cncf$cnlr.median - EM.Fit$dipLogR, LogOR.Square = abs(EM.Fit$cncf$mafR), CN.Total = EM.Fit$cncf$tcn.em, CN.Minor = EM.Fit$cncf$lcn.em, Cell.Fraction = EM.Fit$cncf$cf.em)
    )
  )
}