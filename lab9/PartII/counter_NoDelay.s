/*
* Engr220L - Lab 9
* Date: 11/6/2019
* Author: Josh Bussis
*
* @breif    counter.s is a counter that counts from 0x0 to 0x40000 and displays the current state
*           on the LEDs on the DE2 board.
*           This file has no delay.
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

movia   r11, MAX_COUNT

/* TODO: initialize the timer with the proper timeout period */
RESET_COUNTER:
    addi		r10, zero, 0x0 /* load 0 into r10, which will be our iteration variable */

MAIN_PROG:  

LOOP: /* this is the beginning of the loop */
    addi    r10, r10, 1 /* increment the iteration variable by 1 */
    stwio	r10, 0(r12) /* store the new iteration variable into LEDR_BASE (r12) */
    beq	    r10, r11, RESET_COUNTER /* reset the counter if r10 = r11 */
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

.end
