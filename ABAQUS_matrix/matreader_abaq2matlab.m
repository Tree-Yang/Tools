function strucMCKMat = matreader_abaq2matlab(fileName, option)
% % a function to read mass/damping/stiffness matrix from output of Abaqus
%=================================================================================================
% % By Yang, Jia-Shu
% % Date: 2021-03-07
%=================================================================================================
% Input variables:
%----------------------------------------------------
% fileName : a string indicating which file to read.
%=================================================================================================
% Output variables:
%----------------------------------------------------
% strucMCKMat: mass/damping/stiffness matrix
%=================================================================================================
    if nargin == 1
        option = 'sparse';
    end

    if ~ischar(fileName) && ~isstring (fileName)
        error('The input of function  "matreader_abaq2matlab" should be a string! ');
    end
    
    %read all data from the file indicated by the input
    dataAll = readmatrix(fileName, 'FileType', 'text');
    
    %number of node
    idNodeRow   = dataAll(:,1);
    idNodeCol   = dataAll(:,3);
    
    %number of degree of freedom
    idDofRow    = dataAll(:,2);
    idDofCol    = dataAll(:,4);
    
    %non-zero matrix entry
    nonZeroEntry  = dataAll(:,5);
    nNonZeroEntry = length(nonZeroEntry);
    
    %lables and number of nodes
    idNodeUniRow = unique(idNodeRow);
    nNodeRow     = length(idNodeUniRow);
    idNodeUniCol = unique(idNodeCol);
    nNodeCol     = length(idNodeUniCol);
    if nNodeRow ~= nNodeCol
        error('The number of nodes is not compatiable!');
    end
    
    %the number of degrees of freedom of each node
    nDofEachNodeRow = zeros(nNodeRow, 1);
    nDofEachNodeCol = zeros(nNodeRow, 1);
    parfor ii = 1:nNodeRow
        nDofEachNodeRow(ii) = max(idDofRow(idNodeRow == idNodeUniRow(ii)));
    end
    parfor ii = 1:nNodeCol
        nDofEachNodeCol(ii) = max(idDofCol(idNodeCol == idNodeUniCol(ii)));
    end
    
    %the location of each entry
    locRow = zeros(nNonZeroEntry, 1);
    locCol = zeros(nNonZeroEntry, 1);
    parfor jj = 1:nNonZeroEntry
        locRow(jj) = sum((idNodeUniRow < idNodeRow(jj)) .* nDofEachNodeRow) + idDofRow(jj);
        locCol(jj) = sum((idNodeUniCol < idNodeCol(jj)) .* nDofEachNodeCol) + idDofCol(jj);
    end
    
    %Construct matrix
    strucMCKMat = sparse(locRow, locCol, nonZeroEntry);
    
    if strcmpi(option, 'full')
        strucMCKMat = full(strucMCKMat);
    end

    %Make a symmetrical matrix
    strucMCKMat1 = strucMCKMat + strucMCKMat';
    strucMCKMat1(logical(eye(size(strucMCKMat)))) = diag(strucMCKMat);
    strucMCKMat = strucMCKMat1;

end