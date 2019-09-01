Here are the files for 'Comparing Naive Bayes and Random Forests for Prediction of Breast Cancer Diagnosis' by Lara Chammas and Shruti Doshi. The raw data is in the file 'cancer.csv'. The final poster report is entitled 'Poster_Chammas_Doshi.pdf'. 


The files (and their order) for running the algorithms are: 

1. data_handling.m : Contains the initial loading of data, and dividing it into training (70%) and testing (30%) data

2. stats.m : The basic statistics and visualization of the dataset shown on the pdf

3. cancerRandomForest.m : Random Forest algorithm implementation on the dataset

4. cancerNaiveBayes.m : Naive Bayes algorithm implementation on the dataset


Note, cancerRandomForest.m and cancerNaiveBayes.m are to be run directly as they call data_handling from within their scripts. These scripts are meant to be run with Matlab_R2018b. 