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
dia2pdf() {
	dia -l -e ${1}.eps ${1}.dia
	epstopdf ${1}.eps
}
dia2pdf eg_cfg_start
for x in A B C D E F G H J
do
	dia2pdf statement$x
done
cd ..

cd clog
./mk_clog.sh
cd ..

pdflatex p3.tex
