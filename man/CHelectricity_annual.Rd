\name{CHelectricity_annual}
\alias{CHelectricity_annual}
\docType{data}
\title{Annual electricity summaries for all residential meters in the source}
\description{Compact 2023 and 2024 summaries for all 2,023 residential meters
in the ETH Zurich/EKZ source: 1,528 apartments and 495 single-family houses.
This object is not restricted to the 184-meter daily teaching subsample.}
\usage{data(CHelectricity_annual)}
\format{A data frame with 4,046 meter-year rows. Variables are:
\describe{
\item{meter_id}{Character. Anonymised meter identifier, joining CHelectricity_meters.}
\item{year}{Integer. 2023 or 2024.}
\item{days_in_year}{Integer. 365 or 366.}
\item{import_days, export_days}{Integer. Number of complete local-calendar-day totals for each channel, including complete zero-energy days.}
\item{import_mean_kwh_day, export_mean_kwh_day}{Numeric. Mean of complete daily totals in kWh/day. NA when no complete days exist. These are means over observed complete days, not annual totals divided by 365/366.}
\item{import_sum_kwh, export_sum_kwh}{Numeric. Sum over complete days only, kWh; NA if there are none. An annual total only when the corresponding day count equals days_in_year. No extrapolation or imputation.}
\item{winter_import_days, summer_import_days}{Integer. Complete import days in January, February and December (winter), or June--August (summer), of the indicated calendar year. Winter is not a contiguous December-to-February season across years.}
\item{winter_import_mean_kwh_day, summer_import_mean_kwh_day}{Numeric. Mean complete daily imports in the indicated months; NA if none exist.}
\item{installation_type, object_type}{Character. Source installation and associated-object types.}
\item{has_electric_water_heater, has_heat_pump, has_heat_pump_backup, has_hotwater_heat_pump, has_ev_charging, has_storage_heating, has_direct_heating}{Logical. Source equipment flags, as documented in CHelectricity_meters.}
\item{equipment_changed}{Logical. Source equipment configuration changed over its observation period. Flags describe equipment present at some time, not necessarily throughout either year.}
\item{energy_tariff, grid_tariff, tariff_from, tariff_to}{Source pilot tariff labels and applicability window. Dates have class Date. Literal None denotes the standard tariff. Labels are not prices.}
\item{pilot_waterheater_control, pilot_heatpump_control, pilot_ev_control}{Logical. Original source pilot-control flags, not annual treatment indicators.}
}}
\details{All residential source meters and both calendar years are retained,
including low-coverage and zero-coverage years. Users choose a coverage threshold
explicitly, for example import_days >= 350. Counts and means are channel-specific;
net imports cannot be obtained by subtracting means based on different days.
Imports are electricity drawn from the grid, not necessarily total electricity
consumed when on-site generation is present. Source metadata may be incomplete
or outdated. This is not a representative survey of Swiss households.
Repeated years belong to the same meter; different meters may share buildings.
Equipment coefficients do not identify causal effects of installation.

Local days use Europe/Zurich, including the 92/100-quarter-hour daylight-saving
transitions. A day is complete only when every expected quarter-hour for that
channel is observed. The method matches CHelectricity. No previous-year outcome
is required to use this cross-sectional teaching table.

Run data-raw/CHelectricity/prepare-annual.py on the checksum-verified original
Zenodo v1 archive to regenerate annual.csv.gz. The 904 MB archive is not shipped.
The compact input, checksum and preparation script are installed in
 data-build/CHelectricity; build.R recreates the R objects offline.}
\section{Redistribution}{CC BY 4.0. Credit Katharina Kaiser, Markus Kreft,
Marina Gonz\'alez Vay\'a and Gabriela Hug (2026), Dataset on residential electricity
load profiles in Switzerland, Zenodo v1, DOI 10.5281/zenodo.21398769.
AEC selects residential meters, aggregates complete local days to annual and
seasonal summaries, joins metadata and renames fields. Preserve attribution,
source and licence links.}
\source{\url{https://zenodo.org/records/21398769}}
\references{\url{https://creativecommons.org/licenses/by/4.0/}}
\examples{
data(CHelectricity_annual)
homes2024 <- subset(CHelectricity_annual, year == 2024 & import_days >= 350)
with(homes2024, table(installation_type, has_heat_pump))
fit <- lm(import_mean_kwh_day ~ has_heat_pump + installation_type,
          data = homes2024)
coef(fit)
}
\seealso{\code{\link{CHelectricity}}, \code{\link{CHelectricity_meters}}}
\keyword{datasets}
