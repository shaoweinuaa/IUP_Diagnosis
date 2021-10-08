function [accuracy,spec,sens,PPV,NPV,AUC,X1,Y1]=getMKTestResult(trainTestKernelMatrix,testLabel,nTrain,nTest,model,beta)
trainTestKernel=trainTestKernelMatrix(nTrain+1:nTrain+nTest,1:nTrain,:);
wTrainTestKernel=zeros(nTest,nTrain);

for k=1:length(beta)
    wTrainTestKernel=wTrainTestKernel+trainTestKernel(:,:,k)*beta(k);
end

[predict_b, accuracy,dec_test] = svmpredict(testLabel, [(1:length(testLabel))', wTrainTestKernel], model);    
[accuracy,spec,sens,PPV,NPV]=getClassificationResult(predict_b,testLabel);

if length(unique(testLabel))~=1
  [X1,Y1,T,AUC] = perfcurve(testLabel,dec_test,1);
else
   AUC=1;  
end