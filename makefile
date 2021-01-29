OCAMLC=ocamlfind ocamlopt
EXEC=DoubleRatchet
EXECDEMO=Demo
FILES=rsa.ml aes.ml dr.ml
FILESCMX=rsa.cmx aes.cmx dr.cmx
PACKAGE=-package zarith -package cryptokit

all: compile
	@$(OCAMLC) $(PACKAGE) -linkpkg -o $(EXEC) $(FILESCMX)
	@rm -f *.cmx *.cmi *.o *.out

demo: clear compile
	@$(OCAMLC) $(PACKAGE) -linkpkg -c demo.ml
	@$(OCAMLC) $(PACKAGE) -linkpkg -o $(EXECDEMO) $(FILESCMX) demo.cmx
	@./Demo
	@rm -f *.cmx *.cmi *.o *.out
	@rm -f $(EXECDEMO)

clear:
	@clear

clean:
	rm -f *.cmx *.cmi *.o *.out
	rm -f $(EXEC)

compile:
	@$(OCAMLC) $(PACKAGE) -linkpkg -c $(FILES)

test: compile
	$(OCAMLC) $(PACKAGE) -linkpkg -c test.ml
	$(OCAMLC) $(PACKAGE) -linkpkg -o $(EXEC) $(FILESCMX) test.cmx
	./$(EXEC)

.PHONY: all demo compile test
