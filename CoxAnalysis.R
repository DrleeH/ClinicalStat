#单因素的cox回归
library(survival)
CoxUniVar <- function(dat, status, times, var, digit = 3, Categorical = F){
    dat[[status]] <- as.factor(dat[[status]])
    subgroup <- levels(as.factor(dat[[status]]))
    subgroup1 <- paste0(subgroup[1], " vs ", subgroup[2])
    dat[[status]] <- as.numeric(dat[[status]])
    if(Categorical == T){
        dat[[var]] <- as.character(dat[[var]])
    }
    formu <- as.formula(paste0("Surv(",times,",",status,") ~", var))
    fit <- coxph(formu,data= dat)
    unisum <- summary(fit)
    HR <- exp(coef(fit))
    HR <- round(HR, digit)
    ci <- exp(confint(fit))
    ci <- round(ci, digit)
    cito <- paste0(ci[,1], "-", ci[,2])
    p <- unisum$coefficients[,"Pr(>|z|)"]
    p.val <- ifelse(p < 0.001, "< 0.001", round(p, 3))
    var1 <- names(exp(coef(fit)))
    result <- cbind(var1, status,subgroup1, HR, cito, p, p.val)
    colnames(result) <- c("var", "group", "subgroup","HR", "95%CI", "p.val", "p")
    result <- as.data.frame(result)
    return(result)
}

# 多因素cox回归
CoxMultiVar <- function(dat, status, times,var, adjvar,digit = 3, Categorical = F){
    if(length(adjvar) == 1){
        formu <- as.formula(paste0("Surv(",times,",",status,") ~", var, "+", adjvar))
    }else{
        formu <- as.formula(paste0("Surv(",times,",",status,") ~", var, "+", paste(adjvar, collapse = "+")))
    }
    dat[[status]] <- as.factor(dat[[status]])
    subgroup <- levels(as.factor(dat[[status]]))
    subgroup1 <- paste0(subgroup[1], " vs ", subgroup[2])
    dat[[status]] <- as.numeric(dat[[status]])
    if(Categorical == T){
        dat[[var]] <- as.character(dat[[var]])
        Varlenth <- length(na.omit(unique(dat[[var]]))) - 1
    }else{
        Varlenth <- 1
    }
    fit <- coxph(formu,data= dat)
    unisum <- summary(fit)
    HR <- exp(coef(fit))[1:Varlenth]
    HR <- round(HR, digit)
    ci <- exp(confint(fit))[1:Varlenth,]
    ci <- round(ci, digit)
    if(Varlenth == 1){
        cito <- paste0(ci[1], "-", ci[2])
    }else{
        cito <- paste0(ci[,1], "-", ci[,2])
    }
    p <- unisum$coefficients[1:Varlenth, "Pr(>|z|)"]
    p.val <- ifelse(p < 0.001, "< 0.001", round(p, 3))
    var1 <- names(exp(coef(fit)))[1:Varlenth]
    result <- cbind(var1, status,subgroup1, HR, cito, p, p.val)
    colnames(result) <- c("var", "group", "subgroup","HR", "95%CI", "p.val", "p")
    result <- as.data.frame(result)
    return(result)
}
