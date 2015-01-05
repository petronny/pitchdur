function [Initial Vowel tone]=pinyin_parser(input)
tone=input(length(input));
Initial=sscanf(input,'%[^aoeiuv]');
Vowel=input(length(Initial)+1:length(input)-1);
if length(Initial)==0
	Initial='none';
end
if length(Vowel)==0
	Vowel='none';
end
if length(tone)==0
	tone='none';
end
