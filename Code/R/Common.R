##############################函数描述##############################
# "System.Command.Run"执行系统终端命令
# "Get.GEO.Sample.Info"从GEO提供的Series Matrix文件获取样本相关信息
####################################################################


##' @description 执行系统终端命令
##' @author Xteam.Wh
##' @param System.Command character 设置要执行的终端命令
##' @param Success.Message character 设置终端命令成功运行后给出的提示信息; 默认""
System.Command.Run <- function(System.Command, Success.Message = ""){
  # 参数判断
  System.Command <- as.character(System.Command)
  Success.Message <- as.character(Success.Message)
  stopifnot(length(System.Command) == 1, length(Success.Message) == 1)
  # 根据操作系统环境设置脚本文件
  Command.Script.File <- normalizePath(tempfile(tmpdir = getwd(), pattern = "Command.Script[", fileext = sprintf("].%s", ifelse(Sys.info()["sysname"] == "Windows", "bat", "sh"))), winslash = "/", mustWork = FALSE)
  # 将指令写入对应系统的脚本文件
  write(sprintf(ifelse(Sys.info()["sysname"] == "Windows", "@echo off\n%s", "#!/bin/sh\n%s"),  System.Command), Command.Script.File)
  # 赋予脚本文件读写以及可执行权限
  Sys.chmod(Command.Script.File)
  # 执行脚本
  tryCatch(
    expr = {
      message(sprintf("【%s】正在执行终端命令 ...\n*-*-*-*-*-*\n%s\n*-*-*-*-*-*", Sys.time(), System.Command))
      Command.Run.Status <- system(sprintf("\"%s\"", Command.Script.File))
    },
    error = function(Error.Message){
      stop(Error.Message, call. = FALSE)
    },
    warning = function(Warning.Message){
      warning(Warning.Message, call. = FALSE)
    },
    finally = {
      # 删除脚本文件
      unlink(Command.Script.File, force = TRUE)
      if(exists("Command.Run.Status") && Command.Run.Status == 0){
        message(sprintf("【%s】当前终端命令执行成功 ...", Sys.time()))
        if(nchar(Success.Message) > 0){ message(sprintf("Tip: %s", Success.Message)) }
      }else{
        stop("当前终端命令执行失败 ...", call. = FALSE)
      }
    }
  )
}


##' @description 从GEO提供的Series Matrix文件获取样本相关信息
##' @author Xteam.Wh
##' @param Series.Path character GEO提供的Series Matrix文件路径
##' @return data.frame 包含样本相关信息
Get.GEO.Sample.Info <- function(Series.Path){
  # 参数判断
  Series.Path <- as.character(Series.Path)
  stopifnot(length(Series.Path) == 1 && file.exists(Series.Path))
  # 读取GEO提供的Series Matrix文件, 并从中获取样本相关信息
  GEO.Series.Info <- readLines(con = Series.Path)
  GEO.Sample.Info <- GEO.Series.Info[grepl("^!Sample", GEO.Series.Info)]
  # 每种样本信息单独获取信可作为标识的息名称和信息内容
  GEO.Sample.Info <- lapply(GEO.Sample.Info, function(Info){
    Info <- unlist(strsplit(Info,"\t"))
    Name <- gsub("^!", "", Info[1])
    Value <- gsub("\"", "", Info[-1])
    Value[Value %in% c("", "NA")] <- NA
    if(all(grepl(": ", Value[! is.na(Value)]))){
      Value.Prefix <- unique(gsub(": .*$", "", Value))
      if(length(Value.Prefix) == 1){
        Name <- Value.Prefix
        Value <- gsub("^.*: ", "", Value)
      }
    }
    return(list(Name = Name, Value = Value))
  })
  # 获取信息名称, 并对重复出现的信息名称进行编号
  GEO.Sample.Info.Name <- sapply(GEO.Sample.Info, function(Info){ return(Info$Name) })
  GEO.Sample.Info.Repeat.Name <- unique(GEO.Sample.Info.Name[duplicated(GEO.Sample.Info.Name)])
  for (Name in GEO.Sample.Info.Repeat.Name) {
    Repeat.Index <- which(GEO.Sample.Info.Name %in% Name)
    GEO.Sample.Info.Name[Repeat.Index] <- sprintf("%s_%s", Name, 1:length(Repeat.Index))
  }
  # 将处理后的数据封装成deta.frame格式作为最终结果
  GEO.Sample.Info <- as.data.frame(sapply(GEO.Sample.Info, function(Info){ return(Info$Value) }))
  colnames(GEO.Sample.Info) <- GEO.Sample.Info.Name
  # 返回结果
  return(GEO.Sample.Info)
}