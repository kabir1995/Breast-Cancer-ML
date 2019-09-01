% Uploading the data 

clc; clear all; close all;

%loading the data
data=readtable('cancer.csv');

%adding the column names
colNames={'ID','Class','Mean_Radius','Mean_Texture','Mean_Perimeter','Mean_Area',...
    'Mean_Smoothness','Mean_Compactness','Mean_Concavity','Mean_ConcavePts',...
    'Mean_Symmetry','Mean_FractalDim','SE_Radius','SE_Texture','SE_Perimeter',...
    'SE_Area','SE_Smoothness','SE_Compactness','SE_Concavity','SE_ConcavePts',...
    'SE_Symmetry','SE_FractalDim','Worst_Radius','Worst_Texture','Worst_Perimeter', ...
    'Worst_Area','Worst_Smoothness','Worst_Compactness','Worst_Concavity',...
    'Worst_ConcavePts','Worst_Symmetry','Worst_FractalDim'};

data.Properties.VariableNames = colNames;

%removing of redundant variable ID as not informative for predictive model 
data = removevars(data, 'ID');

%printing the data
data(1:5,:);

%dividing into training and testing dataset
[m,n] = size(data) ;
P = 0.7 ;
idx = randperm(m)  ;
Training = data(idx(1:round(P*m)),:) ; 
Testing = data(idx(round(P*m)+1:end),:) ;