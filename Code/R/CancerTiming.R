##############################函数描述##############################
# "CancerTiming"计算拷贝数改变事件("WGD"、"CNLOH"、"SingleGain"、"DoubleGain")发生的相对时间
####################################################################


##' @description 计算拷贝数改变事件("WGD"、"CNLOH"、"SingleGain"、"DoubleGain")发生的相对时间
##' @author HMU-WH
##' @param MUT.Data matrix | data.frame 包含突变信息的矩阵, 包含必要列[Sample.ID(样本标识ID), SeqName(序列名), Position(所在序列的位点), Alt.Counts(变异等位的reads数), Ref.Counts(参考等位的reads数)]
##' @param CNV.Data matrix | data.frame 包含拷贝数改变信息的矩阵, 包含必要列[Sample.ID(样本标识ID), SeqName(序列名), Position.Start(所在序列的起始位点), Position.End(所在序列的结束位点), CN.Major(主拷贝数), CN.Minor(次拷贝数)]
##' @param Samples.Purity numeric[] 一个包含以样本标识ID命名的数值向量, 包含了各样本的肿瘤纯度
##' @param Min.Mutations numeric 规定位于拷贝数变异区域上的最少突变数量(至少为2), 包含突变少于这个数目的片段将将被从分析队列中剔除
##' @param Bootstrap.Type character 设置进行Bootstrap抽样计算置信区间时采用的分析模型, 可选("parametric", "nonparametric"), 默认"parametric"
##' @param CancerTiming.WGD.Path character 文献《The evolutionary history of 2,658 cancers, nature, 2020》改进的代码路径, 默认是网络地址, 如果运行时无法访问网络可以下载到本地更换为本地地址
############' 下载地址: https://github.com/clemencyjolly/PCAWG11-Timing_and_Signatures/blob/master/cancerTiming.WGD.R
##' @return data.frame 包含列: 
############' $Sample 样本ID 
############' $pi0 拷贝数改变事件发生的相对时间(范围0到1)
############' $lCI Bootstrap抽样计算的95%下置信区间(范围0到1)
############' $uCI Bootstrap抽样计算的95%上置信区间(范围0到1)
############' $N 基因组片段上包含的突变数目(至少为Min.Mutations)
############' $type 拷贝数改变类型("WGD"、"CNLOH"、"SingleGain"、"DoubleGain")
############' $segId 基因组片段的标识ID(以"SeqName-Position.Start-Position.End"命名)
############' $rankInSample 对各样本中推断的拷贝数改变事件发生的相对时间pi0的排秩结果
CancerTiming <- function(MUT.Data, CNV.Data, Samples.Purity, 
                         Min.Mutations = 2, Bootstrap.Type = c("parametric", "nonparametric"), 
                         CancerTiming.WGD.Path = "https://raw.githubusercontent.com/clemencyjolly/PCAWG11-Timing_and_Signatures/master/cancerTiming.WGD.R"){
  library(cancerTiming)
  library(GenomicRanges)
  source(CancerTiming.WGD.Path, encoding = "UTF-8")
  # 参数判断
  MUT.Data <- as.data.frame(MUT.Data)
  CNV.Data <- as.data.frame(CNV.Data)
  Min.Mutations <- as.numeric(Min.Mutations)
  Bootstrap.Type <- match.arg(Bootstrap.Type)
  stopifnot(length(Min.Mutations) == 1 && Min.Mutations >= 2 && Min.Mutations %% 1 == 0, 
            all(c("Sample.ID", "SeqName", "Position", "Alt.Counts", "Ref.Counts") %in% colnames(MUT.Data)), 
            any(c("numeric", "integer") %in% class(Samples.Purity)) && all(Samples.Purity >=0 & Samples.Purity <= 1),
            all(c("Sample.ID", "SeqName", "Position.Start", "Position.End", "CN.Major", "CN.Minor") %in% colnames(CNV.Data)))
  # 识别MUT.Data与CNV.Data的共有样本
  Common.Samples <- intersect(intersect(MUT.Data$Sample.ID, CNV.Data$Sample.ID), names(Samples.Purity))
  if(length(Common.Samples) > 0){
    # 遍历样本构建eventTimingOverList.WGD需要的输入数据
    Input.Data <- lapply(Common.Samples, function(Sample){
      # 提取对应样本的MUT.Data与CNV.Data数据
      Sample.MUT.Data <- MUT.Data[MUT.Data$Sample.ID == Sample, ]
      Sample.CNV.Data <- CNV.Data[CNV.Data$Sample.ID == Sample, ]
      # 提取拷贝数变异类型为"WGD"、"CNLOH"、"SingleGain"、"DoubleGain"的数据
      Sample.CNV.Data$Type[Sample.CNV.Data$CN.Major == 2 & Sample.CNV.Data$CN.Minor == 2] = "WGD"
      Sample.CNV.Data$Type[Sample.CNV.Data$CN.Major == 2 & Sample.CNV.Data$CN.Minor == 0] = "CNLOH"
      Sample.CNV.Data$Type[Sample.CNV.Data$CN.Major == 2 & Sample.CNV.Data$CN.Minor == 1] = "SingleGain"
      Sample.CNV.Data$Type[Sample.CNV.Data$CN.Major == 3 & Sample.CNV.Data$CN.Minor == 1] = "DoubleGain"
      Sample.CNV.Data <- Sample.CNV.Data[Sample.CNV.Data$Type %in% c("WGD", "CNLOH", "SingleGain", "DoubleGain"), ]
      # 构建Sample.MUT.Data与Sample.CNV.Data的基因组GRanges对象
      Sample.MUT.Grangs <- GRanges(seqnames = Sample.MUT.Data$SeqName, ranges = IRanges(start = Sample.MUT.Data$Position, end = Sample.MUT.Data$Position))
      Sample.CNV.Grangs <- GRanges(seqnames = Sample.CNV.Data$SeqName, ranges = IRanges(start = Sample.CNV.Data$Position.Start, end = Sample.CNV.Data$Position.End))
      # 进行基因组区域匹配
      Match.Info <- findOverlaps(query = Sample.MUT.Grangs, subject = Sample.CNV.Grangs)
      # 根据匹配信息构造样本的输入数据
      Sample.MUT.Data <- Sample.MUT.Data[Match.Info@from, ]
      Sample.CNV.Data <- Sample.CNV.Data[Match.Info@to, ]
      Sample.Input <- data.frame(
        type = Sample.CNV.Data$Type, 
        nMutAllele = Sample.MUT.Data$Alt.Counts, 
        nReads = Sample.MUT.Data$Alt.Counts + Sample.MUT.Data$Ref.Counts, 
        mutationId = sprintf("%s-%s", Sample.MUT.Data$SeqName, Sample.MUT.Data$Position),
        segId = sprintf("%s-%s-%s", Sample.CNV.Data$SeqName, Sample.CNV.Data$Position.Start, Sample.CNV.Data$Position.End)
      )
      return(Sample.Input)
    })
    names(Input.Data) <- Common.Samples
    # 运行CancerTiming识别拷贝数变异的相对时间
    CancerTiming.Result <- eventTimingOverList.WGD(dfList = Input.Data, normCont = 1 - Samples.Purity[Common.Samples], eventArgs = list(bootstrapCI = Bootstrap.Type, minMutations = Min.Mutations))
    # 统计CancerTiming的运行结果
    CancerTiming.Summary <- na.omit(getPi0Summary(CancerTiming.Result, CI = TRUE))
    rownames(CancerTiming.Summary) <- NULL
    # 返回结果
    return(CancerTiming.Summary)
  }else{
    stop("'MUT.Data'、'CNV.Data'、'Samples.Purity'不存在共有样本 ...")
  }
}