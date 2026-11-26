CHhydro: reproducible Swiss hydropower/price teaching snapshot, 2016-2024.

Offline rebuild (base R + shasum), from a writable root:
  create data/ and data-raw/; copy installed data-build/CHhydro into data-raw/;
  Rscript --vanilla data-raw/CHhydro/build.R
The script verifies SHA256 checksums and reconstructs data/CHhydro.rda exactly.
The installed inputs require no API access, Python, pandas or registration.

Source refresh (separate maintenance action, no automatic download):
  python download.py
  AEC_ENERGY_INPUTS=/path/to/responses AEC_WEATHER_INPUTS=/path/to/stationfiles
  python prepare.py
prepare.py requires pandas, checks all original-response hashes in provenance.json
and freezes the small inputs. Downloaded files can change; a mismatch requires
review of sources/terms/metadata, not editing a checksum to bypass validation.
The default raw directories are /tmp/aec-swiss-electricity and
/tmp/aec-swiss-apples. Download SIO/GUT historical daily CSVs separately from the
exact MeteoSwiss URLs in provenance.json. Large original responses stay outside
source/installed packages. Weather includes 25-31 December 2015 to calculate the
first 2016 previous-seven-day rainfall sums.

Definitions: market power uses hourly intervals; German source quarter-hours
are averaged only with all four values. UTC alignment precedes Europe/Zurich
civil-day aggregation. Each complete daily mean weights source hours equally,
including all 23/25 hours on DST days. MW means average power; MWh/day is MW
multiplied by hours. Prices are EUR/MWh, not CHF or retail tariffs. Negative
prices are retained. No rounding beyond CSV round-tripping or interpolation.
A daily field is NA if any source hour is missing. Only river generation has
missing retained daily values (10), with river_valid_hours documenting coverage.

Weather uses source daily reference dates unchanged, which are not claimed to
coincide exactly with the Europe/Zurich electricity-day boundaries. Sion and
Guettingen are proxies, not national/catchment-weighted indices. Rain_previous7
sums days date-7 through date-1, excluding current-day rain.

Reservoir generation and pumped_generation are distinct source categories. The
latter is generation, not pumping consumption or net storage injection. Load is
the source system-load series, not household or verified final consumption.
The IV example estimates short-run reservoir dispatch, not consumer demand.
CC BY source rights and attribution are detailed in RIGHTS.txt and package help.
