#!/bin/sh

mkdir `awk -F: '{print $1}' /usr/lib/aliases`
