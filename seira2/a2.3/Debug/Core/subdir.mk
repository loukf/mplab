################################################################################
# Automatically-generated file. Do not edit!
# Toolchain: GNU Tools for STM32 (13.3.rel1)
################################################################################

# Add inputs and outputs from these tool invocations to the build variables 
S_SRCS += \
../Core/main.s 

OBJS += \
./Core/main.o 

S_DEPS += \
./Core/main.d 


# Each subdirectory must supply rules for building sources it contributes
Core/%.o: ../Core/%.s Core/subdir.mk
	arm-none-eabi-gcc -mcpu=cortex-m4 -g3 -DDEBUG -c -x assembler-with-cpp -MMD -MP -MF"$(@:%.o=%.d)" -MT"$@" --specs=nano.specs -mfpu=fpv4-sp-d16 -mfloat-abi=hard -mthumb -o "$@" "$<"

clean: clean-Core

clean-Core:
	-$(RM) ./Core/main.d ./Core/main.o

.PHONY: clean-Core

