function [TLE] = readTLE(filename)
%% *purpose*
%  read the Kelso (Celestrak) Two-Line Element Set Format file
%% *inputs*
%  filename - name of the downloaded TLE file
%% *outputs*
%  Launch Information

%  Orbital Elements
%    Epoch - (days) since J2000
%    SemiMajorAxis - (km) semi-major axis of the orbit
%    Eccentricity - (unitless)
%    RAAN - (deg) Right Ascension of the Ascending Node
%    w - (deg) Argument of Perigee
%    M - (deg) Mean Anomaly
%    revNum - (number) Revolution Number at Epoch
%% *references*
%  https://www.celestrak.com/NORAD/documentation/tle-fmt.php 
%  http://www.castor2.ca/03_Mechanics/03_TLE/index.html
%% *history*
%  20190407 mnoah original code
%% *start*
%% *testcase*
if (~exist('filename','var'))
    filename = '2019-006.txt';
end
str = fileread(filename);
lines = regexp(str, '\r\n|\r|\n', 'split');
lines = lines';
if (isempty(lines{end}))
    lines = lines(1:end-1,:);
end
satname = cell2mat(lines(1:3:end,:));
line1 = cell2mat(lines(2:3:end,:));
line2 = cell2mat(lines(3:3:end,:));
tmpTable = table( ...
    satname, ...
    line1(:,1), ...     % 1.1   01      Line Number of Element Data
    line1(:,3:7), ...   % 1.2   03-07   Satellite Number
    line1(:,8), ...     % 1.3   08      Classification
    line1(:,10:11), ... % 1.4   10-11   International Designator (Last two digits of launch year)
    line1(:,12:14), ... % 1.5   12-14   International Designator (Launch number of the year)
    line1(:,15:17), ... % 1.6   15-17   International Designator (Piece of the launch)
    line1(:,19:20), ... % 1.7   19-20   Epoch Year (Last two digits of year)
    line1(:,21:32), ... % 1.8   21-32   Epoch (Day of the year and fractional portion of the day)
    line1(:,34:43), ... % 1.9   34-43   First Time Derivative of the Mean Motion
    [line1(:,45) repmat('0.',70,1) line1(:,46:50)], ...  % 1.10  45-52   Second Time Derivative of Mean Motion (decimal point assumed)
    line1(:,51:52), ... % power of the Mean Motion Double Dot
    [line1(:,54) repmat('0.',70,1) line1(:,55:59)], ... % 1.11  54-61   BSTAR drag term (decimal point assumed)
    line1(:,60:61), ... % power of the BSTAR term
    line1(:,63), ...    % 1.12  63      Ephemeris type
    line1(:,65:68), ... % 1.13  65-68   Element number
    line1(:,69), ...    % 1.14  69      Checksum (Modulo 10) (Letters, blanks, periods, plus signs = 0; minus signs = 1)
    line2(:,1), ...     % 2.1   01      Line Number of Element Data
    line2(:,3:7), ...   % 2.2   03-07   Satellite Number
    line2(:,9:16), ...  % 2.3   09-16   Inclination [Degrees]
    line2(:,18:25), ... % 2.4   18-25   Right Ascension of the Ascending Node [Degrees]
    [repmat('0.',70,1) line2(:,27:33)], ... % 2.5   27-33   Eccentricity (decimal point assumed)
    line2(:,35:42), ... % 2.6   35-42   Argument of Perigee [Degrees]
    line2(:,44:51), ... % 2.7   44-51   Mean Anomaly [Degrees]
    line2(:,53:63), ... % 2.8   53-63   Mean Motion [Revs per day]
    line2(:,64:68), ... % 2.9   64-68   Revolution number at epoch [Revs]
    line2(:,69), ...    % 2.10   69     Checksum (Modulo 10)
    'VariableNames',{'satname','line1','SatelliteNumber', ...
    'classification','LaunchYear','LaunchNumber', ...
    'LaunchItem', 'EpochYear', 'EpochDay', 'MeanMotionDot_orbit_per_day2', ...
    'MMDDMantissa','MMDDPower','BStarMantissa','BStarPower', ...
    'EmpemerisType', 'ElementNumber', 'Checksum1', 'line2', ...
    'SatNumber','Inclination','RAAN_deg', 'Eccentricity', ...
    'w_deg', 'M_deg', 'MeanMotion_orbit_per_day', 'revNum', 'Checksum2'});
tmpTable.line1 = [];
tmpTable.line2 = [];
tmpTable.SatNumber = []; % duplication
% silly work-around to convert char string to doubles
writetable(tmpTable,'tmp.csv');
TLE = readtable('tmp.csv');
clear tmpTable line1 line2 satname
TLE.LaunchYear(TLE.LaunchYear>56) = TLE.LaunchYear(TLE.LaunchYear>56) + 1900;
TLE.LaunchYear(TLE.LaunchYear<57) = TLE.LaunchYear(TLE.LaunchYear<57) + 2000;
TLE.EpochYear(TLE.EpochYear>56) = TLE.EpochYear(TLE.EpochYear>56) + 1900;
TLE.EpochYear(TLE.EpochYear<57) = TLE.EpochYear(TLE.EpochYear<57) + 2000;
TLE.MeanMotionDoubleDot_orbit_per_day3 = TLE.MMDDMantissa.*10.^TLE.MMDDPower;
TLE.BStar_per_Rearth = TLE.BStarMantissa.*10.^TLE.BStarPower;
TLE.MMDDMantissa = [];
TLE.MMDDPower = [];
TLE.BStarMantissa = [];
TLE.BStarPower = [];

% Mean Motion (n) is defined as the number of orbits (revolutions) the 
% satellite completes about the Earth in exactly 24 hours (one solar day)
% (in theory, there are between 0 and 17 orbits per solar day)
TLE.Period_s = 86400.0./TLE.MeanMotion_orbit_per_day;
mu = 398600.4418; % (km^3/s^2) standard gravitational parameter for the earth
TLE.SemiMajorAxis_km = (mu./(TLE.MeanMotion_orbit_per_day*2*pi./86400).^2).^(1/3);

% Apsis - more orbital parameters
TLE.Apogee_km = TLE.SemiMajorAxis_km.*(1.0 + TLE.Eccentricity);
TLE.Perigee_km = TLE.SemiMajorAxis_km.*(1.0 - TLE.Eccentricity);

end
