##############################函数描述##############################
# "Get.GEO.Sample.Info"从GEO提供的Series Matrix文件获取样本相关信息
####################################################################


##' @description 从GEO提供的Series Matrix文件获取样本相关信息
##' @author HMU-WH
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
    Value.Is.NA <- is.na(Value)
    if(all(grepl(": ", Value[!Value.Is.NA]))){
      Value.Prefix <- unique(gsub(": .*$", "", Value[!Value.Is.NA]))
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