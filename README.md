# Personal mineral and rock collection catalog

This catalog began as a personal hobby.

I have been collecting stones and minerals since childhood, inspired by my grandfather, who was a geologist. Long before I understood the science behind them, I was fascinated by the shapes, colors, and weight of "ordinary" stones. Over the years, this curiosity grew into a small but meaningful collection. When I moved to another continent, I brought it with me (about 15 kilograms of rocks) to keep a connection to my childhood, my early curiosity and passion, and the stories behind each rock in the collection.

This repository is my way of documenting, preserving, and sharing that collection in a structured form.

## Structure

```
minerals/          Mineral cards (one .md per specimen)
taxonomy/          Reference pages (classes, groups, glossary)
images/            Specimen photos (one directory per mineral)
_layouts/          Jekyll HTML layouts
styles/            Site CSS
tools/             PDF build scripts, Lua filter, Typst template
.github/workflows/ CI: Pages deployment + PDF generation
```

## Local preview

```bash
bundle exec jekyll serve
# → http://localhost:4000/minerals/
```

## Adding a mineral

1. Copy `minerals/_template.md` to `minerals/<name>.md`
2. Fill in the YAML frontmatter fields
3. Write a description in the body
4. Add photos to `images/<name>/` as JPEG (see below)

## Images

All specimen photos are stored as JPEG (quality 85, max 2000 px on the longest edge). To convert a new image:

```bash
tools/optimize-image.sh input.png images/mineral-name/specimen.jpg
```

## PDF generation

PDF is built with Pandoc + Typst. A Lua filter (`tools/filters/mineral.lua`) transforms each mineral's YAML front matter into formatted sections, and a custom Typst template (`tools/template.typ`) handles layout.

CI builds the PDF automatically on push and creates a GitHub Release when you push a tag:

```bash
git tag v0.1
git push origin v0.1
```

To build locally (requires `pandoc` and `typst`):

```bash
sh tools/update-pdf-sources.sh
sh tools/build-pdf.sh .
```

Or with Docker:

```bash
docker build -t mineral-pdf .
docker run --rm -v "$PWD:/work" mineral-pdf
```

## Deployment

The site deploys to GitHub Pages automatically on push to `main`. Enable Pages in the repo settings with **Source: GitHub Actions**.
