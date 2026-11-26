\name{CHelectricity}
\alias{CHelectricity}
\docType{data}
\title{Daily electricity exchange for a compact Swiss meter sample}
\description{Daily active-energy imports and exports for a deterministic,
installation-type-stratified sample from the ETH Zurich/EKZ residential dataset.
One row is one meter on one local calendar day, including days without readings.}
\usage{data(CHelectricity)}
\format{A data frame with 134,504 rows and 13 variables (184 meters, 731 days):
\describe{
\item{meter_id}{Character. Anonymised source meter identifier; joins CHelectricity_meters. An installation is not necessarily a household.}
\item{date}{Date. Europe/Zurich calendar day, 1 January 2023 to 31 December 2024.}
\item{year, month}{Integer. Local calendar year and month.}
\item{weekday}{Integer. Monday 1 through Sunday 7.}
\item{intervals_expected}{Integer. Expected quarter-hours in the local day: 92, 96 or 100, accounting for daylight saving time.}
\item{valid_import, valid_export}{Integer. Number of non-missing source quarter-hour readings for the corresponding active-energy channel that day. Zero means no readings, not zero energy.}
\item{import_observed_kwh, export_observed_kwh}{Numeric. Sum of available active import/export readings, in kWh. NA if none available. A partial-day sum is NOT a complete daily total.}
\item{import_kwh, export_kwh}{Numeric. Complete daily import/export totals in kWh; NA unless the corresponding valid count equals intervals_expected. No extrapolation or imputation is performed.}
\item{net_kwh}{Numeric. import_kwh minus export_kwh; NA if either complete total is missing. May be negative for net-exporting installations.}
}}
\details{The Zenodo v1 archive was downloaded 20 October 2026 and checked against
its published MD5 dd40d5e24aee2a3563bc36285b463dbd. Its metadata license is
cc-by-4.0. Original 15-minute values already represent interval energy, not power
or cumulative readings; sum them without multiplying by 0.25 or differencing.

Within each of the ten original installation types, take at most 30 meter IDs,
ranked by SHA-256 of the UTF-8 string AEC-electricity-v1: followed by the ID.
No energy values, completeness measures or pilot outcomes enter selection.
All source installation types are retained, yielding 184 meters. Sample
composition is intentionally disproportionate: do not call unweighted sample
averages representative of households in Switzerland or even of the source.
Selection weights for the finite source collection are in CHelectricity_meters.
The underlying source itself is not a representative Swiss household survey.

UTC timestamps are converted to Europe/Zurich before grouping. A complete
meter-day grid is retained. Days removed by the source for privacy or missing
readings remain missing; no attempt is made to reconstruct removed information.
Reactive-energy channels and 15-minute tariffs are omitted from the compact
panel. No weather values have been added. No causal tariff effect follows from
observational differences: pilot recruitment and treatment assignment require
separate analysis. Dependence within meter, building and calendar day matters
for inference and prediction splits. Use time-ordered evaluation for forecasts.

The package includes a compact frozen daily intermediate, source metadata and
checksums in data-build/CHelectricity. Its build.R recreates the .rda files
offline. prepare.py optionally recreates the intermediate from the original
904 MB archive (not distributed with AEC); it requires Python with pandas.
See the installed data-build/README.md for commands and source URLs. Reading the
packaged objects requires no download, pandas or Python.
}
\section{Redistribution}{CC BY 4.0. Credit Katharina Kaiser, Markus Kreft,
Marina González Vayá and Gabriela Hug (2026), Dataset on residential electricity
load profiles in Switzerland, Zenodo v1, DOI 10.5281/zenodo.21398769. Cite the
licence and identify AEC sampling, local-day aggregation and completeness rules.
The data licence is distinct from the arXiv manuscript's licence.}
\source{\url{https://zenodo.org/records/21398769}}
\references{\url{https://creativecommons.org/licenses/by/4.0/}}
\examples{
data(CHelectricity)
data(CHelectricity_meters)
d <- merge(CHelectricity, CHelectricity_meters[c("meter_id","installation_type")])
aggregate(import_kwh ~ installation_type, d, mean)
}
\seealso{\code{\link{CHelectricity_meters}}, \code{\link{CHelectricity_annual}}}
\keyword{datasets}
