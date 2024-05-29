#
# greppin Makefile
#

.PHONY: all clean

DEFS=-DWITH_HYPERSCAN -DPCRE2_CODE_UNIT_WIDTH=8

CXX=c++

CFLAGS=-c -Wall -O3 -pedantic -std=c++11

INC=-I/usr/local/include -I${HYPERSCAN_BUILD}/../src

LFLAGS=-L/usr/local/lib -L${HYPERSCAN_BUILD}/lib -Wl,-rpath=${HYPERSCAN_BUILD}/lib
LIBS+=-lpcre -lpcre2-8 -lhs


ifeq ($(shell uname), NetBSD)
INC+=-I/usr/pkg/include
LFLAGS+=-L/usr/pkg/lib
endif


ifeq ($(shell uname), Darwin)
DEFS+=
else
LIBS+=-pthread
endif


all: greppin

greppin: grab.o main.o nftw.o engine-pcre.o engine-pcre2.o engine-hs.o
	$(CXX) grab.o main.o nftw.o engine-pcre.o engine-pcre2.o engine-hs.o $(LFLAGS) $(LIBS) -o greppin

main.o: main.cc
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o main.o

nftw.o: nftw.cc
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o nftw.o

grab.o: grab.cc grab.h
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o grab.o

engine-pcre.o: engine-pcre.cc
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o engine-pcre.o

engine-pcre2.o: engine-pcre2.cc
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o engine-pcre2.o

engine-hs.o: engine-hs.cc
	$(CXX) $(CFLAGS) $(INC) $(DEFS) $< -o engine-hs.o

clean:
	rm -f *.o
