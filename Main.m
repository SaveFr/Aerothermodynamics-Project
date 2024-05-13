clc; clear all; 

%--------------------- AEROTHERMODYNAMIC PROJECT -------------------%
% Data needed
%------------ Constants --------------- % 
M = 5.975*1e24; % [kg] Earth's mass
G = 6.674*1e-11; %[m^3*kg^-1*s^-1] gravitional constant 
gamma = 1.4; % [-] Specific Heat ratio
R_E = 6371; %[km] Radius of the Earth 
rho_sl = 1.225 ; % [kg/m^3] density at sea level 
param.R_E=R_E;
param.m=m;
param.rho_sl=rho_sl;

%------------ Object characteristics ------------%
m=1; % [kg] mass of the object 
R_c=10; % [m] radius of curvature of the object 
param.R_c=R_c;
%--------------------- ATMOSPHERIC --------------------------------% 

% In this part, we compute the density, temperature, pressure, speed of
% sound, and other charcteristics of the atmosphere
% we are using the files taken online 
% THE ALTITUDE SHOULD BE IN KM
h= 100; % [km] altitude
division=0.01; % [km] altitude step size
unit=1; % [-] metric
[List_Z,~, ~, List_T, List_P, List_rho, List_c, List_g, List_mu, List_nu, List_k, ~, ~] = atmo(h,division,unit); 
param.Z= round(List_Z,4);
param.T=List_T;
param.P=List_P;
param.rho=List_rho;
param.g=List_g;
% param.mu=List_mu;
% param.nu=List_nu;
% param.k=List_k;

% % gravity 
% % g is a function of m, r 
% r=(h+R_E)*1e3; 
% g= m*G*M/r^2; % [m/s^2] acceleration of gravity 
% g

%--------------------- AERODYNAMICS --------------------------------% 

%--------------------- TRAJECTORY --------------------------------% 
%----------------TO DO: check for modified Newton Theory ----------------------% 
% Unknowns
Cd= 2.2; % [-] drag coefficient 
S = 2; % [m^2] area of drag
L=0; % [N] lift, it is neglected
param.L=L;
param.S=S;
param.Cd=Cd;

% Initial condition 
h_0=100;        % [km] initial altitude 
r_0=R_E+h_0;    % [km] initial radius
V_0=5;          % [km/s] initial speed 
flight_path_angle_0= -deg2rad(15); % [deg] initial flight path angle

% Defining the time span
t_i=0;    % [s] initial time 
t_f=1000; %[s] end time 
nbr_points= 10000; % [-] number of points 

% Computation
U_init=[r_0; V_0; flight_path_angle_0]; % vector of initial conditions
t_span=linspace(t_i,t_f,nbr_points);
[~,List_U]=ode78( @(t,U) U_dot(t,U,param),t_span,U_init);
[~,List_U_multi]=ode113( @(t,U) U_dot(t,U,param),t_span,U_init);

%--------------------- ABLATION --------------------------------% 

%--------------------- THERMAL --------------------------------% 
Cp= 1004; %[J/kg/K] specific heat at constant pressure for air
h_s= Cp*T + 1/2*V^2; % [J/kg] specific total enthalpy
h_w_300= 1; % [J/kg] wall enthalpy evaluated at 300 K
% Convection computation
% for continuum regime 
Q_c= 1.103*1e8/sqrt(param.R_c)*sqrt(rho/param.rho_sl)*(V/7925)^3.5 * (h_s - h_w_300)/(h_s - 3.045*1e5);

% free molecular regime 
alpha= 1; 
Q_c= alpha*rho*V^3/2;

% Radiation computation
Q_RR= eps*sigma*T^4 ; % [J/m^2] net heat flux (T is the temperature of the body)
%--------------------- AEROTHERMODYNAMICS --------------------------------% 

function m=ablation(Q,hf)
    m=1;
end


function dUdt = U_dot(t,U,param)
    dUdt=zeros(3,1);

    % Assigning the values  
    r=U(1);
    V=U(2);
    flight_path_angle=U(3);

    % -------
    L=param.L;
    S=param.S;
    Cd=param.Cd;
    R_E=param.R_E;

    z=r-R_E;
    i=find(min(abs(param.Z-z))==abs(param.Z-z));
    T=param.T(i);
    P=param.P(i);
    rho=param.rho(i);
    g=param.g(i);

    % Need to call ablation module after 
    m=param.m;

    % Computation of the derivative
    D= 1/2*rho*V^2*S*Cd;
    dUdt(1)=V*sin(flight_path_angle); 
    dUdt(2)= -D/m -g*sin(flight_path_angle);
    dUdt(3)=L/(V*m) + (V/r -g/V)*cos(flight_path_angle);

end