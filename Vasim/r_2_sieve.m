clear;
Table=readtable('orbital_paramters.xlsx');
global mu Table_n ;
mu = 398600;
Table_n=[];
Table_d = [];
r_parent=table2array(Table(1,1:3));
v_parent=table2array(Table(1,4:6));
r = table2array(Table(2:end,1:3));%[orbitalparams.(1)(i:i)  orbitalparams.(2)(i:i)  orbitalparams.(3)(i:i)]; %orbitalparams(i,1:3);
v = table2array(Table(2:end,4:6));%[orbitalparams.(4)(i:i)  orbitalparams.(5)(i:i)  orbitalparams.(6)(i:i)]; %orbitalparams(i,4:6);
dt=5;
j=0;
k=0;
for i=1:length(r(:,1))
    Vsc(i,:)=sqrt(2*mu/norm(r(i,:)));
end
ro=r-r_parent;
vo=v-v_parent;
Rcr=0.001;%Critical Radius of the parent object in km
Rth=Rcr+Vsc*dt;
Racc=Rcr+9.81*10^(-3)*dt^2;%g is in km/s^2
for i=1:length(r(:,1))
    Rth_fine(i,:)=Racc+norm((dt/2)*(ro(i,:)*vo(i,:)'/norm(vo(i,:))));
    if norm(ro)^2<Rth_fine(i,:)^2
        j=j+1;
        Table_n(j,:)=[r(i,:) v(i,:)];
    else
        k=k+1;
        Table_d(k,:)=[r(i,:) v(i,:)];
    end
end