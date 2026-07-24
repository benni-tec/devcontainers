#!/bin/bash

TEX_REQUIREMENTS="${TEX_REQUIREMENTS:=requirements.tex.txt}"

installed=$(tlmgr list --only-installed --data name)
# installed="sttools algorithms algorithmicx"
for pkg in $(cat "$TEX_REQUIREMENTS"); do
    if echo "$installed" | grep -qxF "$pkg"; then
        echo "$pkg is already installed, skipping."
        continue
    fi
    tlmgr install "$pkg"
done
tlmgr path add
