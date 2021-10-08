function classificationResults=Cross_validation_MK(morphData,topoData,haraData,label,Partition,outputWeightFile,Feature_Name)
currentFolder = pwd;
addpath(genpath(currentFolder));
Hara_Name=Feature_Name.Hara_Name;
Morph_Name=Feature_Name.Morph_Name;
Topo_Name=Feature_Name.Topo_Name;

for i=1:10 
 ind=Partition{i};
 trainLabel=[label(find(ind==3));label(find(ind==4));label(find(ind==5))];
 testLabel=label(find(ind==1));   
 valLabel=label(find(ind==2));
 nTrain=length(trainLabel);
 nTest=length(testLabel);
 nVal=length(valLabel);
 [trainMorphData{i},valMorphData,testMorphData,mean_Morph{i},std_Morph{i}]=zscoreNomalize(morphData,ind);
 [trainTopoData{i},valTopoData,testTopoData,mean_Topo{i},std_Topo{i}]=zscoreNomalize(topoData,ind);
 [trainHaraData{i},valHaraData,testHaraData,mean_Hara{i},std_Hara{i}]=zscoreNomalize(haraData,ind);
 trainValKernelMatrix(:,:,1)=calckernel('linear','',[trainMorphData{i};valMorphData]);
 trainValKernelMatrix(:,:,2)=calckernel('linear','',[trainTopoData{i};valTopoData]);
 trainValKernelMatrix(:,:,3)=calckernel('linear','',[trainHaraData{i};valHaraData]);
 trainTestKernelMatrix(:,:,1)=calckernel('linear','',[trainMorphData{i};testMorphData]);
 trainTestKernelMatrix(:,:,2)=calckernel('linear','',[trainTopoData{i};testTopoData]);
 trainTestKernelMatrix(:,:,3)=calckernel('linear','',[trainHaraData{i};testHaraData]);
 [beta(i,:),model{i}]=getMKWeight(trainValKernelMatrix,trainLabel,valLabel,nTrain,nVal);
 [weight_Morph(i,:),weight_Topo(i,:),weight_Hara(i,:)] =getFeatureWeight(model{i},beta(i,:),trainMorphData{i},trainTopoData{i},trainHaraData{i});
 
 [accuracy(i),spec(i),sens(i),PPV(i),NPV(i),AUC(i),X1,Y1]=getMKTestResult(trainTestKernelMatrix,testLabel,nTrain,nTest,model{i},beta(i,:));
 if i==9
   X1_MK =X1;
   Y1_MK=Y1;
   save ROC_MK_IP_IL.mat X1_MK Y1_MK 
end
 trainValKernelMatrix=[];
 trainTestKernelMatrix=[];
 
  
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

max_value=max(accuracy);
index=find(accuracy==max_value);
for i=1:length(index)
    var_beta(i)=std(beta(index(i),:));
end

[max_var_beta,max_var_beta_id]=min(var_beta);
max_id=index(max_var_beta_id)

classificationResults.beta=beta;
classificationResults.model=model{max_id};
classificationResults.opt_beta=beta(max_id,:);
classificationResults.opt_trainMorphData=trainMorphData{max_id};
classificationResults.opt_trainTopoData=trainTopoData{max_id};
classificationResults.opt_trainHaraData=trainHaraData{max_id};

classificationResults.mean_Morph=mean_Morph{max_id};
classificationResults.std_Morph=std_Morph{max_id};

classificationResults.mean_Topo=mean_Topo{max_id};
classificationResults.std_Topo=std_Topo{max_id};

classificationResults.mean_Hara=mean_Hara{max_id};
classificationResults.std_Hara=std_Hara{max_id};

classificationResults.weight_Morph=median(weight_Morph);
classificationResults.weight_Topo=median(weight_Topo);
classificationResults.weight_Hara=median(weight_Hara);
classificationResults.accuracy=accuracy;
classificationResults.sens=sens;
classificationResults.AUC=AUC;




[sort_Value_Hara,sort_ID_Hara]=sort(abs(classificationResults.weight_Hara),'descend');
[sort_Value_Topo,sort_ID_Topo]=sort(abs(classificationResults.weight_Topo),'descend');
[sort_Value_Morph,sort_ID_Morph]=sort(abs(classificationResults.weight_Morph),'descend');
select_Hara_Name=Hara_Name(sort_ID_Hara(1:5));
select_Morph_Name=Morph_Name(sort_ID_Morph(1:5));
select_Topo_Name=Topo_Name(sort_ID_Topo(1:5));
select_feature_name=[select_Hara_Name;select_Topo_Name;select_Morph_Name];
select_feature_weight=[classificationResults.weight_Hara(sort_ID_Hara(1:5)),classificationResults.weight_Topo(sort_ID_Topo(1:5)),classificationResults.weight_Morph(sort_ID_Morph(1:5))];
fid1=fopen(outputWeightFile,'w');
for kk=1:length(select_feature_weight)
  fprintf(fid1,'%f\t%s\n',select_feature_weight(kk),select_feature_name{kk});
end
fclose(fid1)
   

  







 
 




 
 




end
