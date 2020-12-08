/*
 * Fib.c takes an array and converts it to the Fibonacci Sequence
 *
 * @author	Josh Bussis
 * @date 	10/10/2019
 * @class	Engr 220L
 * @where	Calvin University
 * @why		Lab 06 prelab
 */
 
 /*
  * PSUEDO-CODE
  * The overall algorithm is as follows:
  *
  *	int array[size]
  *
  * for item in array:
  *		if the index is zero:
  *			array[index] = 0
  *		else if the index is one:
  *			array[index] = 1
  *		else:
  *			array[index] = array[index - 2] + array[index - 1]
  */
  
//global array of 40 ints
int Fib[40];
  
int main() {
	// convert the array to the Fibonacci Sequence
	int i;
	// loop through the array and fill with the calculated values
	// of the Fibonacci Sequence
	for(i = 0; i < 40; i++) {
		if (i == 0) {
			Fib[i] = 0;
		}
		else if (i == 1) {
			Fib[i] = 1;
		}
		else {
			Fib[i] = Fib[i-2] + Fib[i-1];
		}
	}
	return 0;
}
   