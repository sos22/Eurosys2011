#! /bin/bash

histogram=timings.dat
tmp=$(mktemp)

echo '"" "Reading initial snapshot" "Constructing memory trace of crashed thread" "Building state machines" "Discovering relevant addresses" "Removing references to constant memory" "Specialising state machines" "Constructing suggested fixes"' > $histogram
echo '"" "Reading initial snapshot" "Constructing memory trace of crashed thread" "Building state machines" "Discovering relevant addresses" "Removing references to constant memory" "Specialising state machines" "Constructing suggested fixes"' > errors.dat

cntr=0
for x in race3 race8 race9
do
    for t in $x/timing.*.txt
    do
	echo -ne "$x\\t"
	./build_timeline.sh $t | tr -s ' ' | cut -d' ' -f 2 | tr '\n' '\t'
	echo
    done | ./fiddle_table.py > $tmp
    head -n 1 $tmp | tr ' ' '\n' | (
	read n
	echo -n "$n "
	b=0
	while read field
	do
	    python -c "print $field - $b,"
	    echo -n " "
	    b=$field
	done | tr '\n' ' '
	echo) >> $histogram
    paste <(head -n 1 $tmp | tr ' ' '\n') <(tail -n 1 $tmp | tr ' ' '\n') | tail -n +2 | while read val error
    do
	echo $cntr $val $error
    done >> errors.dat
    cntr=$(($cntr + 1))
done

cat > timings.gpl <<EOF
set terminal postscript eps enhanced
set output "timings.eps"
set auto x
set key invert reverse Left outside
set key autotitle columnheader
set style data histogram
set style histogram rowstacked
set yrange [0:1]
set style fill pattern border -1
set boxwidth 0.75
plot 'timings.dat' using 2:xtic(1), 'timings.dat' using 3:xtic(1), 'timings.dat' using 4:xtic(1), 'timings.dat' using 5:xtic(1),'timings.dat' using 6:xtic(1), 'timings.dat' using 7:xtic(1), 'timings.dat' using 8:xtic(1), 'errors.dat' with errorbars
EOF

rm $tmp
