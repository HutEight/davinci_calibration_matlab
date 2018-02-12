function [pt_wrt_frame_2] = convertCoordinateFrame(pt_wrt_frame_1, affine_frame_1_wrt_2)

    pt_wrt_frame_2 = affine_frame_1_wrt_2*pt_wrt_frame_1;


end