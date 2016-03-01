# CMARK must point to the "cmark" executable
CMARK=/Users/antonio/SOFTWARE/CMARK/bin/cmark
# And XSLTPROC must point to the xsltproc executable
XSLTPROC=/usr/bin/xsltproc

all: test.html test-notoc.html 

test-notoc.html: test.markdown xmark.xsl
	$(CMARK) -t xml test.markdown | $(XSLTPROC) --novalid --nonet --stringparam generate.toc no xmark.xsl - > test-notoc.html

test.html: test.markdown xmark.xsl Makefile
	$(CMARK) -t xml test.markdown > test.xml
	$(XSLTPROC) --novalid --nonet xmark.xsl test.xml > test.html

