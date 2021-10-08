function [predict_b,accuracy,p]=getIndependResults(PT_MK,morphData_Ind,topoData_Ind,haraData_Ind,lable_Ind);
opt_beta=PT_MK.opt_beta;
model=PT_MK.model;
mean_Morph=PT_MK.mean_Morph;
std_Morph=PT_MK.std_Morph;
mean_Topo=PT_MK.mean_Topo;
std_Topo=PT_MK.std_Topo;
mean_Hara=PT_MK.mean_Hara;
std_Hara=PT_MK.std_Hara;

trainMorphData=PT_MK.opt_trainMorphData;
trainTopoData=PT_MK.opt_trainTopoData;
trainHaraData=PT_MK.opt_trainHaraData;

morphData_Ind=(morphData_Ind-repmat(mean_Morph,size(morphData_Ind,1),1))./(repmat(std_Morph,size(morphData_Ind,1),1));
topoData_Ind=(topoData_Ind-repmat(mean_Topo,size(topoData_Ind,1),1))./(repmat(std_Topo,size(topoData_Ind,1),1));
haraData_Ind=(haraData_Ind-repmat(mean_Hara,size(haraData_Ind,1),1))./(repmat(std_Hara,size(haraData_Ind,1),1));

allCrossKernel(:,:,1)=calckernel('linear','',trainMorphData,morphData_Ind);
allCrossKernel(:,:,2)=calckernel('linear','',trainTopoData,topoData_Ind);
allCrossKernel(:,:,3)=calckernel('linear','',trainHaraData,haraData_Ind);

crossKernel=zeros(size(morphData_Ind,1),size(trainMorphData,1));
for i=1:length(opt_beta)
  crossKernel=crossKernel+opt_beta(i)*allCrossKernel(:,:,i);
end

[predict_b, accuracy,p] = svmpredict(lable_Ind, [(1:length(lable_Ind))', crossKernel], model);    










end