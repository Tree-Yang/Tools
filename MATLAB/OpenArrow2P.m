function OpenArrow2P(start_point, end_point, ratio_yx, arr_size, line_color, line_style, line_width, arr_color, arr_width, arr_style)
    %Input:
    %------------------------------------------------
    % start_point: line from whom
    % end_point: line to whom (the point arrow pointing to)
    % arr_color: color of the solid arrow
    % line_color: color of the line
    % line_style: style of the line (not the arrow)
    % arr_size: size of the solid arrow
    % line_width: width of the line
    % ratio_yx: length ratio of y axis to x axis
    % arrow_style: line style of the arrow
    % arrow_width: line style of the arrow
    %------------------------------------------------

    %number of input
    switch nargin
        case 2
            ratio_yx   = 1;
            arr_size   = 2;
            line_color = [0 0.4470 0.7410]; line_style = '-'; line_width = 1;
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 3
            arr_size   = 2;
            line_color = [0 0.4470 0.7410]; line_style = '-'; line_width = 1;
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 4
            line_color = [0 0.4470 0.7410]; line_style = '-'; line_width = 1;
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 5
            line_style = '-'; line_width = 1;
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 6
            line_width = 1;
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 7
            arr_color  = line_color; arr_width  = line_width; arr_style  = line_style;
        case 8
            arr_width  = line_width; arr_style  = line_style;
        case 9
            arr_style  = line_style;
    end
    
    k     = 0.01;                                   % length ratio, arr_size*k is the real size of arrow line

    theta0 = pi / 8;                                 % half angle of the arrow
    theta = atan(tan(theta0)*ratio_yx);

    A1 = [cos(theta), -sin(theta);
        sin(theta), cos(theta)];                    % rotate matrix 1
    A2 = [cos(-theta), -sin(-theta);
        sin(-theta), cos(-theta)];                  % rotate matrix 2
    
    arrow           = start_point' - end_point';    % direction of the line(base line for the arrow)
    arrow           = arrow / norm(arrow) * arr_size;       % set length of base line to a fixed value
    
    arrow_1         = A1 * arrow;                   % rotate the base line
    arrow_2         = A2 * arrow;
    arrow_1         = k * arrow_1 + end_point';     % arrow line 1
    arrow_2         = k * arrow_2 + end_point';     % arrow line 2
    
    hold on;
    plot([start_point(1), end_point(1)], [start_point(2), end_point(2)],'Color',line_color,'LineStyle',line_style,'LineWidth',line_width);    % plot the line
    plot([arrow_1(1),end_point(1)],[arrow_1(2),end_point(2)],'Color',arr_color,'LineWidth',arr_width,'LineStyle', arr_style);
    plot([arrow_2(1),end_point(1)],[arrow_2(2),end_point(2)],'Color',arr_color,'LineWidth',arr_width,'LineStyle', arr_style);
    hold off;
end