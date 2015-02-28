Haxelib
=======

For documentation, please refer to [haxe.org](http://haxe.org/haxelib)

[![Build Status](https://travis-ci.org/HaxeFoundation/haxelib.svg?branch=master)](https://travis-ci.org/HaxeFoundation/haxelib)

-----

### Running the website for development

(Work in progress instructions, 2015-02-27)

```
# Initial checkout
git clone https://github.com/jasononeil/haxelib.git
git checkout feature/newsite

# Install all the libs
haxelib install newsite.hxml
haxelib git ufront-mvc https://github.com/ufront/ufront-mvc.git

# Create directories
mkdir www
mkdir www/legacy
mkdir www/api/
mkdir www/api/3.0
mkdir www/files/
mkdir www/files/3.0

# TODO: copy assets

# Compile the site
haxe site.hxml
haxe newsite.hxml

# Set up the test database
cd www
neko old.n setup

# TODO: check the permissions, writeable directories etc.

# Start the server
nekotools server -rewrite
```

### About this repo

Build files:

* __haxelib.hxml__: Build the current haxelib tool from src/tools/haxelib/Main
* __legacyhaxelib.hxml__: Build the haxelib tool that works with Haxe 2.x
* __prepare.hxml__: Build a tool to prepare the server (I think)
* __site.hxml__: Build the old website, the legacy website, and the Haxe remoting API.
* __newsite.hxml__: Build the new website, the new site unit tests, and the Haxe remoting API. (Also runs the unit tests).
* __test.hxml__: Build the automated tests.

Folders:

* __/src/__: Source code for the haxelib tool and the website, including legacy versions.
* __/bin/__: The compile target for building the haxelib tool, legacy tool, and site preparation tool.
* __/www/__: The compile target (and supporting files) for the haxelib website (including legacy site and API)
* __/test/__: Unit test source code for running on Travis.
* __/testing/__: A setup for manually testing a complete setup.
* __/package/__: Files that are used for bundling the haxelib_client zip file.
