function dm3image = DM3read(dm3filename)
% DM3READ imports ONLY the image part of the .dm3 file (dm3filename) and 
% outputs a array dm3image containing the pixel information

DM3struct = DM3Import(dm3filename);
dm3image = transpose(DM3struct.image_data);