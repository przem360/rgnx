PRGNAME     = smsplus
CC          ?= gcc

# Wybory portów i silników (zachowane z oryginału)
PORT = sdl
SOUND_OUTPUT = sdl12
SOUND_ENGINE = maxim_sn76489
Z80_CORE = z80
SCALE2X_UPSCALER = 1
PROFILE = 0
ZIP_SUPPORT = 1

# Definicja katalogów źródeł
SRCDIR         = ./source ./source/cpu_cores/$(Z80_CORE) ./source/sound ./source/unzip
SRCDIR        += ./source/scalers ./source/ports/$(PORT) ./source/sound/$(SOUND_ENGINE) ./source/sound_output/$(SOUND_OUTPUT)
SRCDIR        += ./source/text/fb

VPATH        = $(SRCDIR)
SRC_C        = $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.c))
SRC_CP       = $(foreach dir, $(SRCDIR), $(wildcard $(dir)/*.cpp))
OBJ_C        = $(notdir $(patsubst %.c, %.o, $(SRC_C)))
OBJ_CP       = $(notdir $(patsubst %.cpp, %.o, $(SRC_CP)))
OBJS         = $(OBJ_C) $(OBJ_CP)

# Podstawowe flagi kompilacji
CFLAGS        += -O2 -Wall -Wextra
CFLAGS        += -DLSB_FIRST -std=gnu99 -DALIGN_DWORD -DNOYUV

# KLUCZOWA ZMIANA: override wymusza dodanie ścieżek include, 
# nawet jeśli Buildroot nadpisuje CFLAGS w linii komend.
override CFLAGS += -I$(CURDIR)/source \
                   -I$(CURDIR)/source/cpu_cores/$(Z80_CORE) \
                   -I$(CURDIR)/source/scalers \
                   -I$(CURDIR)/source/ports/$(PORT) \
                   -I$(CURDIR)/source/sound \
                   -I$(CURDIR)/source/unzip \
                   -I$(CURDIR)/source/sdl \
                   -I$(CURDIR)/source/sound/$(SOUND_ENGINE) \
                   -I$(CURDIR)/source/sound_output \
                   -I$(CURDIR)/source/text/fb

# Obsługa opcjonalnych modułów
ifeq ($(SOUND_ENGINE), maxim_sn76489)
CFLAGS         += -DMAXIM_PSG
endif

ifeq ($(ZIP_SUPPORT), 0)
CFLAGS         += -DNOZIP_SUPPORT
endif

ifeq ($(SCALE2X_UPSCALER), 1)
override CFLAGS += -DSCALE2X_UPSCALER -I$(CURDIR)/source/scale2x
SRCDIR          += ./source/scale2x
endif

# Flagi linkowania - używamy override, aby dołączyć biblioteki systemowe
override LDFLAGS += -lc -lgcc -lm -lSDL -lpthread -lasound -Wl,--as-needed -Wl,--gc-sections

# Reguły budowania
$(PRGNAME): $(OBJS)
	$(CC) $(CFLAGS) -o $(PRGNAME) $^ $(LDFLAGS)

$(OBJ_C) : %.o : %.c
	$(CC) $(CFLAGS) -c -o $@ $<

$(OBJ_CP) : %.o : %.cpp
	$(CXX) $(CXXFLAGS) -c -o $@ $<

clean:
	rm -f $(PRGNAME) *.o
