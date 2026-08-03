#!/bin/sh

# Portable capability scan for macOS and Linux. It performs no installation or configuration.

find_tool() {
    label=$1
    shift
    found=''

    for candidate in "$@"; do
        if command -v "$candidate" >/dev/null 2>&1; then
            found=$(command -v "$candidate")
            break
        fi
    done

    if [ -n "$found" ]; then
        printf '%-20s available  %s\n' "$label" "$found"
    else
        printf '%-20s missing\n' "$label"
    fi
}

printf 'Local tool capability scan\n'
printf 'OS: %s\n' "$(uname -s 2>/dev/null || printf unknown)"
printf 'Architecture: %s\n\n' "$(uname -m 2>/dev/null || printf unknown)"

find_tool 'MATLAB' matlab
find_tool 'Python' python3 python
find_tool 'Git' git
find_tool 'Node.js' node
find_tool 'npm' npm
find_tool '.NET' dotnet
find_tool 'R' Rscript
find_tool 'Julia' julia
find_tool 'Java' java
find_tool 'CMake' cmake
find_tool 'C/C++ compiler' clang gcc cc
find_tool 'Pandoc' pandoc
find_tool 'LaTeX' latexmk pdflatex xelatex
find_tool 'FFmpeg' ffmpeg
find_tool 'Docker' docker

