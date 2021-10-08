function [trainData,valData,testData,mean_value,std_value]=zscoreNomalize(data,ind)

trainData=[data(find(ind==3),:);data(find(ind==4),:);data(find(ind==5),:)];
mean_value=mean(trainData);
std_value=std(trainData);
trainData=zscore(trainData);

testData=data(find(ind==1),:);
testData=(testData-repmat(mean_value,size(testData,1),1))./(repmat(std_value,size(testData,1),1));

valData=data(find(ind==2),:);
valData=(valData-repmat(mean_value,size(valData,1),1))./(repmat(std_value,size(valData,1),1));








end
