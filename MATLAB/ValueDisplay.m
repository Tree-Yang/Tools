function ValueDisplay(x, name, groupsize)

    %display output information on command window
    %the vector to be displayed should be numeric type
    %a name will be generated according to the name of the vector 
    %   and the number of elements in the vector
    
    %by Yang, Jia-Shu; 2020-06-06

    if ~isa(name, 'char')
        error('name should be a string!');
    end
    if ~isa(x,'numeric')
        error('x should be a vector in numeric type!');
    end

    %length of values to be displayed
    n = length(x);
    %number of groups
    n_group = ceil(n/groupsize);
    %number of elements in the last group
    n_tail  = n - (n_group-1)*groupsize;
    if n == 1
        fprintf([name, '=', num2str(x,'%15.6f'), '\n']);
    else
        %for each group
        for ii = 1:1:n_group
            str = [];
            if ii ~= n_group    %for group 1:n_group-1
                for jj = 1:1:groupsize
                    n_tmp = (ii-1)*groupsize+jj;
                    if jj ~= groupsize
                        str0 = [name, num2str(n_tmp), '=', num2str(x(n_tmp),'%15.6f'), ';\t'];
                    else
                        str0 = [name, num2str(n_tmp), '=', num2str(x(n_tmp),'%15.6f'), ';\n'];
                    end
                    str = [str, str0];
                end
            else    %for the last group
                for jj = 1:1:n_tail
                    n_tmp = (ii-1)*groupsize+jj;
                    if jj ~= n_tail
                        str0 = [name, num2str(n_tmp), '=', num2str(x(n_tmp),'%15.6f'), ';\t'];
                    else
                        str0 = [name, num2str(n_tmp), '=', num2str(x(n_tmp),'%15.6f'), '.\n'];
                    end
                    str = [str, str0];
                end
            end

            %dispaly the information
            fprintf(str);
        end
    end

end