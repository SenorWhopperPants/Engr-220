/**********************************************************/
/* Define your reset and exception vector addresses here. */
/**********************************************************/

/* The values come from your cpu configuration in SOPC */
/* builder. Should be word aligned.                    */
.equ RESET_VECTOR, 0x00

/***************************/
/* I/O Definitions go here */
/***************************/

/* Define the base address for the IO devices.  Use      */
/* "movia ri, xxx_BASE" to load the base address into a  */
/* register (e.g. register i).  Then you can use  ldwio  */
/* and stwio instructions to read/write to the device.   */
.equ SW_BASE,         0x8000  /* base location of PIO registers for SW device  */
.equ LEDR_BASE,       0x8040  /* base location of PIO registers for LED device */
.equ SEVENSEG30_BASE, 0x8080  /* base location of PIO registers for hex3..0    */
.equ SEVENSEG74_BASE, 0x80c0  /* base location of PIO registers for hex7..4    */
.equ KEY_BASE,        0x8100  /* base location of PIO registers for KEY device */
.equ TIMER_BASE,      0x8140  /* base location for timer I/O device            */

/* define the port register offset amounts (in bytes) */
/* these offsets can be used in ldwio and stwio       */
/* instructions (e.g. ldwio r2, EDGE(r16) )           */
.equ DATA_OFFSET, 0x0     /* data register offset -- e.g. ldwio rj, DATA(ri) */
.equ DIRC_OFFSET, 0x4     /* direction register offset                       */
.equ MASK_OFFSET, 0x8     /* mask register offset                            */
.equ EDGE_OFFSET, 0xc     /* edge register offset                            */

.equ STATUS_OFFSET,  0x0  /* status register offset from timer base          */
.equ CONTROL_OFFSET, 0x4  /* control register offset from timer base         */
.equ PERIODL_OFFSET, 0x8  /* lower half of 32-bit period                     */
.equ PERIODH_OFFSET, 0xc  /* upper half of 32-bit period                     */

