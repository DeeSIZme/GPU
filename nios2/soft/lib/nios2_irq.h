#ifndef NIOS2_IRQ_H
#define NIOS2_IRQ_H

/*****************************************************************************
 * Nios2 builtins are documented here:
 * https://gcc.gnu.org/onlinedocs/gcc/Altera-Nios-II-Built-in-Functions.html
 *****************************************************************************/

// IRQ callback function type
typedef void(*IrqCallback_t)( void );

// Enable Nios II interrupts
// Sets the bit0 of to the status register
// The status register is the control register #0
#define irq_enable() \
   do {  int status = __builtin_rdctl(0);  \
         __builtin_wrctl(0, status | 0x1u); \
   } while(0)

#define irq_disable() \
   do {  int status = __builtin_rdctl(0);  \
         __builtin_wrctl(0, status & ~0x1u); \
   } while(0)


void unmask_irqs(unsigned int m);
void mask_irqs  (unsigned int m);

int RegisterISR ( unsigned int irqN, IrqCallback_t isr );

// The main interrupt handler
void interrupt_handler(void);

#endif
