> This is a series functions to do the basic clinical analysis. All of the functions were writted by R. 

# TableOneStat

compared the differences between two groups or more groups. When the group is **two**, `t-test` is used to analyze the data. When the group is **more than two**, `ANOVA `is used. When the distribution is **normal**, the test is above. Otherwise, `wilcox` test and `kruskal` test is used for two or more group respectively.

## Import 

>TableOneStat(dat, group, var, Normal = TRUE)

Four parameters need to import.

- dat: the datasets we need to analysis
- group: group varable, it can be string type 
- var: the continuous variable
- Normal: whether the data is nomral distribution. 

## Export

The result contains six columns.

- Category: the group name
- level: Specific groups within the group
- n: sample number
- summarise: When the distribution is normal, `mean±sd` is exported. otherwise,  `median(25%var-75%var)` is exported.
- p.val: Specific p-value
- p: if the p.val is less than 0.001, it return `< 0.001`, else the return the specific p value with three decimal places.

![image-20191110190433607](https://tva1.sinaimg.cn/large/0082zybply1gc0dbba0yej30am03r0su.jpg)

# ROCInfoStat:

get the ROC analysis result. this function can also get the subgroup ROC result

## Import 

> ROCSubStatFunc(dat, group, subgroup = NULL,var,retype = c("threshold", "specificity", "sensitivity"),
>                            auc = T,youden = T, digit = 3)

- dat: the datasets we need to analysis
- group: outcome varable, it can be string type 
- subgroup: another subgroup varable.
- var: the continuous variable
- retype: which variables need to be returned. the default is **threshold**, **specificity**, and **sensitivity**. we can also add  **tn (true negative count)**, **tp(true positive count)**, **fn(false negative count)**, **fp(false positive count)**, **npv(negative predictive value)**, **ppv(positive predictive value)**, **precision**, **recall**. **1-specificity**, **1-sensitivity**, **1-accuracy**, **1-npv** and **1-ppv**
- auc: whether the auc is return. `True` is default
- youden: whether the youden number is return. `True` is default
- digit: how many decimal places to keep. 3 is default.

## Export

the result contains at least 9 columns(depends on retype).

![image-20191110190917299](https://tva1.sinaimg.cn/large/0082zybply1gc0dt3sve5j30hz07j3zp.jpg)

- subgroup: when we add subgroup, the specific subgroup.
- group: outcome group name.
- VarGroup: specific outcome group. if the result is `GA vs GC`. the first group is control group. the second group is case group.
- The rest is the ROC result information.

# ROCplot

this R script contains three functions. 

## SubGroupRocPlot

Plot basic ROC plot based on all data or one subgroup data

### Import

> SubGroupRocPlot(dat, subgroup = NULL, var, group, smooth = T, col = "firebrick1")
>
> 

- dat: the datasets we need to analysis
- group: outcome varable, it can be string type 
- subgroup: another subgroup varable. `NULL` is default.
- var: the continuous variable

- smooth: whether the ROC curve is smooth.
- col: ROC curve color.

### Export

Every ROC curve based on subgroup was plotted. and the pdf file will created in working directory.

![image-20200218114010809](https://tva1.sinaimg.cn/large/0082zybply1gc0ejyssm1j30mk0nbmyf.jpg)

## SubGroupRocAllPlot

`SubGroupRocPlot` create a pdf file for each ROC curve based on each subgroup. `SubGroupRocAllPlot` plot all subgroup in one pdf. 

### Import

> SubGroupRocAllPlot(dat, subgroup, var, group, smooth = F, ALL = FALSE, mycol = mycol)

- dat: the datasets we need to analysis
- group: outcome varable, it can be string type 
- subgroup: another subgroup varable. `NULL` is default.
- var: the continuous variable
- ALL: whether plot a ROC curve based on all data.

- smooth: whether the ROC curve is smooth.
- mycol: ROC curve color. Default is `slateblue, seagreen3, dodgerblue, firebrick1, lightgoldenrod, magenta, orange2` seven colors. 

### Export

the pdf file will saved in working directory automatically. 

![image-20200218114912745](https://tva1.sinaimg.cn/large/0082zybply1gc0etd8hlkj30n40nbwh5.jpg)

## MultiVarROCAllPlot

Plot ROC curve with different var or differnet outcome in one pdf 

### Import

>MultiVarROCAllPlot(dat, var, group, smooth = F, mycol = mycol)

- dat: the datasets we need to analysis
- group: outcome varable, it can be string type. The group can contains multi columns.
- subgroup: another subgroup varable. `NULL` is default.
- var: the continuous variable. The var can contains multi columns.
- mycol: ROC curve color. Default is `slateblue, seagreen3, dodgerblue, firebrick1, lightgoldenrod, magenta, orange2` seven colors. 

PS: `Var` and `group` can only have one has multiple group. tow var can  not be be multiple group at the same time. 

