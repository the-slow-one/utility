#!/bin/bash

ssh-keygen -t rsa -b 4096 -C "deepakrajhr@gmail.com"
eval "$(ssh-agent -s)"
cat ${HOME}/.ssh/id_rsa.pub

# EOF
