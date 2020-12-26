CC=ocamlopt
CFLAGS=-W -Wall
EXEC=DoubleRatchet
FILES="rsa.ml"
FILESCMX="rsa.cmx"

all: compile
	$(CC) -o $(EXEC) $(FILESCMX)

clean:
	rm -f *.cmx *.cmi *.o
	rm -f $(EXEC)

compile:
	$(CC) -c $(FILES)

test: compile
	$(CC) -c test.ml
	$(CC) -o $(EXEC) $(FILESCMX) test.cmx
	./$(EXEC)
