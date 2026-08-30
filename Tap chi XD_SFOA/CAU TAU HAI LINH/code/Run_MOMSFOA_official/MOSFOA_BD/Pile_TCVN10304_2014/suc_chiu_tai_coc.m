clear all; close all; clc;
load gamma.mat
segment  = 1;
d_pile   = 0.6;
A_tip = (pi*d_pile^2)/4; % diện tích mũi cọc
C_p = pi*d_pile; % Chu vi thân cọc

LP_in_soil = 27.3; % Length of pile in soil
SKs = [4.8; %2
       5.3; %3
       9.6; %4
       1.7; %5
       4.9; %6
       2.3]'; %7 
ILs = [0.76; %2
       0.31; %3 
       0.63; %4
       0.35; %5
       0.67; %6
       0.3]'; %7 

f_r = ones(1,length(ILs)); 
t_r = 1;
itip = 1;
[Nk_p, N_p] = pile_bearing_capacity(gamma,LP_in_soil,A_tip,C_p,SKs,ILs,segment,f_r,t_r,itip)