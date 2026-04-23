#!/bin/bash

echo "Problem: .vmem file are snapshot of memory and creation of these is IO intense."
echo "Solution: Add the following lines to .vmx file to avoid creation of .vmem files"

echo
echo "prefvmx.minVmMemPct = \"100\""
echo "MemTrimRate = \"0\""
echo "mainMem.useNamedFile = \"FALSE\""
echo "sched.mem.pshare.enable = \"FALSE\""
echo "prefvmx.useRecommendedLockedMemSize = \"TRUE\""

# EOF
