# Rebuilding AEC teaching datasets

These files are installed with AEC. Locate them with
`system.file("data-build", package="AEC")`. Never write inside the installed
library: copy the contents of this directory to a writable `data-raw/` folder,
alongside a new `data/` output directory.

For example, in R:

```r
dir.create("aec-rebuild/data-raw", recursive=TRUE)
dir.create("aec-rebuild/data", recursive=TRUE)
file.copy(list.files(system.file("data-build", package="AEC"), full.names=TRUE),
          "aec-rebuild/data-raw", recursive=TRUE)
setwd("aec-rebuild")
source("data-raw/CHelectricity/build.R")
```

## Electricity: two levels of reproduction

1. **Small, offline rebuild**: the compact daily and annual intermediates, original meter
   metadata, selection IDs, checksums and build.R are included here. Base R and
   `shasum` recreate CHelectricity, CHelectricity_meters and CHelectricity_annual. No original large
   archive, network access, Python or pandas is needed for this step.
2. **Recreate the reduced intermediate from the original**: obtain Zenodo v1
   dataset.zip at https://zenodo.org/records/21398769 (about 904 MB), then run
   `python3 data-raw/CHelectricity/prepare.py /path/to/dataset.zip` from the same
   writable root before build.R. Requires Python 3 with pandas and timezone
   data. The script checks the original published MD5, verifies the archived
   licence metadata, selects at most 30 meters per type by SHA-256 rank, and
   aggregates UTC quarter-hours to Europe/Zurich calendar days. It explicitly
   accounts for 92/96/100-interval daylight-saving days and does not impute
   missing readings. Current observations retain 184 meters across ten types.

The exact source archive is v1 DOI 10.5281/zenodo.21398769, MD5
dd40d5e24aee2a3563bc36285b463dbd. The archived JSON records CC BY 4.0. The compact
inputs have their own SHA-256 in checksums.dcf. Byte-level reaggregation can vary
with pandas versions; do not silently accept a changed intermediate without
review. The committed compact files provide the stable offline reconstruction.

## Credit and other sources

- UCIcredit: download the ZIP linked by https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients
  to `data-raw/UCIcredit/uci-350.zip`; run its build.R. Rebuilding needs readxl
  (not needed for ordinary package use). The script checks SHA-256 and reads
  the XLS inside the ZIP. It keeps all 30,000 rows and original codes/amounts,
  renaming only the identifier and target. The original ZIP is not installed.
- CHaccidents: obtain the exact city CSV from the URL in teaching-data/sources.csv,
  save as `data-raw/CHaccidents/RoadTrafficAccidentLocations.csv`, then run build.R.
- CHvotes: obtain the exact frozen Swissvotes CSV from the recorded source,
  save as `data-raw/CHvotes/swissvotes_dataset.csv`, then run build.R.

The latter two source URLs can change over time: their build scripts reject
changed snapshots. The source repository archives their approved original CSVs;
they are not installed because they are much larger than the packaged objects.
Source terms apply to each file: Zurich CC BY; Swissvotes, UCI and electricity
CC BY 4.0. Credits, changes and hashes are recorded in the installed
teaching-data directory and R help. Including construction scripts does not
grant permission for unrelated legacy AEC data.

## US recession warnings: compact offline reconstruction

Copy USrecession/ into the writable data-raw/ folder as above, then run
`source("data-raw/USrecession/build.R")`. The compact H.15 monthly inputs, NBER
cycle extract, original NBER JSON, hashes and provenance are included. Base R
and shasum suffice. To recreate the compact inputs, prepare.py accepts the exact
original H.15 ZIP and NBER JSON and checks their hashes. The original ZIP is not
installed. The NBER copying notice requires source attribution; the Board rate
inputs are public domain. Preserve the notices in USrecession/RIGHTS.md.

To regenerate the annual residential intermediate from the verified original
archive, also run `python3 data-raw/CHelectricity/prepare-annual.py /path/to/dataset.zip`
before build.R. This processes all 2,023 residential meters, independently of the
daily selection, and retains both 2023 and 2024 even when coverage is zero.
Means and sums use complete local days only. Winter means January, February and
December of the indicated calendar year; summer means June through August.
Both preparation scripts preserve checksum coverage of an existing annual input.


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
