tle = fopen('sample.txt');
table = table2array(Table);
len = height(n_Table3);
index = [];
Norad = [];
for i = 1:height(n_Table3)
    index(i) = find(table(:,:) == n_Table3(i));
    fseek(tle, 140*(index(i)-1) + (index(i)-1), 'bof');
    line1 = fgetl(tle);
    Norad(i) = str2double(strtrim(line1(3:7)));
end