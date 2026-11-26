\name{CHapples_frost}
\alias{CHapples_frost}
\docType{data}
\title{April--May frost summaries at two Swiss weather stations}
\description{Forty station--year summaries of daily minimum air temperature at
Sion (SIO, Valais) and Guettingen (GUT, Thurgau), 2006--2025.}
\usage{data(CHapples_frost)}
\format{A data frame with 40 rows and 9 variables:
\describe{
\item{station}{MeteoSwiss abbreviation, SIO or GUT.}
\item{station_name}{Sion or Guettingen (ASCII transliteration of the station name).}
\item{canton}{VS or TG.}
\item{year}{Calendar year of spring weather.}
\item{frost_days}{Number of April--May source days with tre200dn strictly below zero Celsius.}
\item{valid_days}{Number of nonmissing daily minima; 61 throughout this snapshot.}
\item{expected_days}{Number of days in April--May: 61.}
\item{minimum_tmin_c}{Lowest daily minimum during the window, Celsius.}
\item{cold_degree_days}{Sum of max(0, minus daily minimum temperature), Celsius-days.}
}}
\details{Daily tre200dn measures minimum air temperature at 2 metres. Source
reference dates are retained without a local-time conversion. The window is
April 1--May 31 inclusive in each year. The stations illustrate two fruit-growing
regions; there is no orchard-area weighting. Neither the window nor the 0C
threshold measures observed flowering, flower damage, frost protection or crop
loss. These proxies must not be interpreted as an official national damage index.
No missing days are imputed. The installed daily extract permits independent
aggregation and alternative thresholds without downloading large archives.
The weather history does not extend the two-year market coverage of CHapples.

\strong{Redistribution:} Source: MeteoSwiss. Data are used under
\href{https://creativecommons.org/licenses/by/4.0/}{CC BY 4.0}. AEC extracts
April--May observations from the SIO and GUT daily historical station files and
computes these summaries. Retain attribution and licence link and indicate
these changes when redistributing. Exact URLs and original SHA256 hashes are
in the installed \code{data-build/CHapples/provenance.json}; compact daily inputs,
checksums and a base-R offline rebuild are supplied alongside it.}
\source{\href{https://opendatadocs.meteoswiss.ch/a-data-groundbased/a1-automatic-weather-stations}{MeteoSwiss automatic weather stations};
\href{https://opendatadocs.meteoswiss.ch/general/terms-of-use}{terms of use}.}
\examples{
data(CHapples_frost)
subset(CHapples_frost, year \%in\% 2022:2023)
}
\seealso{\code{\link{CHapples}}}
\keyword{datasets}
