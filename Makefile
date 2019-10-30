RSCRIPT = Rscript --no-init-file

install: doc build
	R CMD INSTALL . && rm *.tar.gz

build:
	R CMD build .

doc:
	${RSCRIPT} -e "devtools::document()"

eg:
	${RSCRIPT} -e "devtools::run_examples()"

codemeta:
	${RSCRIPT} -e "codemetar::write_codemeta()"

check:
	${RSCRIPT} -e 'devtools::check(document = FALSE, cran = TRUE)'

test:
	${RSCRIPT} -e 'devtools::test()'
