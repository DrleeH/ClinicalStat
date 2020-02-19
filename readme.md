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
- group: outcome varable, it can be character type 
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
- VarGroup: specific outcome group. if the result is `GA vs GC`. the `GA` is control group. `GC` is case group.
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
- group: outcome varable, it can be character type 
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
- group: outcome varable, it can be character type 
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

# logitAnalysis

When we perform `logistics regression`. We often do the univaritate regression, then do the multivaritate regression. This script contains two functions, **logitUniVar** and **logitMultiVar**, which can do the univaritate regression and multivaritate regression respectively.

## logitUniVar

Perform the univaritate regression. return the OR value and p value .

### Import

> logitUniVar((dat, group, var, digit = 3, Categorical = F)

- dat: the datasets we need to analysis
- group:  outcome varable, it can be string type.
- var: Variables waiting to be analyzed
- Categorical: is the var categorical variable. `F` is default. Some variable is Category but the data format is number. When we perform logit analysis When the data format is numeric, The analysis will perform as continuous category. 
- digit: how many decimal places to keep. 3 is default.

### Export

Seven column can be returned

![image-20200219124927027](https://tva1.sinaimg.cn/large/0082zybply1gc1m6cs2x2j30op03rq3u.jpg)

- var: Variable name. if the variable is category variable, it will return `variable name + specific subgroup`. 
- group: outcome varable
- subgroup: specific outcome group. if the result is `GA vs GC`. the `GA` is control group. `GC` is case group.
- OR, 95%CI, p.val : logistics result in the analysis.
- p: if the p.val < 0.001, the p will return `< 0.001`. `p` is the result version of `p.val`

## logitMultiVar

Perform the multivaritate regression. return the OR value and p value .

### Import

> logitMultiVar((dat, group, var, adjvar,digit = 3, Categorical = F)

- dat: the datasets we need to analysis
- group:  outcome varable, it can be string type.
- var: Variables waiting to be analyzed
- adjvar: Variables waiting to be adjusted
- Categorical: is the var categorical variable. `F` is default.
- digit: how many decimal places to keep. 3 is default.

**PS**: the `Categorical` paramater is only modify `var` parameter. if the `adjvar` contain categorical variables. Modify the variable before analysis.

### Export

![image-20200219125855072](https://tva1.sinaimg.cn/large/0082zybply1gc1mg7ban7j30pa03k0tp.jpg)

- var: Variable name. if the variable is category variable, it will return `variable name + specific subgroup`. 
- group: outcome varable
- subgroup: specific outcome group. if the result is `GA vs GC`. the `GA` is control group. `GC` is case group.
- OR, 95%CI, p.val : logistics result in the analysis.
- p: if the p.val < 0.001, the p will return `< 0.001`. `p` is the result version of `p.val`