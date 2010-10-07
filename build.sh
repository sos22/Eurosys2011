#! /bin/sh

set -e

cd timing
./mk_timing_table.sh
gnuplot ./timings.gpl
epstopdf timings.eps 
cd ..

latex p3.tex
