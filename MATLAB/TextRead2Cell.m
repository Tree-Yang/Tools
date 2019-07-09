function [ TextCell ] = TextRead2Cell( TextFileName,UpLimRowNum )

  %InpRead: To read all context in the file by row, and a cell will be returned.
  % -----------------------------------------------------
  % Input:
  % TextFileName: A String,the name of the file to be read.
  % UpLimRowNum:  A integer, equal to or more than the largest row number.
  %               Used to initialize the cell
  % Output:
  % TextCell:     A cell, containing all the text in the file.
  % -----------------------------------------------------

  if nargin == 1 || UpLimRowNum == 0
    UpLimRowNum = 10000;
  end

  Fpn = fopen(TextFileName, 'rt'); % Open the files. 'r' means reading permission and 't' means text mode.
  ii = 0;                          % Initialize a index for the row number.
  TextCell = cell(UpLimRowNum,1);  % Initialize a cell to store the text read from the file.

  while feof(Fpn) ~= 1             % When the pointer comes to the end of the file, Fpn = 1; otherwise, Fpn = 0.
    ii = ii + 1;                   % All rows in the file will be read.
    TextCell{ii,1} = fgetl(Fpn);   % Read the next row.
  end

  if ii < UpLimRowNum
    TextCell = TextCell(1:ii,1);   % Remove empty elements in TextCell
  end

  fclose(Fpn);                     % Close the text file

end