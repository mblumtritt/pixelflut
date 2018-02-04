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
generate   Execute given generator FILEs.
help       Print help for given COMMAND.
server     Start Pixelflut server.
version    Print version information.
```

### Start a server

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
