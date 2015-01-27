#!/bin/sh
rm -rf rebuild
cp -r match/f0files-modified windows
ssh windows-iaacnlp 'cd jingbei.li && ./straightAmpMod-syn.sh'
cp -r ./windows/rebuild rebuild
