### 改脚本提供了三个绘制ROC曲线的函数
### 加载相关的包
if(!require(tidyverse)) install.packages("tidyverse")
if(!require(pROC)) install.packages("pROC")
library(tidyverse)
library(pROC)
### 绘制同一变量不同亚组单独绘图
SubGroupRocPlot <- function(dat, subgroup = NULL, var, group, smooth = T, 
                            col = "firebrick1"){
    if(is.null(subgroup)){
        pdf(paste0(var,"_ROC.pdf"),height=6,width=6)
        x <- plot.roc(dat[[group]],dat[[var]],ylim=c(0,1),xlim=c(1,0),
                      smooth= smooth, #绘制平滑曲线
                      ci=TRUE, 
                      main="",
                      #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大
                      col=col,#线的颜色
                      lwd=2, #线的粗细
                      legacy.axes=T)
        legend.name <- paste(var,"AUC",round(as.numeric(x$auc),3),sep=" ")
        legend("bottomright", 
               legend=legend.name,
               col = col,
               lwd = 2,
               bty="n")
        dev.off()
    }else{
    subgroupVar <- unique(dat[[subgroup]])
    for(i in subgroupVar){
    dat1 <- dat[dat[[subgroup]] %in% i,]
    pdf(paste0(subgroup,":", i ,"ROC.pdf"),height=6,width=6)
    x <- plot.roc(dat1[[group]],dat1[[var]],ylim=c(0,1),xlim=c(1,0),
                  smooth= smooth, #绘制平滑曲线
                  ci=TRUE, 
                  main="",
                  #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大
                  col=col,#线的颜色
                  lwd=2, #线的粗细
                  legacy.axes=T)
    legend.name <- paste(var, "in",subgroup,"(" ,i,") AUC",round(as.numeric(x$auc),3),sep=" ")
    legend("bottomright", 
           legend=legend.name,
           col = col,
           lwd = 2,
           bty="n")
    dev.off()
    }
    }
}
### 绘制同一变量不同亚组所有ROC曲线绘制到一张图上
mycol <- c("slateblue", "seagreen3", "dodgerblue", "firebrick1", "lightgoldenrod", 
           "magenta", "orange2")
SubGroupRocAllPlot <- function(dat, subgroup, var, group, smooth = F, ALL = FALSE,
                               mycol = mycol){
    subgroupVar <- unique(dat[[subgroup]])
    dat1 <- dat[dat[[subgroup]] %in% subgroupVar[1],]
    pdf(paste0(subgroup,"ROC.pdf"),height=6,width=6)
    auc.out <- c()
    x <- plot.roc(dat1[[group]],dat1[[var]],ylim=c(0,1),xlim=c(1,0),
                  smooth= smooth, #绘制平滑曲线
                  ci=TRUE, 
                  main="",
                  #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大
                  col=mycol[1],#线的颜色
                  lwd=2, #线的粗细
                  legacy.axes=T)#采用大多数paper的画法，横坐标是“1-specificity”，从0到1
    auc.ci <- c(subgroupVar[1],round(as.numeric(x$auc),3))
    auc.out <- rbind(auc.out,auc.ci)
    for (i in 2:length(subgroupVar)){
        dat2 <- dat[dat[[subgroup]] %in% subgroupVar[i],]
        x <- plot.roc(dat2[[group]],dat2[[var]],
                      add=T, #向前面画的图里添加
                      smooth=smooth,
                      ci=TRUE,
                      col=mycol[i],
                      lwd=2,
                      legacy.axes=T)
        auc.ci <- c(subgroupVar[i],round(as.numeric(x$auc),3))
        auc.out <- rbind(auc.out,auc.ci)
    }
    auc.out <- as.data.frame(auc.out)
    colnames(auc.out) <- c("Name","AUC")
    legend.name <- paste(var, "in", subgroup,"(",subgroupVar,") AUC",auc.out$AUC,sep=" ")
    # legend("bottomright", 
    #        legend=legend.name,
    #        col = mycol[1:length(subgroupVar)],
    #        lwd = 2,
    #        bty="n")
    if(ALL){
        x <- plot.roc(dat[[group]],dat[[var]],
                      add=T, #向前面画的图里添加
                      smooth=smooth,
                      ci=TRUE,
                      col=mycol[length(subgroupVar) + 1],
                      lwd=2,
                      legacy.axes=T)
        legend.nameALL <- paste(var, "AUC",round(as.numeric(x$auc),3),sep=" ")
        legend.name <- c(legend.name, legend.nameALL)
    }
    legend("bottomright", 
           legend=legend.name,
           col = mycol[1:(length(subgroupVar) + 1)],
           lwd = 2,
           bty="n")
    dev.off()
}

### 绘制不同变量在的所有ROC曲线在一张图上
MultiVarROCAllPlot <- function(dat, var, group, smooth = F, 
                               mycol = mycol){
    if(length(var) > 1){
    pdf(paste0("MultiVarROC.pdf"),height=6,width=6)
    auc.out <- c()
    x <- plot.roc(dat[[group]],dat[[var[1]]],ylim=c(0,1),xlim=c(1,0),
                  smooth= smooth, #绘制平滑曲线
                  ci=TRUE, 
                  main="",
                  #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大
                  col=mycol[1],#线的颜色
                  lwd=2, #线的粗细
                  legacy.axes=T)#采用大多数paper的画法，横坐标是“1-specificity”，从0到1
    auc.ci <- c(var[1],round(as.numeric(x$auc),3))
    auc.out <- rbind(auc.out,auc.ci)
    for (i in 2:length(var)){
        x <- plot.roc(dat[[group]],dat[[var[i]]],
                      add=T, #向前面画的图里添加
                      smooth=smooth,
                      ci=TRUE,
                      col=mycol[i],
                      lwd=2,
                      legacy.axes=T)
        auc.ci <- c(var[i],round(as.numeric(x$auc),3))
        auc.out <- rbind(auc.out,auc.ci)
    }
    auc.out <- as.data.frame(auc.out)
    colnames(auc.out) <- c("Name","AUC")
    legend.name <- paste(var, "AUC",auc.out$AUC,sep=" ")
    legend("bottomright", 
           legend=legend.name,
           col = mycol[1:length(var)],
           lwd = 2,
           bty="n")
    dev.off()
    }
    if(length(group) > 1){
        pdf(paste0("MultiGroupROC.pdf"),height=6,width=6)
        auc.out <- c()
        x <- plot.roc(dat[[group[1]]],dat[[var]],ylim=c(0,1),xlim=c(1,0),
                      smooth= smooth, #绘制平滑曲线
                      ci=TRUE, 
                      main="",
                      #print.thres="best", #把阈值写在图上，其sensitivity+ specificity之和最大
                      col=mycol[1],#线的颜色
                      lwd=2, #线的粗细
                      legacy.axes=T)#采用大多数paper的画法，横坐标是“1-specificity”，从0到1
        auc.ci <- c(group[1],round(as.numeric(x$auc),3))
        auc.out <- rbind(auc.out,auc.ci)
        for (i in 2:length(group)){
            x <- plot.roc(dat[[group[i]]],dat[[var]],
                          add=T, #向前面画的图里添加
                          smooth=smooth,
                          ci=TRUE,
                          col=mycol[i],
                          lwd=2,
                          legacy.axes=T)
            auc.ci <- c(group[i],round(as.numeric(x$auc),3))
            auc.out <- rbind(auc.out,auc.ci)
        }
        auc.out <- as.data.frame(auc.out)
        colnames(auc.out) <- c("Name","AUC")
        legend.name <- paste(var, "for", group,"AUC",auc.out$AUC,sep=" ")
        legend("bottomright", 
               legend=legend.name,
               col = mycol[1:length(group)],
               lwd = 2,
               bty="n")
        dev.off()
    }
}
