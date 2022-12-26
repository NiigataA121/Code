/////////////////////////////////////////////////////////////////////////////////////////////////////
2022.12.26

Read me
This repository is for the code used in "Deep learning-based classification of adequate sonographic images for self-diagnosing deep vein thrombosis" submitted to PLOS ONE.

Please read this file before use our programs.

/////////////////////////////////////////////////////////////////////////////////////////////////////


The Train and Test folders contain samples to check the operation in advance.
＿＿＿＿＿＿＿＿＿＿＿＿＿＿_________________________＿＿＿＿＿＿＿＿＿＿＿＿＿＿_________________________
The sample is an ultrasound image of the developer himself only. Redistribution of images is prohibited.
＿＿＿＿＿＿＿＿＿＿＿＿＿＿_________________________＿＿＿＿＿＿＿＿＿＿＿＿＿＿_________________________
When using your own data, please delete them before using the following code.

To use the program, download all files "Convert_video_to_images.m", "Train_and_Test.m", "sample.mp4", "train", and "test" in the same directory.




Train_and_Test.m
　・The program perform training and test of the deep learning model.
　・Prepare the ultrasound images and save them in the "train" folder with Satisfactory, Moderately, and Unsatisfactory. ”test" folder in the same way.
　・By default, the Path setting loads ”train” and ”test” in the same directory.




Conver_video_to_images.m
　・This program preprocesses Train_and_Test.m for use.
　・If you have only ultrasound movies or your ultrasound images are not 224x224 pixels in size, please use this program.
