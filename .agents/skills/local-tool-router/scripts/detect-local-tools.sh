#!/bin/sh

# Portable capability scan for macOS and Linux. It performs no installation,
# network access, service startup, or configuration.

json_mode=false
compact=false
probe_versions=false
output_path=''
probe_timeout=10

while [ "$#" -gt 0 ]; do
    case "$1" in
        --json) json_mode=true ;;
        --compact) json_mode=true; compact=true ;;
        --probe-versions) probe_versions=true ;;
        --output)
            shift
            [ "$#" -gt 0 ] || { printf '%s\n' 'Missing value for --output.' >&2; exit 2; }
            output_path=$1
            ;;
        --timeout)
            shift
            [ "$#" -gt 0 ] || { printf '%s\n' 'Missing value for --timeout.' >&2; exit 2; }
            probe_timeout=$1
            ;;
        *) printf 'Unknown option: %s\n' "$1" >&2; exit 2 ;;
    esac
    shift
done

case "$probe_timeout" in
    ''|*[!0-9]*) printf '%s\n' '--timeout must be a positive integer.' >&2; exit 2 ;;
    0) printf '%s\n' '--timeout must be a positive integer.' >&2; exit 2 ;;
esac

json_escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g; s/\r/\\r/g; s/\n/\\n/g'
}

probe_tool() {
    tool_path=$1
    tool_name=$2
    [ "$probe_versions" = true ] || return 2
    command -v timeout >/dev/null 2>&1 || return 2

    case "$tool_name" in
        matlab|wolframscript|WolframKernel|math|Mathematica) return 2 ;;
        latexmk) args='-v' ;;
        ffmpeg|ffprobe|magick) args='-version' ;;
        dot) args='-V' ;;
        *) args='--version' ;;
    esac

    probe_output_file=$(mktemp "${TMPDIR:-/tmp}/codex-tool-probe.XXXXXX") || return 2
    timeout "$probe_timeout" "$tool_path" "$args" >"$probe_output_file" 2>&1
    probe_code=$?
    probe_output=$(sed -n '1p' "$probe_output_file" | cut -c 1-300)
    rm -f "$probe_output_file"
    if [ "$probe_code" -eq 0 ]; then
        PROBE_STATUS=success
        TOOL_STATUS=available
    elif [ "$probe_code" -eq 124 ]; then
        PROBE_STATUS=timeout
        TOOL_STATUS=unverified
    else
        PROBE_STATUS=failed
        TOOL_STATUS=unverified
    fi
    PROBE_OUTPUT=$probe_output
    return 0
}

tools_json=''
human_rows=''

find_tool() {
    tool_id=$1
    label=$2
    shift 2
    found=''
    found_name=''

    for candidate in "$@"; do
        if command -v "$candidate" >/dev/null 2>&1; then
            found=$(command -v "$candidate")
            found_name=$candidate
            break
        fi
    done

    PROBE_STATUS=not-run
    PROBE_OUTPUT=''
    if [ -n "$found" ]; then
        TOOL_STATUS=unverified
        available=true
        probe_tool "$found" "$found_name" || true
        human_rows="${human_rows}$(printf '%-28s %-11s %s' "$label" "$TOOL_STATUS" "$found")\n"
        command_json="\"$(json_escape "$found_name")\""
        path_json="\"$(json_escape "$found")\""
    else
        TOOL_STATUS=unavailable
        available=false
        human_rows="${human_rows}$(printf '%-28s %-11s' "$label" "$TOOL_STATUS")\n"
        command_json=null
        path_json=null
    fi

    probe_json=null
    if [ "$PROBE_STATUS" != not-run ]; then
        probe_json="{\"status\":\"$PROBE_STATUS\",\"output\":\"$(json_escape "$PROBE_OUTPUT")\"}"
    fi
    entry="{\"id\":\"$(json_escape "$tool_id")\",\"name\":\"$(json_escape "$label")\",\"status\":\"$TOOL_STATUS\",\"available\":$available,\"command\":$command_json,\"path\":$path_json,\"probe\":$probe_json,\"details\":null}"
    if [ -n "$tools_json" ]; then tools_json="$tools_json,$entry"; else tools_json=$entry; fi
}

find_tool matlab 'MATLAB' matlab
find_tool octave 'GNU Octave' octave-cli octave
find_tool wolframscript 'Wolfram Script' wolframscript
find_tool mathematica 'Mathematica or Wolfram Kernel' WolframKernel math Mathematica
find_tool python 'Python' python3 python
find_tool git 'Git' git
find_tool node 'Node.js' node
find_tool npm 'npm' npm
find_tool dotnet '.NET' dotnet
find_tool r 'R' Rscript
find_tool julia 'Julia' julia
find_tool java 'Java' java
find_tool cmake 'CMake' cmake
find_tool cpp-compiler 'C/C++ compiler' clang gcc cc
find_tool pandoc 'Pandoc' pandoc
find_tool latexmk 'LaTeXmk' latexmk
find_tool xelatex 'XeLaTeX' xelatex
find_tool pdflatex 'pdfLaTeX' pdflatex
find_tool bibtex 'BibTeX' bibtex
find_tool biber 'Biber' biber
find_tool makeindex 'MakeIndex' makeindex
find_tool ffmpeg 'FFmpeg' ffmpeg
find_tool ffprobe 'FFprobe' ffprobe
find_tool imagemagick 'ImageMagick' magick
find_tool graphviz 'Graphviz' dot
find_tool docker 'Docker CLI' docker

scanned_at=$(date -u '+%Y-%m-%dT%H:%M:%SZ' 2>/dev/null || printf unknown)
os_name=$(uname -s 2>/dev/null || printf unknown)
architecture=$(uname -m 2>/dev/null || printf unknown)
if [ "$probe_versions" = true ]; then scan_mode=bounded-probe; else scan_mode=discovery; fi
json="{\"schema_version\":1,\"scanned_at\":\"$(json_escape "$scanned_at")\",\"scan_mode\":\"$scan_mode\",\"host\":{\"os\":\"$(json_escape "$os_name")\",\"architecture\":\"$(json_escape "$architecture")\"},\"tools\":[$tools_json]}"

if [ -n "$output_path" ]; then
    output_directory=$(dirname "$output_path")
    [ -d "$output_directory" ] || mkdir -p "$output_directory" || exit 1
    printf '%s\n' "$json" > "$output_path" || exit 1
fi

if [ "$json_mode" = true ]; then
    if [ "$compact" = true ]; then printf '%s\n' "$json"; else printf '%s\n' "$json"; fi
else
    printf 'Local tool capability scan\n'
    printf 'OS: %s\n' "$os_name"
    printf 'Architecture: %s\n\n' "$architecture"
    printf '%b' "$human_rows"
fi
