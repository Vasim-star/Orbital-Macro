%  -----------------------------------------------------------------------------
% 
%                            procedure twoline2rv
% 
%   this procedure converts the two line element set character string data to
%     variables and initializes the sgp4 variables. several intermediate varaibles
%     and quantities are determined. note that the result is a structure so multiple
%     satellites can be worked simaltaneously without having to reinitialize. the
%     verfiication mode is an important option that permits quick checks of any
%     changes to the underlying technical theory. this option works using a
%     modified tle file in which the start, stop, and delta time values are
%     included at the end of the second line of data.
% 
% Author: 
%   Jeff Beck 
%   beckja@alumni.lehigh.edu
%   1.1 (dec 5, 2006) - Corrected line 1, char 45 adjust. jab
%   1.0 (aug 6, 2006) - update for paper dav
% original comments from Vallado C++ version:
%   author        : david vallado                  719-573-2600    1 mar 2001
% 
%   inputs        :
%   longstr1    - TLE character string (min 69 char)
%   longstr2    - TLE character string (min 69 char)
%   typerun     - character for mode of SGP4 execution 
%                   'c' = catalog mode (propagates at 20 min timesteps from
%                           one day before epoch to one day after)
%                   'v' = verification mode (propagates according to start,
%                           stop, and timestep specified in longstr2)
%                   'n' = normal mode (prompts user for start, stop, and
%                           timestep for propagation)
% 
%   outputs       :
%     satrec      - structure containing all the sgp4 satellite information
% 
%   coupling      :
%     getgravconst
%     days2mdhms  - conversion of days to month, day, hour, minute, second
%     jday        - convert day month year hour minute second into julian date
%     sgp4init    - initialize the sgp4 variables
% 
%   references    :
%     norad spacetrack report #3
%     vallado et al. 2005
%  ----------------------------------------------------------------------------*/

function [satrec, startmfe, stopmfe, deltamin] = twoline2rv(whichconst, longstr1, longstr2, typerun,Tb,deltamin)

    global tumin radiusearthkm xke j2 j3 j4 j3oj2  

    rad      =   57.29577951308230;     % [deg/rad]
    xpdotp   =  229.1831180523293;      % = 1440/(2*pi)  [rev/day]/[rad/min]  

    revnum = 0; 
    elnum  = 0;
    year   = 0; 
    satrec.error = 0;

%     // set the implied decimal points since doing a formated read
%     // fixes for bad input data values (missing, ...)
    longstr1
    fprintf('Running')
    for (j = 11:16)
        if (longstr1(j) == ' ')
            longstr1(j) = '_';
        end
    end

    if (longstr1(45) ~= ' ')
        longstr1(44) = longstr1(45);
    end
    longstr1(45) = '.';
     
    if (longstr1(8) == ' ')
        longstr1(8) = 'U';
    end

    if (longstr1(10) == ' ')
        longstr1(10) = '.';
    end

    for (j = 46:50)
        if (longstr1(j) == ' ')
            longstr1(j) = '0';
        end
    end
    if (longstr1(52) == ' ')
        longstr1(52) = '0';
    end
    if (longstr1(54) ~= ' ')
        longstr1(53) = longstr1(54);
    end
    longstr1(54) = '.';

    longstr2(26) = '.';
     
    for (j = 27:33)
        if (longstr2(j) == ' ')
            longstr2(j) = '0';
        end
    end
     
    if (longstr1(63) == ' ')
        longstr1(63) = '0';
    end

    if ((length(longstr1) < 68) || (longstr1(68) == ' '))
        longstr1(68) = '0';
    end

    % parse first line
    carnumb = str2num(longstr1(1))
    satrec.satnum = str2num(longstr1(3:7))
    classification = longstr1(8);
    intldesg = longstr1(10:17);
    satrec.epochyr = str2num(longstr1(19:20));
    satrec.epochdays = str2num(longstr1(21:32));
    satrec.ndot = str2num(longstr1(34:43));
    satrec.nddot = str2num(longstr1(44:50));
    nexp = str2num(longstr1(51:52));
    satrec.bstar = str2num(longstr1(53:59));
    ibexp = str2num(longstr1(60:61));
    numb = str2num(longstr1(63));
    elnum = str2num(longstr1(65:68));
 
    % parse second line
    if (typerun == 'v')
        cardnumb = str2num(longstr2(1));
        satrec.satnum = str2num(longstr2(3:7));
        satrec.inclo = str2num(longstr2(8:16));
        satrec.nodeo = str2num(longstr2(17:25));
        satrec.ecco = str2num(longstr2(26:33));
        satrec.argpo = str2num(longstr2(34:42));
        satrec.mo = str2num(longstr2(43:51));
        satrec.no = str2num(longstr2(52:63));
        %revnum = str2num(longstr2(64:68));
        startmfe = str2num(longstr2(70:81));        
        stopmfe  = str2num(longstr2(83:96)); 
        deltamin = str2num(longstr2(97:105)); 
    else
        cardnumb = str2num(longstr2(1));
        satrec.satnum = str2num(longstr2(3:7));
        satrec.inclo = str2num(longstr2(8:16));
        satrec.nodeo = str2num(longstr2(17:25));
        satrec.ecco = str2num(longstr2(26:33));
        satrec.argpo = str2num(longstr2(34:42));
        satrec.mo = str2num(longstr2(43:51));
        satrec.no = str2num(longstr2(52:63));
        %revnum = str2num(longstr2(64:68));
    end

%     // ---- find no, ndot, nddot ----
    satrec.no   = satrec.no / xpdotp; %//* rad/min
    satrec.nddot= satrec.nddot * 10.0^nexp;
    satrec.bstar= satrec.bstar * 10.0^ibexp;

%     // ---- convert to sgp4 units ----
    satrec.a    = (satrec.no*tumin)^(-2/3);                % [er]
    satrec.ndot = satrec.ndot  / (xpdotp*1440.0);          % [rad/min^2]
    satrec.nddot= satrec.nddot / (xpdotp*1440.0*1440);     % [rad/min^3]

%     // ---- find standard orbital elements ----
    satrec.inclo = satrec.inclo  / rad;
    satrec.nodeo = satrec.nodeo / rad;
    satrec.argpo = satrec.argpo  / rad;
    satrec.mo    = satrec.mo     / rad;

    satrec.alta = satrec.a*(1.0 + satrec.ecco*satrec.ecco) - 1.0;
    satrec.altp = satrec.a*(1.0 - satrec.ecco*satrec.ecco) - 1.0;

%     // ----------------------------------------------------------------
%     // find sgp4epoch time of element set
%     // remember that sgp4 uses units of days from 0 jan 1950 (sgp4epoch)
%     // and minutes from the epoch (time)
%     // --------------------------------------------------------------

%     // input start stop times manually
     if ((typerun ~= 'v') && (typerun ~= 'c'))
         startmfe = input('input start mfe: ');
         stopmfe  = input('input stop mfe: ');
         deltamin = input('input time step in minutes: ');
     end
   
%     // perform complete catalog evaluation
     if (typerun == 'c')
%          startmfe =  -1440.0;
%          stopmfe  =  1440.0;
%          deltamin = 20.0;
         startmfe =  0;
         stopmfe  =  Tb;
%         deltamin = Tb;
     end

%     // ------------- temp fix for years from 1950-2049 ----------------
%     // ------ correct fix will occur when year is 4-digit in 2le ------
     if (satrec.epochyr < 50)
         year= satrec.epochyr + 2000;
       else
         year= satrec.epochyr + 1900;
     end

     [mon,day,hr,minute,sec] = days2mdh ( year,satrec.epochdays );
     satrec.jdsatepoch = jday( year,mon,day,hr,minute,sec );

%     // ------------- initialize the orbit at sgp4epoch --------------
     sgp4epoch = satrec.jdsatepoch - 2433281.5; % days since 0 Jan 1950
% JAB (060816): Changed back to using satrec to pass arguments.
%      [satrec] = sgp4init(whichconst, satrec, satrec.bstar, satrec.ecco, sgp4epoch, ...
%          satrec.argpo, satrec.inclo, satrec.mo, satrec.no, satrec.nodeo);
     [satrec] = sgp4init(whichconst, satrec, sgp4epoch);

     