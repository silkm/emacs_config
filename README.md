# emacs_config
My Emacs init.el, uses straight.el package management

## Overview

It's hard to recommend Emacs to anyone who just wants to get things done, and isn't really interested in keyboard shortcuts and customising their workspace. I tend to describe Emacs by saying it's a hobby and a toy before it's a glorious customisable editor of all kinds. With straight.el configuration I actually now think it's recommendable, but with the caveat that it won't make you more productive for a long time, it'll just make you really, really happy if you like this kind of thing.

This config applies to Emacs 26 but will hopefully be applicable to future versions of Emacs, but you know how it is...

## What's in the box

The config in short

* Bootstrapping straight.el for sane package management
* Better defaults and global settings
* Themes
* Navigation and productivity
* Editors and configs
* Org-mode
* Custom-set-variables, custom-set-faces

## How to use

Create a directory `~/.emacs.d/` and place `init.el` inside there. Install and open GNU Emacs and it will automatically load init.el and install all packages to `~/.emacs.d/`.

Everything should work out of the box, you will need to change the customisation settings to suit you depending on what you use it for. ie. if you open an R script, it will set the *major mode* to `ess` and use the configuration in `init.el`, including which R instance to use, so that's something you may need to change.
