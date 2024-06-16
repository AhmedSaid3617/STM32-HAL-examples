#ifndef GPIO_H

#define RCC_BASE 0x40021000
#define RCC_APB2ENR *((volatile unsigned int*)(RCC_BASE + 0x18))

#define GPIOA_BASE 0x40010800 
#define GPIOA_CRH *((volatile unsigned int*)(GPIOA_BASE + 0x04))
#define GPIOA_ODR *((volatile unsigned int*)(GPIOA_BASE + 0x0C))

#define GPIOC_BASE 0x40011000
#define GPIOC_CRH *((volatile unsigned int*)(GPIOC_BASE + 0x04))
#define GPIOC_ODR *((volatile unsigned int*)(GPIOC_BASE + 0x0C))

#define GPIO_H
#endif
