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
# VarGroup的结果是 control vs case

if(!require(tidyverse)) install.packages("tidyverse")
if(!require(pROC)) install.packages("pROC")
library(tidyverse)
library(pROC)
ROCStatFunc <- function(dat, group, var,retype = c("threshold", "specificity", "sensitivity"),
                        auc = T,youden = T, digit = 3){
    VarGroup <- levels(as.factor(dat[[group]]))
    VarGroup1 <- paste0(VarGroup[1], " vs ", VarGroup[2])
    rocmodel <- roc(dat[[group]], dat[[var]])
    other <- coords(rocmodel, "b", ret = retype, transpose = FALSE)
    other <- round(other, digit)
    if(auc == T){
        auc <- round(ci.auc(rocmodel),digit)
        auc <- paste0(auc[2],"(",auc[1],"-",auc[3],")")
        if(youden == T){
            abc <- coords(rocmodel, "b", ret = c("specificity", "sensitivity"), transpose = FALSE)
            youdenres <- abc[1] + abc[2] - 1
            youdenres <- round(youdenres, digit)
            result <- cbind(group, VarGroup1, auc, other, youdenres)
            names(result) <- c("group", "VarGroup","auc(95%CI)", retype, "youden")
        }else{
            result <- cbind(group, VarGroup1, auc, other)
            names(result) <- c("group", "VarGroup", "auc(95%CI)", retype)
        }
    }else{
        if(youden == T){
            abc <- coords(rocmodel, "b", ret = c("specificity", "sensitivity"), transpose = FALSE)
            youdenres <- abc[1] + abc[2] - 1
            youdenres <- round(youdenres, digit)
            result <- cbind(group, VarGroup1, other, youdenres)
            names(result) <- c("group","VarGroup", retype, "youden")
        }else{
            result <- cbind(group, VarGroup1,other)
            names(result) <- c("group", "VarGroup",retype)
        }
    }
    return(result)
}

ROCSubStatFunc <- function(dat, group, subgroup = NULL,var,retype = c("threshold", "specificity", "sensitivity"),
                           auc = T,youden = T, digit = 3){
    if(is.null(subgroup)){
        ROCStatFunc(dat = dat, group = group, var = var, retype = retype, 
                    auc = auc, youden = youden, digit = digit)
    }else{
        ROCAll <- ROCStatFunc(dat = dat, group = group, var = var, retype = retype, 
                              auc = auc, youden = youden, digit = digit)
        ROCAll$subgroup <- subgroup
        ROCAll1 <- ROCAll[,c(ncol(ROCAll), 1:(ncol(ROCAll)-1))]
        SubUniq <- unique(dat[[subgroup]])
        resultROC <- sapply(SubUniq, function(x){
            SubGroupName <- paste0(subgroup, ": ", x)
            dat1 <- dat[dat[[subgroup]] == x,]
            result <- ROCStatFunc(dat = dat1, group = group, var = var, retype = retype, 
                                 auc = auc, youden = youden, digit = digit)
            result$subgroup <- SubGroupName
            return(result)
        })
        result1 <- t(resultROC)
        result1 <- result1[,c(ncol(result1), 1:(ncol(result1)-1))] 
        result2 <- rbind(ROCAll1, result1)
        result3 <- sapply(result2, unlist) # V4 修复了数据框里面是列表的bug
        return(result3)
    }
}

