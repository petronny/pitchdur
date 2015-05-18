#!/bin/sh
for i in Type*
do
	rm $i/*.{dur,pit,tone}
	echo $i
	python2 split.py $i
done
echo ========
for i in origin/Type*
do
	ls $i |wc -l
done
