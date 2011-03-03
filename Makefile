
PDFLATEX=pdflatex
IMAGES=400px-Wimshurst.eps WF-Hermans.eps
DEPS=index.html Makefile ../latehxigu.xslt eo.sed  titolpag.tex revisio.tex $(IMAGES)
.PHONY: all clean deps images
all: wimshurst-a4.pdf wimshurst-a5.pdf wimshurst-libreto.pdf


revisio.tex: .svn
	-svn up >/dev/null
	date  --rfc-3339=date | tr -d "\n" > revisio.tex
	svn info |  grep Revision | awk '{print " r" $$2}' >> revisio.tex



deps:

wimshurst-a5.tex: $(DEPS)
	xsltproc -novalid --stringparam centering yes ../latehxigu.xslt $<  | sed -f eo.sed -f ../utf8-tex.sed > $@

wimshurst-a4.tex: $(DEPS)
	xsltproc -novalid --stringparam centering yes --stringparam geometry a4paper ../latehxigu.xslt $<  | sed -f eo.sed  -f ../utf8-tex.sed > $@

%.dvi: %.tex
	latex $<

%.signature.ps: %-a5.ps
	psbook -s8 $< $@

%.ps: %.dvi
	dvips $< -f > $@

%.eps: %.jpg
	convert $< $@


wimshurst-libreto.ps:  wimshurst.signature.ps
	psnup -d -l -pa4 -Pa5 -2  $< $@


%.pdf: %.ps
	ps2pdf $<

%.pdf: %.tex
	-$(PDFLATEX) $<


%.ps.gz: %.ps
	gzip -f $<


clean:
	rm -f *.pdf *.log *.aux *.dvi profitulo-a4*  *.ps profitulo-a5* *.eps