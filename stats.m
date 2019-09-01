run('data_handling.m')

classes = data(:,1);
classes = table2array(classes);
class_labels=categorical(classes(:,1));
tabulate(class_labels)

data2=cell2mat(data{:,1})
class_M=data(data2=='M',:);
class_B=data(data2=='B',:);

radius_mean_M = mean(class_M.Mean_Radius,1)
texture_mean_M = mean(class_M.Mean_Texture,1)
radius_mean_B = mean(class_B.Mean_Radius,1)
texture_mean_B = mean(class_B.Mean_Texture,1)
area_mean_B = mean(class_B.Mean_Area,1)
area_mean_M = mean(class_M.Mean_Area,1)


radius_std_M=std(class_M.Mean_Radius,1)
texture_std_M = std(class_M.Mean_Texture,1)
radius_std_B = std(class_B.Mean_Radius,1)
texture_std_B = std(class_B.Mean_Texture,1)
area_std_B = std(class_B.Mean_Area,1)
area_std_B = std(class_B.Mean_Area,1)

radius_skew_M=skewness(class_M.Mean_Radius,1)
texture_skew_M = skewness(class_M.Mean_Texture,1)
radius_skew_B = skewness(class_B.Mean_Radius,1)
texture_skew_B = skewness(class_B.Mean_Texture,1)
area_skew_B = skewness(class_B.Mean_Area,1)
area_skew_B = skewness(class_B.Mean_Area,1)


figure('Name','Histogram of Mean Radius')
h1=histogram(class_M.Mean_Radius)
hold on
h2=histogram(class_B.Mean_Radius)
legend('Malignant','Benign')
xlabel('Mean Radius of Cell Nuclei')
ylabel('Count')

figure('Name','Histogram of Mean Texture')
h3=histogram(class_M.Mean_Texture)
hold on
h4=histogram(class_B.Mean_Texture)
legend('Malignant','Benign')
xlabel('Mean Texture of Cell Nuclei')
ylabel('Count')

figure('Name','Histogram of Mean Area')
h5=histogram(class_M.Mean_Area)
hold on
h6=histogram(class_B.Mean_Area)
legend('Malignant','Benign')
xlabel('Mean Area of Cell Nuclei')
ylabel('Count')