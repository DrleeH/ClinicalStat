#单因素的logit回归
logitUniVar <- function(dat, group, var, digit = 3, Categorical = F){
    formu <- as.formula(paste0(group, " ~ ", var))
    dat[[group]] <- as.factor(dat[[group]])
    subgroup <- levels(as.factor(dat[[group]]))
    subgroup1 <- paste0(subgroup[1], " vs ", subgroup[2])
    if(Categorical == T){
        dat[[var]] <- as.character(dat[[var]])
        Varlenth <- length(na.omit(unique(dat[[var]])))
    }else{
        Varlenth <- 2
    }
    fit <- glm(formu, data = dat, family = binomial())
    unisum <- summary(fit)
    OR <- exp(coef(fit))[2:Varlenth]
    OR <- round(OR, digit)
    ci <- exp(confint(fit))[2:Varlenth,]
    ci <- round(ci, digit)
    if(Varlenth == 2){
        cito <- paste0(ci[1], "-", ci[2])
    }else{
        cito <- paste0(ci[,1], "-", ci[,2])
    }
    p <- unisum$coefficients[,"Pr(>|z|)"][2:Varlenth]
    p.val <- ifelse(p < 0.001, "< 0.001", round(p, 3))
    var1 <- names(exp(coef(fit)))[2:Varlenth]
    result <- cbind(var1, group,subgroup1, OR, cito, p, p.val)
    colnames(result) <- c("var", "group","subgroup", "OR", "95%CI", "p.val", "p")
    result <- as.data.frame(result)
    return(result)
}
# 多因素logit回归
logitMultiVar <- function(dat, group, var, adjvar,digit = 3, Categorical = F){
    if(length(adjvar) == 1){
        formu <- as.formula(paste0(group, " ~ ", var, "+", adjvar))
    }else{
        formu <- as.formula(paste0(group, " ~ ", var, "+", paste(adjvar, collapse = "+")))
    }
    dat[[group]] <- as.factor(dat[[group]])
    subgroup <- levels(as.factor(dat[[group]]))
    subgroup1 <- paste0(subgroup[1], " vs ", subgroup[2])
    if(Categorical == T){
        dat[[var]] <- as.character(dat[[var]])
        Varlenth <- length(na.omit(unique(dat[[var]])))
    }else{
        Varlenth <- 2
    }
    fit <- glm(formu, data = dat, family = binomial())
    unisum <- summary(fit)
    OR <- exp(coef(fit))[2:Varlenth]
    OR <- round(OR, digit)
    ci <- exp(confint(fit))[2:Varlenth,]
    ci <- round(ci, digit)
    if(Varlenth == 2){
        cito <- paste0(ci[1], "-", ci[2])
    }else{
        cito <- paste0(ci[,1], "-", ci[,2])
    }
    p <- unisum$coefficients[,"Pr(>|z|)"][2:Varlenth]
    p.val <- ifelse(p < 0.001, "< 0.001", round(p, 3))
    var1 <- names(exp(coef(fit)))[2:Varlenth]
    result <- cbind(var1, group,subgroup1, OR, cito, p, p.val)
    colnames(result) <- c("var", "group","subgroup", "OR", "95%CI", "p.val", "p")
    result <- as.data.frame(result)
    return(result)
}
