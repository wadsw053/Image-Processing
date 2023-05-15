function [image, path, DM3Image] = load_DM3()

% Use uigetfile to get the filename and the path of the image file
disp('============================')
disp('||                        ||')
disp('||  Select the .dm3 file  ||')
disp('||                        ||')
disp('============================')
disp(' ')
[img_filename, path] = uigetfile('*.dm3', 'Select an DM3 File'); 

DM3Image = DM3Import([path img_filename]);
image = transpose(DM3Image.image_data);

figure
imagesc(image)