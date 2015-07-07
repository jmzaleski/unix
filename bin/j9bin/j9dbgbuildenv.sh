#!/bin/bash

export vmdebug="/Zi /Odi -DDEBUG"
export VMDEBUG=$vmdebug

export vmasmdebug="/Zi -DDEBUG"
export vmlink="/debug /debug:full /debugtype:cv" ##obsolete for vc7? /debugtype:both"
export gnudebug=-g


