/**
 * factorial.c calculates the factorial of a given number
 *		through recursion
 *
 * @author	Josh Bussis
 * @date 	10/17/2019
 * @class	Engr 220L
 * @where 	Calvin University
 */
 
 /**
  * @brief 	factorial() is the recursive function to calculate the 
  *			factorial of a given number.
  *
  * @param 	(unsigned int)number
  * @return (unsigned int)factorial
  */
  unsigned int factorial(unsigned int number) {
	// check for the base case
	if (number == 0) {
		return 1;
	}
	// recursive step
	else {
		return (number * factorial(number - 1));
	}
  }
  