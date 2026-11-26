\name{CHvotes}
\alias{CHvotes}
\docType{data}
\title{Institutional and participation data for Swiss federal votes}
\description{A nonpartisan teaching selection from Swissvotes, Année Politique
Suisse, University of Bern. One row is one voting object or tie-break question,
not one individual voter and not necessarily one voting day.}
\usage{data(CHvotes)}
\format{A data frame with 710 rows and 14 variables:
\describe{
\item{vote_id}{Character. Original Swissvotes/OFS object number, including fractional suffixes; do not coerce to integer.}
\item{date}{Date. Voting day.}
\item{year}{Integer. Calendar year derived from date.}
\item{title_fr, title_en}{Character. Original short French and English titles. English titles are missing for many earlier objects. Titles retain traceability and are not used to select political positions.}
\item{source_url}{Character. Original link to the object on Swissvotes.}
\item{procedure}{Factor with five levels in source-code order 1--5: mandatory_referendum, optional_referendum, popular_initiative, direct_counterproposal, tie_break_question.}
\item{objects_on_day}{Integer. Swissvotes count of federal proposals on that day (source anzahl). An initiative, its counterproposal and tie-break question together count as ONE proposal. This need not equal the number of rows for that date.}
\item{eligible_voters}{Numeric. Number eligible to vote on the object (berecht).}
\item{ballots_cast}{Numeric. Returned ballots for the object, including blank and invalid ballots (stimmen).}
\item{turnout_pct}{Numeric. Source-reported returned ballots as a percentage of eligible voters (bet); units 0--100, not 0--1. Historic denominators can be missing even where the percentage is reported.}
\item{blank_ballots}{Numeric. Blank ballots, including unanswered items for initiatives with counterproposals (leer).}
\item{invalid_ballots}{Numeric. Invalid ballots (ungultig).}
\item{valid_ballots}{Numeric. Valid votes (gultig), not all returned ballots.}
}}
\details{The source was downloaded on 20 October 2026; the distribution page
labels its CSV 28 September 2026. All objects dated on or before 20 October 2026
are retained, giving coverage 12 September 1848 to 27 September 2026. Four
scheduled objects after the cut-off are excluded. Empty strings and source dots
are converted to NA; no observations are imputed. Other variables (party
positions, recommendations, policy themes, yes/no results) are deliberately not
included in the teaching selection. This is selection of columns, not selection
of objects according to their political content. Rows are sorted by date/ID.

Objects on a common voting day are dependent. Do not treat repeated object
turnout as independent voting-day replicates. Turnout may differ across objects;
there is no invented overall voting-day participation variable. Analyses of
procedure or the number of objects are descriptive unless a separate causal
strategy is justified. The electorate and institutions change over this long
history, including the introduction of federal women's suffrage in 1971.

This is a fixed, offline snapshot. Source hashes and exact source-column mappings
are in the installed \file{teaching-data/} directory. The repository's
\file{data-raw/CHvotes/build.R} rebuilds it from the archived CSV after checking
its SHA-256. Do not assume the live source URL will keep identical contents.
}
\section{Redistribution}{Swissvotes explicitly licenses the dataset and
codebook under Creative Commons Attribution 4.0 International (CC BY 4.0).
Redistribution and adaptation, including commercial reuse, are permitted with
appropriate credit, a licence link and an indication of changes. Cite Swissvotes,
Année Politique Suisse, University of Bern, the source version and access date.
AEC selected/renamed variables, recoded procedure, converted missing values and
excluded future objects. This licence does not cover arbitrary third-party
documents linked from Swissvotes or other legacy AEC datasets.}
\source{Swissvotes (2026), dataset, Année Politique Suisse, University of Bern.
\url{https://swissvotes.ch/page/dataset}, CSV labelled 28 September 2026,
accessed 20 October 2026.}
\references{Swissvotes codebook:
\url{https://swissvotes.ch/page/dataset/codebook-de.pdf}.
CC BY 4.0: \url{https://creativecommons.org/licenses/by/4.0/}.}
\examples{
data(CHvotes)
recent <- subset(CHvotes, year >= 2000)
aggregate(turnout_pct ~ procedure, recent, mean)
# Count voting days without treating all object rows as independent days:
length(unique(recent$date))
}
\seealso{\code{\link{CHvotes_cantons}}}
\keyword{datasets}
