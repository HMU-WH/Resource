##############################函数描述##############################
# "System.Command.Run"通过R执行给定的系统终端命令
####################################################################


##' @description 通过R执行给定的系统终端命令
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