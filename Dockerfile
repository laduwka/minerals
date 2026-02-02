# Build PDF with Pandoc + Typst

FROM ghcr.io/pandoc/minimal:latest
ENTRYPOINT []
SHELL ["/bin/sh", "-c"]
ENV LANG=C.UTF-8 LC_ALL=C.UTF-8

# Install Typst
RUN apk add --no-cache curl xz \
    && curl -fsSL https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz \
       -o /tmp/typst.tar.xz \
    && tar -xJf /tmp/typst.tar.xz -C /tmp/ \
    && mv /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst \
    && rm -rf /tmp/typst.tar.xz /tmp/typst-x86_64-unknown-linux-musl \
    && apk del curl xz

WORKDIR /work

# Default command builds the PDF using the manifest
COPY tools/build-pdf.sh /usr/local/bin/build-pdf
RUN chmod +x /usr/local/bin/build-pdf
CMD ["/bin/sh","-c","build-pdf /work && echo 'Built mineral-catalog-local.pdf'"]
