function [weight_Morph,weight_Topo,weight_Hara] =getFeatureWeight(model,beta,trainMorphData,trainTopoData,trainHaraData)

sv_Morph=trainMorphData(model.sv_indices,:);
sv_Topo=trainTopoData(model.sv_indices,:);
sv_Hara=trainHaraData(model.sv_indices,:);
sv_coef=model.sv_coef;
weight_Morph=zeros(1,size(trainMorphData,2));
weight_Topo=zeros(1,size(trainTopoData,2));
weight_Hara=zeros(1,size(trainHaraData,2));

for i=1:length(sv_coef)
 weight_Morph=weight_Morph+sv_Morph(i,:)*beta(1)*sv_coef(i);
 weight_Topo=weight_Topo+sv_Topo(i,:)*beta(2)*sv_coef(i);
 weight_Hara=weight_Hara+sv_Hara(i,:)*beta(3)*sv_coef(i);
end

