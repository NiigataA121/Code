%% from a vide to frame images   
prompt1 = 'Enter video file name：';
movieName = input(prompt1,'s'); 
movie = VideoReader(movieName); 
      
imageFrame = zeros(movie.Height,movie.Width,3,int64(movie.FrameRate*movie.Duration),'uint8'); %4次元構成の動画情報の初期化
prompt3='Enter save name of frame images：';
rootname1 = input(prompt3,'s'); %ファイル名に使用する文字列
extension = '.png'; %拡張子

k = 1;
while hasFrame(movie)
    imageFrame(:,:,:,k) = readFrame(movie);
    imwrite(imageFrame(:,:,:,k),strcat(['.\' ...
            ],rootname1,num2str(k),extension));
    k = k + 1;
end

%% to change image size
list = dir('.\*.jpg'); 

for n = 1:length(list)
    fullpath = fullfile(list(n).folder,list(n).name); 
    I = imread(fullpath); 
    I2 = imresize(I,[224 224]);
     
    fileName = list(n).name;
    imwrite(I2,strcat('.\',fileName)); 
end

%% Deep Learning

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


