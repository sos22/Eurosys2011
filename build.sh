#! /bin/sh

set -e

cd timing
./mk_timing_table.sh
gnuplot ./timings.gpl
epstopdf timings.eps 
epstopdf without_replay.eps
./build_r4.sh
gnuplot ./r4.gpl
epstopdf e4.eps
cd ..

pdflatex p3.tex
