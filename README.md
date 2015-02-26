Haxelib
=======

For documentation, please refer to [haxe.org](http://haxe.org/haxelib)

[![Build Status](https://travis-ci.org/HaxeFoundation/haxelib.svg?branch=master)](https://travis-ci.org/HaxeFoundation/haxelib)

-----

### About this repo

Build files:

* __haxelib.hxml__: Build the current haxelib tool from src/tools/haxelib/Main
* __legacyhaxelib.hxml__: Build the haxelib tool that works with Haxe 2.x
* __prepare.hxml__: Build a tool to prepare the server (I think)
* __site.hxml__: Build the website, the legacy website, and the Haxe remoting API.
* __test.hxml__: Build the automated tests.

Folders:

* __/src/__: Source code for the haxelib tool and the website, including legacy versions.
* __/bin/__: The compile target for building the haxelib tool, legacy tool, and site preparation tool.
* __/www/__: The compile target (and supporting files) for the haxelib website (including legacy site and API)
* __/test/__: Unit test source code for running on Travis.
* __/testing/__: A setup for manually testing a complete setup.
* __/package/__: Files that are used for bundling the haxelib_client zip file.
