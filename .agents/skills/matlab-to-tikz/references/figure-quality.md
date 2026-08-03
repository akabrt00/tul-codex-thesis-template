# PGFPlots figure quality

## Layout

- Size a thesis plot near `width=0.90\linewidth` and `height=0.56\linewidth`; adjust for labels, the actual column, and content.
- Keep plot-area proportions comparable across related figures.
- Prefer one clear message per plot. Use subplots only when shared scales or direct comparison justify them.
- Keep tick labels horizontal when practical and avoid unnecessary tick density.

## Typography and notation

- Let LaTeX typeset all labels, legends, and mathematics.
- Use the document language consistently. Preserve established symbols from the surrounding text.
- Write a quantity and unit together, preferably using the project's `siunitx` convention, for example `Čas $t$ (s)`.
- State multipliers explicitly, such as `$\times 10^3$`, and never hide normalization.

## Series and color

- Distinguish series with color plus solid/dashed/dotted lines or distinct markers.
- Prefer a color-blind-safe palette and confirm that the graph remains understandable in grayscale.
- Avoid red–green-only contrasts, gradients without a labeled color bar, transparency that changes interpretation, shadows, and 3-D decoration.
- Use marks only densely enough to identify sampled values; do not cover a continuous curve with oversized markers.

## Data integrity

- Preserve numeric precision in data files and control displayed precision through tick formatting.
- Do not smooth, interpolate, truncate, normalize, aggregate, or remove outliers without scientific justification and disclosure.
- Label measured, simulated, fitted, and reference series accurately.
- Define error bars or bands in the caption or surrounding text: standard deviation, standard error, confidence interval, tolerance, or another quantity.
- Use logarithmic axes only when scientifically appropriate and clearly labeled. Check non-positive values before conversion.

## PGFPlots practices

- Keep larger datasets in relative-path CSV files and use `table` rather than thousands of inline coordinates.
- Use `unbounded coords=jump` for intentional gaps represented by non-finite values.
- Use stable axis limits only when comparison requires them; otherwise include all valid data with modest whitespace.
- Set legend entries from scientific series names, not filenames or MATLAB object handles.
- Load optional PGFPlots libraries only when used.
