clear
clc

imds_train = imageDatastore('.\train\','IncludeSubfolders',true,'LabelSource','foldernames');  
imds_test = imageDatastore('.\test\','IncludeSubfolders',true,'LabelSource','foldernames');

trainImgs = imds_train;
testImgs = imds_test;
numClasses = numel(categories(imds_train.Labels));

net = resnet101;
lgraph = layerGraph(net);

newLearnableLayer = fullyConnectedLayer(3, ... 
        'Name','new_fc', ...
        'WeightLearnRateFactor',10, ...
        'BiasLearnRateFactor',10);
lgraph = replaceLayer(lgraph,'fc1000',newLearnableLayer);
newClassLayer = classificationLayer('Name','new_classoutput');
lgraph = replaceLayer(lgraph,'ClassificationLayer_predictions',newClassLayer);

options = trainingOptions('sgdm', ...
    'InitialLearnRate',0.001, ...
    'MiniBatchsize',64, ...
    'Plots','training-progress',...
    'MaxEpochs',10,...
    'Shuffle','every-epoch', ...
    'ExecutionEnvironment','gpu');
   
[net,info] = trainNetwork(trainImgs,lgraph,options); 
[testPreds,err] = classify(net,testImgs);

testActual = testImgs.Labels;
numCorrect = nnz(testPreds == testActual);
accuracy =  numCorrect / numel(testPreds)
confusionchart(testImgs.Labels,testPreds);



