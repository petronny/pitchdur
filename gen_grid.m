function gen_grid(filename)
INF=1000;
input=fopen(filename,'r');
text=fgets(input);
text=fgets(input);
text=fgets(input);
while ~feof(input)
	text=fgets(input);
	mark=sscanf(text,'%f',[1 1])*100;
	plot([mark mark],[-INF INF],'--k');
end
plot([0 INF],[0 0],'--k');
