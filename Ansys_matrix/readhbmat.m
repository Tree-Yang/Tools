function [matrix, right_term] = readhbmat(file_name)
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % This function read matrix exported with Ansys 'HBMAT' command (Stiffness/mass/damping matrix 
    %       in Harwell-Boeing format) into MATLAB sparse matrix
    % !The order of DOF is optimized by the Ansys, so the order of the DOF may be different from
    %   !the origin order by the node number  
    % Code by Yang, Jiashu
    % 2021-08-06, at Insititute for Risk and Reliability, Leibniz University Hannover
    % Email: jiashuyang@tongji.edu.cn
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    readapproach = 1;

    %open file
    hbmat_id = fopen(file_name);

    %read the head of the exported file from Ansys
    %---------------------------------------------------------------------------------
    %the first line: matrix name
    [~] = fgetl(hbmat_id); 
    
    %the second line
    x2 = fscanf(hbmat_id, '%d', 5);
    %the number of rows in the file (except the head lines (5))
    % total_row_num = x2(1);
    %number of column indexes, equals to the size of the matrix plus one
    num_col_ind   = x2(2);
    %number of row indexes, equals to the number of nonzero elements in the matrix
    num_row_ind   = x2(3);
    %number of nonzero elements in the matrix
    num_val       = x2(4);
    %number of the right term (load vector), and therefore, equals to the number of row/column of the matrix
    num_right_term = x2(5);

    %the third line
    %type of the matrix
    mattype = fscanf(hbmat_id, '%s', 1);
    %{
        The type of the matrix is identified by three characters:
        The first character may be 'R', 'C', or 'P', where
                'R' stands for 'real-value matrix', 'C' means 'complex-value matrix',
                and 'P' means no matrix elements are included.
        The second character may be 'S', 'U', 'H', 'Z', 'R', where 'S' implies 'symmetric matrix',
                'U' means 'asymmetric matrix', 'H' indicates 'Hermitian matrix', 'Z' stands for 
                'ill-conditioned matrix', and 'R' means 'band matrix'.
        The third character may be 'A' or 'E', where 'A' implies 'assembled matrix' and 'E' means 
                'element matrix'.
        
        Usually, for global stiffness/mass/damping matrix, the type is 'RSA'.
        For symmetric matrix, the Harwell-Boeing format only record the lower triangular elements of the matrix
    %}
    if strcmpi(mattype(1), 'C')
        warning('The matrix contains complex-value element!');
        if ~strcmpi(mattype(2), 'S')
            warning('The matrix may be asymmetric!');
            if strcmpi(mattype(3), 'E')
                warning('Element matrix rather than global matrix are exported');
            end
        end
    end

    x = fscanf(hbmat_id, '%d', 4);
    %number of row of the matrix
    nrow   = x(1);
    %number of column of the matrix
    ncol   = x(2);
    if nrow ~= ncol
        warning('The matrix is not a square matrix!');
    end
    %number of non-zero element in the matrix
    nnzero = x(3);
    %number of entries of elements, zero for gloabl matrix
    %neltvl = x(4);
    [~] = fgetl (hbmat_id);

    %the fourth line: format of values
    [~] = fgetl (hbmat_id);

    %the fifth line: information about right-hand term (load vector)
    if num_right_term ~= 0
        [~] = fgetl (hbmat_id);
    end

    %read the indexes of the values
    %---------------------------------------------------------------------------------
    %index of diagonal elements of the matrix
    %   Since only lower triangular elements of the matrix, the index of diagonal elements indicate
    %       the start of a new column
    diag_ind = fscanf(hbmat_id, '%d', num_col_ind);
    %index of column of the nonzero elements
    con_ind = zeros(num_val, 1);
    %* ATTENTION: diag_ind(ii+1)-1 should be equal to vai_num
    %* ATTENTION: length(diag_ind)-1 should be equal to ncol
    for ii = 1 : 1 : length(diag_ind)-1
        con_ind(diag_ind(ii):diag_ind(ii+1)-1, :) = ii * ones(diag_ind(ii+1)-diag_ind(ii), 1);
    end

    %read the row indexes of nonzero elements
    row_ind = fscanf(hbmat_id, '%d', num_row_ind);

    %read the values of nonzero elements
    %---------------------------------------------------------------------------------
    if readapproach ==  1
        %++++++++++++++++++++++++++++++++++
        %approach 1:
        [~] = fgetl(hbmat_id);
        vals = zeros(nnzero, 1);
        for kk = 1:1:nnzero
            val_str  = fgetl(hbmat_id);
            val_str  = strrep(val_str, 'D', 'e');
            val_str  = strrep(val_str, 'd', 'e');
            vals(kk) = str2double(val_str);
        end
    elseif readapproach == 2
        %++++++++++++++++++++++++++++++++++
        %approach 2:
        vals_str_mat = fscanf(hbmat_id, '%f %c %c %d', [4, num_val]);
        for jj = 1:num_row_ind
            if strcmpi(vals_str_mat(3,jj), '-')
                vals_str_mat(4,jj) = -vals_str_mat(4,jj);
            end
        end
        vals = vals_str_mat(1,:) .* (10.^vals_str_mat(4,:));
        vals = vals';
    end

    matrixL = sparse(row_ind, con_ind, vals);
    matrix  = matrixL + matrixL';

    matrix(logical(eye(nrow))) = 1/2 * diag(matrix);

    %read the right-hand term
    %---------------------------------------------------------------------------------
    if readapproach ==  1
        %++++++++++++++++++++++++++++++++++
        %approach 1:
        right_term = zeros(num_right_term,1);
        if num_right_term ~= 0
            for jj = 1 : 1 : num_right_term
                right_str      = fgetl(hbmat_id);
                right_str      = strrep(right_str, 'D', 'e');
                right_str      = strrep(right_str, 'd', 'e');
                right_term(jj) = str2double(right_str)';
            end
        end
    elseif readapproach == 2
        %++++++++++++++++++++++++++++++++++
        %approach 2:
        if num_right_term ~= 0
            right_str_mat = fscanf(hbmat_id, '%f %c %c %d', [4,num_right_term]);
            right_term    = right_str_mat(1,:) .* (10.^right_str_mat(4,:));
            right_term    = right_term';
        else
            right_term    = [];
        end
    end

    %close file
    fclose(hbmat_id); 
end
