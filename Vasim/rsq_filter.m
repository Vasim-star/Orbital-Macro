Rcr = 5;
n_Table = [];
n_Table2 = [];
n_Table3 = [];
j=0; y=0; x=0;
dt=300;
Rth = Rcr + 10.7386 * dt;
for c = 1:20
    for i = c:20:height(Table_n)
        if(abs(Table_n(i,1) - rinspire(1)) < Rth && abs(Table_n(i,2)  - rinspire(2)) < Rth && abs(Table_n(i,3)  - rinspire(3)) < Rth)
            j=j+1;
            n_Table(j, :) = Table_n(i, :);
        end
    end
    for i = c:20:height(n_Table)
        if(sqrt((n_Table(i,1) - rinspire(1))^2 + (n_Table(i,2) - rinspire(2))^2 + (n_Table(i,3) - rinspire(3))^2) < Rth)
            y = y + 1;
            n_Table2(y, :) = n_Table(i, :);
        end
    end
    for i = c:20:height(n_Table2)
        V = n_Table2(i, 4:6) - vinspire;
        R = n_Table2(i, 1:3) - rinspire;
        if(sqrt(norm(R)^2 - dot(R,V)^2/norm(V)^2) < Rcr)
            x = x + 1;
            n_Table3(x, :) = n_Table2(i, :);
        end
    end
end