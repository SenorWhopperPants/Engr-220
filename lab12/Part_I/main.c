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
    alt_u8 ascii;
    alt_u8 parity;
    char message[2];

    // open the LCD device
    alt_up_character_lcd_dev * char_lcd_dev = alt_up_character_lcd_open_dev("/dev/LCD");
    
    // open the UART device
    alt_up_rs232_dev * char_rs232_dev = alt_up_rs232_open_dev("/dev/UART");
    
    // if either device failed to open... return -1
    /* TODO */
    
    // initialize the LCD device
    alt_up_character_lcd_init(char_lcd_dev);
    // make the cursor blink
    alt_up_character_lcd_cursor_blink_on(char_lcd_dev);
    
    
    // loop infinitely...
    //   read UART device
    //   if read was success...
    //     write character to LCD
    //     echo reversed-case character to Putty
    while (1) {
        message[1] = '\0';
        err_code = alt_up_rs232_read_data(char_rs232_dev, &ascii, &parity);
        if (err_code == 0) {
            // put the character in the message array
            message[0] = ascii;
            alt_up_character_lcd_set_cursor_pos(char_lcd_dev, 0, 0);
            alt_up_character_lcd_string(char_lcd_dev, message);
            // check for upper/lower case
            if (ascii >= 0x41 && ascii <= 0x5A) {
                // it's upper case so make it lower
                ascii += 32;
            }
            else if (ascii >= 0x61 && ascii <= 0x7A) {
                // it's lower case so make it upper
                ascii -= 32;
            }
            // echo back the reverse-cased char to UART
            alt_up_rs232_write_data(char_rs232_dev, ascii);
        }
    }
    // Return Success
    return 0;
}
