# nexys4-ddr
### 1.UART Demo
  The default output is a string of characters. If RX receives an input character, it outputs the character directly through TX.
### 2.ADT7420 Demo
  This demo contains 3 states:  
                               1. Write data to ADT7420 0x03 register.  
                               2. Read data(8bit) from ADT7420 0x03 register.  
                               3. Read data(16bit) from ADT7420 0x00 register.  
  In this demo, the temperature is displayed through digital tube.  
