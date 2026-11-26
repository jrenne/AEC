Offline: from a writable AEC root containing data/ and data-raw/CHapples/, run
Rscript --vanilla data-raw/CHapples/build.R
Installed inputs: system.file('data-build/CHapples', package='AEC'). Copy this
folder into data-raw/CHapples in a writable directory and create data/ first.
The build verifies SHA256 hashes and reproduces both compressed R objects.

prepare.py WORKBOOK SIO_CSV GUT_CSV freezes the upstream inputs (openpyxl).
provenance.json gives original URLs and hashes; checksums.dcf identifies the
frozen inputs used in this release. Live sources can change: the packaged
snapshot, not a future download, defines exact reproducibility.

market.csv: sheet deutsch, rows 47:58 and 73:84, columns C:F. Blank quantity
cells are absent rows; the single blank price remains NA. Totals/change rows
are excluded. July/August 2023 belong to harvest 2022 although printed in the
source's 2023/24 column; source_season preserves that original label. September
starts the crop-year proxy; it is not a verified harvest date of each sale.
No rounding, imputation, inflation correction, extrapolation or causal filtering.

weather-daily.csv.gz: station/date/tre200dn only; the source daily date labels
are retained, without converting them to local civil days. Counts use strictly
negative Tmin during April 1--May 31, 61 valid observations at each station in
every retained year. 0C is not a frost day. The two stations illustrate Valais
and eastern Switzerland; they are not an orchard-weighted national sample.
The April--May window is a simple spring proxy, not observed flowering or damage.
CHapples joins the unweighted mean of the two annual counts by harvest_year.

Validation: unique keys; complete spring calendars; missingness; dates and crop
year assignment; official Sept--June totals and quantity-weighted prices;
independent weather reaggregation and installed offline rebuild (tests/apples.R).
Teaching estimation uses 40 matched Sept--June rows, not all 44. Only two harvest
years have market data. Longer weather history does not lengthen the IV sample.
