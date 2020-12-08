/*
* Engr220L - Lab 12
* Date: 12/4/2019
* Author: Josh Bussis
*
* Allows interaction with the LCD screen from Putty
* 
*/

// include for LCD device from the BSP
#include "altera_up_avalon_character_lcd.h"

// include for UART device from the BSP
#include "altera_up_avalon_rs232.h"

int main( void )
{
    // needed variables
    int err_code;
    alt_u8 * buf;
    alt_u8 * parity;
    // open the LCD device
    alt_up_character_lcd_dev * char_lcd_dev = alt_up_character_lcd_open_dev("/dev/LCD");
    
    // open the UART device
    alt_up_rs232_dev * char_rs232_dev = alt_up_rs232_open_dev("/dev/UART");
    
    // if either device failed to open... return -1
    /* TODO */
    
    // initialize the LCD device
    alt_up_character_lcd_init(char_lcd_dev);
    
    // declare working variables (partiy & character) already did at the top
    
    // loop infinitely...
    //   read UART device
    //   if read was success...
    //     write character to LCD
    //     echo reversed-case character to Putty
    while (1) {
        err_code = alt_up_rs232_read_data(char_rs232_dev, buf, parity);
        if (!err_code) {
            // // set cursor position to center on the first row
            // alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 2, 0);
            // write "Hello, I am" on the first line
            alt_up_character_lcd_string(char_lcd_dev, buf);

            // check for upper/lower case
            if (*buf >= 0x41 && *buf <= 0x5A) {
                // it's upper case so make it lower
                *buf += 32;
            }
            else if (*buf >= 0x61 && *buf <= 0x7A) {
                // it's lower case so make it upper
                *buf -= 32;
            }
            // echo back the reverse-cased char to UART
            alt_up_rs232_write_data(char_rs232_dev, buf);
        }
    }
    
    // Return Success
    return 0;
}
