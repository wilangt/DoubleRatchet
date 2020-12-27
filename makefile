OCAMLC=ocamlfind ocamlopt
EXEC=DoubleRatchet
FILES=rsa.ml
FILESCMX=rsa.cmx
PACKAGE=zarith

all: compile
	$(OCAMLC) -package $(PACKAGE) -linkpkg -o $(EXEC) $(FILESCMX)

clean:
	rm -f *.cmx *.cmi *.o *.out
	rm -f $(EXEC)

compile:
	$(OCAMLC) -package $(PACKAGE) -linkpkg -c $(FILES)

test: compile
	$(OCAMLC) -package $(PACKAGE) -linkpkg -c test.ml
	$(OCAMLC) -package $(PACKAGE) -linkpkg -o $(EXEC) $(FILESCMX) test.cmx
	./$(EXEC)

.PHONY: all
.PHONY: compile
.PHONY: test
