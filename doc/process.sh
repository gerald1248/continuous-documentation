#!/bin/sh

OBJ=master
MAIN_OBJ=master.adoc
OUTPUT_DIR=./output
IMAGES_SRC=./images
IMAGES_DST=${OUTPUT_DIR}/images
OUTPUT_NAME=${OBJ}

# clean
rm -rf ${OUTPUT_DIR}

# prepare
mkdir -p ${IMAGES_DST}

# prepare images folder
rm -rf ./images
mkdir images
cp static-images/*.png images/
cp static-images/*.png output/images/

for DIR in `ls -l | grep "^d" | awk '{print $9}' | grep "^[a-z]" | grep -v output`; do
  if [ -d ${DIR}/images ]; then
	  cp -r ${DIR}/images/* images/
  fi;
done

# html
asciidoctor -v -r asciidoctor-diagram -a toc=left -o ${OUTPUT_DIR}/index.html ${MAIN_OBJ}

# pdf
asciidoctor-pdf -r asciidoctor-diagram -a toc=left -a imagesdir=${IMAGES_DST} -a imagesoutdir=${IMAGES_DST} -o ${OUTPUT_DIR}/${OBJ}.pdf ${MAIN_OBJ}
