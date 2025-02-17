function [plane_1_param, plane_2_param, fval, rot_mat] = davinci_planes_fit(pt_mat_01, pt_mat_02)
        
        x_1 = pt_mat_01(:,1);
        y_1 = pt_mat_01(:,2);
        z_1 = pt_mat_01(:,3);
        x_2 = pt_mat_02(:,1);
        y_2 = pt_mat_02(:,2);
        z_2 = pt_mat_02(:,3);
        
        % Initial params
        % We will rely on these 4 pcfitplane to give us initial normals of planes.  
        plane_1 = plane(x_1, y_1, z_1);
        plane_2 = plane(x_2, y_2, z_2);

        % Points in arc_2_y
        arc_1_pts = [x_1, y_1, z_1];
        arc_2_pts = [x_2, y_2, z_2];

        arc_1_pts(isnan(arc_1_pts(:,1)),:)= [];
        arc_2_pts(isnan(arc_2_pts(:,1)),:)= [];
        
        % Putting  arm joint 1 arc into a POINTCLOUD
        pc_arc_1 = pointCloud([x_1, y_1, z_1]);
    
        % Fitting PLANES with FMINCON

        fmin_pc_1 = arc_1_pts;
        fmin_pc_2 = arc_2_pts;
        fmin_pc1_size = size(fmin_pc_1,1);
        fmin_pc2_size = size(fmin_pc_2,1);
   
        % Search from Plane normal
        a0_1 = plane_1.Normal(1);
        a0_2 = plane_1.Normal(2);
        a0_3 = plane_1.Normal(3);
        a0_5 = plane_2.Normal(1);
        a0_6 = plane_2.Normal(2);
        
%         fmin_fun_2_planes = @(a)(norm(fmin_pc_1*[a(1);a(2);a(3)]+ ...
%             a(4)*ones(fmin_pc1_size,1))/sqrt(a(1)^2+a(2)^2+a(3)^2) + ...
%             norm(fmin_pc_2*[a(5);a(6);(-(a(1)*a(5)+a(2)*a(6))/a(3))]+ ...
%             a(7)*ones(fmin_pc2_size,1))/sqrt(a(5)^2+a(6)^2+(-(a(1)*a(5)+a(2)*a(6))/a(3))^2));

        
        fmin_fun_2_planes =  @(a)sqrt((sum(((fmin_pc_1*[a(1);a(2);a(3)]+ ...
         a(4)*ones(fmin_pc1_size,1))/sqrt(a(1)^2+a(2)^2+a(3)^2)).^2)/fmin_pc1_size) + ...
         (sum(((fmin_pc_2*[a(5);a(6);(-(a(1)*a(5)+a(2)*a(6))/a(3))]+ ...
         a(7)*ones(fmin_pc2_size,1))/sqrt(a(5)^2+a(6)^2+(-(a(1)*a(5)+a(2)*a(6))/a(3))^2)).^2)/fmin_pc2_size));
        
        
        lb = [-1,-1,-1,-10,-1,-1,-10];
        ub = [1,1,1,10,1,1,10];
        a0 = [a0_1,a0_2,a0_3,0.5,a0_5,a0_6,0];
        A = [];
        b = [];
        Aeq = [];
        beq = [];
        nonlcon = [];
        size_max = 3000000;
        options = optimoptions('fmincon','MaxFunctionEvaluations',size_max,'MaxIterations',30000);
        
        [a, fval] = fmincon(fmin_fun_2_planes,a0,A,b,Aeq,beq,lb,ub,nonlcon,options);
        
%       FMINCON ENDS
        
        vec_pc1 = a(:,1:3);
        vec_pc1 = vec_pc1/norm(vec_pc1);
        c2 = (-(a(1)*a(5)+a(2)*a(6))/a(3));
        vec_pc2 = a(:,5:6);
        vec_pc2(1,3) = c2;
        vec_pc2 = vec_pc2/norm(vec_pc2);
        norm3 = cross(vec_pc2, vec_pc1);
%       RETURE
        rot_mat = [-transpose(vec_pc2) -transpose(vec_pc1) transpose(norm3)];
        plane_1_param = a(:,1:4);
        
        plane_2_param = [a(:,5:6) c2 a(7)];
        
end