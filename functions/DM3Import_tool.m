%finding dm3 files
folderPath = 'S:\Colin Wadsworth\20230129_training\Scan1';  % Specify the folder path
filePattern = fullfile(folderPath, '*.dm3');  % File pattern to match .txt files

fileList = dir(filePattern);  % Get a list of all .txt files in the folder

% Loop over each file in the list
for i = 1:numel(fileList)
    filename = fileList(i).name;  % Get the file name
    
    % Do something with the file, for example, display the file name
    disp(filename);
end
