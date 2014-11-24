function outlier=find_outlier(x)
k1 = 4;
k2 = 1;
inlier = [];
outlier = [];

len = length(x);
average1 = mean(x);
standard1 = std(x);

for i = 1:len
	if abs( x(i) - average1) < k1 * standard1
		inlier = [inlier x(i)];
	end
end

average2 = mean(inlier);
standard2 = std(inlier);

for i = 1:len
	if abs( x(i) - average2) >= k2 * standard2
		outlier = [outlier i];
	end
end
