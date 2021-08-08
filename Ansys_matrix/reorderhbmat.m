function matrix = reorderhbmat(matrix, mapping_file)

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function reset the order of the matrix exported with Ansys 'HBMAT' command 
    %       (Stiffness/mass/damping matrix in Harwell-Boeing format)
    % Code by Yang, Jiashu
    % 2021-08-07, at Insititute for Risk and Reliability, Leibniz University Hannover
    % Email: jiashuyang@tongji.edu.cn
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    %open the mapping file
    mappingid  = fopen(mapping_file);

    %the first line: head of the file
    [~]        = fgetl(mappingid);

    nequ       = size(matrix, 1);

    equ_id     = zeros(nequ, 1);
    node_id    = zeros(nequ, 1);
    dof_id_str = cell(nequ, 1);

    ii = 0;
    dim = 2;
    while ~feof(mappingid)
        ii             = ii + 1;
        line           = fgetl(mappingid);
        line           = strip(line);
        strcell        = strsplit(line);
        equ_id(ii)     = str2double(strcell{1});
        node_id(ii)    = str2double(strcell{2});
        dof_id_str{ii} = strcell{3};
        if dim == 2 && strcmpi(strcell{3}, 'UZ')
            dim = 3;
        end
    end

    %-----------------------------------------------------------------------------------------------
    dof_id = zeros(nequ,1);
    if dim == 2
        % for 2D structures
        %---------------------------------------
        for jj = 1 : 1 : nequ
            switch dof_id_str{jj}
            case 'UX'
                dof_id(jj) = 1;
            case 'UY'
                dof_id(jj) = 2;
            case 'ROTZ'
                dof_id(jj) = 3;
            otherwise
                error('Please check the type of element and DOF labels!');
            end
        end
    elseif dim == 3
        % for 3D structures
        %---------------------------------------
        for jj = 1 : 1 : nequ
            switch dof_id_str{jj}
            case 'UX'
                dof_id(jj) = 1;
            case 'UY'
                dof_id(jj) = 2;
            case 'UZ'
                dof_id(jj) = 3;
            case 'ROTX'
                dof_id(jj) = 4;
            case 'ROTY'
                dof_id(jj) = 5; 
            case 'ROTZ'
                dof_id(jj) = 6;
            otherwise
                error('Please check the type of element and DOF labels!');
            end
        end
    end
    %-----------------------------------------------------------------------------------------------


    node_list  = unique(node_id);
    n_node     = length(node_list);
    ord_origin = zeros(nequ, 1);
    dof_loc    = 0;
    for ii = 1:1:n_node
        %equation with respect to node ii
        equid_node_i   = find(node_id == node_list(ii));
        %number of DOF of node ii
        ndof_node_i    = length(equid_node_i);
        %DOF lables of node ii
        dof_node_i     = dof_id(equid_node_i);
        %the original order of equations (DOFs) corresponding to node ii
        [~, ind]       = sort(dof_node_i, 'ascend');
        %reset the order
        equ_ord_origin = equid_node_i(ind);
        ord_origin(equ_ord_origin) = dof_loc+1 : dof_loc+ndof_node_i;

        dof_loc        = dof_loc + ndof_node_i;
    end


    tmp1 = sort(ord_origin, 'ascend');
    tmp2 = (1:1:nequ)';
    if sum(abs(tmp1 - tmp2)) ~= 0 
        warning('Not all columns/rows of the matrix are included!');
    end

    [~, ord_reset] = sort(ord_origin, 'ascend');
    matrix         = matrix(ord_reset,ord_reset);


    %close file
    fclose(mappingid);
end
