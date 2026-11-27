"""Install the reviewed compact AEC construction files from data-raw/."""

from pathlib import Path
import shutil

# Explicit allowlist: original large archives stay outside the installed package.
BUILD_FILES = {
    'CHaccidents': (
        'build.R',
    ),
    'CHapples': (
        'README.txt',
        'RIGHTS.txt',
        'build.R',
        'checksums.dcf',
        'column-mappings.csv',
        'market.csv',
        'paired-2024.xlsx',
        'prepare.py',
        'provenance.json',
        'weather-daily.csv.gz',
    ),
    'CHelectricity': (
        'annual.csv.gz',
        'build.R',
        'checksums.dcf',
        'daily.csv.gz',
        'metadata.csv',
        'prepare-annual.py',
        'prepare.py',
        'selected-meter-ids.txt',
        'zenodo-record.json',
    ),
    'CHhydro': (
        'README.txt',
        'RIGHTS.txt',
        'build.R',
        'checksums.dcf',
        'column-mappings.csv',
        'download.py',
        'electricity-daily.csv.gz',
        'prepare.py',
        'provenance.json',
        'validation.csv',
        'weather-daily.csv.gz',
    ),
    'CHvotes': (
        'build.R',
    ),
    'FRaccidents_daily': (
        'LICENSE-DATA.md',
        'Q_descriptif_champs_RR-T-Vent.csv',
        'RIGHTS.txt',
        'accidents-daily.csv.gz',
        'build.R',
        'checksums.dcf',
        'meteo-source.json',
        'prepare.py',
        'provenance.json',
        'weather-daily.csv.gz',
    ),
    'FRradars': (
        'LICENSE-DATA.md',
        'LICENSE-REPLICATION-CODE.txt',
        'RIGHTS.txt',
        'SOURCE-LICENCES.md',
        'build.R',
        'checksums.dcf',
        'prepare-from-replication.R',
        'source-providers.csv',
        'stack-counts.csv.gz',
        'upstream-sha256.json',
    ),
    'UCIcredit': (
        'build.R',
        'uci-record.json',
    ),
    'USrecession': (
        'RIGHTS.md',
        'build.R',
        'business_cycle_dates.json',
        'checksums.dcf',
        'column-mappings.csv',
        'h15-monthly.csv',
        'nber-copying-permission.txt',
        'nber-cycles.csv',
        'prepare.py',
        'provenance.json',
    ),
}


def main():
    source = Path("data-raw")
    target = Path("inst/data-build")
    for family, names in BUILD_FILES.items():
        destination = target / family
        destination.mkdir(parents=True, exist_ok=True)
        for name in names:
            shutil.copy2(source / family / name, destination / name)
    print("Reviewed construction sources copied; large archives excluded.")


if __name__ == "__main__":
    main()
