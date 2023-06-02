##############################函数描述##############################
# "PhyloWGS.Run"运行PhyloWGS推断系统发生树
####################################################################


##' @description 运行PhyloWGS推断系统发生树
##' @author HMU-WH
##' @param SSM.File character 运行PhyloWGS的SSM输入文件
##' @param Output.Dir character PhyloWGS运行结果的输出路径
##' @param PhyloWGS.Dir character PhyloWGS在系统中的安装路径
##' @param System.Python2.Alias character Python2在系统中的可执行命令, 默认"python"
##' @param CNV.File character 运行PhyloWGS的CNV输入文件
##' @param Sign.Name character 数据集的标志性名称, 建议使用患者ID
##' @param MCMC.Chain.Num numeric 运行PhyloWGS使用的MCMC链数, 默认5
##' @param Seed.Set numeric[] 为每条MCMC链指定随机种子的集合, 默认c(1:5)
##' @param MCMC.Samples numeric MCMC过程要忽略的初始采样数, 默认1000
##' @param Burnin.Samples numeric MCMC过程要保留的初始采样数, 默认2500
##' @param MH.Iterations numeric MCMC过程中Metropolis-Hastings(MH)采样算法的最大迭代次数, 默认5000
##' @param Min.SSMS numeric 提取结果是要求每个克隆中至少包含的SSM数量, 若该值小于1, 则为占总SSM数量的比例, 若该值为大于等于1的整数, 则为具体数目
##' @param Keep.Superclone logical 是否保留超级亚克隆(对于非多主树的祖先克隆, 当其仅有一个子克隆时, 若该子克隆种的SSM数量大于等于祖先克隆种SSM数量的3倍, 则将该子克隆定义为超级亚克隆), 默认FALSE
########' 若祖先克隆与超级亚克隆在样本种的平均CCF差值小于等于0.1, 则考虑将超级亚克隆与祖先克隆进行合并为新的祖先克隆
##' @param Include.Multiprimary logical 是否允许结果中包含多起源树, 即从Normal节点开始产生多个克隆, 默认FALSE
##' @param Max.Mltiprimary numeric 允许多主树存在最大比例, 当且仅当"Include.Multiprimary"为False时生效, 若多主树存在的比例小于该值，将会从结果中移除多主树; 若多主树存在的比例大于等于该值, 程序会抛出异常, 默认0.8
PhyloWGS.Run <- function(SSM.File, 
                         Output.Dir, 
                         PhyloWGS.Dir, 
                         System.Python2.Alias = "python", 
                         CNV.File = NULL, Sign.Name = NULL, 
                         MCMC.Chain.Num = 5, Seed.Set = 1:5, 
                         MCMC.Samples = 2500, Burnin.Samples = 1000, MH.Iterations = 5000, 
                         Min.SSMS = 0.01, Keep.Superclone = FALSE, Include.Multiprimary = FALSE, Max.Mltiprimary = 0.8){
  # 参数判断
  Min.SSMS <- as.numeric(Min.SSMS)
  Seed.Set <- as.numeric(Seed.Set)
  SSM.File <- as.character(SSM.File)
  CNV.File <- as.character(CNV.File)
  Sign.Name <- as.character(Sign.Name)
  Output.Dir <- as.character(Output.Dir)
  MCMC.Samples <- as.numeric(MCMC.Samples)
  MH.Iterations <- as.numeric(MH.Iterations)
  PhyloWGS.Dir <- as.character(PhyloWGS.Dir)
  Burnin.Samples <- as.numeric(Burnin.Samples)
  MCMC.Chain.Num <- as.numeric(MCMC.Chain.Num)
  Max.Mltiprimary <- as.numeric(Max.Mltiprimary)
  Keep.Superclone <- as.logical(Keep.Superclone)
  Include.Multiprimary <- as.logical(Include.Multiprimary)
  System.Python2.Alias <- as.character(System.Python2.Alias)
  stopifnot(
    length(Include.Multiprimary) == 1, 
    length(SSM.File) == 1 && file.exists(SSM.File), 
    length(Sign.Name) == 0 || length(Sign.Name) == 1, 
    length(PhyloWGS.Dir) == 1 && dir.exists(PhyloWGS.Dir), 
    length(MCMC.Samples) == 1 && MCMC.Samples > 0 && MCMC.Samples %% 1 == 0, 
    length(CNV.File) == 0 || (length(CNV.File) == 1 && file.exists(CNV.File)), 
    length(MH.Iterations) == 1 && MH.Iterations > 0 && MH.Iterations %% 1 == 0, 
    length(Max.Mltiprimary) == 1 && Max.Mltiprimary >= 0 && Max.Mltiprimary <= 1, 
    length(MCMC.Chain.Num) == 1 && MCMC.Chain.Num > 0 && MCMC.Chain.Num %% 1 == 0, 
    length(Burnin.Samples) == 1 && Burnin.Samples >= 0 && Burnin.Samples %% 1 == 0, 
    length(System.Python2.Alias) == 1 && nchar(Sys.which(System.Python2.Alias)) > 0, 
    length(Seed.Set) == MCMC.Chain.Num && all(Seed.Set > 0) && all(Seed.Set %% 1 == 0), 
    length(Min.SSMS) == 1 && ((Min.SSMS > 0 && Min.SSMS < 1) || (Min.SSMS >= 1 && Min.SSMS %% 1 == 0))
  )
  if(length(CNV.File) == 0){
    CNV.File <- sprintf("%s/cnv_data.txt", dirname(SSM.File))
    file.create(CNV.File)
    on.exit(unlink(CNV.File, force = TRUE))
  }
  if(length(Sign.Name) == 0){
    Sign.Name <- "Sign.Name.NA"
  }
  # 运行PhyloWGS
  System.Command.Run(System.Command = sprintf("\"%s\" \"%s/multievolve.py\" --num-chains %s --random-seeds %s --mcmc-samples %s --burnin-samples %s --mh-iterations %s --ssms \"%s\" --cnvs \"%s\" --output-dir \"%s/Multievolve\"", 
                                              System.Python2.Alias, normalizePath(PhyloWGS.Dir, winslash = "/"), MCMC.Chain.Num, paste0(Seed.Set, collapse = " "), MCMC.Samples, Burnin.Samples, MH.Iterations, normalizePath(SSM.File, winslash = "/"), normalizePath(CNV.File, winslash = "/"), normalizePath(Output.Dir, winslash = "/")))
  # 提取运行结果
  System.Command.Run(System.Command = sprintf("\"%s\" \"%s/write_results.py\" --min-ssms %s%s%s \"%s\" \"%s/Multievolve/trees.zip\" \"%s/summ.json.gz\" \"%s/muts.json.gz\" \"%s/mutass.zip\"", 
                                              System.Python2.Alias, normalizePath(PhyloWGS.Dir, winslash = "/"), Min.SSMS, ifelse(Keep.Superclone, " --keep-superclones", ""), ifelse(Include.Multiprimary, " --include-multiprimary", sprintf(" --max-multiprimary %s", Max.Mltiprimary)), Sign.Name, normalizePath(Output.Dir, winslash = "/"), normalizePath(Output.Dir, winslash = "/"), normalizePath(Output.Dir, winslash = "/"), normalizePath(Output.Dir, winslash = "/")))
}