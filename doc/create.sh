#!/bin/sh

docker run -it -v `pwd`:/documents/ gerald1248/asciidoctor ./process.sh
