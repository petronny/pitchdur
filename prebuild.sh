# Matching .lab and .f0_ascii
[ ! -d match/lab ] && mkdir -p match/lab
[ ! -d match/f0_ascii ] && mkdir -p match/f0_ascii
rm -f missing-list.txt
cd orgin
for i in *.lab
do
	j=${i%.lab}.f0_ascii
	if [ -f $j ]
	then
		cp $i ../match/lab
		cp $j ../match/f0_ascii
	else
		echo $j >> ../missing-list.txt
	fi
done
cd ..

# Genernating f0files
[ ! -d match/f0files ] && mkdir -p match/f0files
cd match/f0_ascii
for i in *.f0_ascii
do
	cat $i |awk '{print $1}' > ../f0files/$i
done
cd ../..
