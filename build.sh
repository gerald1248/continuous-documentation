#!/bin/sh

docker run -v `pwd`:/documents/ gerald1248/asciidoctor ./render.sh
