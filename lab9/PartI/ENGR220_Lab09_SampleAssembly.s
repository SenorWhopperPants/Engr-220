/***************************************************************************/
/* Name:   <Author Name>                                                   */
/* Course: Engineering 220L                                                */
/* Lab:    <Lab Number>                                                    */
/* Date:   <Current Date>                                                  */
/***************************************************************************/
/*TEMPLATE: fill in the title block above */

/* The ".include nios_macros.s" assembler directive includes NIOS macros for use in the program */
.include "nios_macros.s"

/* The word-aligned address of the reset vector, value is taken from the 
   cpu configuration in SOPC builder. */
/*TEMPLATE: replace 0x00 with the appropriate address */
.equ RESET_VECTOR, 0x00

/* The ".text" assemlber directive indicates the beginning of the code section of the program */
.text

/* The ".org RESET_VECTOR" assembler directive places the main routine at the reset address */
.org RESET_VECTOR

/* The ".global _start" assembler directive exports the "_start" label as an external symbol */
.global _start

/* The "_start" label identifies the program start location for the debugger */
_start:

/*******************/
/****   MAIN    ****/
/*******************/
/*TEMPLATE: replace the comments below with a description of the program */
/* Pseudo-code for this program is as follows */
/*   Initialize variables (sum), initialize registers, etc
     Begin LOOP
       Read value from array
       If value=0, exit the loop
       Add value to sum variable
       Increment loop index (or pointer address)
     return to "Begin LOOP"
*/

/*TEMPLATE: replace the contents of the MAIN_PROG_INIT label as needed for the program */
/**** init ****/
MAIN_PROG_INIT:
    movia gp, MyArray           /* load the address of the array into the gp register */
    mov r8, r0                  /* clear register 8 for the sum */
    add r0, r0, r0              /* equivalent to a nop (no op) instruction */

/*TEMPLATE: replace the contents of the MAIN_PROG label as needed for the program */
/**** run ****/
MAIN_PROG:
    ldw r9, 0(gp)               /* get a number from the array */
    beq r9, r0, MAIN_PROG_END   /* if the number is zero, then finished */
    add r8, r8, r9              /* accumulate the sum */
    addi gp, gp, 4              /* increment the pointer to look at the next number */
    br MAIN_PROG                /* loop back */

/*TEMPLATE: replace the contents of the MAIN_PROG_END label as needed for the program */
/**** destroy ****/
MAIN_PROG_END:
    br MAIN_PROG_END            /* infinite loop to keep program from going into the weeds */

/*******************/
/****   DATA    ****/
/*******************/
/* The ".data" directive identifies the section of the program that defines global variables */
.data

/*TEMPLATE: replace the contents of the data section as needed for the program */
/* The "MyArray" label has an address equal to the address of the first element in the 
   array of words immediately following the label, this program uses it as arbitrary 
   zero-terminated example content to sum in the main program.  A ".word" array ensures each 
   element has 4 bytes of storage space */
MyArray:
.word 52,377,136,2011,23,872,1003,1,97,5432,0

/* The ".end" assembler directive indicates the end of the program and 
   all following lines are discarded */
.end
