#!/usr/bin/env python3
"""Generate editable PGFPlots snippets from export_matlab_figure manifests."""

from __future__ import annotations

import argparse
import json
import os
from pathlib import Path


def tex_text(value: object) -> str:
    replacements = {"\\": r"\textbackslash{}", "&": r"\&", "%": r"\%", "$": r"\$", "#": r"\#", "_": r"\_", "{": r"\{", "}": r"\}"}
    return "".join(replacements.get(char, char) for char in str(value or ""))


def style_for(series: dict) -> list[str]:
    styles = ["thick"]
    color = series.get("color")
    if isinstance(color, list) and len(color) == 3:
        red, green, blue = (max(0.0, min(1.0, float(x))) for x in color)
        styles.append(f"color={{rgb,1:red,{red:.6g};green,{green:.6g};blue,{blue:.6g}}}")
    styles.append({"--": "dashed", ":": "dotted", "-.": "dashdotted"}.get(series.get("lineStyle"), "solid"))
    marker = {"none": "none", "o": "o", "+": "+", "x": "x", "*": "*", "s": "square", "square": "square", "d": "diamond", "diamond": "diamond", "^": "triangle", "v": "triangle", ">": "triangle", "<": "triangle", ".": "*"}.get(str(series.get("marker", "none")).lower(), "none")
    styles.append(f"mark={marker}")
    if marker != "none":
        styles.append("mark repeat=5")
    plot_type = series.get("type")
    if plot_type == "scatter":
        styles.extend(["only marks", "mark=*"])
    elif plot_type == "bar":
        styles.append("ybar")
    elif plot_type == "stair":
        styles.append("const plot")
    elif plot_type == "errorbar":
        styles.append("error bars/.cd,y dir=both,y explicit")
    return styles


def axis_tex(axis: dict, manifest_dir: Path, output_dir: Path) -> str:
    options = [r"width=0.90\linewidth", r"height=0.56\linewidth", r"unbounded coords=jump", r"grid=major", r"grid style={draw=black!12}", r"legend style={draw=none,fill=none,font=\small}"]
    for key, option in (("title", "title"), ("xlabel", "xlabel"), ("ylabel", "ylabel")):
        if axis.get(key):
            options.append(f"{option}={{{tex_text(axis[key])}}}")
    if axis.get("xscale") == "log":
        options.append("xmode=log")
    if axis.get("yscale") == "log":
        options.append("ymode=log")
    lines = [r"\begin{tikzpicture}", r"  \begin{axis}[", "    " + ",\n    ".join(options), "  ]"]
    for series in axis.get("series", []):
        source = manifest_dir / series["dataFile"]
        relative = Path(os.path.relpath(source, output_dir)).as_posix()
        table_options = "x=x,y=y,col sep=comma"
        if series.get("type") == "errorbar":
            table_options += ",y error minus=yminus,y error plus=yplus"
        lines.append(f"    \\addplot+[{','.join(style_for(series))}] table [{table_options}] {{{relative}}};")
        lines.append(f"    \\addlegendentry{{{tex_text(series.get('name'))}}}")
    lines.extend([r"  \end{axis}", r"\end{tikzpicture}"])
    return "\n".join(lines)


def main() -> int:
    parser = argparse.ArgumentParser()
    parser.add_argument("manifest", type=Path)
    parser.add_argument("output", type=Path)
    args = parser.parse_args()
    manifest_path = args.manifest.resolve()
    output_path = args.output.resolve()
    manifest = json.loads(manifest_path.read_text(encoding="utf-8"))
    axes = manifest.get("axes", [])
    if isinstance(axes, dict):
        axes = [axes]
    if not axes:
        raise SystemExit("Manifest contains no axes.")
    output_path.parent.mkdir(parents=True, exist_ok=True)
    chunks = ["% Generated from MATLAB data; review labels, units, caption, and scientific meaning.", "% Requires \\usepackage{pgfplots} and \\pgfplotsset{compat=1.18}."]
    for index, axis in enumerate(axes, start=1):
        if len(axes) > 1:
            chunks.append(f"% MATLAB axis {index}; arrange multi-panel layouts deliberately.")
        chunks.append(axis_tex(axis, manifest_path.parent, output_path.parent))
    output_path.write_text("\n\n".join(chunks) + "\n", encoding="utf-8")
    print(f"Generated {output_path} from {len(axes)} axis/axes.")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
