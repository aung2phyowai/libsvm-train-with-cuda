CXX ?= g++
CFLAGS = -Wall -Wconversion -g -fPIC
SHVER = 2
OS = $(shell uname)

all: svm-train

lib: svm.o
	if [ "$(OS)" = "Darwin" ]; then \
		SHARED_LIB_FLAG="-dynamiclib -Wl,-install_name,libsvm.so.$(SHVER)"; \
	else \
		SHARED_LIB_FLAG="-shared -Wl,-soname,libsvm.so.$(SHVER)"; \
	fi; \
	$(CXX) $${SHARED_LIB_FLAG} svm.o -o libsvm.so.$(SHVER)

cudasvm.o: cudasvm.cu
	/usr/local/cuda/bin/nvcc -ccbin g++ -c -O3 -I./ -I/usr/local/cuda/include/ -gencode arch=compute_35,code=sm_35 cudasvm.cu -o cudasvm.o

svm-predict: svm-predict.c svm.o
	$(CXX) $(CFLAGS) svm-predict.c svm.o -o svm-predict -lm
svm-train: svm-train.c svm.o cudasvm.o
	$(CXX) $(CFLAGS) svm-train.c svm.o cudasvm.o -o svm-train -lm -L/usr/local/cuda/lib64 -lcublas -lcudart -lgomp
svm-scale: svm-scale.c
	$(CXX) $(CFLAGS) svm-scale.c -o svm-scale
svm.o: svm.cpp svm.h
	$(CXX) $(CFLAGS) -fopenmp -O3 -c svm.cpp
clean:
	rm -f *~ svm.o svm-train svm-predict svm-scale cudasvm.o libsvm.so.$(SHVER)
