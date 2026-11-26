\name{CHapples}
\alias{CHapples}
\docType{data}
\title{Swiss class I apple wholesale prices, sales and spring frost proxies}
\description{Matched monthly price and quantity series for two Swiss apple
varieties, with harvest-year frost summaries for teaching demand estimation.}
\usage{data(CHapples)}
\format{A data frame with 44 rows and 10 variables, September 2022--June 2024:
\describe{
\item{date}{Date: first day of sale month, a label rather than a release date.}
\item{variety}{Gala or Golden Delicious.}
\item{quality_class}{I; conventional/IP Swiss-origin table apples, excluding organic.}
\item{quantity_t}{Tonnes sold by surveyed major Swiss warehouses to domestic buyers.}
\item{price_chf_kg}{Nominal wholesale price for loose goods, CHF/kg; one missing value (Gala, July 2023). No inflation correction.}
\item{harvest_year}{Calendar year for September--December, preceding year for January--August. Proxy for crop supplying stored fruit, not a verified origin of each sale.}
\item{source_season}{Original workbook column: 2022/23 or 2023/24. July/August 2023 appear under 2023/24 but are assigned harvest_year 2022.}
\item{frost_sio_days}{April--May days with strictly negative minimum air temperature at Sion in harvest_year.}
\item{frost_gut_days}{Same count at Guettingen.}
\item{frost_mean_days}{Arithmetic mean of the two station counts; not orchard-weighted.}
}}
\details{The OFAG/BLW and SWISSCOFEL workbook accompanying the 20 September
2024 analysis provides monthly price and quantity series for the same variety,
quality and marketing stage. They are collected in separate surveys, not
matched transactions. The quantity inquiry covers major warehouses estimated
to represent over 80 percent of pome-fruit sales, not all Swiss consumption.
Imports and exports are excluded. Prices pool sales channels; changes in
channel composition can affect the average. Volumes are sales, not production,
stocks or household consumption. All nonempty quantity cells are retained;
totals and percentage-change rows are excluded. The source's weighted campaign
prices can be reproduced from September--June quantities and prices.

A balanced September--June comparison contains 40 rows, two varieties and two
harvest years. July/August are retained in the object but excluded from that
comparison because only one campaign has these months. Frost has only two
independent annual values in this sample; 40 rows do not provide 40 weather
shocks. The frost instrument is equivalent to a harvest-year indicator and
cannot identify price alongside harvest-year fixed effects. Ordinary IV
standard errors, or cluster inference with only two harvest clusters, do not
justify precise causal conclusions. A negative demand slope does not establish
instrument relevance in the expected direction or the exclusion restriction.
See \code{CHapples_frost} for the longer weather history and construction.

\strong{Redistribution:} the original workbook (sheet deutsch, H5) explicitly
permits processing and publication with source attribution. Credit: BLW,
Fachbereich Marktanalysen; SWISSCOFEL. This source-specific permission is not a
CC licence and does not extend to other archives. Weather: Source: MeteoSwiss,
\href{https://creativecommons.org/licenses/by/4.0/}{CC BY 4.0}; AEC selects days
and computes annual summaries. Preserve both source attributions, the weather
licence link, and identify transformations when reusing the joined table.
The market data are not relicensed as CC BY by this join.

Frozen inputs, original workbook, source hashes, permission notice and offline
base-R construction script are installed in \code{data-build/CHapples}.}
\source{\href{https://www.donnees-agrimarche.ch/blog/nouvel-apercu-marche-suisse-pommes}{OFAG: Nouvel apercu du marche suisse des pommes (20 September 2024)};
\href{https://opendatadocs.meteoswiss.ch/general/terms-of-use}{MeteoSwiss open-data terms}.}
\examples{
data(CHapples)
x <- subset(CHapples, !format(date, "\%m") \%in\% c("07", "08"))
aggregate(quantity_t ~ variety + harvest_year, x, sum)
with(x, table(harvest_year, frost_mean_days))
}
\seealso{\code{\link{CHapples_frost}}}
\keyword{datasets}
