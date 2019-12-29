t = 0:0.2:10;
x = cos(t);
y = sin(t);
figure; hold on;
plot(t,y,'Color',[197,90,17]/255,'LineWidth', 1.0, ...
    'LineStyle','-.','Marker','o','MarkerSize',6,'MarkerEdgeColor', ...
    [197,90,17]/255,'MarkerFaceColor',[244,177,131]/255);
plot(t,x,'Color',[84,130,53]/255,'LineWidth', 1.0, 'LineStyle','--',...
    'Marker','s','MarkerSize',6,'MarkerEdgeColor',[84,130,53]/255,...
    'MarkerFaceColor',[169,209,142]/255);
xlim([1,9]); ylim([-1,1]);
xticks(1:2:9); yticks(-1:0.5:1); 
box on; grid on;
xlabel('Time[s]'); ylabel('Displacement[m]');
h = legend('sin(t)','cos(t)','Location','best');
set(gca, 'FontSize', 12, 'FontName', 'Arial','XMinorTick','on','YMinorTick','on',...
    'XMinorGrid','on','YMinorGrid','on');
set(h, 'FontSize', 12, 'FontName', 'Arial','box','off');
hold off;

figure;
xv = 0:0.2:10;
yv = 0:0.2:10;
[xm, ym] = meshgrid(xv,yv);
zm = sin(xm)+cos(ym);
[c,h]=contour(xm, ym, zm, [-1 -0.5 0 0.5 1], 'k-','LineWidth', 1.0, 'Showtext', 'on');
clabel(c,h,'FontName','Arial','FontSize',12);
xlabel('\itx'); ylabel('\ity');
set(gcf,'Units','centimeters','Position',[5 5 8 6]);
set(gca,'Units','centimeters','Position',[1.2 1.2 6.5 4.5]);
set(gca, 'FontSize', 12, 'FontName', 'Arial','XMinorTick','on','YMinorTick','on',...
    'XMinorGrid','on','YMinorGrid','on');


figure;
mesh(xm, ym, zm);
colormap jet;
colorbar;
box on;
xlabel('\itx'); ylabel('\ity');zlabel('\itz');
set(gca, 'FontSize', 12, 'FontName', 'Arial','XMinorTick','on','YMinorTick','on',...
    'XMinorGrid','on','YMinorGrid','on');
