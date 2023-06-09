##############################函数描述##############################
# "DE.Limma"通过limma包进行差异表达分析
# "DE.EdgeR"通过edgeR包进行差异表达分析
# "DE.DESeq2" 通过DESeq2包进行差异表达分析
####################################################################


##' @description 通过limma进行差异表达分析
##' @author HMU-WH
##' @param Data matrix | data.frame 表达谱数据(行为基因列为样本, 对于一代测序数据, 应该是经过log2转化处理后的数据; 对于二代测序数据, 应该是未经log2转化处理的数据)
##' @param Is.Case logical[] 标志表达谱各样本是否为case样本, 要与表达普样本顺序一一对应
##' @param Is.Voom logical 是否对表达谱数据进行voom标化处理, 当应用于二代测序数据(建议: Counts或TPM数据)时需要设置为TRUE; 默认FALSE 
##' @param Voom.Plot logical 是否显示voom标化结果图, 当且仅当Is.Voom = TRUE时生效; 默认FALSE
##' @param Adj.Method character 差异表达分析p值校正方法, 可从"p.adjust.methods"中选择; 默认"holm"
##' @return data.frame limma差异表达分析的结果, 包含"logFC"、"P.Value"、"adj.P.Val"等信息
DE.Limma <- function(Data, Is.Case, Is.Voom = FALSE, Voom.Plot = FALSE, Adj.Method = p.adjust.methods){
  library(limma)
  # 参数处理
  Data <- as.data.frame(Data)
  Is.Case <- as.logical(Is.Case)
  Is.Voom <- as.logical(Is.Voom)
  Voom.Plot <- as.logical(Voom.Plot)
  Adj.Method <- match.arg(Adj.Method)
  stopifnot(ncol(Data) == length(Is.Case), length(Is.Voom) == 1 && length(Voom.Plot) == 1)
  # 将表达矩阵设置为case样本在前control样本在后
  Data <- cbind(Data[,Is.Case],Data[,!Is.Case])
  # 设置分组信息
  Condition <- factor(rep(c('case', 'control'), c(sum(Is.Case),sum(!Is.Case))), levels = c('case', 'control'))
  # 生成样本矩阵
  Design <- model.matrix(~0 + Condition)
  colnames(Design) <- levels(Condition)
  rownames(Design) <- colnames(Data)
  if(Is.Voom){
    # 使用voom对数据进行标化
    Data <- voom(Data, Design, plot = Voom.Plot)
  }
  # 为每个基因拟合线性模型
  Fit <- lmFit(Data, Design)
  # 定义对比关系: 后续将计算标记为1的组(前者case)相对于-1的组(后者control), 基因表达值的上调/下调状态
  Contrast <- makeContrasts('case-control', levels = Design)
  # 为线性模型添加对比关系
  Fit <- contrasts.fit(Fit, Contrast)
  # 使用经验贝叶斯模型拟合标准误差,计算差异表达的概率
  Fit <- eBayes(Fit)
  # p值校正、提取差异分析结果
  Limma.Result <- topTable(Fit, number = Inf, adjust.method = Adj.Method, sort.by = "none")
  # 返回结果
  return(Limma.Result)
}


##' @description 通过edgeR进行差异表达分析
##' @author HMU-WH
##' @param Data matrix | data.frame 未经过任何处理的Count表达谱数据(行为基因列为样本)
##' @param Is.Case logical[] 标志表达谱各样本是否为case样本, 要与表达普样本顺序一一对应
##' @param Normalize.Method character 计算归一化因子时所使用的归一化方法, 可选("TMM", "TMMwsp", "RLE", "upperquartile", "none");  默认"TMM"
##' @param Adj.Method character 差异表达分析p值校正方法, 可从"p.adjust.methods"中选择; 默认"holm"
##' @return data.frame edgeR差异表达分析的结果, 包含"logFC"、"PValue"、"FDR"等信息
DE.EdgeR <- function(Data, Is.Case, Normalize.Method=c("TMM", "TMMwsp", "RLE", "upperquartile", "none"), Adj.Method = p.adjust.methods){
  library(edgeR)
  # 参数处理
  Data <- as.data.frame(Data)
  Is.Case <- as.logical(Is.Case)
  Adj.Method <- match.arg(Adj.Method)
  Normalize.Method <- match.arg(Normalize.Method)
  stopifnot(ncol(Data) == length(Is.Case))
  # 将表达矩阵设置为case样本在前control样本在后
  Data <- cbind(Data[,Is.Case],Data[,!Is.Case])
  # 设置分组信息
  Condition <- factor(rep(c('case', 'control'), c(sum(Is.Case),sum(!Is.Case))), levels = c('case', 'control'))
  # 生成样本矩阵
  Design <- model.matrix(~0 + Condition)
  colnames(Design) <- levels(Condition)
  rownames(Design) <- colnames(Data)
  # 构建DGEList对象
  DGEList <- DGEList(counts = Data, group = Condition)
  # 计算标化因子
  DGEList <- calcNormFactors(DGEList, method = Normalize.Method)
  # 估计离散值
  DGEList <- estimateDisp(DGEList, Design)
  # 拟合拟似然性负二项式广义对数线性模型
  Fit <- glmQLFit(DGEList, Design)
  # 定义对比关系: 后续将计算标记为 1 的组(前者case)相对于 -1 的组（后者control）, 基因表达值的上调/下调状态
  Contrast <- makeContrasts(case-control, levels=Design)
  # 为模型添加对比关系, 并进经验贝叶斯拟似然F检验
  Fit <- glmQLFTest(Fit, contrast = Contrast)
  # p值校正、提取差异分析结果
  EdgeR.Result <- as.data.frame(topTags(Fit, n = Inf, adjust.method = Adj.Method, sort.by = "none"))
  # 返回结果
  return(EdgeR.Result)
}


##' @description 通过DESeq2包进行差异表达分析
##' @author HMU-WH
##' @param Data matrix | data.frame 未经过任何处理的Count表达谱数据(行为基因列为样本)
##' @param Is.Case logical[] 标志表达谱各样本是否为case样本, 要与表达普样本顺序一一对应
##' @param Adj.Method character 差异表达分析p值校正方法, 可从"p.adjust.methods"中选择; 默认"holm"
##' @return data.frame DESeq2差异表达分析的结果包含"log2FoldChange"、"pvalue"、"padj"等信息
DE.DESeq <- function(Data, Is.Case, Adj.Method = p.adjust.methods){
  library(DESeq2)
  # 参数处理
  Data <- as.data.frame(Data)
  Is.Case <- as.logical(Is.Case)
  Adj.Method <- match.arg(Adj.Method)
  stopifnot(ncol(Data) == length(Is.Case))
  # 将表达矩阵设置为case样本在前control样本在后
  Data <- cbind(Data[,Is.Case],Data[,!Is.Case])
  # 设置分组信息
  Condition <- relevel(factor(rep(c("case", "control"), c(sum(Is.Case),sum(!Is.Case)))), ref = "control")
  # 构建DESeq数据对象
  DESeq.DataSet <- DESeqDataSetFromMatrix(countData = Data, colData = DataFrame(Condition), design = ~ Condition)
  # 进行DESeq分析
  DESeq.DataSet <- DESeq(DESeq.DataSet)
  # 提取DESeq分析结果(参数contrast用于规定fold change的计算方式为"case"/"control")
  DESeq.Result <- data.frame(results(DESeq.DataSet, contrast = c("Condition", "case", "control"), pAdjustMethod = Adj.Method))
  # 返回结果
  return(DESeq.Result)
}