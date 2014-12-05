function gen_grid(marks)
INF=600;
for i=1:length(marks)
	plot([marks(i) marks(i)],[-INF INF],'--k');
end
plot([0 INF],[0 0],'--k');
