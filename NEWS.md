# AEC 0.2.0

AEC now supplies only the fourteen documented teaching datasets used or
documented by the current EcoStat course. Legacy data and unreviewed raw
inputs have been removed from this release and retained in a private archive.
This change does not erase earlier Git history or grant rights to old files.

The former econometric procedures are no longer exported by AEC. Use IdSS
for its documented public API (including estim.armax, sim.arma and VAR/SVAR
procedures). Historical AEC code is retained privately, not silently aliased
to possibly different algorithms. The three current books are checked
against the new package contents.

Offline reconstruction tests retain exact structure, keys, dates and counts,
with an elementwise tolerance of 64 machine epsilons for real-valued columns
to accommodate cross-platform decimal conversion. The Paris reconstruction
uses base R and shasum, without jsonlite or digest.
