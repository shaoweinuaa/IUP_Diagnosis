function [accuracy,spec,sens,PPV,NPV]=getClassificationResult(predict,groundTrues)

TP=length(intersect(find(predict==1),find(groundTrues==1)));
TN=length(intersect(find(predict==-1),find(groundTrues==-1)));
FN=length(intersect(find(predict==-1),find(groundTrues==1)));
FP=length(intersect(find(predict==1),find(groundTrues==-1)));
spec=TN/(TN + FP);
sens = TP/(TP + FN);
accuracy= (TP + TN) / (TP + FP + TN + FN);
PPV=TP/(TP+FP); 
NPV = TN/(TN+FN);


