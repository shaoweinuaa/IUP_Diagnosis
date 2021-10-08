function [opt_beta,opt_model]=getMKWeight(trainValKernelMatrix,trainLabel,valLabel,nTrain,nVal)
currentFolder = pwd;
addpath(genpath(currentFolder));
trainKernel=trainValKernelMatrix(1:nTrain,1:nTrain,:);
trainValKernel=trainValKernelMatrix(nTrain+1:nTrain+nVal,1:nTrain,:);
temp=0;
t=0;
for c=0:3
 param=['-t ',num2str(4),' -c ',num2str(2^c)];
   
 for wMorph=0:0.05:1
    for wTopo=0:0.05:1
      wTrainKernel=zeros(nTrain,nTrain);
      wTrainValKernel=zeros(nVal,nTrain);
      if (wMorph+wTopo)<1
         t=t+1;
         beta=[wMorph,wTopo,1-wMorph-wTopo];
         
         for k=1:length(beta)
             wTrainKernel=wTrainKernel+trainKernel(:,:,k)*beta(k);
             wTrainValKernel=wTrainValKernel+trainValKernel(:,:,k)*beta(k);
         end
         model = svmtrain(trainLabel, [(1:length(trainLabel))', wTrainKernel], param);
         [predict_b,acc,p] = svmpredict(valLabel, [(1:length(valLabel))', wTrainValKernel], model);    
         [accuracy,spec,sens,PPV,NPV]=getClassificationResult(predict_b,valLabel);
         z(t,:)=[accuracy, beta,c];
         
         
         [X1,Y1,T,AUC] = perfcurve(valLabel,p,1);
         if accuracy>temp
            temp=accuracy;
            
         end
                
      end
   end
end
index=find(z(:,1)==temp);
[min_Beta_variance,min_beta_variance_id]=min(std(z(index,2:4)'));
opt_beta=z(index(min_beta_variance_id),2:4);
opt_c=z(index(min_beta_variance_id),5);
opt_param=['-t ',num2str(4),' -c ',num2str(2^opt_c)];

wTrainKernel=zeros(nTrain,nTrain);
for k=1:length(beta)
    wTrainKernel=wTrainKernel+trainKernel(:,:,k)*opt_beta(k);
end
opt_model = svmtrain(trainLabel, [(1:length(trainLabel))', wTrainKernel], opt_param);


end
