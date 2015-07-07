#!/bin/sh

ssh -L 137:localhost:137 \
	-L 138:localhost:138 \
	-L 139:localhost:139 matz@ll0


