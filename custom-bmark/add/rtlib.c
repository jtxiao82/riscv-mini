#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "rtlib.h"

void injectControlEnd(char *FunctionAndBBName) {

  __asm__("addi x0, x2, 16");// Deactivate BB FI
  

  // The following code shouldn't be corrupted
  //int a;
  //int b = a;
  //printf("%s\n", FunctionAndBBName);

  __asm__("addi x0, x1, 16");// Activate BB FI
}


