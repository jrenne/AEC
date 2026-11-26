# Rights evidence for the new teaching snapshots

Checked 20 October 2026. This file concerns the twelve new objects.
The legacy AEC redistribution audit remains unresolved.

## Zurich accidents: redistribution permitted with attribution

Official source page:
https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte

The page's licence section explicitly labels the city export Creative Commons
Attribution. Its licence link is https://opendefinition.org/licenses/cc-by/,
which explains that redistribution and reuse are permitted with appropriate
credit. The catalogue does not state a CC BY version; AEC does not invent one
or claim CC0. Required credit in the source notes: “Bundesamt für Strassen ASTRA”.
The distributor/data owner is the City of Zurich, Dienstabteilung Verkehr.
The exact exported CSV is listed in sources.csv by URL and SHA-256.

Preserve the above producer/distributor credits, source URL, source/access
dates and CC BY notice when redistributing. State that AEC renamed selected
columns, decoded calendar/boolean fields, derived severity flags and created
monthly accident counts. Do not imply endorsement by the source institutions.
Geographic coverage is the city of Zurich, not the canton or all Switzerland.

User explicitly accepted city-only coverage on 20 October 2026 if the national
file's redistribution rights could not be established. The separate national
STAC collection reports `license: proprietary` and links generic federal terms;
the geocat metadata reports access level B. These do not override the explicit
CC BY licence applied to this city export, and this audit does not clear the
national file or restricted individual annual research extracts.

National metadata checked:
https://data.geo.admin.ch/api/stac/v0.9/collections/ch.astra.unfaelle-personenschaeden_alle
https://www.geocat.ch/geonetwork/srv/api/records/a76e370a-eb4c-409b-bf10-5dbda021528e/formatters/xml

## Swissvotes: CC BY 4.0

Official source page: https://swissvotes.ch/page/dataset

The page explicitly licenses both the dataset and its codebook under Creative
Commons Attribution 4.0 International. Redistribution/adaptation is permitted,
including commercially, with appropriate attribution, a licence link and an
indication of changes. Licence: https://creativecommons.org/licenses/by/4.0/

Credit: Swissvotes (2026), dataset, Année Politique Suisse, University of Bern,
CSV labelled 28 September 2026, accessed 20 October 2026.

AEC selected institutional and participation fields, renamed/recoded columns,
converted empty/dot cells to NA, excluded four scheduled objects after the
20 October 2026 cut-off and reshaped cantonal fields. Do not apply the licence
to every external document linked from the database.

The two raw CSV snapshots may be retained in data-raw for reproducibility under
these source terms. They are excluded from R source-package builds, but are
redistributed in the Git repository. The same attribution obligations apply in
both channels. The packaged .rda objects are governed by these data-specific
terms, independently of the unresolved software licence in DESCRIPTION.


## UCI credit: CC BY 4.0

The official UCI dataset page states CC BY 4.0:
https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients
Credit I-Cheng Yeh (2009), UCI Machine Learning Repository, DOI 10.24432/C55S3H.
AEC retains all 30,000 observations and source codes/amounts, renaming only ID
and the next-month-default column. The ZIP is archived in the repository but
excluded from the installed package. The included construction script is not
an assertion of rights over the older Lending Club `credit` object.

## Swiss electricity: CC BY 4.0 confirmed in original record metadata

Official version record: https://zenodo.org/records/21398769
API: https://zenodo.org/api/records/21398769
The archived API JSON explicitly contains metadata.license.id = cc-by-4.0.
The data licence must not be confused with the separately licensed arXiv paper.
Credit Kaiser, Katharina; Kreft, Markus; González Vayá, Marina; and Hug,
Gabriela (2026), Dataset on residential electricity load profiles in Switzerland,
version v1, DOI 10.5281/zenodo.21398769. The published archive MD5 is
 dd40d5e24aee2a3563bc36285b463dbd.
AEC's selected/renamed metadata and reduced daily energy data are adaptations
under CC BY 4.0. Preserve attribution and the licence link and identify the
sampling, UTC-to-local-day aggregation and explicit missing-data rules.
The original 904 MB archive stays outside Git and outside the R package.
The compact daily intermediate and construction files may be redistributed
under the same data terms. No weather dataset or published-paper images are
included. No attempt is made to reconstruct source privacy deletions.

## US recession early-warning data: copying permission confirmed

The separate [US-EWS-RIGHTS.md](US-EWS-RIGHTS.md) records the corrected review.
The NBER chronology page explicitly permits copying with source attribution;
the Board H.15 Treasury-rate inputs have a public-domain source. USrecession
preserves source notices and credits and documents AEC's transformations.
The earlier finding that the chronology was not cleared is superseded by this
specific evidence, not by a general licence assumed for NBER materials.

The CHelectricity_annual extension uses the same verified archive and CC BY 4.0
permission: all residential meters, complete-day annual/seasonal aggregation,
and joined source metadata. No extra data source has been introduced.


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

FRaccidents_daily (22 October 2026) adds 3,287 consecutive Paris observation days,
2011-2019, and 57,266 injury accidents, joined to independent Paris-Montsouris
rainfall. Both harmonised BAAC data and Meteo-France daily observations permit
redistribution under Licence Ouverte 2.0. Credit Jean-Paul Renne, Ministry of
the Interior/ONISR and Meteo-France, retaining source versions/update dates.
The dataset is about 6 KiB. See ?FRaccidents_daily and its installed compact
inputs, extraction/build scripts, source metadata, full licence and RIGHTS.txt
in data-build/FRaccidents_daily. Accidents and rain use matching 06-to-06 UTC
intervals, not a naive join of civil dates to precipitation reference dates.
