#! /bin/sh

echo '"Reading initial snapshot" "Constructing memory trace of crashed thread" "Building state machines" "Discovering relevant addresses" "Removing references to constant memory" "Specialising state machines" "Constructing suggested fixes"' > r4.dat
cd r4
for x in *
do
    b=0
    ../build_timeline.sh $x/timing.txt | tr -s ' ' | cut -d ' ' -f 2 | while read n
    do
	python -c "print $n - $b"
	b=$n
    done | tr '\n' ' ' >> ../r4.dat
    echo >> ../r4.dat
done

cat > ../r4.gpl <<EOF
set terminal postscript eps enhanced
set output "r4.eps"
set auto x
set key invert reverse Left outside
set key autotitle columnheader
set style data histogram
set style histogram rowstacked
set style fill pattern border -1
unset xtic
plot 'r4.dat' using 1, 'r4.dat' using 2, 'r4.dat' using 3, 'r4.dat' using 4, 'r4.dat' using 5
EOF