function DataSave(file_name)
    %input:
    %file_name: a string as initial file name

    time_arr = fix(clock);                              %get current time as array
    time_str = sprintf('_%d_%d_%d_%d_%d_%d.',time_arr); %turn time into string
    fn       = [file_name, time_str, 'mat'];           %file name according to current time
    save(fn,'-v7.3');                                   %save all the data to *.mat
end