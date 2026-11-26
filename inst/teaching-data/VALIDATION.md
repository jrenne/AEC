# Validation of the new teaching data

20 October 2026, R 4.5.1 on macOS arm64.

- Both R preparation scripts complete from the frozen source CSVs. Each rejects
  a changed input SHA-256 instead of silently refreshing the snapshot.
- Four .rda objects are built: 70,767 Zurich accidents (24 columns), 180 monthly
  rows (7 columns), 710 national voting objects (14 columns), and 17,482 observed
  canton-object rows (7 columns).
- tests/teaching-data.R passes from the source repository and against an isolated
  installed package. It independently checks raw-column alignment, keys, foreign
  keys, coverage/cut-off, every monthly severity count, missing values, source
  mappings, cantonal reshaping and neutral teaching calculations.
- All four help examples execute successfully. R CMD check reports the Rd
  structure, metadata, cross-references, usage, contents and examples OK.
- R CMD build and R CMD INSTALL succeed. The final source-package R CMD check
  has **0 errors, 3 warnings and 1 note**. The remaining diagnostics concern the
  pre-existing software-licence placeholder, undocumented legacy procedures and
  datasets, invalid character encodings in the legacy credit object, and missing
  namespace imports/global-variable notes in legacy R code. No new teaching
  object is named in the encoding or missing-documentation diagnostics.
- The build now excludes the macOS Finder Icon file, declares the existing
  R >= 3.5.0 serialization requirement and uses xz lazy-data compression.
- Legacy data were not changed. No public release, push, course rebuild,
  dependency-lock update or replacement of the user's installed AEC was made.

Rights are separate from technical validation: the new Zurich export is CC BY
with source credit and Swissvotes is CC BY 4.0. See RIGHTS.md. The overall AEC
redistribution audit remains open because legacy restricted data remain present.


## Credit and electricity addition, 20 October 2026

- UCIcredit contains 30,000 rows and 25 columns, including 6,636 positive
  next-month default indicators. Source values and undocumented codes retained.
- CHelectricity contains 134,504 local meter-days for 184 Swiss installations
  over 2023--2024. CHelectricity_meters retains all 2,447 source metadata rows.
- The Zenodo v1 archive matches published MD5
  dd40d5e24aee2a3563bc36285b463dbd. Its archived API record confirms CC BY 4.0.
- Seven new compressed data objects total 2,347,760 bytes. Installed construction
  scripts and compact inputs total 1,712,272 bytes. Size tests enforce limits of
  3 MiB and 2 MiB respectively. The original 904 MB ZIP is not included.
- Both source tests and installed-package tests pass. Additional tests cover
  retained credit codes, client keys and outcome counts, electricity panel keys,
  partial-day missing values, net energy, all four 2023--2024 Swiss daylight-saving
  transitions, deterministic type sample sizes and weights, dictionaries, size
  budgets, and exact offline reproduction from the installed construction files.
- Full R CMD check: zero errors, 3 warnings and 1 note, as before. All examples
  and both data-test scripts pass. Remaining warnings/notes are the legacy issues
  described above, not new data or documentation problems.
- Construction scripts for all four families are installed in data-build/.
  Electricity can be rebuilt offline from compact inputs; prepare.py supports
  optional reaggregation from the external original archive. Credit rebuilding
  needs the versioned UCI ZIP and readxl. Neither is needed for ordinary use.

## US recession panel

516 consecutive monthly rows, 1982-01 through 2024-12, with seven variables.
47 contemporaneous recession months; 504 twelve-month target matches containing
36 recession months; the final twelve target values remain NA. Tests check
peak/trough boundaries, calendar lead alignment, units/spread identity, the
13/28/23/440 warning confusion counts, threshold monotonicity and exact offline
reconstruction from the installed compact inputs. The compressed object is
4,020 bytes. Specific NBER attribution permission is preserved separately.

## Full residential annual electricity extension

- All 2,023 residential source meters retained: 1,528 apartments and 495 houses,
  each with 2023/2024 rows (4,046 rows, 30 columns); no coverage-based selection.
- At least 350 complete import days: 1,738 homes in 2023 (1,279 apartments,
  459 houses), 1,480 in 2024 (1,035 apartments, 445 houses).
- Original archive MD5 verified; all residential meter files processed. Local
  complete-day rules match the existing daily panel, including DST.
- tests/electricity-annual.R checks the full residential universe, unique keys,
  day-count limits, missingness, sum/mean identities, and independently reaggregates
  overlapping daily meters to verify annual and seasonal summaries.
- tests/credit-electricity.R verifies exact reconstruction of all three electric
  objects from installed compact inputs, complete installed field mappings and
  unchanged size budgets (new teaching data <3 MiB; build inputs <2 MiB).
- Annual .rda: 114,084 bytes; compact annual input: 131,528 bytes. The original
  904 MB archive remains outside the package.


Swiss apples (CHapples, CHapples_frost): 44 monthly variety observations and
40 station-year spring frost summaries. Market source: BLW, Fachbereich
Marktanalysen; SWISSCOFEL, 20 September 2024 accompanying workbook. Its explicit
processing/publication permission requires attribution (deutsch H5); this is
not a blanket CC licence for the portal or other archives. Weather: Source:
MeteoSwiss, CC BY 4.0, April-May 2006-2025 daily Tmin at SIO/GUT, aggregated by
AEC. Preserve both attributions and indicate transformations. See package
help and data-build/CHapples/RIGHTS.txt for exact scope, URLs and frozen evidence.
Offline inputs and scripts reproduce both objects; only two harvest years
have matched market data, so the frost IV does not support precise inference.


CHhydro adds 3,288 observed daily Swiss market rows, 2016–2024, with original
Energy-Charts/SMARD electricity series and MeteoSwiss station weather. All source
data are CC BY 4.0 with distinct required attributions: Energy-Charts.info /
Fraunhofer ISE; Bundesnetzagentur | SMARD.de; Source: MeteoSwiss. Retain licence
link https://creativecommons.org/licenses/by/4.0/ and state AEC aggregation/joins.
See ?CHhydro and data-build/CHhydro/RIGHTS.txt for permissions, provenance,
negative prices, DST, incomplete-day handling and identification limits.
The snapshot precedes the documented 2025 production-source change. Compact
inputs and offline construction scripts are installed; large raw API responses
are excluded. Data-only size remains below 3 MiB; the collective construction
file budget is now 3 MiB to include the new reproducible inputs.


FRradars (21 October 2026) adds a compact extraction of Renne's October 2026
speed-camera paper: 21,939 comparison rows, 406 treated stacks and 639 distinct
sites. Three integer annual crash counts reproduce the article's principal
2 km network / 100 m corridor first-year point estimate without raw personal
records or large spatial inputs. Processed data use Licence Ouverte 2.0; credit
Jean-Paul Renne, Ministry of the Interior/ONISR and DSR, Antoine Augusti, IGN
and OpenDataSoft, retaining underlying source terms (including commune inputs
under Licence Ouverte 1.0). See ?FRradars and data-build/FRradars/RIGHTS.txt.
All source notices, input/script hashes, optional extraction and offline build
code are installed. The R data file is about 19 KiB. Repeated control appearances
are not independent observations; the help explains weighting and site-level
resampling. Classroom inference is distinguished from the archived article
bootstrap. The family is an explicit user-requested French exception to the
preference for Swiss examples. Collective data/build budgets remain 3 MiB each.

## Paris daily accidents and rainfall, 22 October 2026

- FRaccidents_daily contains 3,287 consecutive observation intervals, 2011-2019,
  seven columns and 57,266 recorded injury accidents from department 75.
- Independent Montsouris RR observations cover every interval. The original
  QRR flags are retained; no interpolation or complete-case loss is hidden.
- Accident clock times are converted from Europe/Paris to UTC and grouped over
  the rain gauge's 06-to-06 UTC intervals, with boundary-day source records.
- tests/paris-weather.R passes in the source tree and against an isolated
  installed package, including identical offline reconstruction from installed
  compact inputs. Existing tests/radars.R continues to pass.
- The compressed data object is 6,396 bytes. Large accident/weather archives
  remain outside the package; compact source counts and station values, SHA256
  provenance, extraction/build scripts, metadata and licence notices are included.
- Chapter 4 and the data appendix have been rebuilt in HTML/PDF. Early examples
  use the Paris daily series and large-sample HAC inference; Swissvotes is
  introduced in the two-way clustering section and reused for shrinkage.
