function updateFigure(F,state)
global para;
pos_x = state(:,1);
pos_y = state(:,2);
d = para.arr*abs(state(:,3));
dir = [cos(state(:,4)) sin(state(:,4))];
set(F.ph,'XData',pos_x);
set(F.ph,'YData',pos_y);
%refreshdata(F.ph);
for i = 1:para.N
    x = pos_x(i)/para.xybnd/3 + 0.5;
    y = pos_y(i)/para.xybnd/3 + 0.5;
    set(F.af(i),'Position',[x y d(i)*dir(i,:)]);
end