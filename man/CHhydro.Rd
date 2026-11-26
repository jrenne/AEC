\name{CHhydro}
\alias{CHhydro}
\docType{data}
\title{Swiss reservoir hydropower, wholesale prices and German wind generation}
\description{Observed daily electricity-market and weather series for teaching
short-run hydropower dispatch and instrumental variables, 2016--2024.}
\usage{data(CHhydro)}
\format{A data frame with 3288 daily rows and 18 variables:
\describe{
\item{date}{Date: Europe/Zurich civil day for electricity observations; source reference date for matched weather. Not a publication/forecast date.}
\item{hours}{23, 24 or 25 electricity source hours in the local day.}
\item{reservoir_mw}{Swiss Hydro water reservoir generation, daily mean MW; separate from the pumped-storage generation category.}
\item{pumped_generation_mw}{Swiss Hydro pumped storage generation, mean MW; not pumping consumption or net storage injection.}
\item{river_mw}{Swiss Hydro Run-of-River generation, mean MW. Ten days are NA because source hours are incomplete.}
\item{river_valid_hours}{Number of observed river-generation hours in the day; compare to hours. Partial-day means are not retained as complete days.}
\item{nuclear_mw}{Swiss nuclear generation, daily mean MW.}
\item{load_mw}{Source Swiss system-load series, daily mean MW; not household demand or verified final consumption.}
\item{price_eur_mwh}{Swiss day-ahead wholesale price, daily arithmetic mean EUR/MWh. Six negative daily means are retained; not CHF or a retail tariff.}
\item{wind_onshore_de_mw}{German onshore wind generation, daily mean MW.}
\item{wind_offshore_de_mw}{German offshore wind generation, daily mean MW.}
\item{wind_de_mw}{Sum of onshore and offshore daily wind generation, MW.}
\item{temperature_sio_c}{Daily mean 2m air temperature at Sion, Celsius, source parameter tre200d0.}
\item{temperature_gut_c}{Same variable at Guettingen.}
\item{rain_sio_mm}{Daily precipitation at Sion, mm, source parameter rre150d0.}
\item{rain_gut_mm}{Same variable at Guettingen.}
\item{rain_previous7_sio_mm}{Sion precipitation summed from date minus 7 to date minus 1, excluding current-day rain.}
\item{rain_previous7_gut_mm}{Same preceding-seven-day sum at Guettingen.}
}}
\details{The snapshot is constructed directly from Energy-Charts API observations,
not simulated values or coefficients from a published study. The electricity
window comprises all complete calendar years 2016--2024, before the January
2025 Swiss generation source change documented by Energy-Charts. Swiss production
is disseminated with ENTSO-E/BFE provenance and may incorporate the provider's
energy corrections; these data are not described as unprocessed meter readings.

German source quarter-hours are averaged to UTC hours only when all four readings
exist. Swiss production and prices are hourly. Electricity timestamps are aligned
in UTC and then grouped into Europe/Zurich civil days. Each daily field is the
mean of all source hours; any missing hour makes that field NA. All retained
fields except river_mw are fully observed. Daily energy in MWh is mean MW times
hours; summing daily MW is not an energy total. The daily price averages the same
hours without generation or trade-volume weighting. No missing values or prices
are imputed, and negative prices are not discarded.

Weather retains MeteoSwiss daily reference dates unchanged; the source weather
intervals are not asserted to coincide exactly with the electricity-day boundaries.
The two stations are proxies for weather conditions, not population- or catchment-
weighted national indices. The compact weather input begins 25 December 2015 to
construct the first preceding-seven-day rainfall sums.

An IV illustration can relate reservoir_mw to price_eur_mwh, using German wind
and calendar/weather controls. Outside wind supply shifts residual demand facing
Swiss producers. Instrument relevance does not establish exclusion: common
European weather, water availability, transmission constraints, wind curtailment
and expected future prices may complicate interpretation. A short-run dispatch
response is not a policy-invariant structural elasticity or a household-demand
estimate. Period-specific magnitudes differ. No overidentification test is
available with only one excluded instrument.

\strong{Redistribution:} all retained source data are under
\href{https://creativecommons.org/licenses/by/4.0/}{CC BY 4.0}. Credit
Energy-Charts.info / Fraunhofer ISE for production and API dissemination;
Bundesnetzagentur | SMARD.de for price data; and Source: MeteoSwiss for weather.
Each original Swiss price response explicitly states the SMARD CC BY licence;
public_power uses the API's explicit default CC BY licence without a response-
specific exception in this snapshot. Preserve attributions, licence link and
source URLs, and state the selection, aggregation and joins performed by AEC.
Do not imply source endorsement. These permissions do not extend to all Swissgrid,
ENTSO-E or EEX material, or to legacy AEC datasets.

Original-response SHA256 hashes, URLs, price licence strings, compact inputs and
the offline base-R rebuild are installed under \code{data-build/CHhydro}. Python
and pandas are needed only to reprepare intermediates from upstream responses,
not to use the data or reconstruct the R object from packaged inputs.}
\source{\href{https://api.energy-charts.info/}{Energy-Charts API};
\href{https://energy-charts.info/charts/power/chart.htm?c=CH&l=en}{Swiss generation provenance};
\href{https://www.smard.de/en/datennutzung}{SMARD data-use terms};
\href{https://opendatadocs.meteoswiss.ch/general/terms-of-use}{MeteoSwiss terms}.
All sources retrieved 20 October 2026.}
\examples{
data(CHhydro)
range(CHhydro$date)
sum(CHhydro$price_eur_mwh < 0)
# Average power times actual hours gives daily energy, including DST days.
summary(CHhydro$reservoir_mw * CHhydro$hours)
}
\keyword{datasets}
