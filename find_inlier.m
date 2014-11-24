function inlier=find_inlier(x)
k1 = 4;
inlier = [];

len = length(x);
average1 = mean(x);
standard1 = std(x);

for i = 1:len
	if abs( x(i) - average1) < k1 * standard1
		inlier = [inlier i];
	end
end
