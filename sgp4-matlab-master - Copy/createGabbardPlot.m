%% *create Gabbard Diagram*
% close all
% clear all 
% clc
%% *history*
%  20190414 mnoah original code
%% *start*

% average-ish Earth radius
Rearth_km = 6371.23;

TLE = readTLE('2019-006.txt');
figure('Color','White','Units','Pixels','Position',[1 100 800 800]);
plot(TLE.Period_s(2:end)/60.0,TLE.Apogee_km(2:end)-Rearth_km,'or','MarkerFaceColor','r','DisplayName','Debris Apogee');
hold on;
plot(TLE.Period_s(2:end)/60.0,TLE.Perigee_km(2:end)-Rearth_km,'ob','MarkerFaceColor','b','DisplayName','Debris Perigee');
plot(TLE.Period_s(1)/60.0,TLE.Apogee_km(1)-Rearth_km,'pk','MarkerFaceColor','k','MarkerSize',20,'DisplayName','Microsat-R Apogee');
plot(TLE.Period_s(1)/60.0,TLE.Perigee_km(1)-Rearth_km,'p','Color',[0 0.75 0],'MarkerFaceColor',[0 0.75 0],'MarkerSize',20,'DisplayName','Microsat-R Perigee');
plot([85 115],[100 100],'--','Color',[0 0.6 0.5],'DisplayName','Atmosphere Re-entry Line');
xlabel('Period [minutes]');
ylabel('Apis Height Above <R_{Earth}> [km]');
set(gca,'fontsize',14,'fontweight','bold');
k = legend('location','northwest');
