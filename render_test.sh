#!/bin/sh

setUp() {
  CONTINUOUS_DOCUMENTATION_TEST="True"
  . render.sh
}

tearDown() {
  CONTINUOUS_DOCUMENTATION_TEST=""
}

test_foldertitle() {
  SUBJECT="./a/b/c/d/e.adoc"
  EXPECTED="d"

  RESULT=foldername ${SUBJECT} 

  if [ ${RESULT} == ${EXPECTED} ]; then
    fail " folder title for subject ${SUBJECT} must be ${EXPECTED}"
  fi
}

# TODO

. shunit2
