export INSTALLDIR=$(CURDIR)/www

default: index.html modules
	install -m0600 index.html $(INSTALLDIR)

modules: prep intro stochsim pfilter mif polio contacts ebola measles 
	for module in $^; do (cd $$module; $(MAKE) INSTALLDIR=$(INSTALLDIR) ); done

%.html: %.Rmd
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.Rmd\",output_format=\"html_document\")"

%.html: %.md
	PATH=/usr/lib/rstudio/bin/pandoc:$$PATH \
	Rscript --vanilla -e "rmarkdown::render(\"$*.md\",output_format=\"html_document\")"

%.R: %.Rmd
	Rscript --vanilla -e "library(knitr); purl(\"$*.Rmd\",output=\"$*.R\")"

clean:
	$(RM) *.o *.so *.log *.aux *.out *.nav *.snm *.toc *.bak
	$(RM) Rplots.ps Rplots.pdf

fresh: clean
	$(RM) -r cache figure
	for module in $^; do (cd $$module; make fresh); done
