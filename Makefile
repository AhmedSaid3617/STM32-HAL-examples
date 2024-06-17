SRC_DIR = src
OBJS_DIR = build
INC_DIR = inc
LIBS_SRC = ./libs/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Src
LIBS_INCS = -I./libs/STM32CubeF1/Drivers/STM32F1xx_HAL_Driver/Inc
LIBS_INCS += -I./libs/STM32CubeF1/Drivers/CMSIS/Device/ST/STM32F1xx/Include
LIBS_INCS += -I./libs/STM32CubeF1/Drivers/CMSIS/Include
INCS = -I $(INC_DIR) $(LIBS_INCS)

vpath %.c $(SRC_DIR)
vpath %.c $(LIBS_SRC)
vpath %.o $(OBJS_DIR)

PROJECT_NAME = stm32_blink
CC = arm-none-eabi-
CFLAGS = -mcpu=cortex-m3 -g -O0 -DSTM32F103xB -mthumb
SRC := $(wildcard *.c) $(wildcard $(SRC_DIR)/*.c) 
OBJ := $(addprefix $(OBJS_DIR)/, $(notdir $(SRC:.c=.o)) stm32f1xx_hal.o stm32f1xx_hal_cortex.o stm32f1xx_hal_rcc.o stm32f1xx_hal_gpio.o) 
As = $(wildcard *.s)
AsOBJ = $(OBJS_DIR)/$(As:.s=.o)

.PHONY: flash
flash: build
	openocd -f stlink.cfg -c "program $(PROJECT_NAME).elf verify reset exit"

.PHONY: build
build: build_dir $(PROJECT_NAME).bin

$(OBJS_DIR)/%.o: %.c
	$(CC)gcc $< -c $(INCS)  -o $@   $(CFLAGS)

$(OBJS_DIR)/%.o: %.s
	$(CC)gcc -c $< -o $@ $(CFLAGS)

$(PROJECT_NAME).elf: $(OBJ) $(AsOBJ)
	$(CC)gcc -T STM32F103.ld $(AsOBJ) $(OBJ) -o $@ $(CFLAGS)

$(PROJECT_NAME).bin: $(PROJECT_NAME).elf
	$(CC)objcopy -O binary $< $@

clean:
	rm *.elf -f
	rm *.bin -f
	rm build/*.o -f
	rm *.map -f

.PHONY: rebuild
rebuild: clean build

.PHONY: build_dir
build_dir:
	mkdir -p $(OBJS_DIR)
