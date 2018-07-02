% RN@HMS Queen Elizabeth 
% 25/06/18

%%
clc
close all
clear all

%% Parameters

% l_original = 1.0;
l2 = 0.3;
a = 0.00;

theta_1 = pi/6;
theta_2 = pi/4;

%% Case#1 First rotate about J2 then J1

% after rotating theta_2
y = l2*sin(theta_2);

r_1 = a + l2*cos(theta_2);

% after rotating theta_1
x = sin(theta_1)*r_1;
z = -(a + cos(theta_1)*r_1);

pt_case1 = [x y z]

%% Case#2 First rotate about J1 then J2

% after rotating theta_1
x = sin(theta_1)*(a + l2);

r_2 = cos(theta_1)*(a + l2 - a/cos(theta_1));

% after rotating theta_2
y = sin(theta_2)*r_2;
z = - (a + cos(theta_2)*r_2);

pt_case2 = [x y z]

