#! /bin/sh

set -e

cd timing
./mk_timing_table.sh
gnuplot ./timings.gpl
epstopdf timings.eps 
epstopdf without_replay.eps
./build_r4.sh
gnuplot ./r4.gpl
epstopdf r4.eps
cd ..

cd diagrams
dia -l -e eg_cfg_start.eps eg_cfg_start.dia
epstopdf eg_cfg_start.eps
cd ..

cd clog
./mk_clog.sh
cd ..

pdflatex p3.tex
