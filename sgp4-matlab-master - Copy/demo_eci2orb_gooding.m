% demo_eci2orb_gooding       November 22, 2014

% this script demonstrates how to interact with the
% eci2orb_gooding function which calculates the
% classical orbital elements from an ECI state
% vector using R. H. Gooding's method

% R. H. Gooding, "On Universal Elements, and Conversion
% Procedures To and From Position and Velocity",
% Celestial Mechanics 44 (1988), 283-298

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all;

% earth gravitational constant (kilometer^3/second^2)

mu = 398600.4415;

%%%%%%%%%%%%%%%%%%
% elliptical orbit
%%%%%%%%%%%%%%%%%%

% eci position vector (kilometers)

reci(1) = +3871.56734351188;
reci(2) = +6365.21709672617;
reci(3) = -2670.28756008413;

% eci velocity vector (kilometers/second)

veci(1) = -5.20544460471574;
veci(2) = +4.25847877360187;
veci(3) = +2.38188428278297;

clc; home;

fprintf('\ndemo_eci2orb_gooding');

fprintf('\n====================');

fprintf('\n\nECI state vector - elliptical orbit\n');

svprint(reci, veci);

fprintf('\nclassical orbital elements - elliptical orbit\n');

oev = eci2orb_gooding (mu, reci, veci);

oeprint1(mu, oev, 1);

%%%%%%%%%%%%%%%%%%
% hyperbolic orbit 
%%%%%%%%%%%%%%%%%%

% eci position vector (kilometers)

reci(1) = -4786.49275664045;
reci(2) = -3852.86985447614;
reci(3) = -2307.35522767897; 

% eci velocity vector (kilometers/second)

veci(1) = +2.99280761783281;  
veci(2) = -9.54679394718429;  
veci(3) = +5.53554782769536;

fprintf('\n\nECI state vector - hyperbolic orbit\n');

svprint(reci, veci);

fprintf('\nclassical orbital elements - hyperbolic orbit\n');

oev = eci2orb_gooding (mu, reci, veci);

oeprint1(mu, oev, 1);

