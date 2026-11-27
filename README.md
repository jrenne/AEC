# AEC

Documented datasets supporting the Econometrics and Statistics / EcoStat course.

## New documented teaching data

```r
data("CHaccidents", package = "AEC")
data("CHaccidents_monthly", package = "AEC")
data("CHvotes", package = "AEC")
data("CHvotes_cantons", package = "AEC")
data("UCIcredit", package = "AEC")
data("CHelectricity", package = "AEC")
data("CHelectricity_meters", package = "AEC")
data("CHelectricity_annual", package = "AEC")
data("CHhydro", package = "AEC")
data("CHapples", package = "AEC")
data("CHapples_frost", package = "AEC")
help("CHaccidents", package = "AEC")
help("CHvotes", package = "AEC")
```

| Object | Unit and coverage | Rows | Data terms |
|---|---|---:|---|
| `CHaccidents` | Recorded accident in the **city of Zurich**, 2011–2025 | 70,767 | CC BY, credit ASTRA and City of Zurich |
| `CHaccidents_monthly` | City-month, January 2011–December 2025 | 180 | Same source terms; AEC aggregation |
| `CHvotes` | Federal voting object, 1848–September 2026 | 710 | CC BY 4.0, Swissvotes |
| `CHvotes_cantons` | Canton × voting object, observed combinations 1866–March 2024 | 17,482 | CC BY 4.0, Swissvotes |
| `UCIcredit` | Taiwanese credit-card clients, 2005 repayment histories | 30,000 | CC BY 4.0, Yeh/UCI |
| `CHelectricity` | 184 Swiss installations × local calendar days, 2023–2024 | 134,504 | CC BY 4.0, Kaiser et al. |
| `CHelectricity_meters` | Metadata for all source installations, with sample flag | 2,447 | CC BY 4.0, Kaiser et al. |
| `CHelectricity_annual` | All 2,023 residential meters × two annual summaries, with equipment metadata | 4,046 | CC BY 4.0, Kaiser et al. |
| `USrecession` | Monthly Treasury yields and NBER recession targets, 1982–2024 | 516 | Board public domain; NBER copying permitted with attribution |
| `CHapples` | Swiss class I apple variety × sale month, 2022–2024 | 44 | Workbook-specific processing/publication permission; weather CC BY 4.0 |
| `CHapples_frost` | Two stations × spring years, 2006–2025 | 40 | CC BY 4.0, MeteoSwiss |
| `CHhydro` | Swiss hydropower, wholesale prices, German wind and weather, 2016–2024 | 3,288 | CC BY 4.0; Energy-Charts, SMARD, MeteoSwiss |
| `FRradars` | French camera-site comparisons; three annual crash counts and 639 distinct sites | 21,939 | Licence Ouverte 2.0; Renne (2026) and source-provider terms |

All fourteen objects (nine source families) work offline after installation. Each R help entry provides
the full variable dictionary, units, missing-value treatment, coverage, source,
transformations and limitations. The installed `teaching-data/` directory
contains exact source URLs and SHA-256 hashes, column mappings, observed
accident-code dictionaries and rights evidence. `system.file("teaching-data",
package="AEC")` locates it.

Zurich includes property-damage accidents as well as injury accidents. Reporting
of property damage changed on 1 July 2015; counts are not traffic-adjusted risk
rates. The original Zurich family contains no radar data; the separate FRradars family is documented below. Swissvotes examples focus on participation
and institutions, without party recommendations or political outcome variables.
Objects voted on the same date are not independent voting days. Cantonal
coverage is shorter than national coverage; missing observations are not zeros.

See [CONTRIBUTING.md](CONTRIBUTING.md) for the source map and maintenance checks.

### Rebuild the snapshots

From the repository root, using the archived, checksum-verified CSV files:

```sh
Rscript --vanilla data-raw/CHaccidents/build.R
Rscript --vanilla data-raw/CHvotes/build.R
Rscript --vanilla data-raw/UCIcredit/build.R
Rscript --vanilla data-raw/CHelectricity/build.R
Rscript --vanilla data-raw/CHapples/build.R
Rscript --vanilla data-raw/CHhydro/build.R
python3 data-raw/build-teaching-metadata.py
python3 data-raw/package-build-sources.py
Rscript --vanilla tests/teaching-data.R
Rscript --vanilla tests/credit-electricity.R
Rscript --vanilla tests/apples.R
Rscript --vanilla tests/hydro.R
```

The R scripts require base R and the `shasum` command (available on macOS/Linux);
the UCI source-XLS rebuild also requires `readxl`.
The metadata/copy scripts require Python 3 standard library only. Recreating the
electricity daily intermediate from Zenodo requires pandas and the external
904 MB source ZIP; neither is needed for ordinary use or for the compact offline
rebuild. The ZIP stays outside Git and outside the installed package. Downloads and
refreshes are separate maintenance operations. A source update requires review
of its terms, schemas, hashes and documentation; the scripts deliberately reject
an unreviewed replacement file. Raw inputs stay out of R source-package builds
through `.Rbuildignore` but remain subject to data terms in Git.

## Release scope and redistribution

Version 0.2.0 ships fourteen documented data objects and their reviewed
construction inputs. Legacy datasets and procedures have been removed from
this release. Use IdSS for time-series and structural-shock procedures.
Software is MIT; data retain the separate terms in `inst/DATA-SOURCES.md`.
Removing current files does not remove previous public Git history.

## Size and installed construction scripts

The fourteen compressed data objects are below 3 MiB in total. Construction
scripts and compact electricity inputs are installed under `data-build/`, below
3 MiB. Locate them with `system.file("data-build", package="AEC")`; its README
explains a rebuild in a writable directory. The package never downloads sources
automatically. Tests enforce both size limits. Legacy datasets are excluded from this release.

UCIcredit preserves undocumented demographic/status codes and negative statement
balances. It contains neither incomes nor loan interest rates. Electricity
sampling takes at most 30 meters per installation type; sample averages are not
Swiss household population averages. Complete-day totals are NA for incomplete
days, and local-day aggregation accounts for daylight saving time.

## US recession early-warning panel

`USrecession` adds 516 monthly observations, January 1982–December 2024:
3-month and 10-year Treasury yields, their spread, NBER recession status and
a matched twelve-month-ahead target (last twelve targets are missing). It is
about 4 KB compressed. See `?USrecession` for units and temporal conventions,
`teaching-data/US-EWS-RIGHTS.md` for the corrected source-specific copying
permission, and `data-build/USrecession/` for compact offline construction inputs.
Credit the Board of Governors of the Federal Reserve System, U.S. Treasury and
National Bureau of Economic Research, Business Cycle Dating Committee.
NBER notice: Permission to copy is granted, provided attribution of source is given.
This permission does not relicense unrelated NBER material or legacy AEC data.

The annual electricity table retains all 1,528 apartment and 495 single-family-house
meters, independently of the daily subsample. Complete-day counts accompany annual
and seasonal means; no coverage threshold is imposed in the stored object.
Use `subset(CHelectricity_annual, year == 2024 & import_days >= 350)` for a
well-covered one-year cross section. Equipment flags are static source metadata,
not verified year-specific treatments. See `?CHelectricity_annual`.


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

`FRaccidents_daily` adds a compact Paris accident/rainfall application: 3,287
consecutive 06-to-06 UTC days in 2011-2019, 57,266 BAAC injury accidents and
independent Paris-Montsouris rainfall. The data object is about 6 KiB. See its
help for units, interval alignment, source attributions and Licence Ouverte 2.0
redistribution conditions. Offline inputs and construction scripts are installed
in `data-build/FRaccidents_daily`; the optional extractor uses the article's
`accidents-radars-france` repository and Meteo-France archive. No live download
is needed for classroom use or for rebuilding the packaged object.
