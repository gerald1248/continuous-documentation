#!/bin/sh

TITLE=`cat title.txt`
OBJ=master
MAIN_OBJ=master.adoc
OUTPUT_DIR=./output
IMAGES_DST=${OUTPUT_DIR}/images

# clean
rm -rf ${OUTPUT_DIR}/*

# prepare
mkdir -p ${IMAGES_DST}

# markdown filter
for FILE in `find . -type f -name "*.md" | grep -v "\./README.md"`; do
  echo "Converting ${FILE}"
  pandoc ${FILE} -f markdown+emoji -t asciidoc -o ${FILE}.adoc
done

# prepare images folder
for DIR in static-images `find . -type d -name images | grep -v ./output/images`; do
  echo "Fetching images from ${DIR}"
  cp -r ${DIR}/* output/images/
done

cat << EOF >${MAIN_OBJ}
:imagesdir: images
:title-logo-image: static-images/logo.png

= ${TITLE}

:sectnums:
:leveloffset: +1

EOF

for FILE in `find . -name "*.adoc" | grep -v ${MAIN_OBJ} | sort -u`; do
  echo "include::${FILE}[]" >>${MAIN_OBJ}
  echo "" >>${MAIN_OBJ}
done

echo "= Printout" >> ${MAIN_OBJ}
echo "link:master.pdf[Get the PDF]" >> ${MAIN_OBJ}
echo "" >> ${MAIN_OBJ}

# html
asciidoctor -v -r asciidoctor-diagram -a toc=left -o ${OUTPUT_DIR}/index.html ${MAIN_OBJ}

# pdf
asciidoctor-pdf -r asciidoctor-diagram -a toc=left -a imagesdir=${IMAGES_DST} -a imagesoutdir=${IMAGES_DST} -o ${OUTPUT_DIR}/${OBJ}.pdf ${MAIN_OBJ}
