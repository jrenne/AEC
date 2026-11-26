# Teaching dataset redesign

Decision record, 20 October 2026.

## Agreed direction

AEC will be the documented distribution point for a small number of recurring
teaching datasets. Prefer Swiss observations. The package documentation will
describe each dataset independently of its use in EcoStat; a dedicated course
chapter will introduce the questions and observation structures.

The initial redesign replaced French accidents with Swiss road accidents.
On 21 October 2026, the user requested a simplified application of their
French speed-camera paper for Chapter 5 DiD. FRradars is the resulting small
exception: it complements, rather than replaces, the Zurich accident data. The debt
issuance proposal has also been set aside because clear redistribution terms
have not been established for the auction workbooks.

## Target families and current evidence

All eight families have now been imported, with user-approved city-only
accident coverage and the accepted Taiwanese UCI credit source.

| Proposed family | Observational unit and purpose | Source / rights status |
|---|---|---|
| `CHaccidents` / `CHaccidents_monthly` | Recorded accidents with injury OR property damage in the **city of Zurich**, plus monthly city counts. No radars. | Imported: 70,767 accidents and 180 months, 2011--2025. Explicit CC BY city export with ASTRA credit. City-only scope approved by user. National-file rights remain unresolved; no national observations imported. |
| `CHvotes` / `CHvotes_cantons` | Federal object-level institutional/participation fields plus an unbalanced canton-object panel. No invented common voting-day turnout. | Imported: 710 national objects and 17,482 canton-object rows. Explicit CC BY 4.0, Swissvotes. Full source/version/hash, dictionaries and transformations documented in R help and teaching-data/. |
| `CHelectricity` / `CHelectricity_meters` | Daily energy exchange for 184 Swiss meters plus all 2,447 source metadata rows. | Imported under confirmed CC BY 4.0, Zenodo v1. Daily panel: 134,504 rows. No weather included. Compact daily inputs and all build scripts are installed; 904 MB archive excluded. |
| `UCIcredit` | 30,000 Taiwanese credit-card clients with binary next-month payment outcome and six-month histories. | Imported under CC BY 4.0, UCI dataset 350. Non-Swiss source explicitly accepted by user. Original codes/amounts retained; only ID and outcome renamed. |
| `USrecession` | Monthly yield-curve warning and recession outcomes at a fixed twelve-month horizon. | Imported: 516 months, 1982–2024. Direct Board public-domain H.15 inputs; specific NBER copying permission with attribution. |

| `CHapples` / `CHapples_frost` | Monthly Swiss class I Gala/Golden wholesale sales and prices, plus two-station spring weather. | 44 market rows; 40 station-years. Specific attribution-based workbook permission; weather CC BY 4.0. |

| `CHhydro` | Original Swiss reservoir production, wholesale prices, German wind and daily weather, 2016–2024. | Imported: 3,288 days; CC BY 4.0, Energy-Charts/SMARD/MeteoSwiss; compact offline inputs installed. |

## Nonpartisan voting examples

Use participation and institutional procedure as the recurring theme. Main
examples should not depend on political parties, voting recommendations or
polarising policy subjects. Preserve source identifiers and documentation so
that observations remain traceable. Do not secretly select observations to
produce a desired conclusion.

Objects on the same day share participation conditions and are not independent
replicates. Define voting-day participation carefully: object-specific valid
ballots/participation must not be silently treated as identical. A regression
of participation on the number of objects is descriptive unless a defensible
identification strategy is supplied.

## Package documentation required for each imported dataset

- R help entry with definition, observational unit, coverage, dimensions,
  variable meanings, units, categorical levels and missing-value rules.
- Original producer, exact source URLs, source version/access date, immutable
  input checksum and the applicable data-specific reuse terms and citation.
- Reproducible preparation script in `data-raw/`, with no credentials or
  restricted respondent files committed. Raw files may be archived publicly
  only when their terms allow it.
- Explicit transformation and selection rules. Keep derived panels and
  aggregates distinguishable from source observations.
- Checks for keys, duplicate records, date coverage, units and documented
  consistency relations; preserve a fixed teaching vintage.
- Updated `inst/DATA-SOURCES.md`, `inst/COPYRIGHTS` and README. The software
  licence must not silently replace third-party data terms.

Students should be able to use packaged snapshots without network access once
installed. Download/refresh is a separate maintenance operation. Existing SHP,
HRS and other legacy data remain subject to the audit and cannot be declared
cleared merely because replacements are planned.

## Accident interpretation

Neither the selected Zurich export nor the public national dataset is the French BAAC relational
database. Do not assume it includes individual age, sex, income, vehicle records
or numbers of injured people simply because BAAC did. Check the actual schema
before choosing an exercise. A severe-accident model describes severity among
recorded injury accidents; it is not a population risk model for all road users.
Regional counts need an exposure measure if interpreted as accident rates.

## Evidence links

- OFROU dashboard and official download entry:
  https://www.astra.admin.ch/fr/dashboard-fr
- Accident dataset catalogue:
  https://opendata.swiss/en/dataset/strassenverkehrsunfallorte
- Catalogue filtered to open-use resources (supporting, not conclusive evidence):
  https://opendata.swiss/en/dataset?organization=bundesamt-fur-strassen-astra&political_level=confederation&res_license=https%3A%2F%2Fopendata.swiss%2Fterms-of-use%23terms_open
- Official STAC collection, including its conflicting generic licence metadata:
  https://data.geo.admin.ch/api/stac/v0.9/collections/ch.astra.unfaelle-personenschaeden_alle
- Swissvotes dataset, licence, CSV/Excel and codebook:
  https://swissvotes.ch/page/dataset
- MeteoSwiss open-data terms:
  https://opendatadocs.meteoswiss.ch/general/terms-of-use
- Electricity candidate:
  https://zenodo.org/records/21398769
- UCI fallback:
  https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients

All seven families are packaged and documented. Installed construction scripts
and compact electricity inputs support offline reproduction; large archives are
not installed. Size checks constrain the twelve new .rda objects below 3 MiB
and construction files plus compact inputs below 3 MiB. No existing course code or dependency
pin has been changed; the user's installed AEC has not been replaced.

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

CHelectricity_annual: all 2,023 residential source meters, 4,046 meter-years
(2023/2024), complete-day annual/seasonal summaries and equipment metadata.
Same CC BY 4.0 source and credit as the daily panel; offline annual input and
preparation script included. No previous-year outcome is needed for a regression.


Swiss apples: CHapples (44 variety-month rows) and CHapples_frost (40 station-year
rows) use the 20 September 2024 BLW/SWISSCOFEL accompanying workbook and
MeteoSwiss daily temperatures. The workbook explicitly permits processing and
publication with source attribution (deutsch H5); retain BLW, Fachbereich
Marktanalysen; SWISSCOFEL. This is a source-specific permission, not a CC licence
for market data or a clearance of other archives. Weather: Source: MeteoSwiss,
CC BY 4.0 (https://creativecommons.org/licenses/by/4.0/); AEC extracts and
aggregates April-May 2006-2025. Retain both attributions and indicate changes.
See data-build/CHapples/RIGHTS.txt, README.txt, provenance.json and the original
workbook for evidence, exact URLs, source hashes, scope and offline rebuilding.
Package help documents every field and the two-harvest identification limit.


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
