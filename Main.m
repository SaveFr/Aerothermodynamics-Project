% Aerothermodynamic Project 
% 5 modules to do 
% Data needed
% Constant
M = 5.975*1e24; % [kg] Earth's mass
G = 6.674*1e-11; %[m^3*kg^-1*s^-1] gravitional constant 
gamma = 1.4; % [-] Specific Heat ratio
R_E = 6371; %[km] Radius of the Earth 
m=1; % [kg] mass of the object 


% Aerodynamic 

% Trajectory




% Atmospheric
% In this part, we compute the density, temperature, pressure, speed of
% sound, and other charcteristics of the atmosphere
% we are using the files taken online 
% THE ALTITUDE SHOULD BE IN KM
h= 100; % [km] altitude
division=0.01; % [km] altitude step size
unit=1; % [-] metric
[List_Z,~, ~, List_T, List_P, List_rho, List_c, List_g, List_mu, List_nu, List_k, ~, ~] = atmo(h,division,unit); 

% % gravity 
% % g is a function of m, r 
% r=(h+R_E)*1e3; 
% g= m*G*M/r^2; % [m/s^2] acceleration of gravity 
% g

% Ablation 
% Thermal
% Aerothermodynamics
