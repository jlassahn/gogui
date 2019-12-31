
// Glue routines for connecting the C interface to Golang

#include <stdlib.h>
#import "include/gui.h"

extern void SetWindowCallbacks(Window window);
extern void SetButtonCallbacks(Button button);
extern void SetBoxCallbacks(Box box);
extern void SetScrollBoxCallbacks(ScrollBox box);

