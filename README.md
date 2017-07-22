# Moonscript boilerplate

A fork of the Moonscript + Löve2D boilerplate. This version is for making Lua
modules fast in Moonscript language.

This is intended for making modules for Löve2D, treating them as libraries, but
you can make standalone Lua programs. The only thing you have to take into
account is that this grunt does not ship with the `run` command.

## Requisites

You need installed:
+ `npm` (and thus, `nodejs`)
+ `Lua`
+ `Grunt CLI` (Or else you will be not able to run the build script)

For Grunt see [GruntJS getting started](https://gruntjs.com/getting-started)

So before starting be sure that you can access them in your console using the
commands of `grunt` and `lua`. If not, check your path.

## How to start

Clone or download this boilerplate, then run `npm install` (Just the first
time).

Then, when `npm` finishes, you can do the command `grunt build-run` or just
`grunt` whenever you want to build your module/library.

## Tested versions

This boilerplate is tested under `Lua 5.3` but should be
compatible with all versions, since uses NodeJS to invoke the compiler and
copy the files.
