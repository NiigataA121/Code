clear
clc

disp('Select a folder including a video file which you want to process：');
uigetdir;

disp(' ')
prompt1 = 'Write video file name（ex: echoVideoName.mp4）：';
movieName = input(prompt1,'s'); 
movie = VideoReader(movieName); 
      
imageFrame = zeros(movie.Height,movie.Width,3,int64(movie.FrameRate*movie.Duration),'uint8'); %4次元構成の動画情報の初期化

disp(' ')
prompt2 = 'Write save name of frame images（ex: echoImage）：';
rootname1 = input(prompt2,'s');

disp(' ')
prompt3 = 'Write extension (ex: .png)：';
extension1 = input(prompt3,'s');

k = 1;
while hasFrame(movie)
    imageFrame(:,:,:,k) = readFrame(movie);
    imwrite(imageFrame(:,:,:,k),strcat(['.\' ...
            ],rootname1,num2str(k),extension1));
    k = k + 1;
end

disp('Select a folder including images file which you want to process：');
uigetdir;
list = dir(strcat('.\*',extension1)); 

for n = 1:length(list)
    fullpath = fullfile(list(n).folder,list(n).name); 
    I = imread(fullpath); 
    I2 = imresize(I,[224 224]);
     
    fileName = list(n).name;
    imwrite(I2,strcat('.\',fileName)); 
end