#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rtlib.h"

void injectControlEnd(char *FunctionAndBBName) {

  // Addi x0, x2, 16, HEX: 01010013, Dec: 16842771
  __asm__("addi x0, x2, 16");// Deactivate BB FI
  

  // The following code shouldn't be corrupted
  //int a;
  //int b = a;
  //printf("%s\n", FunctionAndBBName);
 
  // Addi x0, x1, 16, HEX: 01008013, Dec: 16810003
  __asm__("addi x0, x1, 16");// Activate BB FI

}


