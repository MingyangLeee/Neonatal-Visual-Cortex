function tline=my_readtext(text)
    fid = fopen(text,'r');
    i = 1;
    while feof(fid) == 0   
        tline{i,1} = fgetl(fid);    
        i = i+1;
    end
    fclose(fid);