% RN@HMS Queen Elizabeth
% 23/07/18
% Descriptions.
%
% Notes.
%


function [affine] = convertQuaternionWithOriginTo4x4(origin_x, origin_y, origin_z, x,y,z,w)

  
  R = convertQuaternionToRotMat(x,y,z,w);
  affine = R;
  affine(1,4) = origin_x;
  affine(2,4) = origin_y;
  affine(3,4) = origin_z;
  affine(4, 1:4) = [0 0 0 1];

end