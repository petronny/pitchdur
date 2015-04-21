function ret=scale(a,min1,max1,min2,max2)
if min1 ~= max1
	ret=(a-min1)/(max1-min1);
	ret=ret*(max2-min2)+min2;
else
	ret=a
end
