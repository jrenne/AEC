\name{CHelectricity_meters}
\alias{CHelectricity_meters}
\docType{data}
\title{Metadata and sampling information for Swiss residential electricity meters}
\description{Metadata for all 2,447 anonymised installations in the Zenodo v1
source, with a flag identifying the 184 installations selected for CHelectricity.}
\usage{data(CHelectricity_meters)}
\format{A data frame with 2,447 rows and 23 variables:
\describe{
\item{meter_id}{Character. Unique anonymised source meter identifier.}
\item{installation_type}{Character. Apartment, Single-family house, Common areas, Heat pump, Underground garage, Heating system, Feed-in system, EV charging station, Water heater or Elevator. Do not equate every installation with a household.}
\item{object_type}{Character. Type of the associated building/object, distinct from installation_type. Source object identifiers are omitted.}
\item{housing_units}{Numeric. Number of housing units belonging to the object associated with a non-housing installation, where provided. NA is not zero.}
\item{source_complete_intervals}{Numeric. Source number of quarter-hours with all original energy channels available, for the FULL meter history, not the sampled daily complete-day count.}
\item{max_net_injection_kw}{Numeric. Source maximum quarter-hour mean net injection, kW. Unlike the panel's energies, this is power.}
\item{has_electric_water_heater}{Logical. Reported electric resistance water heater (1_ewh).}
\item{has_heat_pump}{Logical. Reported heat pump (1_hp).}
\item{has_heat_pump_backup}{Logical. Reported heat-pump backup heating rod (1_hp-add).}
\item{has_hotwater_heat_pump}{Logical. Reported domestic hot-water heat pump (1_hp-wh).}
\item{has_ev_charging}{Logical. Reported EV charging station (1_ev).}
\item{has_storage_heating, has_direct_heating}{Logical. Reported storage/direct electric heating.}
\item{equipment_changed}{Logical. Source equipment configuration changed during the observation period; flags indicate any equipment present at some time, not necessarily present every day.}
\item{energy_tariff, grid_tariff}{Character. Pilot tariff labels, retained verbatim. The literal None denotes the standard tariff, not a missing observation. These are labels, not price observations.}
\item{tariff_from, tariff_to}{Date. Pilot-tariff local start and exclusive end, where available. Outside this window use the source standard-tariff interpretation; do not treat a tariff label as applying to the entire history.}
\item{pilot_waterheater_control, pilot_heatpump_control, pilot_ev_control}{Logical. Original pilot-control flags; water-heater and heat-pump flags may mark all meters belonging to a participating household. These are not time-varying treatment indicators.}
\item{selected_daily}{Logical. This meter is included in the compact daily panel.}
\item{daily_selection_weight}{Numeric. Source installation-type count divided by sampled count for that type, for selected meters only; NA otherwise. Finite-source sampling expansion factor, not a population survey weight and not a correction for incomplete energy observations.}
}}
\details{Preserves all source metadata rows; drops 0_object_id and
0_object_id_manual, renames the remaining fields, converts booleans/dates and
adds two sampling fields. Equipment records may be incomplete or outdated. NA
housing-unit and tariff-date values are preserved. The source has several
installation meters associated with a building, so meter-level independence is
not implied. No effort is made to identify buildings, customers or geographic
locations from anonymised profiles. Exact field mappings are installed in
teaching-data/column-mappings.csv.
See CHelectricity for sampling, source checksum, coverage and build instructions.}
\section{Redistribution}{CC BY 4.0. Credit Kaiser, Kreft, González Vayá and Hug
(2026), Zenodo v1, DOI 10.5281/zenodo.21398769; identify AEC field selection,
renaming and added sampling fields.}
\source{\url{https://zenodo.org/records/21398769}}
\references{\url{https://creativecommons.org/licenses/by/4.0/}}
\examples{
data(CHelectricity_meters)
with(CHelectricity_meters, table(installation_type, selected_daily))
}
\seealso{\code{\link{CHelectricity}}}
\keyword{datasets}
