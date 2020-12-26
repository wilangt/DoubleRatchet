all:
	ocamlopt -c rsa.ml
	ocamlopt -o DoubleRatchet rsa.cmx

clean:
	rm -f *.cmx
	rm -f *.cmi
	rm -f *.o
	rm -f DoubleRatchet
