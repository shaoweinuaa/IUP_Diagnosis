function classificationResults=Cross_validation_SK(data,label,Partition)
currentFolder = pwd;
addpath(genpath(currentFolder));
for i=1:10
 ind=Partition{i};
 trainLabel=[label(find(ind==3));label(find(ind==4));label(find(ind==5))];
 testLabel=label(find(ind==1));   
 valLabel=label(find(ind==2));
 [trainData,valData,testData]=zscoreNomalize(data,ind);
 for c=0:3
   parameter=['-t ', num2str(0),' -c ',num2str(2^c)];
   model=svmtrain(double(trainLabel),double(trainData),parameter);
  [predict_val, r, dec_val]=svmpredict(double(valLabel), double(valData), model);
   val_acc(c+1)=r(1); 
 end
 [max_value,opt_index]=max(val_acc); 
 opt_c=2^(opt_index-1); 
 opt_parameter=['-t ', num2str(0),' -c ',num2str(opt_c)];
 opt_model=svmtrain(double(trainLabel),double(trainData),opt_parameter);
 [predict_test, res, dec_test]=svmpredict(double(testLabel), double(testData), opt_model);

[accuracy(i),spec(i),sens(i),PPV(i),NPV(i)]=getClassificationResult(predict_test,testLabel);
if length(unique(testLabel))~=1
    [X1,Y1,T,AUC(i)] = perfcurve(testLabel,dec_test,1);
  else
    AUC=0;  
 end
if i==10
   X1_MIL =X1;
   Y1_MIL=Y1;
   save ROC_MIL_IP_IL.mat X1_MIL Y1_MIL
end

classificationResults.m_acc=mean(accuracy);
classificationResults.std_acc=std(accuracy);

classificationResults.m_spec=mean(spec);
classificationResults.std_spec=std(spec);

classificationResults.m_sens=mean(sens);
classificationResults.std_sens=std(sens);

classificationResults.m_PPV=mean(PPV);
classificationResults.std_PPV=std(PPV);

classificationResults.m_NPV=mean(NPV);
classificationResults.std_NPV=std(NPV);

classificationResults.m_AUC=mean(AUC);
classificationResults.std_AUC=std(AUC);

classificationResults.accuracy=accuracy;
classificationResults.sens=sens;
classificationResults.AUC=AUC;







  

end
