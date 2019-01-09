# Continuous documentation

![Docker Automated](https://img.shields.io/docker/automated/gerald1248/continuous-documentation.svg)
![Docker Build](https://img.shields.io/docker/build/gerald1248/continuous-documentation.svg)

Use this repo to generate HTML-with-PDF documentation for arbitrary collections of Asciidoc and Markdown files.

Conversion is handled by the separate image [gerald1248/asciidoctor](https://github.com/gerald1248/asciidoctor), which derives from the upstream image [asciidoctor/asciidoctor](https://github.com/asciidoctor/docker-asciidoctor), adding `pandoc` and charting plugins.

To document your own projects, consider including your own Git repositories as git modules in `doc` or simply copy the scripts in `doc` to the root folder of your repository.

The generated HTML page consolidates all images in a single `images` folder and ends with a download link to the PDF.

Getting started
---------------
Start by adjusting the file `values.json`. It contains the `title` of your project as it will appear at the top of the HTML output and on the title page of the PDF version. Another key is `filename`, which determines the name of the PDF outputl. (The web page always takes `index.html`.)
