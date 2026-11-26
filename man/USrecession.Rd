\name{USrecession}
\alias{USrecession}
\docType{data}
\title{US Treasury term spreads and NBER recession indicators}
\description{A compact monthly panel for teaching early-warning rules, binary
prediction and time-series methods. One row represents one calendar month.}
\usage{data(USrecession)}
\format{A data frame with 516 rows and 7 variables, January 1982--December 2024:
\describe{
\item{date}{Date, first day of the observation month, a calendar label rather than a publication date.}
\item{yield_3m}{Three-month nominal Treasury constant-maturity yield, monthly business-day average, percent per annum, investment basis. Board series RIFLGFCM03_N.M.}
\item{yield_10y}{Ten-year nominal Treasury constant-maturity yield on the same basis, percent per annum. Board series RIFLGFCY10_N.M.}
\item{term_spread}{yield_10y minus yield_3m, in percentage points. Negative values represent an inverted yield curve.}
\item{recession}{Integer 0/1, NBER-dated recession in the observation month: the month after a peak through the trough month, inclusive.}
\item{target_date_12m}{Date, observation month plus twelve calendar months.}
\item{recession_12m}{Integer 0/1, recession status at target_date_12m. The final twelve values are NA because the targets lie outside this snapshot. Not a forecast and not an indicator of any recession within the intervening twelve months.}
}}
\details{Rates come directly from the Federal Reserve Board H.15 SDMX release
retrieved on 20 October 2026, selecting the two monthly constant-maturity series.
The source's month-end labels are changed to first-of-month labels; no rates
are interpolated, rounded further or spliced to discount-basis Treasury bills.
Both series are already business-day averages. Their quoted percentages are
not divided by 100, so the spread is in percentage points.

The NBER JSON chronology was retrieved on the same date; the chronology page
is labelled last updated 14 March 2023. Five recession episodes intersect the
snapshot, including the final eleven months of the 1981--1982 episode. There
are 47 contemporaneous recession months. The 504 matched forecast-origin
months end in December 2023; their targets span January 1983--December 2024,
with 36 recession months across four complete episodes. Calendar matching,
rather than dropping rows and shifting observations, constructs the target.

The recorded recession status is retrospective reference dating. It must not
be used as a predictor known at the observation date. Monthly yield averages
are known only after that month; date is not a claim of beginning-of-month
availability. These are a fixed historical snapshot, not a real-time vintage
archive. The last twelve targets are deliberately left missing, not assigned
zero. A fixed negative-spread rule requires no model fitting. Evaluate fitted
models in chronological order and account for delayed outcome availability.
Monthly classifications are dependent; 36 positive months are not 36 distinct
recessions. The known dating can be used for retrospective evaluation.

Construction sources, compact inputs, hashes, provenance and copying notices
are installed in data-build/USrecession/. Copy them to a writable rebuild root
as described in data-build/README.md. build.R rebuilds the object offline with
base R and shasum. prepare.py reconstructs compact inputs from the exact H.15
ZIP and NBER JSON; the 4.3 MB H.15 source archive is not installed.}
\section{Redistribution}{The NBER chronology page expressly states:
``Permission to copy is granted, provided attribution of source is given.''
Retain this notice and credit the National Bureau of Economic Research,
Business Cycle Dating Committee. This is a source-specific permission, not a
claim of CC BY or public-domain status for NBER material generally. The
Board's information is public domain unless otherwise indicated; credit the
Board of Governors of the Federal Reserve System and U.S. Treasury. AEC
selects months, aligns labels, computes spreads and encodes recession targets;
it does not imply endorsement by the sources. See teaching-data/US-EWS-RIGHTS.md.}
\source{Board of Governors of the Federal Reserve System, H.15 Selected
Interest Rates, Treasury constant-maturity monthly series.
\url{https://www.federalreserve.gov/releases/h15/}

National Bureau of Economic Research, Business Cycle Dating Committee,
US Business Cycle Expansions and Contractions.
\url{https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions}
\url{https://data.nber.org/data/cycles/business_cycle_dates.json}}
\references{\url{https://www.federalreserve.gov/disclaimer.htm}}
\examples{
data(USrecession)
z <- subset(USrecession, !is.na(recession_12m))
warning <- z$term_spread < 0
table(Warning=warning, Recession=z$recession_12m)
mean(warning[z$recession_12m==1]) # historical detection rate
mean(warning[z$recession_12m==0]) # historical false-positive rate
}
\keyword{datasets}
