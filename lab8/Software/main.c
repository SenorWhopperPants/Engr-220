/*
* Engr220L - Lab 8
* Date: 10/24/2019
* Author: Josh Bussis
*
* This program demonstrates a recursive binary search algorithm and makes some 
* unique considerations to support Engr220L-#8.  A binary search algorithm over 
* an ordered array checks if the value being searched for is in the lower or 
* upper half of the ordered array.  It repeatedly does this for the selected half 
* until there are so few elements in the array remaining that the item is trivially
* found or declared unfound.  
* 
*/

// TODO: change this to decide whether to use C-Code (1) or Assembly (0),
//       it should be set to Assembly (0) for most of the lab
// NOTE: changing this sometimes requires recompiling twice before the change takes effect
#define USE_CCODE  0

// TODO: change this to decide whether to use stdio & printf or not.
//       it should be 0 (do-not-use) anytime you're running on the DE2 boards
// NOTE: changing this sometimes requires recompiling twice before the change takes effect
#define USE_IO     0

// This is an include which is only included if USE_IO is 1, for printf()
#if USE_IO == 1
    #include <stdio.h>
#endif /* USE_IO == 1 */

// This global array of 16 values is an example for us to search within
// Note: this array MUST be ordered from least to greatest
int gArrayToBeSearchedIn[16];

// This global array of 10 values is an example for us to search for
int gValuesToBeSearchedFor[10];

// This global array of 10 values is where we will store the results of our searches
int gSearchResults[10];

// This definition of BinarySearchC() is a recursive C-code solution to doing a binary search,
// we will replace it with BinarySearch() which is an equivalent recursive Assembly solution.
// Returns the index of the value in the array, or -1 for value unfound
#if USE_CCODE == 1
    int BinarySearchC(int* arrayToSearchIn, int valueBeingSearchedFor, unsigned int startIndex, unsigned int endIndex)
    {
        // The middle index is halfway between the start and the end (rounding down)
        // The middle value is the value of the array at the middle index
        const unsigned int midIndex = ( startIndex + ( ( endIndex - startIndex ) / 2 ) );
        const int midValue = arrayToSearchIn[midIndex];
        
        // There are 4 cases to this solution:
        // Case 1: base-case where the value has been found at the middle index
        // Case 2: base-case where the value was not found anywhere in the array
        // Case 3: inductive case where the sub-problem is the left-half of the array
        // Case 4: inductive case where the sub-problem is the right-half of the array
        if ( midValue == valueBeingSearchedFor )
        {
            // We found the value, return its index
            return midIndex;
        }
        else if ( startIndex == endIndex )
        {
            // We did not find the value and have nothing left to search, return unfound
            return -1; // -1 indicates not-found
        }
        else if ( valueBeingSearchedFor < midValue )
        {
            // The value is either in the left-half of the ordered array or not in the array at all
            return BinarySearchC( arrayToSearchIn, valueBeingSearchedFor, startIndex, midIndex-1 );
        }
        else // valueBeingSearchedFor > midValue
        {
            // The value is either in the right-half of the ordered array or not in the array at all
            return BinarySearchC( arrayToSearchIn, valueBeingSearchedFor, midIndex+1, endIndex );
        }
    }
#endif /* USE_CCODE == 1 */

int main()
{
    // Initialize the array to search in to some example values,
    // do not change these
    gArrayToBeSearchedIn[0]  = -20;
    gArrayToBeSearchedIn[1]  = -17;
    gArrayToBeSearchedIn[2]  = -3;
    gArrayToBeSearchedIn[3]  = 0;
    gArrayToBeSearchedIn[4]  = 1;
    gArrayToBeSearchedIn[5]  = 4;
    gArrayToBeSearchedIn[6]  = 9;
    gArrayToBeSearchedIn[7]  = 12;
    gArrayToBeSearchedIn[8]  = 13;
    gArrayToBeSearchedIn[9]  = 26;
    gArrayToBeSearchedIn[10] = 31;
    gArrayToBeSearchedIn[11] = 34;
    gArrayToBeSearchedIn[12] = 49;
    gArrayToBeSearchedIn[13] = 77;
    gArrayToBeSearchedIn[14] = 83;
    gArrayToBeSearchedIn[15] = 91;
    
    // Initialize the array of values to search for to some example values,
    // do not change these
    gValuesToBeSearchedFor[0] = 26;   // expected result is 9
    gValuesToBeSearchedFor[1] = 99;   // expected result is -1 (unfound)
    gValuesToBeSearchedFor[2] = 4;    // expected result is 5
    gValuesToBeSearchedFor[3] = -17;  // expected result is 1
    gValuesToBeSearchedFor[4] = -20;  // expected result is 0
    gValuesToBeSearchedFor[5] = 21;   // expected result is -1 (unfound)
    gValuesToBeSearchedFor[6] = 13;   // expected result is 8
    gValuesToBeSearchedFor[7] = 91;   // expected result is 15
    gValuesToBeSearchedFor[8] = 4;    // expected result is 5
    gValuesToBeSearchedFor[9] = -1;   // expected result is -1 (unfound)
    
    unsigned int searchIndex = 0;
    int valueToSearchFor = 0;
    
    // Iterate through the values we want to search for and store the search results in
    // the gSearchResults global array
    for ( searchIndex = 0; searchIndex < 10; searchIndex++ )
    {
        valueToSearchFor = gValuesToBeSearchedFor[searchIndex];
        #if USE_CCODE == 1
            // Start the recursion with the full array size (0 to 15)
            gSearchResults[searchIndex] = BinarySearchC( gArrayToBeSearchedIn, valueToSearchFor, 0, 15 );
        #else
            // Start the recursion with the full array size (0 to 15)
            gSearchResults[searchIndex] = BinarySearch( gArrayToBeSearchedIn, valueToSearchFor, 0, 15 );
        #endif
        
        // If enabled, log some useful information to the console
        #if USE_IO == 1
            printf( "Searched for %d, result was %d\n", valueToSearchFor, gSearchResults[searchIndex] );
        #endif /* USE_IO == 1 */
    }
    
    return 0; // 0 indicates success
}
