# AEC 0.2.0 data redistribution register

Release review: 26 November 2026. This register covers the fourteen objects
shipped in this release. Source-specific terms apply to data independently
of the MIT software licence. Preserve credits, licence links, source dates
and notices of transformations. Detailed evidence is installed under
`teaching-data/` and `data-build/`; R help documents each dataset.

| Objects | Source terms | Required credit | Source |
|---|---|---|---|
| CHaccidents;CHaccidents_monthly | CC BY (catalogue does not specify version) | Bundesamt fuer Strassen ASTRA; City of Zurich, Dienstabteilung Verkehr | https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte |
| CHvotes;CHvotes_cantons | CC BY 4.0 | Swissvotes, Annee Politique Suisse, University of Bern | https://swissvotes.ch/page/dataset |
| UCIcredit | CC BY 4.0 | I-Cheng Yeh (2009), UCI Machine Learning Repository | https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients |
| CHelectricity | CC BY 4.0 | Kaiser, Kreft, Gonzalez Vaya and Hug (2026) | https://zenodo.org/records/21398769 |
| CHelectricity_meters | CC BY 4.0 | Kaiser, Kreft, Gonzalez Vaya and Hug (2026) | https://zenodo.org/records/21398769 |
| USrecession | Public domain; credit requested | Board of Governors of the Federal Reserve System; U.S. Treasury | https://www.federalreserve.gov/releases/h15/ |
| USrecession | Permission to copy granted with source attribution | National Bureau of Economic Research, Business Cycle Dating Committee | https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions |
| CHelectricity_annual | CC BY 4.0 | Kaiser, Kreft, Gonzalez Vaya and Hug (2026) | https://zenodo.org/records/21398769 |
| CHapples | Processing and publication permitted with source attribution (workbook deutsch H5) | BLW, Fachbereich Marktanalysen; SWISSCOFEL | https://www.donnees-agrimarche.ch/blog/nouvel-apercu-marche-suisse-pommes |
| CHapples;CHapples_frost | CC BY 4.0 | Source: MeteoSwiss | https://opendatadocs.meteoswiss.ch/general/terms-of-use |
| CHhydro | CC BY 4.0; explicit SMARD licence in every Swiss price response | Energy-Charts.info / Fraunhofer ISE; Bundesnetzagentur ; SMARD.de | https://api.energy-charts.info/ |
| CHhydro | CC BY 4.0 | Source: MeteoSwiss | https://opendatadocs.meteoswiss.ch/general/terms-of-use |
| FRradars | Licence Ouverte 2.0; retain source terms including commune LO 1.0 | Jean-Paul Renne; Ministry of Interior/ONISR/DSR; Antoine Augusti; IGN; OpenDataSoft | https://github.com/jrenne/accidents-radars-france |
| FRaccidents_daily | Licence Ouverte / Open Licence 2.0 | Jean-Paul Renne; Ministry of the Interior / ONISR, BAAC | https://github.com/jrenne/accidents-radars-france |
| FRaccidents_daily | Licence Ouverte / Open Licence 2.0 | Meteo-France, Paris-Montsouris station 75114001 | https://meteofrance.s3.sbg.io.cloud.ovh.net/data/synchro_ftp/BASE/QUOT/Q_75_previous-1950-2024_RR-T-Vent.csv.gz |

All original inputs retained in this source tree belong to these reviewed
families. Legacy SHP, HRS/RAND, SMI, Airbnb, Lending Club, and other old
snapshots are excluded, along with their raw inputs. The former audit is
retained as `HISTORICAL-DATA-AUDIT.md` for provenance; its old course-use
descriptions are historical, not the current release inventory.

The BLW/SWISSCOFEL apple workbook uses a specific permission for processing
and publication with attribution, not a blanket Creative Commons licence.
The NBER chronology has a copying permission with source attribution.
Zurich identifies CC BY without specifying its version; do not invent one.

Removing files from a new release does not remove older Git commits.
Earlier publicly distributed versions require a separate history review.
