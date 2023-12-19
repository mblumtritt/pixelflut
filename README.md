# Pixelflut

A Pixelflut client written in Ruby.

## Description

Based on the idea of a simple server protocol to collaborate on a shared canvas named [Pixelflut](https://cccgoe.de/wiki/Pixelflut) this gem implements a Ruby version of a client.

This gem is an open experiment. You are welcome to fork or create pull requests to find the fastest solution!

### Installation

Use the Ruby package manager to install the gem:

```sh
gem install pixelflut
```

Now the `pxf` command offers the complete functionality.

### General Help

You'll find some help on the command line:

```
$ pxf
Usage: pxf [options] <image>

Options:
      --host <address>       target host address (default 127.0.0.1)
  -p, --port <port>          target port (default 1337)
  -c, --connections <count>  count of connections (default 4)
  -x, --transpose-x <x>      transpose image <x> pixels
  -y, --transpose-y <y>      transpose image <y> pixels
  -m, --mode <mode>          select pixel encoding (TEXT | BIN)
  -t, --threads              use threads instead of processes
  -h, --help                 print this help
  -v, --version              print version information

```
