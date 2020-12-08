/*
* Engr220L - Lab 9
* Date: 11/6/2019
* Author: Josh Bussis
*
* @breif    counter.s is a counter that counts from 0x0 to 0x40000 and displays the current state
*           on the LEDs on the DE2 board.
*           This file using the built in timer.
* 
*/

/************/
/* INCLUDES */
/************/
.include "nios_macros.s"
.include "nios_defs.s"   /* .equ statements specific to this system */

/*************/
/* CONSTANTS */
/*************/
.equ MS100,     5000000    /* number of clock cycles in 100 msec provided as example */
.equ MS100LOW,  0x4b40     /* 16 least signif bits */
.equ MS100HIGH, 0x4c       /* 16 most signif bits */

/****************/
/* TEXT SECTION */
/****************/
.text
/* Place the main routine at the reset address */
.org RESET_VECTOR 

/* Program start location must be identified */
.global _start
_start:

/*********************/
/* MAIN PROGRAM CODE */
/*********************/

MAIN_PROG_INIT:
  
/* TODO: initialize PIO devices if needed */
movia   r12, LEDR_BASE /* store the base address of LEDR in r12 */
movia   r14, TIMER_BASE /* store the base address of the timer */

/* SET UP TIMER VARIABLES (PERIOD = 0x17d 7840) */
ldwio	r15, PERIODL_OFFSET(r14)    /* store periodl into r15 */
ldwio	r16, PERIODH_OFFSET(r14)    /* store periodh into r16 */
movia    r15, LOWER_PERIOD           /* add the lower half of the period into r15 */       
movia    r16, UPPER_PERIOD           /* add the upper half of the period into r16 */
stwio   r15, PERIODL_OFFSET(r14)    /* store this back to IO */
stwio   r16, PERIODH_OFFSET(r14)    /* store this back to IO */

/* CONTROL = 0x0006, STATUS = 0x0002 */
ldwio	r17, STATUS_OFFSET(r14) /* load status into r17 */
ldwio   r18, CONTROL_OFFSET(r14) /* load control into r18 */
movia    r17, STATUS_VAR /* set the status value */
movia    r18, CONTROL_VAR /* set the control value */
stwio   r17, STATUS_OFFSET(r14) /* store the new value to IO */
stwio   r18, CONTROL_OFFSET(r14) /* store the new value to IO */


movia   r11, MAX_COUNT  /* assign max count to r11 */
movia   r13, INNER_LOOP_DELAY /* assign inner loop delay to r13 */
movia   r9, TO_SET /* assign the value to look for the in the STATUS */

RESET_COUNTER:
    addi		r10, zero, 0x0 /* load 0 into r10, which will be our iteration variable */

MAIN_PROG:  

LOOP: /* this is the beginning of the loop */
    addi    r10, r10, 1 /* increment the iteration variable by 1 */
    stwio	r10, 0(r12) /* store the new iteration variable into LEDR_BASE (r12) */
WAIT_FOR_TIMER:
    ldwio   r17, STATUS_OFFSET(r14) /* get the current status */
    beq     r17, r9, CONTINUE /* break out of loop if TO is set */
    br      WAIT_FOR_TIMER /* loop until TO is set */
CONTINUE:
    /* reset the status and counter variables */
    movia    r17, STATUS_VAR /* set the status value */
    stwio   r17, STATUS_OFFSET(r14) /* store the new value to IO */
    beq	    r10, r11, RESET_COUNTER /* loop back to RESET_COUNTER so the loop can restart */
    br      LOOP    /* loop */
LOOP_END:


MAIN_PROG_END:
    /* infinite loop to keep out of global memory, useful for final breakpoint */
    br MAIN_PROG_END

/****************/
/* DATA SECTION */
/****************/
.data

/* if any global variables are needed, place them here */
.equ    MAX_COUNT, 0x40000 /* max count value */
.equ    INNER_LOOP_DELAY, 0x650000 /* inner loop delay value */
.equ    TO_SET, 0x0003 /* value to check for TO being set */
.equ    STATUS_VAR, 0x0002 /* value to set STATUS */
.equ    CONTROL_VAR, 0x0006 /* value to set CONTROL */
.equ    UPPER_PERIOD, 0x17d /* upper half of PERIOD */
.equ    LOWER_PERIOD, 0x7840 /* lower half of PERIOD */

.end
