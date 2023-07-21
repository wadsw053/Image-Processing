function I = dm3_to_uint16(dm3_image, tol)
%DM3_TO_UINT16 convert .dm3 image to 'uint16' class
%   I = DM3_TO_UINT16(DM3_IMAGE, TOL) converts the input .dm3 image, 
%   DM3_IMAGE of the 'double' class to the 'uint16' type image I, with 
%   elements outside the tolerance factor TOL clipped.  If no TOL is
%   specified, the default value is 0.0002.
%   
%   NOTE: Its major difference between the TOUINT16 function is that this
%   function will clip the outlier pixels, while TOUINT16 span all pixel
%   values over the range [0, 65535].  This feature makes this function
%   more suitable for processiong electron microscopy images with low
%   signal-to-noise ratio.
%narginchk validates the argument is called with a min of 1 and a max of 2
%input arguments 
narginchk(1, 2)

%returns the number of function input argumuents given in the call to the
%currently executing function
if nargin < 2
    tol = 0.0002;
else
    if ( any(tol < 0) || any(tol > 1) || any(isnan(tol)) )
        error(message('dm3_to_uint16:tolOutOfRange'))
    end
end

K = 2^16 - 1;       % K is the scaling factor, 2^16-1 for uint16 class
%make the new image an array of zeros with the size of the orginal file
I = zeros(size(dm3_image));

[clipped_dm3, lowhigh] = clip_dm3(dm3_image, tol);


if size(clipped_dm3, 3) == size(lowhigh, 2)
    for i = 1 : size(lowhigh, 2)
        itemp = clipped_dm3(:, :, i) - lowhigh(1, i);
        I(:, :, i) = round(K .* (itemp ./ (lowhigh(2, i) - lowhigh(1, i))));
    end
else
    error(message('dm3_to_uint16:clipped_dm3 and lowhigh sizes not match'))
end

I = uint16(I);