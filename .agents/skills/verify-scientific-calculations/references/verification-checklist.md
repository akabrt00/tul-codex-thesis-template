# Calculation verification checklist

- Define symbols, units, coordinate system, domain, initial or boundary conditions, and requested precision.
- Separate measured inputs, sourced constants, assumptions, and derived values.
- Check dimensions before numerical substitution.
- Preserve full precision internally and state the rounding rule used for reported values.
- Check zero, sign, limit, range, branch, and order-of-magnitude behavior where meaningful.
- For fitted models, inspect residuals, sample size, parameter uncertainty, and extrapolation limits.
- For statistics, state the population, exclusions, missing-data handling, and method assumptions.
- Compare independent methods using an explicit tolerance justified by the problem.
- Record software, plugin, toolbox, package, or algorithm versions when they may affect reproducibility.
- Treat disagreement as an unresolved result until its cause is understood.
