# Reading and maintaining AEC

AEC is a data-only package. Econometric procedures live in IdSS.

- `data/`: frozen objects loaded by `data(..., package = "AEC")`.
- `man/`: dataset help, including runnable examples, units and limitations.
- `data-raw/<family>/build.R`: the canonical construction script for each source.
- `inst/data-build/`: installed copies of the reviewed compact construction files.
- `inst/teaching-data/`: provenance, variable mappings and rights evidence.
- `tests/`: independent data checks and installed offline reconstruction checks.

Each R builder can run from a writable root containing `data-raw/` and `data/`.
Use two-space indentation, spaces around operators and after commas, one
statement per line and explicit intermediate names for nested operations.
Retain source checksum checks, calendar conventions and missing-value rules.
Do not download or refresh data as a side effect of installation or testing.

After editing a canonical builder, run this from the repository root:

```sh
python3 data-raw/package-build-sources.py
R CMD build .
```

The copy script uses an explicit list of reviewed files for all nine source
families. Edit this list only after reviewing any new input's provenance,
redistribution terms and size. Never edit installed copies independently.
`inst/data-build/README.md` explains offline reconstruction and which source
families require original files outside the installed package.

Install the built archive in a temporary R library and run `R CMD check`.
The checks cover the fourteen-object inventory, documented units, sample keys,
missingness, numerical benchmarks, size limits and offline reconstruction.
Compare rebuilt objects with the frozen data before accepting a builder change.
The software licence does not replace the data-specific terms in
`inst/DATA-SOURCES.md`.
