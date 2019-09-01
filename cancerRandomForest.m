rng(1)

run('data_handling.m') %import data and make training and testing sets 

%NumTrees =   
%samples_per_node = 
%depth of tree 
%features in bag

%array with values of number of trees for the forrest 
%numTree = [1, 10 , 20 , 30, 40 , 50 , 60 , 70 , 80 , 90 , 100] ; 

%array of values to try for minimum number of observations per tree leaf
minLeaf = [1:10]; 

%array of values to vary the number of predictors to select per split 
numPredictors = [1 : 15] ; 

%initalize arrays to hold values created in loops 
Parameters = [];
Errors = [] ;  
Final = table ; 
Accuracy = [] ; 
ErrorAllTable = [] ; 

%generate list of class labels to use for confusion matrix 
labels_training = table2cell(Training(:,1)); 
labels_testing = Testing{:, 1} ; 

for i = 1:length(numTree)
    
    for j = 1:length(minLeaf)
    
        for k = 1:length(numPredictors)
        
        Model = TreeBagger(numTree(i), Training, 'Class', 'OOBPrediction', 'on', 'minLeafSize', minLeaf(j), ...
            'NumPredictorsToSample', numPredictors(k)); 
       
        Parameters = [Parameters; numTree(i), minLeaf(j), numPredictors(k)]; %input the parameters tested into an array
        
        %generate the error (or the misclassification probability) for each
        %model for out-of-bag observations in the training data 
        %using ensemble to calculate an average for all the trees in that
        %model
        model_error = oobError(Model, 'Mode', 'Ensemble') ; 
        
        Error_all = oobError(Model); %generate the errors for each of the trees in the model for plotting
      
        %input the oobError values into an array
        Errors = [Errors; model_error];
        
        ErrorAllTable = [ErrorAllTable ; Error_all];
        
       %use the trained model to predict classes on the out of bag
       %observations stored in the model
       [predicted_labels,scores]= oobPredict(Model);
       
       %generate the confusion matrix from the ooBPredict output 
       CM_model= confusionmat(labels_training,predicted_labels);
        
       %calculate the accuracy of the model using the confusion matrix 
       Accuracy_model = 100*sum(diag(CM_model))./sum(CM_model(:));
       
       %store the model accuracy values in an array
       Accuracy = [Accuracy; Accuracy_model] ; 
       
       %join the parameters test and the model error and accuracy in a row
       %in an array 
       Final = [Parameters Errors Accuracy] ; 
    end
     end 
end 

%plot the out of bag classification error for the number of trees grown
figure;
plot(Error_all)
xlabel 'Number of grown trees';
ylabel 'Out-of-bag classification error';

%transform the array to a table
Final = array2table(Final) ; 
%assign column names to table
Final.Properties.VariableNames = {'NumTrees', 'NumLeaves' , 'NumSamples', 'oobErrorValue', 'AccuracyValue'} ; 

%find the minimum model error
min_error = min(Final{:,4}) %find the minimum error for all the models 

%find the highest model accuracy 
highestAccuracy = max(Final{:,5})

%find the model row with the highest accuracy and what its parameters are 
best_model = Final(Final.AccuracyValue == highestAccuracy, :)

%Train a new model using the parameters 
numtrees = best_model{:,1} ; 
numLeaves = best_model{:,2};
numSamples = best_model{:,3} ; 

Model_Final = TreeBagger(numtrees, Training, 'Class', 'OOBPrediction', 'on', 'minLeafSize', numLeaves, 'NumPredictorsToSample', numSamples); 

%Test the model using predict and the testing dataset 
[predicted_labels,scores]= predict(Model_Final, Testing(:, 2:31));

%generate a confusion matrix 
CM_model_final= confusionmat(labels_testing,predicted_labels, 'Order', {'M', 'B'});
figure
confusionchart(CM_model_final)
       
%output metrics 
Accuracy_Final = 100*sum(diag(CM_model_final))./sum(CM_model_final(:)) ; 
Error_Final =  oobError(Model_Final, 'Mode', 'Ensemble') ; 

%Make the ROC curve
MPosition = find(strcmp('M',Model_Final.ClassNames)) ; %find the column which the malignant cases are in 

[false_positives,true_positive,T,AUC] = perfcurve(labels_testing,scores(:,MPosition),'M'); %generate the values

%plot ROC curve
figure
plot(false_positives,true_positive)
xlabel('False Positive Rate')
ylabel('True Positive Rate')
AUC %print the area under the curve value 