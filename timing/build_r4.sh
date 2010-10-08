#! /bin/bash

histogram=../r4.dat
tmp=$(mktemp)

echo '"" "Reading initial snapshot" "Determining aliasing pattern for stack resolution" "Building state machines" "Discovering relevant addresses" "Collecting logs of relevant addresses" "Specialising state machines" "Constructing suggested fixes"' > r4.dat
echo '"" "Standard deviation" "Determining aliasing pattern for stack resolution" "Building state machines" "Discovering relevant addresses" "Collecting logs of relevant addresses" "Specialising state machines" "Constructing suggested fixes"' > r4.errors.dat

cd r4
cntr=0
for x in *
do
    for t in $x/timing.*.txt
    do
	echo -ne "$x\\t"
	../build_timeline.sh $t | tr -s ' ' | cut -d' ' -f 2 | tr '\n' '\t'
	echo
    done | ../fiddle_table.py -N > $tmp
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
    done >> ../r4.errors.dat
    cntr=$(($cntr + 1))
done

cat > ../r4.gpl <<EOF
set terminal postscript eps enhanced
set output "r4.eps"
set auto x
set key invert reverse Left outside
set key autotitle columnheader
set style data histogram
set style histogram rowstacked
set style fill solid border -1
unset xtic
plot 'r4.dat' using 2 lt rgb "#eeeeee", 'r4.dat' using 3 lt rgb "#cccccc", 'r4.dat' using 4 lt rgb "#aaaaaa", 'r4.dat' using 5 lt rgb "#888888", 'r4.dat' using 6 lt rgb "#666666", 'r4.dat' using 7 lt rgb "#444444", 'r4.dat' using 8 lt rgb "#222222", 'r4.errors.dat' with errorbars

EOF

rm $tmp
