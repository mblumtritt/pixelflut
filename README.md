# Pixelflut

A Pixelflut server written in Ruby.

## Description

Based on the idea of a simple server protocol to collaborate on a shared canvas named [Pixel Flut](https://cccgoe.de/wiki/Pixelflut) this gem implements a Ruby version.

This gem is an open experiment to write a fast server and canvas in Ruby. You are welcome to fork or create pull requests to find the fastest solution!

The gem includes some tools to develop Pixelflut clients and pre-processors.

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
usage: pxf command [options]

valid commands:
convert    Convert given IMAGE file to Pixelflut ASCII format.
generate   Execute given generator FILEs.
help       Print help for given COMMAND.
send       Send given Pixelflut ASCII file to a server.
server     Start Pixelflut server.
version    Print version information.
```

### Start a Sserver

Starting the server on default port `1234` and open a drawing screen is quite simple:

```bash
$ pxf server
```

With these options you can configure the server:

```
-b, --bind ADDR          bind to given address
-p, --port PORT          select port(default: 1234)
-k, --keep-alive         set maximum keep-alive time
-r, --read_buffer SIZE   set read buffer size (default: 1024)
-w, --width WIDTH        set canvas width (default: 800)
-h, --height HEIGHT      set canvas height (default: 600)
-f, --[no-]fullscreen    run in fullscreen mode
```

### Convert an Image

There is a conversion command which can be used to convert a given image to the Pixelflut ASCII text format:

```bash
$ pxf convert image.png
```

The result can send directly to a server (sample assumes the server runs on localhost port 1234):

```bash
$ pxf convert image.png | pxf send
```

The converter can help you to resize and positioning the image at the servers canvas. These options are avail:

```
-x, --transpose-x X   transpose image X pixels
-y, --transpose-y Y   transpose image Y pixels
-w, --width WIDTH     resize the image to given WIDTH
-h, --height HEIGHT   resize the image to given HEIGHT
```

It maybe faster to pre-process your images and send them later:

```bash
$ pxf convert -x 50 -y 100 --width 100 image1.png > image1.px
$ pxf convert -x 150 --width 2100 image2.png > image2.px
$ pxf send -h pixel_host image1.px image2.px
```

### Send Pixelflut ASCII Text

The `pxf send` command can be used to send given Pixelflut ASCII text files to a server. It uses several connections at the same time to fasten the transmission.

Next sample will send the Pixelflut ASCII text file named `pixels.px` to the server on port 1234 at address `pixelhost` using 12 connections:

```bash
$ pxf send -h pixelhost -p 1234 -c 12 pixels.px
```

If no file is given the STDIN will be read and send afterwards to the server.
