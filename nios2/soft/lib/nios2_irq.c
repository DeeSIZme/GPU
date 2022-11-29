#include "nios2_irq.h"

static IrqCallback_t IrqCallbackTable[32] = {0};

// The mask register (ienable) in the control register #3
void unmask_irqs(unsigned int irq)
{
   int mask = 0x1 << irq;
   int ienable = __builtin_rdctl(3);
   __builtin_wrctl(3, ienable | mask);
}

void mask_irqs(unsigned int irq)
{
   int mask = 0x1 << irq;
   int ienable = __builtin_rdctl(3);
   __builtin_wrctl(3, ienable & ~mask);
}


int RegisterISR ( unsigned int irqN, IrqCallback_t isr )
{
   if (irqN > 31) return 0;
   IrqCallbackTable[irqN] = isr;
   unmask_irqs(irqN);
   return 1;
}

// This function is called when an exception occurs (see reset.S)
// The interrupt are disabled automatically by the CPU while executing it.
// The interrupt are re-enabled when we call `eret` (see reset.S)
void interrupt_handler(void)
{
   unsigned int irqN;
   int mask;
   // interrupt pending registers is control register #4
   int ipending;
   ipending = __builtin_rdctl(4);

   for ( irqN = 0, mask = 0x1;
         irqN < 32;
         irqN++, mask = mask << 0x1)
   {
      if (mask & ipending) {
         if(IrqCallbackTable[irqN])
            (IrqCallbackTable[irqN])();
         ipending = ipending & ~mask;
         if(!ipending) break;
      }
   }
}
