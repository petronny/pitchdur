function [in_x,in_y]=find_inlier(ay,p)
if nargin<2
	p=[0]
end

k1 = 1;
k2 = 2;
inlier = [];
outlier = [];

len = length(ay);
x=linspace(0,len-1,len);
y=ay-polyval(p,x)';

average1 = mean(y);
standard1 = std(y);

for i = 1:len
	if abs( y(i) - average1) < k1 * standard1
		inlier = [inlier y(i)];
	end
end

average2 = mean(inlier);
standard2 = std(inlier);

in_x=[];
in_y=[];

for i = 1:len
	if abs( y(i) - average2) < k2 * standard2
		in_x = [in_x x(i)];
		in_y = [in_y ay(i)];
	end
end
