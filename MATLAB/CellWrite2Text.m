function [status] = CellWrite2Text(TextCell, TextFileName)

  %InpRead: To write context in the cell by row.
  % -----------------------------------------------------
  % Input:
  % TextFileName: A String,the file name to be write.
  % TextCell:     A cell, containing all the text.
  % Output:
  % status: status for fclose, equals to 0 if file close normally.
  % -----------------------------------------------------
  
  Fpn = fopen (TextFileName, 'wt');     % Open the files. 'w' means writing perminssion and 't' means text mode.
  n_row = size(TextCell,1);             %Get the total number of lines in cell.
  for ii = 1 : 1 : n_row
    fprintf(Fpn, '%s\n', TextCell{ii}); %Write the cell into file by row.
  end
  status = fclose(Fpn);

end