function stacked_image = image_stacking(stacking_num, starting_frame_dir)
% IMAGE_STACKING performs image stacking over the first FRAME_NUM of images
% (or ALL images if FRAME_NUM is not specified or 0) in the directory of
% STARTING_FRAME_DIR (or use uigetfile to get the starting frame).  The
% output array STACKED_IMAGE is of the same class as the input frame.

narginchk(0, 2)

% the case that the first frame full file path is not inputed
if nargin < 2       
    % use gui to get the path and file name of the first frame
    [starting_frame, frame_dir] = uigetfile({['*.tif;*.tiff;*.png;*.jpg;' ...       
        '*.jpeg;*.bmp;*.dm3'], ['Images (*.tif,*.tiff,*.png,*.jpg,*.jpeg,' ...
        '*.bmp,*.dm3']; '*.*', 'All Files (*.*)'}, 'Select One Frame');
    starting_frame_dir = fullfile(frame_dir, starting_frame);

     % get the number of images in the folder with the same format as the specified first frame
    [~, starting_frame_name, frame_type] = fileparts(starting_frame_dir);
    frame_num = length(dir([frame_dir '*' frame_type]));       
    
    % the case that the number of frames to be stacked is not specified
    if nargin < 1       
        % then the stacking number is the number of all qualified frames
        stacking_num = frame_num;            
    else
        if stacking_num == 0
            stacking_num = frame_num;
        elseif stacking_num < 0
            error(message(['image_stacking: invalid stacking number, cant be' ...
                ' negative']))
        elseif stacking_num > frame_num
            error(message(['image_stacking: invalid stacking number, excess ' ...
                'the total image number']))
        end
    end
else
    [frame_dir, starting_frame_name, frame_type] = fileparts(starting_frame_dir);
    if isempty(frame_type)
        error(message('image_stacking: invalid starting frame full path'))
    end
end

if strcmp(frame_type, '.dm3')
    read = @DM3read;
else
    read = @imread_convert;
end

[stacked_array, data_type] = read(starting_frame_dir);
listing = dir([frame_dir '*' frame_type]);
count = 0;

for i = 1 : stacking_num - 1
    if strcmp(listing(i).name, [starting_frame_name frame_type])
        count = count + 1;
    end
    
    frame_file = fullfile(frame_dir, listing(i + count).name);
    frame = read(frame_file);
    stacked_array = stacked_array + frame;
end

stacked_image = backconvert(stacked_array, data_type);

end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [A, data_type] = imread_convert(imagefile)
% IMREAD_CONVERT reads the image of general format (with the full file path
% IMAGEFILE) and converts its pixel values to 'double' type (without 
% rescaling).  It outputs the converted image array A and DATA_TYPE of the 
% original image.

image = imread(imagefile);
A = double(image);
data_type = class(image);

end


function [dm3image, data_type] = DM3read(dm3filename)
% DM3READ reads the image of .dm3 format (with the full file path
% DM3FILENAME).  It outputs the image array A and DATA_TYPE of the 
% original image (i.e., 'double' in this case).

DM3struct = DM3Import(dm3filename);
dm3image = transpose(DM3struct.image_data);
data_type = class(dm3image);

end


function stacked_image = backconvert(stacked_array, data_type)
% BACKCONVERT converts the the resulting array STACKED_ARRAY from the stacking
% process back to the original data type, DATA_TYPE, of the input frame.
% The conversion will rescale the image and span the pixel values over the
% whole range.

if strcmp(data_type, 'double')
    stacked_image = stacked_array;
else
    lb = min(stacked_array, [], 'all');
    ub = max(stacked_array, [], 'all');
    temp = (stacked_array - lb) ./ (ub - lb);
    switch data_type
        case 'uint8'
            K = 2^8 - 1;
            stacked_image = uint8(round(K .* temp));
        case 'uint16'
            K = 2^16 - 1;
            stacked_image = uint16(round(K .* temp));
        otherwise
            error(message('backconvert: data type not supported'))
    end
end

end

