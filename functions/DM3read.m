function dm3image = DM3read('Scan7_0_90_-1591ps.dm3'):
% DM3READ imports ONLY the image part of the .dm3 file (dm3filename) and 
% outputs an array dm3image containing the pixel information

DM3struct = DM3Import(dm3filename);
dm3image = transpose(DM3struct.image_data);