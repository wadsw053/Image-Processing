%The following code is used to find dm3 files and convert them to tif files
%to be made into a movie in imageJ
%Author:Colin Wadsworth

%create a new folder
mkdir test1
folderPath = 'C:\Users\wadsw053\Documents\MATLAB\Scan7';  % Specify the folder path for folder that holds .dm3 files
filePattern = fullfile(folderPath, '*.dm3');  % File pattern to match .dm3 files

fileList = dir(filePattern);  % Get a list of all .dm3 files in the folder

% Loop over each file in the list
for i = 1:numel(fileList)
    filename = fileList(i).name;  % Get the file name
    
    % creates a list of dm3 files
    dm3list = fileList.name;
    %imports the dm3 files, so that the intensity data for the image can be
    %found 
    dm3data = DM3Import(dm3list);
    %transposes dm3 image data, which is the .image_data found after
    %importing the dm3 data structure that holds the intensity values
    dm3image = transpose(dm3data.image_data);
    %converts dm3 data to unit16 
    I = dm3_to_uint16(dm3image, 0.0002);
    %after this step, can preform different image anylsis techniques
    
    %saves the image data as a tiff file
    savename = [num2str(i) '.tif'];
    %create file for each scan
    imwrite(I, savename)
end
 
%move to desired folder
sourceFolder = 'C:\Users\wadsw053\Documents\MATLAB';  % Specify the source folder path
destinationFolder = 'C:\Users\wadsw053\Documents\MATLAB\test1';  % Specify the destination folder path
fileExtension = '*.tif';  % Specify the file extension of files to be moved

filePattern = fullfile(sourceFolder, fileExtension);  % File pattern to match files with the given extension
fileList = dir(filePattern);  % Get a list of all files in the source folder with the specified extension

% Loop over each file in the list
for i = 1:numel(fileList)
    filename = fileList(i).name;  % Get the file name
    
    % Build the full file paths for source and destination
    sourceFile = fullfile(sourceFolder, filename);
    destinationFile = fullfile(destinationFolder, filename);
    
    % Move the file from the source to the destination folder
    movefile(sourceFile, destinationFile);
    
    disp(['Moved file: ', filename])
end

