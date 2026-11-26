\name{FRradars}
\alias{FRradars}
\docType{data}
\title{French speed-camera comparisons for a compact difference-in-differences application}
\description{Integer injury-crash counts in three annual windows for the
406 treated-site comparisons in the principal specification of Renne (2026).
One row is a site in a treated site's comparison set; sites can recur.}
\usage{data(FRradars)}
\format{A data frame with 21,939 rows and 10 variables:
\describe{
\item{stack_id}{Integer. Comparison identifier, 1 to 406. Each comparison has one treated site and 10--104 future-treated controls.}
\item{site_id}{Character. Original camera-site key. There are 639 distinct sites, 406 appearing as treated sites and 477 as controls; roles overlap.}
\item{treated}{Logical. TRUE for the site whose installation anchors this comparison, FALSE for a comparison site.}
\item{anchor_month}{Date. First day of the treated site's installation month, January 2012--December 2022.}
\item{installation_month}{Date. First day of this row's own recorded installation month; control installations fall after anchor month plus 12.}
\item{road_class}{Character. Matched route class: autoroute, nationale or departementale. Constant within each comparison.}
\item{speed_limit_kmh}{Numeric. Recorded speed limit, km/h; NA is a separate matching stratum, not zero.}
\item{accidents_earlier}{Integer. Total injury crashes in months -24 to -13 relative to anchor_month.}
\item{accidents_pre}{Integer. Total injury crashes in months -12 to -1 relative to anchor_month.}
\item{accidents_post}{Integer. Total injury crashes in months +1 to +12 relative to anchor_month. The installation month is omitted.}
}}
\details{The same calendar windows apply to the treated site and its controls.
Divide counts by 12 for crashes per site-month; multiply that mean by 100
for crashes per 100 site-months. Zeros are observed zero counts, not imputed
missing values. There are no traffic-exposure denominators.

Counts refer to a road corridor extending 2 km in each direction along the
connected monitored road and at most 100 m from it. Candidates must retain
at least 75 percent of nominal two-sided network reach and pass the article's
road-match and large-city exclusion rules. Nearby pre-existing cameras
exclude sites, and nearby subsequent installations invalidate affected
post windows. Controls have the same road-class and exact speed-limit stratum,
receive their camera after the comparison's post window, and lie more than
4 km from the treated site. Each comparison has at least ten controls.
See the paper for the full geometry and exposure rules.

Average each treated change minus its controls' mean change, then give each
of the 406 comparisons equal weight. This reproduces the paper's first-year
point estimate, -0.01477094585114 injury crashes per site-month. Pooling all control
rows equally would give unintended extra weight to comparisons with more controls.
A site may be a control in several comparisons and later a treated site;
independent-row or independent-comparison standard errors are inappropriate.
For uncertainty, resample physical site IDs jointly in all their roles,
renormalizing control weights in each comparison. Classroom bootstrap draws
need not match the paper's archived draws or its full candidate population.

The compact extraction does not identify raw accident records, provide
monthly event histories or reproduce geometry/sensitivity analyses. Its
annual earlier window supports one pre-period diagnostic, not the paper's
joint test of two six-month pre-treatment coefficients. Absence of a
significant pre-period contrast does not prove parallel trends.

Offline inputs and build.R are installed in data-build/FRradars.
prepare-from-replication.R optionally reconstructs the compact input from
the article's full checksum-verified replication checkout.}
\section{Redistribution}{Licence Ouverte 2.0 for the processed data, with
underlying source attributions and terms preserved. Credit Jean-Paul Renne,
Accidents corporels et radars fixes en France, version 1.1.0 (11 October 2026);
Ministry of the Interior/ONISR (BAAC), Ministry of the Interior/DSR and
Antoine Augusti (camera inventories), IGN BD TOPO (road geometry), and
OpenDataSoft (2013 commune geography; underlying Licence Ouverte 1.0).
AEC extracts and aggregates the comparison windows. Complete source dates,
license texts and attribution notices are in data-build/FRradars/RIGHTS.txt,
SOURCE-LICENCES.md and source-providers.csv.}
\source{\url{https://github.com/jrenne/accidents-radars-france}
and \url{https://github.com/jrenne/accidents-radars-replication}.}
\references{Renne, J.-P. (2026). The Effects of Speed Cameras on Injury Crashes
in France. Working paper, October.}
\examples{
data(FRradars)
scores <- vapply(split(FRradars, FRradars$stack_id), function(d) {
  change <- (d$accidents_post-d$accidents_pre)/12
  change[d$treated]-mean(change[!d$treated])
}, numeric(1))
mean(scores)
}
\keyword{datasets}
