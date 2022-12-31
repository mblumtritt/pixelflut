# Pixelflut

A Pixelflut client written in Ruby.

## Description

Based on the idea of a simple server protocol to collaborate on a shared canvas named [Pixelflut](https://cccgoe.de/wiki/Pixelflut) this gem implements a Ruby version of a client.

This gem is an open experiment. You are welcome to fork or create pull requests to find the fastest solution!

### Installation

Use [Bundler](http://gembundler.com/) to install the gem:

```bash
$ gem install pixelflut
```

Now the `pxf` command offers the complete functionality.

### General Help

You'll find some help on the command line:

```bash
$ pxf
Usage: pxf [OPTIONS] IMAGE

Options:
    --host ADDRESS        target host address
-p, --port PORT           target port (default 1234)
-c, --connections CONN    count of connections (default 4)
-x, --transpose-x X       transpose image X pixels
-y, --transpose-y Y       transpose image Y pixels
-s, --scale SCALE         scale image by SCALE factor
-m, --pixel MODE          select pixel coding (RGBX | RGBA | RGB)
-h, --help                print this help
```
