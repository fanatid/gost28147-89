CC = gcc
CFLAGS =
DEFS = -O2 -std=c11 -Wall
LIBS = -lssl -lcrypto
DEPS = gost89.h

%.o: %.c $(DEPS)
	$(CC) -c -o $@ $< $(DEFS) $(CFLAGS)

benchmark: benchmark.o gost89.o
	$(CC) -o $@ $^ $(DEFS) $(CFLAGS) $(LIBS)

generator: generator.o gost89.o
	$(CC) -o $@ $^ $(DEFS) $(CFLAGS) $(LIBS)

all: benchmark generator

clean:
	rm -f *.o benchmark generator

.DEFAULT_GOAL := all

