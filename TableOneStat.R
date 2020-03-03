### 用来进行差异分析
### 通过Normal参数来控制此否符合正态分布
### 如果符合正态分布进行两组进行T检验，三组进行方差分析
### 符合不符合正态分布分布，则进行非参
if(!require(tidyverse)) install.packages("tidyverse")
library(tidyverse)
TableOneStat <- function(dat, group, var, Normal = TRUE){
    datexpr <- dat[c(var, group)]
    datexpr <- na.omit(datexpr)
    datexpr$num <- as.factor(datexpr[[group]])
    len <- length(unique(datexpr[[group]])) 
    if(Normal == T){
        result <- datexpr %>% group_by(!!sym(group)) %>% 
            summarise(n = n(), mean = mean(!!sym(var), na.rm = T),
                      sd = sd(!!sym(var), na.rm = T)) %>% 
            mutate(summarise = paste0(round(mean,3), "±", round(sd,3)),
                   group = group) %>% 
            select(!!sym(group), n, summarise)
        if(len == 2){
            formu <- as.formula(paste0(var, "~", "num"))
            p.val <- t.test(formu, data = datexpr)$p.val
            result$p.val <- c(p.val, "")
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", round(p.val,3)), "")
        }else if(len >= 3){
            formu <- as.formula(paste0(var, "~", "num"))
            fit <- aov(formu, data = datexpr)
            p.val <- summary(fit)[[1]]$'Pr(>F)'[1] 
            result$p.val <- c(p.val, rep("",len -1))
            result
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", round(p.val,3)), rep("",len -1))
        }
    }else{
        result <- datexpr %>% group_by(!!sym(group)) %>% 
            summarise(n = n(), median = median(!!sym(var), na.rm = T),
                      `25%` = quantile(!!sym(var), .25,na.rm = T),
                      `75%` = quantile(!!sym(var), .75,na.rm = T)) %>% 
            mutate(summarise = paste0(round(median, 3), "(", round(`25%`, 3), "-",
                                      round(`75%`, 3), ")"), 
                   group = group) %>% 
            select(!!sym(group), n, summarise)
        if(len == 2){
            formu <- as.formula(paste0(var, "~", "num"))
            p.val <- wilcox.test(formu, data = datexpr)$p.val
            result$p.val <- c(p.val, "")
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", p.val), "")
        }else if(len >= 3){
            formu <- as.formula(paste0(var, "~", "num"))
            fit <- kruskal.test(formu, data = datexpr)
            p.val <- fit$p.value
            result$p.val <- c(p.val, rep("",len -1))
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", round(p.val,3)), rep("",len -1))
        }
    }
    result$var <- var
    ColNum <- ncol(result)
    result <- result[,c(ColNum, 1:(ColNum - 1))]
    return(result)
}
