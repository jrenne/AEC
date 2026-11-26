\name{FRaccidents_daily}
\alias{FRaccidents_daily}
\docType{data}
\title{Daily Paris injury accidents and rainfall, 2011--2019}
\description{A compact daily aggregation of French BAAC injury accidents from
Jean-Paul Renne's accidents-radars-france repository, joined to independent
Meteo-France rainfall observations at Paris-Montsouris.}
\usage{data(FRaccidents_daily)}
\format{A data frame with 3,287 rows and seven variables:
\describe{
\item{date}{Date identifying the start of a 24-hour observation interval: 06:00 UTC on this date until 06:00 UTC the next date.}
\item{injury_accidents}{Integer. Number of recorded injury accidents in department 75 (Paris) during that interval. Counts accidents, not injured persons. Zero counts are retained.}
\item{rain_mm}{Numeric. Precipitation in mm over exactly the same 06-to-06 UTC interval, Meteo-France parameter RR at station 75114001 PARIS-MONTSOURIS. Values are already in mm, not integers to divide by ten.}
\item{rain_quality}{Integer. Original QRR quality code; 3,286 values equal 1 and one equals 0. Preserved without excluding observations.}
\item{weekday}{Integer. Weekday of the interval's start date: Monday = 1 through Sunday = 7.}
\item{month}{Integer. Month of the interval's start date, 1--12.}
\item{year}{Integer. Year of the interval's start date, 2011--2019.}
}}
\details{The sample consists of all 3,287 consecutive dates from 1 January
2011 to 31 December 2019, containing 57,266 injury accidents. The pre-pandemic
period and single-city station pairing are chosen before estimating a weather
regression. No selection is made on accident counts or regression results.

The repository's harmonised accident dates and local civil clock times are
converted from Europe/Paris to UTC before aggregation. Records from adjoining
civil dates are used at the two boundaries. The 06 UTC boundary is chosen to
match the documented Meteo-France RR interval, rather than assigning rainfall
from a different interval to civil-day counts. Start-date calendar indicators
are labels for these intervals, not exact civil-day partitions. Daylight-saving
ambiguous autumn hours occur before both possible 06 UTC boundaries, so they
do not change interval membership.

The BAAC atmospheric-condition variable describes conditions at an observed
accident. It cannot supply rainfall exposure on days without accidents; the
independent station series avoids that selection. A single gauge is a proxy
for rainfall across Paris. Traffic volumes, individual road users and accident
locations are not included. Counts are not exposure-adjusted accident risk.
A linear regression is a descriptive mean approximation; its residuals may be
heteroskedastic and serially correlated. The data are a single time series,
not a canton-by-date panel.

Offline compact inputs, SHA256 checks, extraction and build scripts, source
versions and attribution notices are installed under data-build/FRaccidents_daily.
The optional Python extraction requires the full article repository and the
original Meteo-France archive, which are not bundled.}
\section{Redistribution}{Licence Ouverte / Open Licence 2.0 permits extraction,
transformation and redistribution with attribution and source update dates.
Credit Jean-Paul Renne, accidents-radars-france (commit recorded in provenance.json);
Ministry of the Interior / ONISR, BAAC; and Meteo-France, daily climatological
observations, station Paris-Montsouris. AEC aggregates accidents, selects the
weather series, aligns observation intervals and derives calendar labels.
Full licence, source URLs, retrieval date and source versions are preserved in
the installed construction directory. These terms apply to the data, not to
unrelated package code.}
\source{\url{https://github.com/jrenne/accidents-radars-france};
\url{https://www.data.gouv.fr/datasets/donnees-climatologiques-de-base-quotidiennes};
\url{https://www.data.gouv.fr/datasets/bases-de-donnees-annuelles-des-accidents-corporels-de-la-circulation-routiere-annees-de-2005-a-2024}}
\examples{
data(FRaccidents_daily)
with(FRaccidents_daily, plot(rain_mm, injury_accidents))
}
\keyword{datasets}
