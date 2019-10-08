#!/bin/bash

if [[ ! -d "atire" ]]; then
    # As of Oct 7, 2019, this remote repo still exists...
    # hg clone http://www.atire.org/hg/atire -r f3102a7a5848
    # ... but it's still safer to have a local copy...
    tar xvfz atire.tar.gz
fi

cd atire

make clean all
