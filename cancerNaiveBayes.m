run('data_handling.m')

%for 10-fold cross validation
maxiter = 10;
iter = 1;
results = cell(1,1);
names = cell(1,1);
[m,n] = size(Training) ;
%To divide the training dataset into 70% train and 30% validation
P = 0.7 ;

while iter<=maxiter
    table_i=table;
    Distribution=["kernel","mvmn", "normal"];
    Width = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
    %Iterating to vary the distributions
    for i =1:length(Distribution)
        if Distribution(i)=="kernel"
            %Iterating to vary the bandwidth for the kernel distribution
            for j=1:length(Width)
                %Dividing the training dataset further into validation and 
                %train set for every fold
                idx = randperm(m)  ;
                Training_set = Training(idx(1:round(P*m)),:) ; 
                Validation_set = Training(idx(round(P*m)+1:end),:) ;
                %Storing the original lables
                actual_labels=table2cell(Validation_set(:,1));
                
                %Building the model for Kernel Distribution
                M=fitcnb(Training_set,'Class','DistributionName',Distribution(i),'Width',Width(j));
                %Fitting the model on the validation set
                [predicted_labels,scores_train]=predict(M,Validation_set(:,2:end));
                
                %Calculating a confusion matrix
                CM_model= confusionmat(actual_labels,predicted_labels);
                %Calculating the Accuracy of the model using the formula
                %Acc= TP + TN / TP+TN+FP+FN
                Accuracy_model = 100*sum(diag(CM_model))./sum(CM_model(:));
                loss_model=loss(M,Validation_set,'Class');
                
                %Storing the Accuracy and the Distribution Name for each model
                results{j,iter}=Accuracy_model;
                name=strcat(Distribution(i), num2str(Width(j)));
                names{j,iter}=name;
            end
        else
            %Dividing the training dataset further into validation and
            %train set for every fold
            idx = randperm(m)  ;
            Training_set = Training(idx(1:round(P*m)),:) ; 
            Validation_set = Training(idx(round(P*m)+1:end),:) ;
            %Storing the original lables
            actual_labels=table2cell(Validation_set(:,1));
            
            %Building the model for Gaussian and mvmn Distribution
            M=fitcnb(Training,'Class','DistributionName',Distribution(i));
            %Fitting the model on the validation set
            [predicted_labels,scores_train]=predict(M,Validation_set(:,2:end));
            
            %Calculating a confusion matrix
            CM_model= confusionmat(actual_labels,predicted_labels);
            %Calculating the Accuracy of the model using the formula
            %Acc= TP + TN / TP+TN+FP+FN
            Accuracy_model = 100*sum(diag(CM_model))./sum(CM_model(:));
            loss_model=loss(M,Validation_set,'Class');
            
            %Storing the Accuracy and the Distribution Name for each model
            results{length(Width)+i-1,iter}=Accuracy_model;
            names{length(Width)+i-1,iter}=Distribution(i);
        end
        
    end
    iter=iter+1;
end 
T=cell2table(results);
N=cell2table(names);
%Creating a table which mentions the hyperparameters and their respective
%accuracy performance for every fold
T=[N(:,1) T];
%Calculating the mean accross every model
T_mean=mean(T{:,2:end},2);
T_mean=array2table(T_mean);
%Creating a table with the various models and their mean accuracy
%performance
final=[T(:,1) T_mean]; 
%Finding the best performing model and displaying it
highest_avg=max(final{:,2});
best_model = final(final.T_mean == highest_avg, :)

%Selecting the best performing model and building it on the training set
Mdl=fitcnb(Training,'Class','DistributionName','normal');
%Fitting the model on the test data
[observed_labels,scores]=predict(Mdl,Testing(:,2:31));
%Storing the original lables
real_labels=table2cell(Testing(:,1));
%Creating and displaying a table with actual labels and predicted labels
%for the data point
info=table(real_labels,observed_labels,'VariableNames',...
    {'TrueLabel','PredictedLabel'});
disp(info(1:6,:)) 

%Calculating and plotting a confusion matrix
CM= confusionmat(real_labels,observed_labels,'Order',{'M','B'});
figure('Name','Confusion Matrix for Navie Bayes')
confusionchart(CM)
%Calculating the Accuracy of the model using the formula 
%Acc= TP + TN / TP+TN+FP+FN
Accuracy = 100*sum(diag(CM))./sum(CM(:));
fprintf('Accuracy = %f\n',Accuracy);
%Calculating the Classification Loss of the model
Loss=loss(Mdl,Testing,'Class');
fprintf('Loss = %f\n',Loss);

%ROC Calculation
[FP,TP,T,AUC]= perfcurve(real_labels,scores(:,2),'M');
fprintf('AUC = %f\n',AUC);
figure
plot(FP,TP)
xlabel('False Positive Rate')
ylabel('True Positive Rate')
title('ROC Curve for Naive Bayes Classifier')
