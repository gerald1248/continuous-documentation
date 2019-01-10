#!/bin/sh

setUp() {
  CONTINUOUS_DOCUMENTATION_TEST="True"
  . render.sh
}

tearDown() {
  CONTINUOUS_DOCUMENTATION_TEST=""
}

test_foldername() {
  SUBJECT="./a/b/c/some-folder-name/e.adoc"
  EXPECTED="some-folder-name"

  RESULT=`foldername ${SUBJECT}`

  if [ "${RESULT}" != "${EXPECTED}" ]; then
    fail " folder name for subject \"${SUBJECT}\" must be \"${EXPECTED}\" but was \"${RESULT}\""
  fi
}

test_foldertitle() {
  SUBJECT="./a/b/c/some-folder-name/e.adoc"
  EXPECTED="SOME-FOLDER-NAME"

  RESULT=`foldertitle ${SUBJECT}`

  if [ "${RESULT}" != "${EXPECTED}" ]; then
    fail " folder title for subject \"${SUBJECT}\" must be \"${EXPECTED}\" but was \"${RESULT}\""
  fi
}

test_nestingdepth() {
  SUBJECT="./a/b/c/some-folder-name/e.adoc"
  EXPECTED=4

  RESULT=`nestingdepth ${SUBJECT}`

  if [ "${RESULT}" != "${EXPECTED}" ]; then
    fail " nesting depth for subject \"${SUBJECT}\" must be \"${EXPECTED}\" but was \"${RESULT}\""
  fi
}

. shunit2
