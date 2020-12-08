/*
* Engr220L - Lab 11
* Date: 11/23/2019
* Author: Josh Bussis
*
* This program will display a message on the 16x2 LCD display on the DE2 board
* 
*/

#include "altera_up_avalon_character_lcd.h"

int main()
{
    char* first_row = "Hello, I am\0";
    char* second_row = "Josh\0";
    alt_up_character_lcd_dev * char_lcd_dev;

    // open the Character LCD port
    char_lcd_dev = alt_up_character_lcd_open_dev("/dev/LCD");

    // make the cursor blink here

    // initialize the character display
    alt_up_character_lcd_init(char_lcd_dev);

    // make the cursor blink
    alt_up_character_lcd_cursor_blink_on(char_lcd_dev);

    // set cursor position to center on the first row
    alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 2, 0);
    // write "Hello, I am" on the first line
    alt_up_character_lcd_string(char_lcd_dev, first_row);

    // set cursor position for second row
    alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 6, 1);
    // write "Josh" on the second line
    alt_up_character_lcd_string(char_lcd_dev, second_row);

    return 0;  // 0 indicates success
}
