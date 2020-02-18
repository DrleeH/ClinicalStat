# 函数参数介绍

## TableOneStat: 用来分析一个变量在不同分组之间的差异

### 输入：

```R
TableOneStat(dat, group, var, Normal = TRUE)
```

我们需要输入四个参数

- dat : 需要分析的数据集
- group : 想要分析的分组
- var： 想要分析的连续性变量
- Normal: 是否服从正态分布

### 输出：

- 如果服从**正态分布**，**两个变量**的我们使用`t检验`来进行分析。如果是**2个以上变量**的使用`方差分析`。同时返回`mean±sd`
- 如果**不服从正态分布**：**两个变量**的我们使用`wilcox检验`来进行分析，如果是**2个以上变量**的使用`kruskal检验`进行统计分析。同时返回`median(25%var-75%var)`

![image-20191110190433607](/Users/lihao/Library/Application Support/typora-user-images/image-20191110190433607.png)

## ROCInfoStat: 获得ROC分析当中的结果信息

脚本里面包括两个函数。其实只有`ROCSubStatFunc`即可。之前那个已经整合到这个里面。但是因为`ROCSubStatFunc`也是基于前一个修改的。所以不能删除。

### 输入

```R
ROCSubStatFunc(dat, group, subgroup = NULL,var,retype = c("threshold", "specificity", "sensitivity"),
                           auc = T,youden = T, digit = 3)
```

- `dat`： 需要输入的数据框
- `group`： 结果变量的列名
- `subgroup`：亚组内的ROC曲线信息分析。这里如果我们想做亚组的话，就填。如果不做的话。就把`"age"`这个改成`NULL`。
- `retype` : 需要提取的信息。可以包括“threshold”, “specificity”, “sensitivity”, “accuracy”, “tn” (true negative count), “tp” (true positive count), “fn” (false negative count), “fp” (false positive count), “npv” (negative predictive value), “ppv” (positive predictive value), “precision”, “recall”. “1-specificity”, “1-sensitivity”, “1-accuracy”, “1-npv” and “1-ppv” 这么多。默认是是前三种。如果需要别的可以往后加就行。
- `auc`: 是否获得最佳曲线下面积。如果不想用就把`T`改成`F`
- `youden`： 是否获得约登指数。如果不想用就把`T`改成`F`

### 输出

![image-20191110190917299](/Users/lihao/Library/Application Support/typora-user-images/image-20191110190917299.png)

- `subgroup`: 亚组的分组。其中第一列是在整体下面的ROC曲线
- `group`： 结局变量的名字。
- `VarGroup`： 变量的分组。前面的是对照组，后面的病例组。例如：“GA vs GC+GS”代表，GA是对照组，GC+GS是病例组
- 剩下的都是函数指定后出现的结果

## ROCplot: 绘制ROC曲线

脚本包括三个函数

### SubGroupRocPlot：绘制单独的ROC曲线

可以定义基于某一个亚组来绘制各个亚组的ROC曲线。

```R
SubGroupRocPlot(dat, subgroup = NULL, var, group, smooth = T, col = "firebrick1")
```

- `dat`： 输入的数据集
- `subgroup`：基于某一个亚组进行绘图。如果是`NULL`则不绘制整体的图
- `var`： 用来做ROC的变量
- `group`： 用来绘制ROC的结局变量。必须是**二分类**的
- `smooth`： 曲线是否平滑
- `col`： ROC曲线的颜色

### SubGroupRocAllPlot：把某一变量的所有亚组的ROC曲线绘制到一个图上。

```R
SubGroupRocAllPlot(dat, subgroup, var, group, smooth = F, ALL = FALSE, mycol = mycol)
```

- `dat`： 输入的数据集
- `subgroup`：基于某一个亚组进行绘图。如果是`NULL`则不绘制整体的图
- `var`： 用来做ROC的变量
- `group`： 用来绘制ROC的结局变量。必须是**二分类**的

- `smooth`： 曲线是否平滑
- `ALL`: 是否绘制一个所有数据的ROC曲线

- `mycol`： ROC曲线的颜色设定

### MultiVarROCAllPlot: 在一个图上绘制不同结局或者不同变量的ROC

```R
MultiVarROCAllPlot(dat, var, group, smooth = F, mycol = mycol)
```

- `dat`： 输入的数据集
- `subgroup`：基于某一个亚组进行绘图。如果是`NULL`则不绘制整体的图
- `var`： 用来做ROC的变量。 var可以是多个通过`c`来链接
- `group`： 用来绘制ROC的结局变量。必须是**二分类**的。group可以是多个。通过`c`来链接
- `mycol`： ROC曲线的颜色设定

PS：var和group变量只能有一个是多个。如果两个都是多个的话。则不能绘图