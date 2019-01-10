#!/bin/sh

TITLE=`jq -r .title values.json`
FILENAME=`jq -r .filename values.json`
OBJ=master
DOC=${OBJ}.adoc
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
  dirname ${FILE} | sed 's/\.//' | tr -cd '/' | wc -c | tr -d '[:space:]'
}

translit() {
  FILE=$1
  for KEY in `jq -r '.substitutions | keys[]' values.json`; do
    VALUE=`jq -r ".substitutions | .[\"${KEY}\"]" values.json`
    if [ `grep -c "${KEY}" "${FILE}"` -gt "0" ]; then
      sed -i.bak "s/${KEY}/${VALUE}/" ${FILE}
    fi
  done
  # for images imported from Markdown, adjust image paths here
  sed -i.bak "s/image:images\//image:/" ${FILE}
  sed -i.bak "s/image::images\//image:/" ${FILE}
  rm -f ${FILE}.bak
}

# don't proceed if testing the above functions only
if [ ! -z ${CONTINUOUS_DOCUMENTATION_TEST} ]; then
  return 0
fi

# clean
rm -rf ${OUTPUT_DIR}/*

# prepare
mkdir -p ${IMAGES_DST}

# markdown filter
for FILE in `find . -type f -name "*.md"`; do
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

cat << EOF >${DOC}
:imagesdir: images
:title-logo-image: static-images/logo.png
:toclevels: 3
:source-highlighter: pygments
:pygments-style: emacs
:icons: font
:stem: latexmath

= ${TITLE}

:sectnums:
:leveloffset: 1

EOF

NESTINGDEPTH=0
SECTIONTITLE=""
for FILE in `find . -type f -name "*.adoc" | grep -v ${DOC} | sort -u`; do
  echo "Including file ${FILE}"

  # handle nesting for spine
  NEWDEPTH=`nestingdepth ${FILE}`
  NEWTITLE=`foldertitle ${FILE}`
  if [ ${NEWDEPTH} -gt ${NESTINGDEPTH} ]; then
    OFFSET=$((1 + ${NEWDEPTH}))
    echo ":leveloffset: ${OFFSET}" >>${DOC}
    echo "= ${NEWTITLE}" >>${DOC}
    echo "" >>${DOC}
  elif [ ${NEWDEPTH} -eq ${NESTINGDEPTH} ] && \
       [ ${NESTINGDEPTH} -ne 0 ] && \
       [ ${NEWTITLE} != ${SECTIONTITLE} ]; then
    echo "= ${NEWTITLE}" >>${DOC}
    echo "" >>${DOC}
  elif [ ${NEWDEPTH} -lt ${NESTINGDEPTH} ]; then
    OFFSET=$((1 + ${NEWDEPTH}))
    echo ":leveloffset: ${OFFSET}" >>${DOC}
    echo "" >>${DOC}
  fi
  NESTINGDEPTH=${NEWDEPTH}
  SECTIONTITLE=${NEWTITLE}

  echo "include::${FILE}[]" >>${DOC}
  echo "" >>${DOC}
  translit ${FILE}
done

echo ":leveloffset: 1" >>${DOC}
echo "" >>${DOC}

echo "= Get the PDF" >> ${DOC}
echo "link:${FILENAME}.pdf[Download ${FILENAME}.pdf]" >> ${DOC}
echo "" >> ${DOC}

# html
asciidoctor -v -r asciidoctor-diagram -a toc=left -a allow-uri-read -o ${OUTPUT_DIR}/index.html ${DOC}

# pdf
asciidoctor-pdf -r asciidoctor-diagram -a toc=left -a allow-uri-read -a imagesdir=${IMAGES_DST} -a imagesoutdir=${IMAGES_DST} -o ${OUTPUT_DIR}/${FILENAME}.pdf ${DOC}
