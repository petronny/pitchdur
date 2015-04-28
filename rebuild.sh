#!/bin/sh
rm -rf rebuild
scp -r match/f0files-modified windows-iaacnlp:jingbei.li
ssh windows-iaacnlp 'cd jingbei.li && ./straightAmpMod-syn.sh'
scp -r windows-iaacnlp:jingbei.li/rebuild rebuild
