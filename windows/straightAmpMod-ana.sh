rm -f command.bat
cd orgin-f0files
for i in *.f0_ascii
do
	j=${i%.f0_ascii}.wav
	if [ -f ../corpus/$j ]
	then
		k=${i%.f0_ascii}.spg
		echo "straightAmpMod.exe -ana -shift 10 -f0file orgin-f0files\\$i corpus\\$j spg\\$k" >> ../command.bat
	fi
done
cd ..
cmd.exe /c command.bat
