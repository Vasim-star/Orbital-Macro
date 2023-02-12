clear;
Table=readtable('orbital_paramters.xlsx');
global mu Table_n ;
mu = 398600;
Table_n=[];
Table_d = [];
r = table2array(Table(:,1:3));%[orbitalparams.(1)(i:i)  orbitalparams.(2)(i:i)  orbitalparams.(3)(i:i)]; %orbitalparams(i,1:3);
v = table2array(Table(:,4:6));%[orbitalparams.(4)(i:i)  orbitalparams.(5)(i:i)  orbitalparams.(6)(i:i)]; %orbitalparams(i,4:6);
for i = 1:4152
    coe = coe_from_sv(r(i,:), v(i,:));
    pg(i) = coe(7) * (1 - coe(2));
    ag(i) = coe(7) * (1 + coe(2));
end
j=0;
k=0;
c=1;
for i = 1:4152
    if((pg(1) >= pg(i) && ag(1) <= ag(i)) || (pg(1) <= pg(i) && ag(1) >= ag(i)))
%         fprintf("Proceed vector " + i + " to next filter \n");
        k=k+1;
        Table_n(k, :) = [r(i,:) v(i,:)];
    else 
        if(abs(pg(1)-pg(i)) < 1  || abs(ag(1)-ag(i)) < 1)
%             fprintf("Proceed vector " + i + " to next filter \n");
            k=k+1;
            Table_n(k, :) = [r(i,:) v(i,:)];

        else
            j=j+1;
%             fprintf("Discard the vector: " + i +"\n");
            Table_d(j, :) = [r(i,:) v(i,:)];

        end
    end
end