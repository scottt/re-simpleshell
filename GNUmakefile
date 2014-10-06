CFLAGS := -O0 -Wall -g3 -m32

PROGRAMS := $(basename $(wildcard *.c *.S))
PROGRAMS := $(filter-out override-time, $(PROGRAMS))
PROGRAMS += override-time.so

DERIVED_FILES := $(PROGRAMS)

.PHONY: all
all: $(PROGRAMS)

observe-libc-start-main: CFLAGS += -static

override-time.so: override-time.c
	$(CC) -fPIC -shared $(CFLAGS) $< -o $@

.PHONY: clean
clean:
	rm -rf $(DERIVED_FILES)
