#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 59 Temple Place - Suite 330,
#   Boston, MA 02111-1307, USA.

.section .reset, "ax" , @progbits

.global _reset
_reset:
   .set     noat              /* Instruct the assembler NOT to use reg at (r1) as  */
   .set     nobreak           /* Suppresses a warning message that says that some  */
   movia    r2, _start        /* jump to the _start function of the crt0 */
   jmp      r2                /* jmp as we are not expecting to return ! */

.section .exceptions, "ax"

.weak interrupt_handler

.global _exception
_exception:
   subi    sp, sp, 128
   stw     et, 96(sp)
   rdctl   et, ipending        /* or ctl4 */
   beq     et, r0, SKIP_EA_DEC /* Interrupt is not external          */
   subi    ea, ea, 4           /* Must decrement ea by one instruction
                                * for external interupts, so that the
                                * interrupted instruction will be run */
SKIP_EA_DEC:
   stw  r1,  4(sp)       /* Save all registers  */
   stw  r2,  8(sp)
   stw  r3,  12(sp)
   stw  r4,  16(sp)
   stw  r5,  20(sp)
   stw  r6,  24(sp)
   stw  r7,  28(sp)
   stw  r8,  32(sp)
   stw  r9,  36(sp)
   stw  r10, 40(sp)
   stw  r11, 44(sp)
   stw  r12, 48(sp)
   stw  r13, 52(sp)
   stw  r14, 56(sp)
   stw  r15, 60(sp)
   stw  r16, 64(sp)
   stw  r17, 68(sp)
   stw  r18, 72(sp)
   stw  r19, 76(sp)
   stw  r20, 80(sp)
   stw  r21, 84(sp)
   stw  r22, 88(sp)
   stw  r23, 92(sp)
   stw  r25, 100(sp)     /* r25 = bt (skip r24 = et, because it is saved above) */
   stw  r26, 104(sp)     /* r26 = gp */
                             /* skip r27 because it is sp, and there is no point in saving this */
   stw  r28, 112(sp)     /* r28 = fp */
   stw  r29, 116(sp)     /* r29 = ea */
   stw  r30, 120(sp)     /* r30 = ba */
   stw  r31, 124(sp)     /* r31 = ra */
   addi fp,  sp, 128

   call interrupt_handler   /* Call the C language interrupt handler */

   ldw  r1,  4(sp)       /* Restore all registers */
   ldw  r2,  8(sp)
   ldw  r3,  12(sp)
   ldw  r4,  16(sp)
   ldw  r5,  20(sp)
   ldw  r6,  24(sp)
   ldw  r7,  28(sp)
   ldw  r8,  32(sp)
   ldw  r9,  36(sp)
   ldw  r10, 40(sp)
   ldw  r11, 44(sp)
   ldw  r12, 48(sp)
   ldw  r13, 52(sp)
   ldw  r14, 56(sp)
   ldw  r15, 60(sp)
   ldw  r16, 64(sp)
   ldw  r17, 68(sp)
   ldw  r18, 72(sp)
   ldw  r19, 76(sp)
   ldw  r20, 80(sp)
   ldw  r21, 84(sp)
   ldw  r22, 88(sp)
   ldw  r23, 92(sp)
   ldw  r24, 96(sp)
   ldw  r25, 100(sp)     /* r25 = bt */
   ldw  r26, 104(sp)     /* r26 = gp */
                         /* skip r27 because it is sp, and we did not save this on the stack */
   ldw  r28, 112(sp)     /* r28 = fp */
   ldw  r29, 116(sp)     /* r29 = ea */
   ldw  r30, 120(sp)     /* r30 = ba */
   ldw  r31, 124(sp)     /* r31 = ra */

   addi sp,  sp, 128     /* restore frame */

   eret                  /* return from exception */

.type	interrupt_handler,@function

interrupt_handler:
  br .

.section	.text
.align	3
.globl	_start
.type	_start,@function

_start:

	# set up the stack pointer.
	movhi	sp, %hiadj(nasys_stack_top)
	addi	sp, sp, %lo(nasys_stack_top)

	# make sure it is aligned
	nor	sp, sp, sp
	ori	sp, sp, 0x7 # clear lowest three bits
	nor	sp, sp, sp

	# set up the global pointer.
	movhi	gp, %hiadj(_gp)
	addi	gp, gp, %lo(_gp)

	#set up the exception temporary
	movhi	et, %hiadj(_end)
	addi	et, et, %lo(_end)

	movhi	r2, %hiadj(__start_2)
	addi	r2, r2, %lo(__start_2)
	jmp	r2

