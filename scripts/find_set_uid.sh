#!/bin/bash

# List all bin with setuid

# 1
find / -perm -u=s -type f 2>/dev/null

#2
find / -type f -perm -04000 -ls 2>/dev/null
