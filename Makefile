PROJECT = foo
CPU ?= cortex-m3

AS = arm-none-eabi-as
LD = arm-none-eabi-ld
OBJDUMP = arm-none-eabi-objdump
OBJCOPY = arm-none-eabi-objcopy
READELF = arm-none-eabi-readelf
GDB = C:/msys64/mingw64/bin/gdb-multiarch.exe

build:
	$(AS) -mthumb -mcpu=$(CPU) -g -c $(PROJECT).S -o $(PROJECT).o
	$(LD) -Tmap.ld $(PROJECT).o -o $(PROJECT).elf
	$(OBJDUMP) -D -S $(PROJECT).elf > $(PROJECT).elf.lst
	$(READELF) -a $(PROJECT).elf > $(PROJECT).elf.debug
	$(OBJCOPY) -O ihex $(PROJECT).elf $(PROJECT).hex
	$(OBJCOPY) -O binary $(PROJECT).elf $(PROJECT).bin

gdb:
# 	&"[Console]::OutputEncoding = [System.Text.Encoding]::UTF8"

	"$(GDB)" -q $(PROJECT).elf \
		-ex "target extended-remote localhost:3333" \
		-ex "monitor reset halt" \
		-ex "load" \
		-ex "monitor reset halt"

flash:
	openocd -f interface/stlink.cfg -f target/stm32f1x.cfg \
		-c "program $(PROJECT).elf verify reset exit"

clean:
	del /f *.o *.elf *.lst *.debug *.hex *.bin 2>nul || true