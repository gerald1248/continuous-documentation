#!/bin/sh

docker run -it -v `pwd`:/documents/ asciidoctor/docker-asciidoctor ./process.sh
