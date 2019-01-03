# Continuous documentation

![Docker Automated](https://img.shields.io/docker/automated/gerald1248/continuous-documentation.svg)
![Docker Build](https://img.shields.io/docker/build/gerald1248/continuous-documentation.svg)

Use this repo to generate HTML-with-PDF documentation for arbitrary collections of Asciidoc and Markdown files.

Conversion is handled by the separate image [gerald1248/asciidoctor](https://github.com/gerald1248/asciidoctor), which derives from the upstream image [asciidoctor/asciidoctor](https://github.com/asciidoctor/docker-asciidoctor), adding `pandoc` and charting plugins.

To document your own projects, consider including your own Git repositories as git modules in `doc` or simply copy the scripts in `doc` to the root folder of your repository.

The generated HTML page consolidates all images in a single `images` folder and ends with a download link to the PDF.

Personalisation
---------------
Start by adjusting the file `doc/title.txt`. It should contain the title of your project.

If images (with relative paths) are stored in folders other than `images`, simple string lookups can be added to the process by filling in the file `translit.txt`. Enter the `find` and `replace` expressions as follows:

```
search string|replacement string
another search string|another replacement string
```
