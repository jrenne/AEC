\name{CHvotes_cantons}
\alias{CHvotes_cantons}
\docType{data}
\title{Cantonal participation in Swiss federal votes}
\description{Long-form cantonal observations from the same frozen Swissvotes
source as \code{CHvotes}. Join vote_id to CHvotes for procedure and titles.}
\usage{data(CHvotes_cantons)}
\format{A data frame with 17,482 rows and seven variables:
\describe{
\item{vote_id}{Character. Foreign key to CHvotes; unique together with canton.}
\item{date}{Date. Voting day; coverage 14 January 1866 to 3 March 2024.}
\item{canton}{Character. One of the 26 official two-letter canton abbreviations.}
\item{eligible_voters}{Numeric. Source canton-specific eligible voters, or NA.}
\item{ballots_cast}{Numeric. Returned ballots, including blank/invalid ballots.}
\item{turnout_pct}{Numeric. Source-reported cantonal participation, in percent, or NA.}
\item{valid_ballots}{Numeric. Valid cantonal votes, not all returned ballots.}
}}
\details{The source columns are canton-prefixed berecht, stimmen, bet and gultig.
Empty/dot values become NA. A canton-object row is retained if any of these four
source measures is observed. All-empty combinations are omitted, so this is an
unbalanced panel. No earlier Jura history is invented. The source's cantonal
columns stop earlier than its national observations; do not fill recent
missing canton observations with zeros or national values. No turnout is
recomputed from other variables. Rows are sorted by date, numeric object ID and
canton. Source values are preserved rather than forced to reconcile.

Dependence exists across cantons within a ballot and across objects on the same
day, and potentially over time within a canton. These are aggregate turnout
data, not individual choices. See CHvotes for institutional changes, full source
and transformation details.}
\section{Redistribution}{CC BY 4.0. Credit Swissvotes, Année Politique Suisse,
University of Bern; cite the source, access date and licence, and identify the
AEC reshaping and missing-value conversion.}
\source{\url{https://swissvotes.ch/page/dataset}; CSV labelled 28 September 2026,
downloaded 20 October 2026.}
\references{\url{https://creativecommons.org/licenses/by/4.0/}}
\examples{
data(CHvotes_cantons)
sample <- subset(CHvotes_cantons, date >= as.Date("2000-01-01"))
aggregate(turnout_pct ~ canton, sample, mean)
}
\seealso{\code{\link{CHvotes}}}
\keyword{datasets}
