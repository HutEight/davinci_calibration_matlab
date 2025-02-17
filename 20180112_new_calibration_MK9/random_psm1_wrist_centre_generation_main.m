%%
clc
close all
clear all

%% Spec
% J1 range: -1.5 to +1.5
% J2 rnage: -1.0 to +1.0
% J3 range: 0.05 to 0.23

%% 
J1 = [-1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100;
    -1.5 + 3*randi([1 100])/100]

J2 = [-1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100;
    -1 + 2*randi([1 100])/100]

J3 = [0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;
    0.05 + 0.18*randi([1 100])/100;]

J4567 = [0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;
    0 0 0 0.139;]

PSM2 = [0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;
    0 0 0 0 0 0 0;]

output = [J1 J2 J3]

    