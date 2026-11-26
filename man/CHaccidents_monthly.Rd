\name{CHaccidents_monthly}
\alias{CHaccidents_monthly}
\docType{data}
\title{Monthly counts of recorded Zurich road accidents}
\description{Monthly aggregation of \code{CHaccidents}, with one row per city-month.
This is a city time series, not a panel of Swiss cantons.}
\usage{data(CHaccidents_monthly)}
\format{A data frame with 180 rows and seven variables:
\describe{
\item{date}{Date. First day of the month, January 2011 to December 2025; an aggregation label, not an accident date.}
\item{year, month}{Integer. Calendar year and month.}
\item{accidents}{Integer. Number of all recorded accidents in that month.}
\item{injury_accidents}{Integer. Number with any injury, including fatalities (as1--as3).}
\item{severe_accidents}{Integer. Number with serious injury or fatalities (as1--as2).}
\item{fatal_accidents}{Integer. Number with fatalities (as1).}
}}
\details{Counts sum the logical flags of the complete accident snapshot. All 180
calendar months are present. The severity counts are nested and must not be
added together. They count accidents, not people. These are not exposure-adjusted
rates. The property-damage reporting change on 1 July 2015 affects comparability
of total counts; no correction is silently applied. See \code{CHaccidents} for
source coverage, dependence, reproducibility and redistribution conditions.}
\section{Redistribution}{Same CC BY source conditions as \code{CHaccidents}.
Credit Bundesamt fuer Strassen ASTRA and the City of Zurich, identify this as an
AEC monthly aggregation, and retain the source link.}
\source{\url{https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte}}
\examples{
data(CHaccidents_monthly)
plot(injury_accidents ~ date, CHaccidents_monthly, type="l",
     xlab="", ylab="Recorded injury accidents")
}
\seealso{\code{\link{CHaccidents}}}
\keyword{datasets}
