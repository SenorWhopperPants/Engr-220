/*
* Engr220L - Lab 9
* Date: 11/6/2019
* Author: Josh Bussis
*
* @breif    counter.s is a counter that counts from 0x0 to 0x40000 and displays the current state
*           on the LEDs on the DE2 board.
*           This file uses a loop to delay.
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

movia   r11, MAX_COUNT  /* assign max count to r11 */
movia   r13, INNER_LOOP_DELAY /* assign inner loop delay to r13 */

/* TODO: initialize the timer with the proper timeout period */
RESET_COUNTER:
    addi		r10, zero, 0x0 /* load 0 into r10, which will be our iteration variable */

MAIN_PROG:  

LOOP: /* this is the beginning of the loop */
    addi    r14, zero, 0x0 /* load 0 into r14, which will be the inner loop interation */
    addi    r10, r10, 1 /* increment the iteration variable by 1 */
    stwio	r10, 0(r12) /* store the new iteration variable into LEDR_BASE (r12) */
INNER_LOOP:
    addi    r14, r14, 1 /* increment the iteration variable */
    beq     r14, r13, INNER_LOOP_END /* break out of the loop */
    br      INNER_LOOP /* go back to the top */

INNER_LOOP_END:
    beq	    r10, r11, RESET_COUNTER /* loop back to RESET_COUNTER if r10 = r11 */
    br      LOOP /* keep looping */
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

.end
