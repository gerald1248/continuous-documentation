#!/bin/sh

TITLE=`cat title.txt`
OBJ=master
MAIN_OBJ=master.adoc
OUTPUT_DIR=./output
IMAGES_DST=${OUTPUT_DIR}/images

foldername() {
  FILE=$1
  dirname ${FILE} | sed 's/.*\///'
}

foldertitle() {
  FILE=$1
  foldername ${FILE} | tr '[:lower:]' '[:upper:]' | tr '_' ' '
}

nestingdepth() {
  FILE=$1
  dirname ${FILE} | sed 's/\.//' | tr -cd '/' | wc -c
}

translit() {
  FILE=$1
  for LINE in `grep "|" translit.txt`; do
    SEARCH=`echo "${LINE}" | cut -d"|" -f1`
    if [ `grep -c "${SEARCH}" "${FILE}"` -gt "0" ]; then
      REPLACE=`echo ${LINE} | cut -d "|" -f2`
      sed -i.bak "s/${SEARCH}/${REPLACE}/" ${FILE}
      rm ${FILE}.bak
    fi
  done
}

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
for EXTENSION in svg png gif; do
  for FILE in `find . -name "*.${EXTENSION}"`; do
    echo "Copying image ${FILE}"
    cp ${FILE} output/images/
  done
done

cat << EOF >${MAIN_OBJ}
:imagesdir: images
:title-logo-image: static-images/logo.png
:toclevels: 3

= ${TITLE}

:sectnums:
:leveloffset: 1

EOF

NESTINGDEPTH=0
SECTIONTITLE=""
for FILE in `find . -type f -name "*.adoc" | grep -v ${MAIN_OBJ} | sort -u`; do
  echo "Including file ${FILE}"

  # handle nesting for spine
  NEWDEPTH=`nestingdepth ${FILE}`
  NEWTITLE=`foldertitle ${FILE}`
  if [ ${NEWDEPTH} -gt ${NESTINGDEPTH} ]; then
    OFFSET=$((1 + ${NEWDEPTH}))
    echo ":leveloffset: ${OFFSET}" >>${MAIN_OBJ}
    echo "= ${NEWTITLE}" >>${MAIN_OBJ}
    echo "" >>${MAIN_OBJ}
  elif [ ${NEWDEPTH} -eq ${NESTINGDEPTH} ] && \
       [ ${NESTINGDEPTH} -ne 0 ] && \
       [ ${NEWTITLE} != ${SECTIONTITLE} ]; then
    echo "= ${NEWTITLE}" >>${MAIN_OBJ}
    echo "" >>${MAIN_OBJ}
  elif [ ${NEWDEPTH} -lt ${NESTINGDEPTH} ]; then
    OFFSET=$((1 + ${NEWDEPTH}))
    echo ":leveloffset: ${OFFSET}" >>${MAIN_OBJ}
    echo "" >>${MAIN_OBJ}
  fi
  NESTINGDEPTH=${NEWDEPTH}
  SECTIONTITLE=${NEWTITLE}

  echo "include::${FILE}[]" >>${MAIN_OBJ}
  echo "" >>${MAIN_OBJ}
  translit ${FILE}
done

echo ":leveloffset: 1" >>${MAIN_OBJ}
echo "" >>${MAIN_OBJ}

echo "= Get the PDF" >> ${MAIN_OBJ}
echo "link:${OBJ}.pdf[Download ${OBJ}.pdf]" >> ${MAIN_OBJ}
echo "" >> ${MAIN_OBJ}

# html
asciidoctor -v -r asciidoctor-diagram -a toc=left -o ${OUTPUT_DIR}/index.html ${MAIN_OBJ}

# pdf
asciidoctor-pdf -r asciidoctor-diagram -a toc=left -a imagesdir=${IMAGES_DST} -a imagesoutdir=${IMAGES_DST} -o ${OUTPUT_DIR}/${OBJ}.pdf ${MAIN_OBJ}
