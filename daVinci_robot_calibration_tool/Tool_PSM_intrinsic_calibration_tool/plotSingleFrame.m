% RN@HMS Queen Elizabeth
% 16/10/18
% Description.
% 
% Notes.
%
%


function [] = plotSingleFrame(frame_homo, index) 

origin = frame_homo(1:3, 4);
x_vec = frame_homo(1:3, 1);
y_vec = frame_homo(1:3, 2);
z_vec = frame_homo(1:3, 3);

scatter3(origin(1), origin(2), origin(3), 'filled', 'black');



scale = 0.1;
    % Y axis
    yx_0 = origin(1);
    yy_0 = origin(2);
    yz_0 = origin(3);
    yx_t = origin(1) + y_vec(1)*scale;
    yy_t = origin(2) + y_vec(2)*scale;
    yz_t = origin(3) + y_vec(3)*scale;
    v0_y= [yx_0 yy_0 yz_0];
    vz_y= [yx_t yy_t yz_t];
    v0z_y=[vz_y;v0_y];
    plot3(v0z_y(:,1),v0z_y(:,2),v0z_y(:,3),'g');
    % X axis
    xx_0 = origin(1);
    xy_0 = origin(2);
    xz_0 = origin(3);
    xx_t = origin(1) + x_vec(1)*scale;
    xy_t = origin(2) + x_vec(2)*scale;
    xz_t = origin(3) + x_vec(3)*scale;
    v0_y= [xx_0 xy_0 xz_0];
    vx_y= [xx_t xy_t xz_t];
    v0x_y=[vx_y;v0_y];
    plot3(v0x_y(:,1),v0x_y(:,2),v0x_y(:,3),'r');       
    % Z axis
    zx_0 = origin(1);
    zy_0 = origin(2);
    zz_0 = origin(3);
    zx_t = origin(1) + z_vec(1)*scale;
    zy_t = origin(2) + z_vec(2)*scale;
    zz_t = origin(3) + z_vec(3)*scale;
    v0_y= [zx_0 zy_0 zz_0];
    vy_y= [zx_t zy_t zz_t];
    v0y_y=[vy_y;v0_y];
    plot3(v0y_y(:,1),v0y_y(:,2),v0y_y(:,3),'b');
    
text(zx_t, zy_t, zz_t, num2str(index), 'Color', 'black');    

end