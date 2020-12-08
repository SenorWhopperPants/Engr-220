/*
* Engr220L - Lab 10
* Date: 11/13/2019
* Author: Josh Bussis
*
* This program uses ISR to handle intertupts
* 
*/

/************/
/* INCLUDES */
/************/
.include "nios_macros.s"
.include "nios_defsISR.s" /* system specific definitions */

/*************/
/* CONSTANTS */
/*************/
/* TODO: add your own .equ statements here */
.equ    MEM_END_ADDR, 0x7000    /* address for the stack pointer */
.equ    UPPER_PERIOD, 0x17d     /* upper half of PERIOD */
.equ    LOWER_PERIOD, 0x7840    /* lower half of PERIOD */
.equ    STATUS_VAR, 0x0002      /* value to set STATUS */
.equ    CONTROL_VAR, 0x0007     /* value to set CONTROL */
.equ    COUNT_MAX, 0x40000      /* max value of the counter */

/****************/
/* TEXT SECTION */
/****************/
.text
/* Place the main routine at the reset address */
.org RESET_VECTOR

/* Program start location must be identified */
.global _start
_start:

/* jump over the ISR code in order to begin execution at MAIN_PROG_INIT */
br MAIN_PROG_INIT

/************/
/* ISR CODE */
/************/
/* ISR = Interrupt Service Routine */

/* The following happens when an external interrupt occurs:  The cpu:
   1. Copies the contents of the status register (ctl0) to estatus
      (ctl1) saving the processor's pre-exception status
   2. Clears the U bit of the status register, forcing the processor 
      into supervisor mode
   3. Clears the PIE bit of the status register, disabling external
      processor interrupts
   4. Writes the address of the instruction after the exception to 
      the ea register (r29)
   5. Transfers execution to the address of the exception handler that
      determines the cause of the interrupt
*/
.org EXCEPTION_VECTOR
ISR:
    /* these three lines of code should not be changed */
    rdctl et, ctl4 /* Check if an external (hardware) intr has occurred */
    beq et, r0, EXCEPTION_ACTION 
    subi ea, ea, 4 /* If yes, decrement ea to re-execute interrupted  
                      instruction when you return from the ISR */

EXCEPTION_ACTION:
/* The interrupt-service/exception-handler routine: After determining
   the source of the interrupt, the interrupt condition must be cleared.
   Note that if any register besides r0, et, ea, and sp are used, they must
   first be pushed on the stack and then pulled off the stack before
   returning from the interrupt (eret). */

    /* TODO: push to stack any registers that will change (except as noted above) */
    /*       it is also allowable to push and pop for just certain cases of the ISR */
    subi   sp, sp, 4 /* make the stack 1 word bigger */
    stw    r20, 0(sp) /* fill the 4th added word on the stack with r18 */
   
CHECK_FOR_INTR_0:
/* TODO: check if intr 0 needs service by checking bit 0 of ipending (ctl4). */
/* TODO: this should execute every time the ISR is called, even if another check-#==yes */
    rdctl et, ctl4    /* Read the interrupt pending register = ctrl_reg4 */
    andi  et, et, 0x1 /* and the ctrl reg with TIMER_MASK (checking if bit 0 is high) */
    beq   et, zero, CHECK_FOR_INTR_1 /* if the timer intr bit isn't set, skip to next check */

RESPOND_TO_INTR_0:
/* TODO: The interrupt 0 action goes here, this should only execute if check-0==yes */
    ldwio	r20, STATUS_OFFSET(r14)     /* load status into r20 */
    movia   r20, STATUS_VAR             /* set the status value/clear TO bit */
    stwio   r20, STATUS_OFFSET(r14)     /* store r20 back into STATUS_OFFSET */

    /* INCREMENT THE GLOBAL COUNTER */
    ldw		r20, 0(r11)  /* load GLOBAL_COUNTER into r20 */
    addi    r20, r20, 0x1           /* increment r20 by 1 */
    bge		r19, r20, NO_RESET      /* if the counter isn't greater than max, skip over the reset */
RESET:
    addi    r20, zero, 0x0          /* store 0 back into r20 */
NO_RESET:   
    stw     r20, 0(r11)             /* store r20 back into the global timer */

    /* send new value to the LEDs */
    stwio	r20, 0(r12)             /* store the new iteration variable into LEDR_BASE (r12) */

CHECK_FOR_INTR_1:
/* TODO: check if intr 1 needs service by checking bit 1 of ipending (ctl4). */
    rdctl   et, ctl4                    /* read the interrupt pending register = ctrl_reg4 */
    andi    et, et, 0x2                 /* check if the second bit is is set high in the interrupt */
    beq     et, zero, CHECK_FOR_INTR_2  /* if there's no key interrupt, then skip to next check */

RESPOND_TO_INTR_1:
/* TODO: The interrupt 1 action goes here, this should only execute if check-1==yes */
    /* clear edge register */
    addi	r20, zero, 0x0              /* load zero into r22 */
    stwio   r20, EDGE_OFFSET(r10)       /* clear the edge register of key */

    /* read SW port */
    ldwio   r20, DATA_OFFSET(r9)        /* store SW data into reg 20 */
    /* store value in PERIODH register */
    stwio   r20, PERIODH_OFFSET(r14)    /* store r20 into PERIODH */
    /* restart timer */
    movia   r20, CONTROL_VAR            /* set the control value into r20 to restart the timer */
    stwio   r20, CONTROL_OFFSET(r14)    /* send value to timer control to restart timer */


CHECK_FOR_INTR_2:
/* TODO: check if intr 2 needs service by checking bit 2 of ipending (ctl4). */
/* TODO: this should execute every time the ISR is called, even if another check-#==yes */

RESPOND_TO_INTR_2:
/* TODO: The interrupt 2 action goes here, this should only execute if check-2==yes */

/* The cpu does the following when you return from the interrupt:  
   1. Copies contents of estatus (ctl1) to status (ctl0) (restores it).
   2. Transfers program execution to the address in ea register (r29)
      by copying what is in ea to the program counter (pc).
   NOTE: If you pushed any registers on the stack, pop them off now. */
END_ISR:
    /* TODO: pop from stack anything that was pushed */
    ldw    r18, 0(sp) /* use the 4th added word on the stack for r18 */
    addi   sp, sp, 4 /* make the stack 1 word smaller */
    eret /* Return from exception */
/****************/
/* END ISR CODE */
/****************/

/*********************/
/* MAIN PROGRAM CODE */
/*********************/

MAIN_PROG_INIT:
/* TODO: the main program startup code goes here */

    SP_INIT:
    addi    r15, zero, MEM_END_ADDR /* store the end of memory in r15 */
    ldw		sp, 0(r15)              /* set the stack pointer as the end of mem */

    GLOBAL_VARIABLES_INIT:
    movia	r11, GLOBAL_COUNTER     /* load GLOBAL_COUNTER into r15 */
    addi    r14, zero, 0x0          /* load r14 with 0 */ 
    stw		r14, 0(r11)             /* store zero into GLOBAL_COUNTER */

    IO_BASE_INIT:
    /* TODO: setup registers with I/O base addresses if needed */
    movia   r12, LEDR_BASE          /* store the LED base in r12 */
    movia   r10, KEY_BASE           /* store the KEY base in r10 */
    movia   r9, SW_BASE             /* store the SW base in r9 */

    IO_DEVICE_INIT:
    /* TODO: initialize PIO devices if needed */

    TIMER_INIT:
    movia   r14, TIMER_BASE /* store the base address of the timer */
    ldwio	r15, PERIODL_OFFSET(r14)    /* store periodl into r15 */
    ldwio	r16, PERIODH_OFFSET(r14)    /* store periodh into r16 */
    movia   r15, LOWER_PERIOD           /* add the lower half of the period into r15 */       
    movia   r16, UPPER_PERIOD           /* add the upper half of the period into r16 */
    stwio   r15, PERIODL_OFFSET(r14)    /* store this back to IO */
    stwio   r16, PERIODH_OFFSET(r14)    /* store this back to IO */

    movia   r19, COUNT_MAX

    SET_PORT_INTR:
    /* TODO: Setup all I/O ports for interrupts: */
    /* 1) clear the intr flag in each port and */
    /* 2) turn interrupts on in each port. */

    /* CONTROL = 0x0007, STATUS = 0x0002 */
    ldwio	r17, STATUS_OFFSET(r14)     /* load status into r17 */
    ldwio   r18, CONTROL_OFFSET(r14)    /* load control into r18 */
    movia   r17, STATUS_VAR             /* set the status value */
    movia   r18, CONTROL_VAR            /* set the control value */
    stwio   r17, STATUS_OFFSET(r14)     /* store the new value to IO */
    stwio   r18, CONTROL_OFFSET(r14)    /* store the new value to IO */

    addi	r22, zero, 0x0 /* load zero into r22 */
    stwio   r22, EDGE_OFFSET(r10) /* clear the edge register of key */

    /* set MASK OFFSET to 0x4 */
    addi    r22, zero, 0x4 /* load 0x4, the value of key2, into r22 */
    stwio   r22, MASK_OFFSET(r10) /* set the correct MASK value to the mask offset */

    SET_IENABLE:
        /* TODO: enable each interrupt in the IENABLE reg */
        /*       Set the IENABLE for control register # as needed, */
        /*       ctl3 is shown as an example */
        
        /* Set the IENABLE for control register 3 */
        rdctl et, ctl3          /* Read the interrupt enable register = ctrl_reg3 */
        ori et, et, TIMER_MASK  /* set the timer interrupt enable bit high */
        /* TODO: use additional ori instructions to turn on other interrupts */
        ori et, et, KEY_MASK    /* set the key interrupt enable bit high */
        wrctl ctl3, et          /* write the final pattern back to IENABLE (ctl3) */

    SET_STATUS:
        /* Now enable interrupts globally in the processor status register. */
        rdctl et, ctl0          /* Read the status register = ctrl_reg0 */
        ori et, et, PIE_MASK    /* set the PIE bit to enable all interrupts */
        wrctl ctl0, et          /* write the pattern back to STATUS (ctl0) */

/* End MAIN_PROG_INIT */
/*********************/

MAIN_PROG:
/* TODO  write main program functionality as needed here */
LOOP:
    br  LOOP    /* keep branching back to the LOOP label, thus making an infinite loop */

MAIN_PROG_END:
    /* infinite loop to keep out of global memory, useful for final breakpoint */
    br MAIN_PROG_END  

/*************************/
/* END MAIN PROGRAM CODE */
/*************************/

/****************/
/* DATA SECTION */
/****************/
.data
/* TODO: if needed, add .word or .skip declarations here for global variables */

/* TODO replace MYGLOBALVAR with whichever global variable(s) you need*/
GLOBAL_COUNTER:
    .word 0         /* allocate 4 bytes and initialize them to 0 */

.end


