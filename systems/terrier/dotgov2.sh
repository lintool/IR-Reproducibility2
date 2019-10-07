#!/bin/bash
set -ef

source ../common.sh

INDEX="singlepass"

tar -zxf terrier-4.0.tar.gz
cd  terrier-4.0

bin/trec_setup.sh $GOV2_LOCATION 2>&1  | tee trec_setup.log

OPTS="-i -j"
if [ "$INDEX" == "classical" ];
then
 OPTS="-i"
fi

echo <<EOF >> etc/terrier.properties
trec.collection.class=TRECWebCollection
#indexer.meta.forward.keys=docno,url
#indexer.meta.forward.keylens=26,256
indexer.meta.forward.keys=docno
indexer.meta.forward.keylens=26
indexer.meta.reverse.keys=
ignore.low.idf.terms=false

#faster indexing with more memory
memory.reserved=104857600
EOF

if [ "$INDEX" == "blocks" ];
then
 OPTS="$OPTS -Dblock.indexing=true"
elif [[ "$INDEX" == "blocks_fields" ]]; then
 OPTS="$OPTS -Dblock.indexing=true -DFieldTags.process=TITLE,ELSE"
fi

JAVA_OPTIONS=-XX:-UseGCOverheadLimit TERRIER_HEAP_MEM=100g bin/trec_terrier.sh $OPTS 2>&1 | tee indexing.${INDEX}.log

if [[ "$INDEX" == "blocks_fields" ]]; then
	 perl -pi -e 's/FSADocumentIndex$/FSAFieldDocumentIndex/g' var/index/data.properties
fi

for RANKER in DPH BM25;
do
  ../dotgov2-ranker.sh $INDEX $RANKER
done

mv var ${INDEX}-var
