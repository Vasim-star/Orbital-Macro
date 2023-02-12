% Table=readtable('Orbital_parameters.xlsx');
global mu;
mu = 398600;
rinspire = [-6908.648657	-248.34867	0.042116784];
vinspire = [-0.025134758	0.997198103	7.525063589];
coeinsp = coe_from_sv(rinspire, vinspire);
pginsp = coeinsp(7) * (1 - coeinsp(2));
aginsp = coeinsp(7) * (1 + coeinsp(2));
Table_n=[];
r = Valmainrv(:,1:3);
v = Valmainrv(:,4:6);
for i = 1:20:length(r(:,1))
    coe = coe_from_sv(r(i,:), v(i,:));
    pg(i) = coe(7) * (1 - coe(2));
    ag(i) = coe(7) * (1 + coe(2));
end
k=0;
for i = 1:20:length(r(:,1))
    if(max(pg(i),pginsp) - min(ag(i), aginsp) < 5 )
%         fprintf("Proceed vector " + i + " to next filter \n");
        for j = i:(i+19)
            k=k+1;
            Table_n(k, :) = [r(j,:) v(j,:)];
        end
    end
end