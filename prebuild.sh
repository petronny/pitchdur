# Matching
[ ! -d match ] && mkdir match
[ -f missing.txt ] && rm missing.txt
for i in origin/*.lab
do
	j=${i%.lab}.f0_ascii
	if [ -f $j ]
	then
		cp $i match/
		cp $j match/
	else
		echo $j >> missing.txt
	fi
done

# Genernating f0files
[ ! -d match/f0files ] && mkdir -p match/f0files
cd match
for i in *.f0_ascii
do
	cat $i |awk '{print $1}' > f0files/$i
done
