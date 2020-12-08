/*
* Engr220L - Lab 8
* Date: 10/30/2019
* Author: Josh Bussis
*
* This assembly code defines the BinarySearch() function 
* as explained below.  It is intended for use in Engr220L-#8
* with the associated Lab 8 main.c file.  
* 
*
*NOTE: to divide and multipy by 2, bit shift the number
*/

/*
    Registers that will be needed
       // return value
       r2 = value to return
           
       // function parameters
       r4 = arrayToSearchIn
       r5 = valueBeingSearchedFor
       r6 = startIndex
       r7 = endIndex

       // local variables
       r16 = midIndex
       r17 = midValue
       r18 = byteOffset
       
    CASES:
       base case:
              - midValue = searchValue
              - we've come to the end without finding it 

       recursive: 
              - if the value is greater than the midValue
              - if the value is less than the midValue
*/

.global BinarySearch
BinarySearch:

/*****************/
/* push to stack */

/*  
Registers that need to be pushed to the stack
       ra 
       r16
       r17
       r18
> */

subi   sp, sp, 16 /* make the stack 4 words bigger */
stw    r18, 0(sp) /* fill the 4th added word on the stack with r18 */
stw    r17, 4(sp) /* fill the 3rd added word on the stack with r17 */
stw    r16, 8(sp) /* fill the 2nd added word on the stack with r16 */
stw    ra, 12(sp) /* fill the 1st added word on the stack with ra */


/*****************************/
/* calculate local variables */

/* calculate midIndex and store in r16 */
sub    r16, r7, r6   /* store endIndex(r7) - startIndex(r6) in midIndex(r16) */
srli   r16, r16, 1    /* bit-shift r16 1 to the right (divide by 2) */
add    r16, r16, r6  /* add start index (r6) to r16 and store back into r16 */

/* calculate midValue and store in r17 */
/* calculate the byte offset needed for arrayToSearchIn[midIndex] (midIndex * 4) */
slli   r18, r16, 2   /* bit-shift midIndex << 2 (multiply by 4) */
add    r18, r18, r4  /* add the offest to the startIndex */
ldw    r17, 0(r18)  /* load 32-bit word from r18 (offest + startIndex) and load in midValue (r17) */

/***************/
/* check cases */

CHECK_CASE_FOUND: /* if midValue == valueBeingSearchedFor (r17 == r5) */
       /* if r17 != r5, skip to the next check */
       bne    r17, r5, CASE_DONE_FOUND
EXECUTE_CASE_FOUND:
       /* store result in r2 so it can return */
       add    r2, r16, zero /* add zero to r17 and store in r2 */
       br     CLEAN_UP /* skip to the end of the function */
CASE_DONE_FOUND:
       /* nothing to be done */

CHECK_CASE_NOTFOUND: /* check if startIndex == startIndex (r6 == r7) */ 
       /* if r6 != r7, skip to next check */
       bne    r6, r7, CASE_DONE_NOTFOUND
EXECUTE_CASE_NOTFOUND:
       /* return -1 since the value was not found */ 
       addi   r2, zero, -0x1 /* add -1 to zero and store in return reg r2 */
       br     CLEAN_UP /* skip to the end of the function */
CASE_DONE_NOTFOUND:

CHECK_CASE_LEFTHALF: /* if valueBeingSearchedFor < midValue (r5 < r17) */
       /* if r5 > r17, skip this execution */
       ble    r17, r5, CASE_DONE_LEFTHALF
EXECUTE_CASE_LEFTHALF:
       /* adjust the variables for the next function call (midIndex - 1) */
       subi   r7, r16, 1 /* subtract 1 from r16 and store back to r7 (endIndex) (subtracting 1) */
       /* call the function and store its results in r2 */
       call BinarySearch
       add    r2, r2, zero  /* store the result of calling BinarySearch in r2 */
       br     CLEAN_UP /* skip to the end of the function */
CASE_DONE_LEFTHALF:


CHECK_CASE_RIGHTHALF: /* if valueBeingSearchedFor > midValue (r5 > r17) */
       /* if r5 < r17, skip this execution */
       ble    r5, r17, CASE_DONE_RIGHTHALF
EXECUTE_CASE_RIGHTHALF:
       /* adjust the variables for the next function call (midIndex + 1) */
       addi   r6, r16, 1 /* add 1 to r16 and store back to r6 (startIndex) */
       /* call the function and store its results in r2 */
       call BinarySearch
       add    r2, r2, zero  /* store the result of calling BinarySearch in r2 */
       br     CLEAN_UP /* skip to the end of the function */
CASE_DONE_RIGHTHALF:

/******************/
/* pop from stack */

/* 
Registers that need to be popped
       r18
       r17
       r16
       ra
> */
CLEAN_UP:
ldw    r18, 0(sp) /* use the 4th added word on the stack for r18 */
ldw    r17, 4(sp) /* use the 3rd added word on the stack for r17 */
ldw    r16, 8(sp) /* use the 2nd added word on the stack for r16 */
ldw    ra, 12(sp) /* use the 1st added word on the stack for r2 */
addi   sp, sp, 16 /* make the stack 5 words smaller */

ret

