all: p3.pdf

p3.pdf: p3.tex timing/r4.pdf timing/timings.pdf timing/without_replay.pdf diagrams/eg_cfg_start.pdf diagrams/statementA.pdf diagrams/statementD.pdf clog/clog.pdf
	pdflatex p3.tex

%.pdf: %.eps
	epstopdf -o $@ $<

%.eps: %.dia
	dia -l -e $@ $<

timing/timings.eps timing/without_replay.eps: timing/timings.gpl timing/timings.dat
	cd timing && gnuplot ./timings.gpl

timing/timings.dat: timing/mk_timing_table.sh
	cd timing && ./mk_timing_table.sh

timing/r4.eps: timing/r4.gpl
	cd timing && gnuplot ./r4.gpl

timing/r4.gpl: timing/build_r4.sh
	cd timing && ./build_r4.sh

clog/clog.pdf: clog/mk_clog.sh
	cd clog && ./mk_clog.sh

