#Mods to get this to work with V2.51 original code:
#add  -mthumb to AFLAGS

CROSS=arm-none-eabi-
CC=$(CROSS)gcc
OBJCOPY=$(CROSS)objcopy
LD=$(CROSS)ld
AS=$(CROSS)as
STRIP=$(CROSS)strip

STM_LIB=FWLib/inc

#ORIGINAL >>>> CFLAGS = -Wall -Os -I. -Iinc  -Werror -mcpu=cortex-m3 -mthumb -msoft-float -MD -I $(STM_LIB)
#NEED AT LEAST >>>> CFLAGS = -Os -Iinc -mcpu=cortex-m3 -mthumb -fno-common -fzero-initialized-in-bss -I $(STM_LIB)

#CFLAGS = -Wall -Os -I. -Iinc  -Werror -mcpu=cortex-m3 -mthumb -fno-common -fzero-initialized-in-bss -msoft-float -MD -I $(STM_LIB)
CFLAGS = -Wall -O2 -I. -Iinc  -Werror -mcpu=cortex-m3 -mthumb -fno-common -fzero-initialized-in-bss -msoft-float -MD -I $(STM_LIB)

#-os = optimise for size
#-o2 = optimise for speed
#-I = directories for header files
#-Wall = turns on error warnings
#-Werror = makes all warnings into errors

#AFLAGS = -mcpu=cortex-m3   
AFLAGS = -mcpu=cortex-m3 -mthumb 
#LDFLAGS = -mcpu=cortex-m3 -lc -lnosys -mthumb -march=armv7 -mfix-cortex-m3-ldrd -msoft-float -lstm32 -nostartfiles  

LDFLAGS = -mcpu=cortex-m3 -lc -mthumb -march=armv7 -mfix-cortex-m3-ldrd -msoft-float -nostartfiles -Wl,-Map,$*.map

# tried LDFLAGS = -mcpu=cortex-m3 -mthumb -march=armv7 -mfix-cortex-m3-ldrd -msoft-float


OBJS = Calibrat.o Draw.o Files.o Function.o Interrupt.o Main.o Menu.o Process.o BIOS.o startup.o stm32f10x_nvic.o
OBJS +=cortexm3_macro.o
#TARGETS = app1.hex app2.hex app3.hex
#TARGETS = app1.hex app2.hex
TARGETS = app1.hex


all: $(OBJS) $(TARGETS)

.PHONY: clean

clean:
	rm -rf $(OBJS) $(TARGETS)

.c.o:
	$(CC) $(CFLAGS) -c -o $@ $*.c

.S.o:
	$(CC) $(AFLAGS) -c -o $@ $*.S

%.elf: %.lds $(OBJS)
	$(CC) -o $@ $(OBJS) $(LDFLAGS) -T $<

%.bin: %.elf
	$(OBJCOPY) -O binary $< $@

%.hex: %.elf
	$(OBJCOPY) -O ihex $< $@
