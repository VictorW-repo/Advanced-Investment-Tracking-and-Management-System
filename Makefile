.PHONY: test

open:
	OCAMLRUNPARAM=b dune exec bin/landingPage.exe

test:
	OCAMLRUNPARAM=b dune exec test/main.exe -- -runner sequential


bisect: bisect-clean
	-dune exec --instrument-with bisect_ppx --force test/main.exe
	bisect-ppx-report html

bisect-clean:
	rm -rf _coverage bisect*.coverage

build:
	dune build
	
clean:
	bisect-clean
	dune clean

zip:
	rm -f finalProject.zip
	zip -r finalProject.zip .

loc:
	cloc --by-file --include-lang=OCaml --exclude-dir=_build .

doc:
	dune build @doc

	
opendoc: doc
	@bash opendoc.sh	