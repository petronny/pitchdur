# Regression on a b c min max ax

## REPTree
Fast decision tree learner. Builds a decision/regression tree using information gain/variance and prunes it using reduced-error pruning (with backfitting).  Only sorts values for numeric attributes once. Missing values are dealt with by splitting the corresponding instances into pieces (i.e. as in C4.5).

和C4.5相比，大概多了backfitting过程，并且数值型排序只进行一次（回想一下J48也就是C4.5算法是每个数据子集都要进行排序），并且缺失值的处理方式和C4.5一样，走不同的path再把结果进行加权。

#### window a b c min max ax //noglobal=1 classifier=REPTree
0 0.431521 5.430043 31.904066  
1 0.438104 5.383405 32.841049  
2 0.436361 5.441807 32.676938  

0 0.384168 4.740090 32.297618 24.031939 28.864679 //with abs(r1) abs(r2)  
0 0.262419 3.551773 31.927866 24.369759 28.869611 0.223741 //with rounded r1 r2  
1 0.264033 3.468563 31.882923 22.460737 27.969752 0.227104 //with rounded r1 r2  
2 0.264675 3.484095 31.947195 22.340753 27.939181 0.227369 //with rounded r1 r2  

0 0.236702 3.135309 31.398704 23.975805 28.803840 0.122963 //with r1 r2  
1 0.243014 3.176468 30.691202 22.516216 27.832360 0.127142 //with r1 r2  
2 0.242808 3.176750 31.039450 22.469090 27.837261 0.131367 //with r1 r2  

0 0.117156 1.479453 24.605966 20.998415 22.692285 0.162782 //with r1 r2 && tone=1 only  
0 0.231838 3.289632 26.828038 20.998415 22.692285 0.162782 //with r1 r2 && tone=1 && scaled
<!--0 0.229888 2.648640 27.879751 21.780934 24.337106 0.090716 //with r1 r2 && tone=2 only  -->
<!--0 0.317299 3.882718 36.716721 31.426417 37.044585 0.121330 //with r1 r2 && tone=3 only  -->
<!--0 0.270594 3.939701 37.018623 24.702090 32.011669 0.095873 //with r1 r2 && tone=4 only  -->
0 0.259646 3.605974 33.298568 25.116733 30.799914 0.116460 //with r1 r2 && tone!=1  
0 0.528342 5.621255 34.704724 25.116733 30.799914 0.116460 //with r1 r2 && tone!=1 && scaled

## LinearRegression

#### window a b c min max //noglobal=1 classifier=LinearRegression
0 0.416986 5.645893 31.809967 23.568226 27.545486  
1 0.412196 5.475688 30.418401 22.140955 25.873306  
2 0.425718 5.626434 30.164066 21.950082 25.526089 //time=47min

0 0.288307 3.937311 30.561100 23.541881 27.402386 0.258758 //with rounded r1 r2  
0 0.264733 3.767818 30.172295 23.463174 27.345129 //with r1 r2  
1 0.272036 3.736644 28.853228 22.074549 25.707198 //with r1 r2 time=18min  
2 0.280070 3.815297 28.764005 21.912833 25.286857 //with r1 r2 time=75min

## KNN

#### window a b c //noglobal=0 classifier=knn(2)
0 0.490565 6.533209 37.758414 //noglobal=1  
0 0.491010 6.563881 43.991276  
1 0.547116 7.286055 40.799967  
2 0.569146 7.696284 43.630907

# Regression on r1 & r2

#### window abs(r1) abs(r2) classifier //noglobal=1
0 0.264261 0.114120 KNN(2)  
0 0.214944 0.083335 REPTree  
0 0.410493 0.118989 REPTree //rounded  
1 0.213719 0.083427 REPTree  
2 0.215450 0.084086 REPTree  
0 0.241087 0.147435 LinearRegression  
1 0.241724 0.151651 LinearRegression  
