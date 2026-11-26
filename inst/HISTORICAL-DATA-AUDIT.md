# AEC data redistribution audit

Audit date: 20 October 2026. Reviewed commit:
`3245789138e77c2d7b591b40e8b6a3405e93cbf1` (also the commit used by EcoStat).

This is an evidence register, not a blanket licence grant. No legacy datasets
have been removed or replaced by this audit. Seven new documented objects have
been added (see below). AEC is not yet ready for a new public
release. Public download availability and a citation do not establish a right
to redistribute. Status applies to the actual AEC snapshot, not to a similarly
named replacement in IdSS.

The subsequent teaching-data redesign is recorded in `TEACHING-DATA.md`.
It selects Swiss road accidents without radars, institution-focused Swissvotes
examples, Swiss electricity/weather and a credit-default dataset still to be
selected. French accidents and debt auction data are outside the selected
scope. Planned replacements do not change the legacy statuses below.

## Status definitions

- **KEEP — source terms identified**: preserve the stated terms and attribution.
- **HOLD — evidence incomplete**: do not include in a new public release until
  the missing provenance or permission is established.
- **REPLACE/CONTROLLED ACCESS**: source conditions do not support unrestricted
  public distribution in an R package or Git repository.

## New teaching datasets added on 20 October 2026

| Object | Snapshot and transformations | Rights and citation |
|---|---|---|
| `CHaccidents` | 70,767 accidents, **city of Zurich**, 2011--2025; all city-export rows retained, selected/renamed fields, integer/logical calendar and involvement fields, derived injury/severe/fatal flags. | **KEEP -- redistribution permitted with attribution.** City catalogue explicitly CC BY (version not specified). Required source: Bundesamt für Strassen ASTRA; distributor City of Zurich, Dienstabteilung Verkehr. Preserve source URL, dates and CC BY notice; identify AEC changes. |
| `CHaccidents_monthly` | 180 monthly aggregates of the same observations, with nested severity counts. | Same CC BY source conditions; identify the aggregation. |
| `CHvotes` | 710 objects from Swissvotes CSV labelled 28 September 2026; institutional and participation fields only; four future objects excluded at 20 October 2026, source missing markers converted to NA. | **KEEP -- CC BY 4.0.** Swissvotes, Année Politique Suisse, University of Bern; preserve attribution, licence link and change notice. |
| `CHvotes_cantons` | 17,482 observed canton-object combinations, 1866--3 March 2024; reshape only source participation/count columns; no missing combinations filled. | Same CC BY 4.0 source terms; identify reshaping. |
| `UCIcredit` | All 30,000 UCI credit-card clients, Taiwan, 2005 histories. Two columns renamed; values and undocumented codes retained. | **KEEP -- CC BY 4.0.** Yeh (2009), UCI Machine Learning Repository, DOI 10.24432/C55S3H. |
| `CHelectricity` | 184 Swiss residential installation meters, 134,504 local meter-days in 2023--2024. At most 30 meters per type by deterministic SHA-256 rank. Partial days kept with completeness counts; complete totals missing if incomplete. | **KEEP -- CC BY 4.0.** Kaiser, Kreft, González Vayá and Hug (2026), Zenodo v1, DOI 10.5281/zenodo.21398769. The archived Zenodo API record explicitly states cc-by-4.0. |
| `CHelectricity_meters` | All 2,447 source metadata rows, renamed/typed fields, two object-ID columns omitted, sampling flag and finite-source expansion weight added. | Same CC BY 4.0 source terms; identify sampling and modifications. |

Complete variable definitions are in R help. Exact URLs, frozen-input hashes,
source-column mappings and observed accident codes are installed in
`teaching-data/`. `teaching-data/RIGHTS.md` records the evidence, including the
distinction between the explicitly CC BY city export and the unresolved national
file. The user accepted city-only coverage. No radar data are included.

## Legacy packaged-data register

| File / object | Provenance and preparation evidence | Current assessment | EcoStat dependency / next action |
|---|---|---|---|
| `BQ.rda` / `BQ` | `data-raw/BQ/load.BQ.data.R` imports `bqdata.csv`, citing the Boston College/RePEc replication resource. | HOLD. No redistribution grant for this exact snapshot documented. | No direct use found in the current course chapters. Replace with the independently reconstructed IdSS version if retained; do not relabel the old snapshot as cleared. |
| `JST.rda` / `JST` | `data-raw/JST/prepareJST.R`, release-6 workbook, CSV and documentation. | KEEP under CC BY-NC-SA 4.0; retain attribution and required variable-specific citations. This does not place the package's code under that licence. | Used in panel and time-series chapters. Include a visible data licence and citations in help and course text. |
| `Ramey.rda` / `Ramey` | `data-raw/Ramey/prepareRamey.R` and `Monetarydat.xlsx`. | HOLD. No express redistribution permission established for the workbook or all constituent series. | No direct use found in current chapters. Candidate for removal from public package and raw-data tree. |
| `US3var.rda` / `US3var` | `data-raw/US3var/load.US.data.R`, FRED extracts. Output/unemployment gaps, inflation, policy rate and oil-price growth. | HOLD pending series-level confirmation, especially the historical `OILPRICE` input and its splice with `MCOILWTICO`. Other headers identify BEA/BLS/CBO/Board series. | No direct use found in current chapters. Establish each archived series' producer and rights; FRED is a distributor, not a universal licence. |
| `USmonthly.rda` / `USmonthly` | `data-raw/USmonthly/load_Month_US_data.R` merges FRED-derived inputs with `Ramey_Monetarydat.csv`. Script also depends on undeclared date variables. | HOLD for the current mixed snapshot. IdSS's reconstructed version is a different dataset. | No direct use found in current chapters. Remove if unused or port the documented IdSS reconstruction and adapt callers. |
| `USyields.rda` / `USyields` | `data-raw/USyields/prepare_USyields.R`; monthly means of Board H.15 Treasury series DGS1, DGS2, DGS3, DGS5, DGS7, DGS10, DGS20, DGS30 via FRED. | KEEP with Board/FRED citation; FRED's DGS1 source page identifies public-domain status. Preserve series identifiers and preparation details. | Used for PCA in appendix. Add data documentation and attribution. |
| `airbnb.rda` / `airbnb` | `data-raw/Zurich_Airbnb/Prep_data_airbnb.R`; Tom Slee Zurich survey 1363, 22 June 2017, entire-home/apartment listings with price below 300. | HOLD. The historical download page is unavailable. MIT licensing of Tom Slee's collection software does not itself license the exported listing data. | Used in panel chapter. Obtain permission for this exact export or replace with a dataset carrying explicit data terms; repeat regressions and maps. |
| `credit.rda` / `credit` | `data-raw/Credit/prep_data.R`; Lending Club extract, 2010 issues and 36-month terms, selected sufficiently populated columns and derived employment indicator. Course links to ethon0426's Kaggle compilation. | HOLD. Exact acquisition lineage and an applicable redistribution grant from a party entitled to license the data have not been established. The Kaggle page was accessible but exposed no readable licence evidence to this audit. | Used for ridge/lasso and binary outcomes. Establish rights or choose an explicitly licensed replacement and repeat estimates. |
| `parapluie.rda` / `parapluie` | `data-raw/parapluie/parapluie.R`; monthly aggregation and detrending of Google Trends, averaged precipitation across six French regions, monthly dummies. | HOLD for combined object. Google permits reuse with attribution, but the weather CSV has no identified producer, acquisition URL or licence in the preparation script. | Used for Frisch–Waugh example. Identify weather source or reconstruct from licensed weather data; cite Google and weather producer. |
| `randdata.rda` / `randdata` | HRS/RAND source-processing scripts and intermediate files in `data-raw/HRS_RAND/`. Final save step linking this packaged object to a documented release was not found. | REPLACE/CONTROLLED ACCESS. HRS requires recipient registration and redistribution controls; an unrestricted GitHub/R-package download does not enforce these. | No direct use found in current chapters. Remove from future public distribution or use registered-user local access. Do not inspect or process respondent records through an LLM; HRS also has an explicit AI policy. |
| `shp.rda` / `shp` | `data-raw/SHP/SHP.R` imports 2019 individual, Covid and income/wealth files from SWISSUbase. The exact final reduction/save step for `shp` is not documented here. | REPLACE/CONTROLLED ACCESS. FORS allows sharing only with authorised users; teaching requires an additional contract and disposal after the course. Public distribution is not established by ordinary research access. | Used in CLT and regressions for medical visits, income and education. Replace with licensed or clearly labelled simulated teaching data, or separate an authorised-user local workflow. |
| `smi.rda` / `smi` | `data-raw/SMI/prepare_smi.R`, `SMI.csv`; course caption identifies Yahoo Finance. | HOLD. No permission for public redistribution of this price history was found in repository evidence. | Used throughout the estimation chapter's Student-t return example. Replace with public-domain EUR/USD as already done in IdSS/Time Series; rerun estimation and revise claims and captions. |
| `zurich.rda` / `zurich_districts` | `data-raw/Zurich_map/make_zurich_map.R`; city district shapefile `stzh.adm_stadtkreise_a`, transformed to WGS84. | HOLD for undocumented historical acquisition; current official Stadtkreise distribution explicitly carries CC0. Clear path: rebuild from that source and archive its metadata/date, or establish the historical file's matching terms. | Used with Airbnb maps. Preserve district identifiers needed by regressions when rebuilding. |

The 13 legacy `.rda` files and seven new `.rda` files in `data/` are all covered
above (20 files in total). Course dependencies were
searched in source chapters; absence of a direct reference does not prove that
no external user or other course relies on an object.

## Public repository versus installed package

`.Rbuildignore` excludes `data-raw/` from an R source package, but **does not
exclude it from GitHub**. The original reviewed commit tracks 62 files in that folder,
including SHP/HRS intermediate datasets, replication workbooks and raw inputs
whose distribution rights are not established. Audit and remediate both the
packaged objects and the repository's tracked raw files. Also check
`supporting_files/` before any release. Do not publish a new audit branch that
merely adds notices while continuing to distribute unapproved data.

The new approved source snapshots and compact electricity intermediate are a separate case: they are redistributable under
the source-specific CC BY conditions documented in `teaching-data/RIGHTS.md`.

Removing files from a new commit does not remove earlier publicly retrievable
copies. Historical cleanup requires a separately planned action, backups and
coordination with users of pinned commits. This audit does not rewrite history
or change repository visibility.

## Software licence

`DESCRIPTION` currently contains the unresolved placeholder
`License: What license is it under?`. A software licence must be selected and
code authorship/third-party notices reviewed before a public release is called
open source. MIT is a possible choice for original code, consistent with IdSS,
but this audit does not assert ownership of every procedure or apply a blanket
licence to data. Third-party data terms must remain separate.

## Prioritised implementation

1. Prepare replacement/local-access examples for SHP; remove HRS/RAND from the
   planned public distribution, including tracked intermediate data.
2. Resolve `credit` and `airbnb`, which support substantial course examples.
3. Replace `smi` with EUR/USD; preserve the statistical exercise, not a claim
   of identical financial results. Identify or replace precipitation inputs.
4. Remove unused legacy snapshots or port documented IdSS reconstructions.
5. Rebuild Zurich districts from official CC0 data; complete citations for JST
   and USyields; resolve software licensing after code attribution review.
6. Validate every changed application and rebuild EcoStat HTML/PDF. Audit the
   source archive and tracked files before publication. Do not alter the course
   lockfile until a tested replacement AEC commit exists.

## Primary evidence consulted on 20 October 2026

- FORS SHP FAQ (authorised users, teaching contract, required attribution):
  https://forscenter.ch/projects/swiss-household-panel/faq/
- HRS Conditions of Use (recipient registration and controlled redistribution):
  https://hrsdata.isr.umich.edu/data-products/conditions-of-use
- HRS AI/LLM policy:
  https://hrsdata.isr.umich.edu/data-products/ai-llm-use-policy
- JST licence terms:
  https://www.macrohistory.net/database/licence-terms/
- JST database and required citations:
  https://www.macrohistory.net/database/
- Board Treasury series / FRED source and public-domain notice:
  https://fred.stlouisfed.org/series/DGS1
- Zurich official Stadtkreise catalogue (CC0):
  https://data.stadt-zuerich.ch/dataset/geo_stadtkreise
- Google Trends reuse and citation:
  https://support.google.com/trends/answer/4365538?hl=en
- Credit source linked by course; licence not established from readable page:
  https://www.kaggle.com/datasets/ethon0426/lending-club-20072020q1
- Tom Slee collection software (MIT applies to that software):
  https://github.com/tomslee/airbnb-data-collection
- Historical Tom Slee export link cited by course (returned 404 during audit):
  https://tomslee.net/airbnb-data-collection-get-the-data

## Working-copy provenance

Audit prepared in a fresh checkout inside TOKEEP_EcoStat/AEC, matching the
course's pinned commit. An existing checkout was subsequently located at
`/Users/jrenne/Dropbox/Teaching/MyRpackages/AEC`, with the same HEAD; it was not
modified. The installed package and course lockfile were not changed. Raw
SHP/HRS respondent records were not opened for this audit.

Installed data-build/ scripts and compact electricity inputs support offline
reconstruction without shipping the 904 MB original archive. Their inclusion
does not change legacy rights. See data-build/README.md.

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

`CHelectricity_annual` extends the same CC BY 4.0 electricity source to all
2,023 residential meters (1,528 apartments; 495 houses), with two annual rows
each. Complete-day energy sums, means, coverage counts, winter/summer import
means and source equipment metadata are retained. This is aggregation of the
same verified Zenodo v1 source; no additional source or permission is required.


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
