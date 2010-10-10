#! /bin/sh

set -e

rm -rf output
rm -f clog.pdf

mkdir output

depths="1 2 5 10 20 50"

for repeat in 1 2 3
do
    for depth in $depths
    do
	grep "By class" data${repeat}/timing.${depth}.txt | sed 's/ *\([0-9.]*\).*building CM \([0-9.]*\), gen fixes \([0-9.]*\)/\1 \2 \3/' | (
	    read inc_replay build_machine gen_fix
	    echo $inc_replay >> output/inc_replay.$depth
	    echo $build_machine >> output/build_cms.$depth
	    echo $gen_fix >> output/gen_fixes.$depth
	    python -c "print $build_machine + $gen_fix" >> output/totals.$depth )
    done
done

for depth in $depths
do
    for field in inc_replay build_cms gen_fixes totals
    do
	mean=$(../summarise_numbers.py < output/${field}.${depth} | grep mean | cut -d' ' -f 2)
	sd=$(../summarise_numbers.py < output/${field}.${depth} | grep sd | cut -d' ' -f 2)
	echo "$depth $mean $sd" >> output/${field}.dat
    done
done

gnuplot ./clog.gpl
epstopdf output/clog.eps --outfile clog.pdf

