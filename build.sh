#! /bin/sh

set -e

cd timing
./mk_timing_table.sh
gnuplot ./timings.gpl
epstopdf timings.eps 
epstopdf without_replay.eps
cd ..

pdflatex p3.tex
