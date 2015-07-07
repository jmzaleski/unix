#!/bin/sh
if [ "$1" != "cvs" ]; then
    # Remove -l {user} {host}
    shift
    shift
    shift
fi
exec "$@"
