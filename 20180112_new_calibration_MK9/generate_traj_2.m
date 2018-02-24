function generate_traj_2(affine_Mg_wrt_portal_0,affine_Mc_wrt_Mg,affine_cam_wrt_Mc,affine_board_0_0_wrt_l_cam)
    
G_Dp = [0,0.015,0,1; 0.015,0.015,0,1; 0.030,0.015,0,1;
        0,0.03,0,1; 0.015,0.03,0,1; 0.030,0.03,0,1;
        0,0.045,0,1; 0.015,0.045,0,1; 0.030,0.045,0,1;
        0,0.06,0,1; 0.015,0.06,0,1; 0.030,0.06,0,1;]';

Pg_p = affine_Mg_wrt_portal_0*affine_Mc_wrt_Mg*affine_cam_wrt_Mc*affine_board_0_0_wrt_l_cam*G_Dp;

disp('generate_traj_cam')
 time = 5;
  for i=1:12
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)+0.01), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time+3)));
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)-0.0033),',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time+5)));
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)+0.01),',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time+8)));
    time = time+11;
  end
 
%   for i=1:12
%     disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)), ',0,1,0, 0, 0, -1, -1,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
%     time = time+3;
%   end  
  

end