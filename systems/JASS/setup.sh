#!/bin/bash

ATIRE_DIR="../ATIRE/atire"

if [[ ! -d ${ATIRE_DIR} ]]; then
	echo "ATIRE is a prerequisite for JASS"
	exit
fi

if [[ ! -d JASS ]]; then
        # As of Oct 7, 2019, this remote repo still exists...
	# git clone https://github.com/lintool/JASS.git
	# git checkout -q b27b319
	# ... but it's still safer to have a local copy...
	tar xvfz JASS.tar.gz
fi

cd JASS
make ATIRE_DIR=../${ATIRE_DIR}
make -C trec2query ATIRE_DIR=../../${ATIRE_DIR}
