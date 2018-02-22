function generate_traj_only_arm(affine_Mg_wrt_portal_0 , affine_Md_wrt_Mg,  affine_Md_wrt_board_0_0)

G_Dp = [0,0.03,0,1; 0.015,0.03,0,1; 0.030,0.03,0,1;
        0,0.045,0,1; 0.015,0.045,0,1; 0.030,0.045,0,1;
        0,0.06,0,1; 0.015,0.06,0,1; 0.030,0.06,0,1;]';

Pg_p =  affine_Mg_wrt_portal_0 * affine_Md_wrt_Mg * inv(affine_Md_wrt_board_0_0) * G_Dp;

disp('generate_traj_only_arm')
 time = 5;
  for i=1:9
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)), ',0,1,0, 0, 0, -1, 0,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time)));
     disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i)), ',0,1,0, 0, 0, -1, 0,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time+3)));
    disp(strcat(num2str(Pg_p(1,i)), ',  ',num2str(Pg_p(2,i)), ',  ' , num2str(Pg_p(3,i))+0.01, ',0,1,0, 0, 0, -1, 0,       0, 0, -0.15, 0,1,0, 0, 0, -1, 0,',   num2str(time+6)));
    time = time+9;
 end


end