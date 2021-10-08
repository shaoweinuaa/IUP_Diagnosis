clear all
clc
close all
currentFolder = pwd;
addpath(genpath(currentFolder));
load dataset.mat


Morph_Name=importdata('Morphlogy_Feas_Name.txt');
Topo_Name=importdata('Topo_Feas_Name.txt');
Hara_Name=importdata('Hara_Feas_Name.txt');
Feature_Name.Morph_Name=Morph_Name;
Feature_Name.Topo_Name=Topo_Name;
Feature_Name.Hara_Name=Hara_Name;


id_IP=find(label==1); %Inverted Papiloma 
id_IT=find(label==2); %Inverted transitional cell carcinoma
id_IL=find(label==3)  % low-grade Ta bladder urothelial carcinoma

%%%%%% InvertedPa vs Inverted TCC
label_PT=[ones(length(id_IP),1);-ones(length(id_IT),1)];
morphData_PT=[Morphology(id_IP,:);Morphology(id_IT,:)];
topoData_PT=[Toppology(id_IP,:);Toppology(id_IT,:)];
haraData_PT=[Haralick(id_IP,:);Haralick(id_IT,:)];
data_all_PT=[morphData_PT,topoData_PT,haraData_PT];
PT_combine= Cross_validation_SK(data_all_PT,label_PT,PT_Partition);
PT_morph= Cross_validation_SK(morphData_PT,label_PT,PT_Partition);
PT_topo= Cross_validation_SK(topoData_PT,label_PT,PT_Partition);
PT_hara=Cross_validation_SK(haraData_PT,label_PT,PT_Partition);
PT_MK=Cross_validation_MK(morphData_PT,topoData_PT,haraData_PT,label_PT,PT_Partition,'MKL_PT_Weight.txt',Feature_Name);

%%%%%% InvertedPa vs low-grade Ta bladder urothelial carcinoma?
label_PL=[ones(length(id_IP),1);-ones(length(id_IL),1)];
morphData_PL=[Morphology(id_IP,:);Morphology(id_IL,:)];
topoData_PL=[Toppology(id_IP,:);Toppology(id_IL,:)];
haraData_PL=[Haralick(id_IP,:);Haralick(id_IL,:)];
data_all_PL=[morphData_PL,topoData_PL,haraData_PL];

PL_topo= Cross_validation_SK(topoData_PL,label_PL,PL_Partition);
PL_hara=Cross_validation_SK(haraData_PL,label_PL,PL_Partition);
PL_MK=Cross_validation_MK(morphData_PL,topoData_PL,haraData_PL,label_PL,PL_Partition,'MKL_PL_Weight.txt',Feature_Name);





























