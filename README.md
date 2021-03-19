# Tree-based boosting algorithm testing
Data set simulation and Bayesian optimization for XGBoost, LightGBM and CatBoost.

The data set simulation file simulates data sets in excel format with varying data characterisics such as number of instances, propotion of categorical features and 
propotion of highly correlated features (with regards to the target). 

The optimization file runs the three algorithms on the simulate data sets using Bayesian hyperparameter optimization, see the PNG-file for current hyperparameter space
and other configurations. 

By setting the same working directory for the two files, the optimization file will find the data sets by itself. 
