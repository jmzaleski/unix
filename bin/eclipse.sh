#!/bin/bash


. ~/.bashrc
. ~/.kenv
# xset fp default
# -funcall make-new-frame-on-left

# strace -c doesn't seem to do the trick. maybe prints just sys time.
# strace -T prints time for each syscall. 

strace  -T ~/build/Ganymede/eclipse/eclipse 



