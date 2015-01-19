rm rebuild/*
rm -f straightAmpMod-syn.bat
cd spg
for k in *.spg
do
	j=${k%.spg}.wav
	i=${k%.spg}.f0_ascii
	echo "straightAmpMod.exe -syn -shift 10 -f0file orgin-f0files\\$i spg\\$k rebuild\\$j" >> ../straightAmpMod-syn.bat
done
cd ..
cmd.exe /c straightAmpMod-syn.bat
