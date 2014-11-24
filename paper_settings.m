function h=paper_settings(papersize)
%papersize=[16 9]
if nargin < 1
	papersize=[16 9];
end
h=figure('PaperSize',papersize,'PaperPosition',[0 0 papersize],'NextPlot','add','visible','off');
figure(h);
hold on;
