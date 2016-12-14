function F = iniFigure(state,dest)
global para;
%global pos_x pos_y;
F.fh=figure('units','centimeters',...
            'position',[5 2 20 15]);
pos_x = state(:,1);
pos_y = state(:,2);   
F.ax=axes;
axis(1.2*para.xybnd*[-1 1 -1 1]);
set(gca,'Position',[.1 0.1 .8 .8]);
hold on;
F.ph=plot(pos_x,pos_y,'.','linewidth',2);
plot(dest(:,1),dest(:,2), 'o');
set(F.ph,'XData',pos_x);
set(F.ph,'YData',pos_y);
F.af = zeros(para.N,1);

for i = 1:para.N
    F.af(i) = annotation('textarrow', [0 0], [0 0],'String', num2str(i));
    set(F.af(i),'HeadLength',5,'HeadLength',5);
end