function fncell = findfilepartname(fileNameP, pathstr)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% By Jiashu Yang
% Date: 2021-02-20 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%find files in a give folder with a starting part of the file name
    if ~strcmp(pathstr(end), '*')
        fileNameP = [fileNameP, '*'];
    end

    if ~isempty(pathstr)
        if ~strcmp(pathstr(end), '/') && ~strcmp(pathstr(end), '\')
            pathstr = [pathstr, '/'];
        end
        pathstrfull = [pathstr, fileNameP];
    else
        pathstrfull = fileNameP;
    end

    list = dir(pathstrfull);

    n    = length(list);

    fncell = cell(n,1);

    for ii = 1:1:n
        fncell{ii} = list(ii).name;
    end

end