#!/bin/bash
# Normalizes given .pfile feature files on a utterance level
#
# Usage:
# ./normutts file1 file2 ... fileN
#

function recho {
    tput setaf 1;
    echo $1;
    tput sgr0;
}

suffix=".norm"

for arg; do

	recho "Normalizing file $arg ..."

	pfile_normutts -i $arg -o ${arg}${suffix}
	rm $arg
	mv ${arg}${suffix} $arg

done
