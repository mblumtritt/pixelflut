# Pixelflut

A Pixelflut client written in Ruby.

## Description

Based on the idea of a simple server protocol to collaborate on a shared canvas named [Pixel Flut](https://cccgoe.de/wiki/Pixelflut) this gem implements a Ruby version of a client.

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
Usage: pxf [options] IMAGE

Options:
      --host ADDRESS               target host address
  -p, --port NUMBER                target port (default 1234)
  -c, --connections COUNT          count of connections (default 4)
  -x, --transpose-x X              transpose image X pixels
  -y, --transpose-y Y              transpose image Y pixels
  -s, --scale FACTOR               scale image by FACTOR

  -h, --help                       print this help
  -v, --version                    print version information
```
