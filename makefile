OCAMLC=ocamlfind ocamlopt
EXEC=Demo
FILES=rsa.ml aes.ml dr.ml demo.ml
FILESCMX=rsa.cmx aes.cmx dr.cmx demo.cmx
PACKAGE=-package zarith -package nocrypto -package cryptokit

all: clear compile
	@$(OCAMLC) $(PACKAGE) -linkpkg -o $(EXEC) $(FILESCMX)
	@./Demo
	@rm -f *.cmx *.cmi *.o *.out
	@rm -f $(EXEC)

clear:
	@clear

clean:
	rm -f *.cmx *.cmi *.o *.out
	rm -f $(EXEC)

compile:
	@$(OCAMLC) $(PACKAGE) -linkpkg -c $(FILES)

test: compile
	$(OCAMLC) $(PACKAGE) -linkpkg -c test.ml
	$(OCAMLC) $(PACKAGE) -linkpkg -o $(EXEC) rsa.cmx aes.cmx dr.cmx test.cmx
	./$(EXEC)

.PHONY: all
.PHONY: compile
.PHONY: test
