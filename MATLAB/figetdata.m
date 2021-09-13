function [xCell, yCell] = figetdata(figFile)

	%Created by Yang Jiashu @ LUH
	%2021-09-13

	%get data from '*.fig' files created by MATLAB
	%---------------------------------------------------
	% figFile: the name of the '.*fig' file to get data from;
	% xCell: x data in a cell format, each element for a curve
	% yCell: y data in a cell format, each element for a curve

	open(figFile);

	lines  = get(gca, 'Children');

	xCell  = get(lines, 'xData');
	yCell  = get(lines, 'YData');

end