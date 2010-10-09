#! /bin/bash

histogram=timings.dat
tmp=$(mktemp)

echo '"" "Reading initial snapshot" "Finding access pattern for stack resolution" "Building state machines" "Discovering relevant addresses" "Collecting logs of relevant addresses" "Specialising state machines" "Constructing suggested fixes"' > $histogram
echo '"" "Standard deviation" "" "" "" "" "" ""' > errors.dat
echo '"" "Reading initial snapshot" "Building state machines" "Generating fixes" "Other"' > time_without_replay
echo '"" "Standard deviation" "" "" ""' > errors.time_without_replay.dat

cntr=0
for x in toctou twovar publish privatize glibc thunderbird
do
    for t in $x/timing.*.txt
    do
	echo -ne "$x\\t"
	./build_timeline.sh $t | tr -s ' ' | cut -d' ' -f 2 | tr '\n' '\t'
	echo
    done | ./fiddle_table.py -n > $tmp
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
    for t in $x/timing.*.txt
    do
	grep "By class" $t | sed 's/ *\([0-9.]*\) By class: initial snapshot \([0-9.]*\), replay \([0-9.]*\), building CM \([0-9.]*\), gen fixes \([0-9.]*\)/\1 \2 \3 \4 \5/' | (
	    read total_time init_snapshot replay build_cm gen_fixes
	    other=$(python -c "print $total_time - $init_snapshot - $replay - $build_cm - $gen_fixes")
	    echo $x $init_snapshot $build_cm $gen_fixes $other
	)
    done | ./fiddle_table.py -N > $tmp
    head -n 1 $tmp >> time_without_replay
    b=0
    paste <(head -n 1 $tmp | tr ' ' '\n') <(tail -n 1 $tmp | tr ' ' '\n') | tail -n +2 | while read val error
    do
	echo $cntr $(python -c "print $b + $val") $error
	b=$(python -c "print $b + $val")
    done >> errors.time_without_replay.dat
    cntr=$(($cntr + 1))
done

rm $tmp
