function diff=basediff(ptone,tone)
diff=0;
a=[0 80 120 100; -100 10 65 -30; -120 -10 0 -50;-50 20 50 30];
if tone=='1' || tone=='2' || tone=='3' || tone=='4'
	if ptone=='1' || ptone=='2' || ptone=='3' || ptone=='4'
		diff=a(ptone-'0',tone-'0');
	end
end

