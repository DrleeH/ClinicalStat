### 计算ROC曲线的相关信息
## 相关参数解读
# dat: 我们需要输入我们的数据集
# group: 想要进行ROC的结局变量
# var： 需要分析的变量
# retype: 想要计算的具体信息: 默认的返回的包括：阈值，灵敏度， 特异度。可以输入“threshold”, “specificity”, “sensitivity”, “accuracy”, 
# “tn” (true negative count), “tp” (true positive count), “fn” (false negative count), 
# “fp” (false positive count), “npv” (negative predictive value), “ppv” (positive predictive value), “precision”, “recall”. “1-specificity”, “1-sensitivity”, “1-accuracy”, “1-npv” and “1-ppv”`
# auc： 是否返回曲线下面积以及95%CI，逻辑值，默认为TRUE。
# youden: 是否返回约登指数，逻辑值，默认为TURE。
# digit: 结果保留几位小数点
## 结果解读
# subgroup的结果是 case vs control

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(pROC)) install.packages("pROC")
library(tidyverse)
library(pROC)
ROCStatFunc <- function(dat, group, var,retype = c("threshold", "specificity", "sensitivity"),
                        auc = T,youden = T, digit = 3){
    subgroup <- levels(as.factor(dat[[group]]))
    subgroup1 <- paste0(subgroup[2], " vs ", subgroup[1])
    rocmodel <- roc(dat[[group]], dat[[var]])
    other <- coords(rocmodel, "b", ret = retype)
    other <- round(other, digit)
    if(auc == T){
        auc <- round(ci.auc(rocmodel),digit)
        auc <- paste0(auc[2],"(",auc[1],"-",auc[3],")")
        if(youden == T){
            abc <- coords(rocmodel, "b", ret = c("specificity", "sensitivity"))
            youdenres <- abc[1] + abc[2] - 1
            youdenres <- round(youdenres, digit)
            result <- c(group, subgroup1, auc, other, youdenres)
            names(result) <- c("group", "subgroup","auc(95%CI)", retype, "youden")
        }else{
            result <- c(group, subgroup1, auc, other)
            names(result) <- c("group", "subgroup", "auc(95%CI)", retype)
        }
    }else{
        if(youden == T){
            abc <- coords(rocmodel, "b", ret = c("specificity", "sensitivity"))
            youdenres <- abc[1] + abc[2] - 1
            youdenres <- round(youdenres, digit)
            result <- c(group, subgroup1, other, youdenres)
            names(result) <- c("group","subgroup", retype, "youden")
        }else{
            result <- c(group, subgroup1,other)
            names(result) <- c("group", "subgroup",retype)
        }
    }
    return(result)
}