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
