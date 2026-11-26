\name{CHaccidents}
\alias{CHaccidents}
\docType{data}
\title{Police-recorded road accidents in the city of Zurich, 2011--2025}
\description{A frozen teaching extract of the City of Zurich open-data export.
Each row is one police-recorded accident on public traffic areas in the city,
including property-damage-only accidents. This is not a nationwide Swiss sample.}
\usage{data(CHaccidents)}
\format{A data frame with 70,767 rows and 24 variables:
\describe{
\item{accident_id}{Character. Original AccidentUID; unique technical identifier.}
\item{year}{Integer. Calendar year, 2011 to 2025.}
\item{month}{Integer. Calendar month, 1 to 12. No exact accident day is supplied.}
\item{weekday}{Integer. Monday = 1 through Sunday = 7, from aw401--aw407.}
\item{hour}{Integer. Hour interval starting at 0 through 23, local source clock time; not a timestamp.}
\item{accident_type_code}{Character. Original accident type code at0--at9 or at00.}
\item{accident_type, accident_type_fr}{Character. Original English and French descriptions of the accident type; see the installed code dictionary for all code/label pairs.}
\item{severity_code}{Character. as1 = fatal; as2 = serious injury; as3 = slight injury; as4 = property damage only. Categories describe the most severe accident outcome.}
\item{severity, severity_fr}{Character. Original English and French severity labels.}
\item{involves_pedestrian}{Logical. Source flag for pedestrian involvement; source defines involvement flags for injury accidents. FALSE must not be interpreted as proof of absence for property-only accidents.}
\item{involves_bicycle}{Logical. Corresponding bicycle involvement flag, including e-bikes.}
\item{involves_motorcycle}{Logical. Corresponding motorcycle involvement flag. Flags are not mutually exclusive.}
\item{road_type_code}{Character. rt432 = main road; rt433 = minor road; rt439 = other. These are the observed source levels, not a complete national road classification.}
\item{road_type, road_type_fr}{Character. Original English and French road-type labels.}
\item{easting_lv95, northing_lv95}{Numeric. Accident-location coordinates in metres in CH1903+ / LV95 (EPSG:2056). Not longitude/latitude.}
\item{canton}{Character. ZH throughout.}
\item{municipality_code}{Character. Original zero-padded OFS/BFS municipality identifier 0261, city of Zurich.}
\item{injury}{Logical. Derived as severity_code in as1, as2, as3.}
\item{severe}{Logical. Derived as severity_code in as1, as2 (includes fatal accidents).}
\item{fatal}{Logical. Derived as severity_code equal to as1.}
}}
\details{
All source rows are retained. Rows are sorted by year, month and accident ID.
Source codes and English/French labels are retained; calendar and involvement
codes are converted to integer/logical values. No missing values occur in this
snapshot. No individual age, sex, vehicle table, precise calendar date or radar
information is included. Accident counts are not counts of injured persons.

From 1 July 2015 the reporting definition for property-damage accidents changed
to include minor incidents, creating a break in the series. Changes in reporting
and exposure must be considered before interpreting time trends. Police records
are not a census of every incident. Accident-level observations may be dependent
within locations and periods. Injury/severity models are conditional on a
recorded accident, not population accident-risk models.

The frozen source was downloaded on 20 October 2026. The catalogue reports
coverage 2011--2025 and an update date of 11 March 2026. No live download is
needed to use the packaged data. Rebuilding requires only the archived CSV and
\file{data-raw/CHaccidents/build.R} in the source repository. That script checks
the raw SHA-256 before creating the objects. Source mappings, all categorical
labels and source hashes are installed in \file{teaching-data/}.
}
\section{Redistribution}{The City of Zurich catalogue labels the export
Creative Commons Attribution (CC BY), linking to the Open Definition CC BY page
without identifying a version in the catalogue text. Preserve that attribution
notice and the source link; do not describe these data as CC0. Required source
credit: \emph{Bundesamt fuer Strassen ASTRA} (Federal Roads Office, OFROU/FEDRO).
Distributor: City of Zurich, Dienstabteilung Verkehr. AEC selected and renamed
columns and derived three logical indicators; these changes are not an official
OFROU product. This notice does not clear the national accident file or legacy
AEC datasets.}
\source{\url{https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte}}
\references{Creative Commons Attribution licence information:
\url{https://opendefinition.org/licenses/cc-by/}. The source catalogue also links
the minimal road-accident-location model and documents the 2015 reporting break.}
\examples{
data(CHaccidents)
prop.table(table(CHaccidents$severity))
with(subset(CHaccidents, injury), table(weekday, severe))
}
\seealso{\code{\link{CHaccidents_monthly}}}
\keyword{datasets}
