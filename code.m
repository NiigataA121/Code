%DeepLearning

imds_train = imageDatastore('D:\a\b\c\train\','IncludeSubfolders',true,'LabelSource','foldernames');  
imds_test = imageDatastore('D:\a\b\c\test\','IncludeSubfolders',true,'LabelSource','foldernames');

trainImgs = imds_train;
testImgs = imds_test;
numClasses = numel(categories(imds_train.Labels));

net = modelName;
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
save('D:\result\');

testActual = testImgs.Labels;
numCorrect = nnz(testPreds == testActual);
accuracy =  numCorrect / numel(testPreds)
confusionchart(testImgs.Labels,testPreds);

[X1,Y1,T1,AUC1] = perfcurve(testImgs.Labels,err(:,1),'1');
AUC1
[X2,Y2,T2,AUC2] = perfcurve(testImgs.Labels,err(:,2),'2');
AUC2
[X3,Y3,T3,AUC3] = perfcurve(testImgs.Labels,err(:,3),'3');
AUC3
output1 = [X1,Y1]; 
output2 = [X2,Y2];
output3 = [X3,Y3];

output1Size = size(output1);
output2Size = size(output2);
output3Size = size(output3);

if(output1Size(1) > output2Size(1))
    bigger = output1Size(1);
else
    bigger = output2Size(1);
end

if(bigger > output3Size(1))
    outputSize = bigger;
else
    outputSize = output3(1)
end

output = NaN(outputSize,6);

for i = 1 : output1Size(1)
    output(i,1) = output1(i,1);
    output(i,2) = output1(i,2);
end

for i = 1 : output2Size(1)
    output(i,3) = output2(i,1);
    output(i,4) = output2(i,2);
end

for i = 1 : output3Size(1)
    output(i,5) = output3(i,1);
    output(i,6) = output3(i,2);
end

csvwrite('D:\result\',output);

classLabels = grp2idx(testImgs.Labels); 
allAUC = multiClassAUC(err,classLabels);

%% color frame

for n = 1:length(testImgs.Files)
    Imgs = readimage(testImgs,n); 
    imgsFile = char(testImgs.Files(n));
    
   
    if  testPreds(n) == '1'
        videoFrameDetected = insertShape(Imgs,'Rectangle',[1 1 224 224],'LineWidth',3,'color','cyan');
    elseif  testPreds(n) == '2'
        videoFrameDetected = insertShape(Imgs,'Rectangle',[1 1 224 224],'LineWidth',3); %def:黄色
    else testPreds(n) == '3'
        videoFrameDetected = insertShape(Imgs,'Rectangle',[1 1 224 224],'LineWidth',3,'color','magenta');
    end
    
    imwrite(videoFrameDetected,imgsFile);
    
    n = n + 1;
end

%% GradCAM
roop = size(testPreds);

for n = 1:roop(1)

    imgPath = cell2mat(testImgs.Files(n));
    I = imread(imgPath);
    
    [filePath,fileName] = fileparts(imgPath);
    
    map = gradCAM(net,I,testPreds(n));
    
    imshow(I);
    hold on;
    imagesc(map,'AlphaData',0.25);
    colormap jet
    hold off;
    
    if testPreds(n) == '1'
        saveas(gcf,strcat('D:\a\b\c\1\',fileName,'.png'));
    elseif testPreds(n) == '2'
        saveas(gcf,strcat('D:\a\b\c\2\',fileName,'.png'));
    else testPreds(n) == '3'
        saveas(gcf,strcat('D:\a\b\c\3\',fileName,'.png'));
    end

end
