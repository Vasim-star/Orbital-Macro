function [r, v] = getsv

% interactive request of state vector

% output

%  r = position vector (kilometers)
%  v = velocity vector (kilometers/second)

% Orbital Mechanics with MATLAB

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\nplease input the position vector x-component (kilometers)\n');
   
r(1) = input('? ');
   
fprintf('\nplease input the position vector y-component (kilometers)\n');
   
r(2) = input('? ');
   
fprintf('\nplease input the position vector z-component (kilometers)\n');
   
r(3) = input('? ');

fprintf('\n\nplease input the velocity vector x-component (km/sec)\n');
   
v(1) = input('? ');

fprintf('\nplease input the velocity vector y-component (km/sec)\n');
   
v(2) = input('? ');

fprintf('\nplease input the position vector z-component (km/sec)\n');
   
v(3) = input('? ');
