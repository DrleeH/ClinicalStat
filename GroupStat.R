TableOneStat <- function(dat, group, var, Normal = TRUE){
    datexpr <- dat[c(var, group)]
    datexpr <- na.omit(datexpr)
    datexpr$num <- as.numeric(as.factor(datexpr[[group]]))
    len <- length(unique(datexpr[[group]])) 
    if(Normal == T){
        result <- datexpr %>% group_by(!!sym(group)) %>% 
            summarise(n = n(), mean = mean(!!sym(var), na.rm = T),
                      sd = sd(!!sym(var), na.rm = T)) %>% 
            mutate(summarise = paste0(round(mean,3), "±", round(sd,3)),
                   category = group) %>% 
            select(category,level = group, n, summarise)
        if(len == 2){
            p.val <- t.test(datexpr[[var]], datexpr[["num"]])$p.val
            result$p.val <- c(p.val, "")
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", round(p.val,3)), "")
        }else if(len >= 3){
            formu <- as.formula(paste0(var, "~", "num"))
            fit <- aov(formu, data = datexpr)
            p.val <- summary(fit)[[1]]$'Pr(>F)'[1] 
            result$p.val <- c(p.val, rep("",len -1))
            result$p <- c(ifelse(p.val < 0.001, "< 0.001", round(p.val,3)), rep("",len -1))
        }
    }else{
        result <- datexpr %>% group_by(!!sym(group)) %>% 
            summarise(n = n(), median = median(!!sym(var), na.rm = T),
                      `25%` = quantile(!!sym(var), .25,na.rm = T),
                      `75%` = quantile(!!sym(var), .75,na.rm = T)) %>% 
            mutate(summarise = paste0(round(median, 3), "(", round(`25%`, 3), "-",
                                      round(`75%`, 3), ")"), 
                   category = group) %>% 
            select(category,level = group, n, summarise)
        if(len == 2){
            p.val <- wilcox.test(datexpr[[var]], datexpr[["num"]])$p.val
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
    return(result)
}
