SRC_DIR = src
OBJS_DIR = build
INC_DIR = inc

vpath %.c $(SRC_DIR)
vpath %.o $(OBJS_DIR)

PROJECT_NAME = stm32_blink
CC = arm-none-eabi-
CFLAGS = -mcpu=cortex-m3 -g
INCS = -I $(INC_DIR)
LIBS = 
SRC := $(wildcard $(SRC_DIR)/*.c)
OBJ := $(subst $(SRC_DIR)/, $(OBJS_DIR)/, $(SRC:.c=.o))
As = $(wildcard *.s)
AsOBJ = $(As:.s=.o)

.PHONY: flash
flash: build
	openocd -f stlink.cfg -c "program $(PROJECT_NAME).elf verify reset exit"

.PHONY: build
build: $(PROJECT_NAME).bin

$(OBJS_DIR)/%.o: %.c
	$(CC)gcc $< -c $(INCS) -o $@   $(CFLAGS)

$(OBJS_DIR)/%.o: %.s
	$(CC)as $< -o $@ $(CFLAGS)

$(PROJECT_NAME).elf: $(OBJ) $(AsOBJ)
	$(CC)ld -T linker_script.ld $(AsOBJ) $(OBJ) -o $@ -Map="map_file.map"

$(PROJECT_NAME).bin: $(PROJECT_NAME).elf
	$(CC)objcopy -O binary $< $@

clean:
	rm *.elf -f
	rm *.bin -f
	rm build/*.o -f
	rm *.map -f

.PHONY: rebuild
rebuild: clean build