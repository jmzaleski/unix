#!/bin/sh -e

DEST_en0=laptop

set -x
echo probe host
ssh -v $DEST_en0 hostname


DEST=`ssh $DEST_en0 ifconfig fw0 | grep "inet[^6]" | cut -d " " -f 2`
set -
ssh $DEST $*
