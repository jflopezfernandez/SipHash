
vpath %.c src
vpath %.h include

MKDIR    ?= mkdir -p
RM       ?= rm -f

CC       ?=  gcc
CFLAGS   ?= -std=c99 -Wall -Wextra -Wpedantic -Wno-implicit-fallthrough -Wno-format
CPPFLAGS ?= 

LD       ?= ld
LDFLAGS  ?= 
LIBS     ?= 

CC       := $(strip $(CC))
CFLAGS   := $(strip $(CFLAGS))
CPPFLAGS := $(strip $(CPPFLAGS) -I include)

LD       := $(strip $(LD))
LDFLAGS  := $(strip $(LDFLAGS))
LIBS     := $(strip $(LIBS))

SRCS     := $(notdir $(wildcard src/*.c))
OBJS     := $(patsubst %.c,%.o,$(SRCS))

TARGETS  := test debug vectors

ifdef cROUNDS
    CFLAGS := $(strip $(CFLAGS) -DcROUNDS=$(cROUNDS))
endif

ifdef dROUNDS
    CFLAGS := $(strip $(CFLAGS) -DdROUNDS=$(dROUNDS))
endif

all: $(TARGETS)
	echo $(CFLAGS)

test: $(SRCS)
	$(CC) $(CFLAGS) $(CPPFLAGS) $(LDFLAGS) $^ -o $@ $(LIBS)

debug: $(SRCS) 
	$(CC) $(CFLAGS) $(CPPFLAGS)            $^ -o $@ -DDEBUG

vectors: $(SRCS) 
	$(CC) $(CFLAGS) $(CPPFLAGS)            $^ -o $@ -DGETVECTORS

.PHONY: clean
clean:
	$(RM) $(OBJS) $(TARGETS)

format:
	clang-format -style="{BasedOnStyle: llvm, IndentWidth: 4}" -i *.c *.h 

dist: clean
	cd ..; \
	tar zcf SipHash-`date +%Y%m%d%H%M`.tgz SipHash/*
