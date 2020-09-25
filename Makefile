all:
	make clean
	make book
	make annex

book:
	R -e 'bookdown::render_book(".")'

annex:
	cp annex/OD01_10_1_fastqc.html docs/OD01_10_1_fastqc.html

clean:
	rm -rf wsbim2122_data

.PHONY: annex clean
