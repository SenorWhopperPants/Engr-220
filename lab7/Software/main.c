/*
* Engr220L - Lab 7 Prelab
* Date: 10/17/2019
* Author: Josh Bussis
*
* This simple program calculates the values of n! for 
* the range of 0 <= n <= 10 and stores them in a global 
* array.  
* 
*/

// Global Array to store the factorial values
unsigned int Fact[10];

// Function Prototype Declaration to be defined and linked 
// against the defintion code written in factorial.c
unsigned int factorial( unsigned int n );

int main()
{
    unsigned int n = 0;
    for ( n = 0 ; n < 11 ; n++ )
    {
        Fact[n] = factorial(n); // call factorial() to do the calculation
    }
    
    return 0;  // 0 indicates success
}
