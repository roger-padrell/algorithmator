# Package

version       = "0.1.0"
author        = "Roger Padrell Casar"
description   = "A collection of algorithms visually represented"
license       = "MIT"
srcDir        = "src"
bin           = @["rect", "voronoiLloyd", "nBody2D", "sand", "conway"]

# Custom silent run task
import os, strutils
task all, "Return a list of all implementations":
    echo "List of available implementations:"
    for file in walkDir("./src"):
        if splitFile(file[1]).ext.endsWith(".nim"):
            echo "- " & splitFile(file[1]).name

# Dependencies

requires "nim >= 2.2.2"

requires "drawim >= 0.1.2"