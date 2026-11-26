"""Regenerate installed source mappings and categorical dictionaries (stdlib only).

Run from the AEC repository root after downloading the two frozen inputs.
The R build scripts rebuild objects; this script rebuilds provenance tables.
"""
import csv
import hashlib
from pathlib import Path

out = Path("inst/teaching-data")
out.mkdir(parents=True, exist_ok=True)

def table(name, header, rows):
    with (out / name).open("w", encoding="utf-8", newline="") as f:
        writer = csv.writer(f)
        writer.writerow(header)
        writer.writerows(rows)

accident_map = {
    "accident_id": "AccidentUID", "year": "AccidentYear", "month": "AccidentMonth",
    "weekday": "AccidentWeekDay (aw401=Monday to aw407=Sunday)", "hour": "AccidentHour",
    "accident_type_code": "AccidentType", "accident_type": "AccidentType_en",
    "accident_type_fr": "AccidentType_fr", "severity_code": "AccidentSeverityCategory",
    "severity": "AccidentSeverityCategory_en", "severity_fr": "AccidentSeverityCategory_fr",
    "involves_pedestrian": "AccidentInvolvingPedestrian",
    "involves_bicycle": "AccidentInvolvingBicycle",
    "involves_motorcycle": "AccidentInvolvingMotorcycle", "road_type_code": "RoadType",
    "road_type": "RoadType_en", "road_type_fr": "RoadType_fr",
    "easting_lv95": "AccidentLocation_CHLV95_E", "northing_lv95": "AccidentLocation_CHLV95_N",
    "canton": "CantonCode", "municipality_code": "MunicipalityCode",
    "injury": "AccidentSeverityCategory in as1/as2/as3",
    "severe": "AccidentSeverityCategory in as1/as2", "fatal": "AccidentSeverityCategory == as1",
}
votes_map = {
    "vote_id": "anr", "date": "datum (dd.mm.yyyy)", "year": "year(datum)",
    "title_fr": "titel_kurz_f", "title_en": "titel_kurz_e", "source_url": "swissvoteslink",
    "procedure": "rechtsform: 1 mandatory_referendum; 2 optional_referendum; 3 popular_initiative; 4 direct_counterproposal; 5 tie_break_question",
    "objects_on_day": "anzahl (initiative/counterproposal/tie-break counted together)",
    "eligible_voters": "berecht", "ballots_cast": "stimmen", "turnout_pct": "bet",
    "blank_ballots": "leer", "invalid_ballots": "ungultig", "valid_ballots": "gultig",
}
maps = [("CHaccidents", accident_map), ("CHvotes", votes_map)]
maps += [("CHvotes_cantons", {
    "vote_id": "anr", "date": "datum", "canton": "source-column prefix, uppercase",
    "eligible_voters": "[canton]-berecht", "ballots_cast": "[canton]-stimmen",
    "turnout_pct": "[canton]-bet", "valid_ballots": "[canton]-gultig"})]
maps += [("CHaccidents_monthly", {
    "date": "first day of year/month (aggregation label)", "year": "year", "month": "month",
    "accidents": "count of accident rows", "injury_accidents": "sum(injury)",
    "severe_accidents": "sum(severe)", "fatal_accidents": "sum(fatal)"})]
table("column-mappings.csv", ["dataset", "variable", "source_or_transformation"],
      [(name, key, value) for name, mapping in maps for key, value in mapping.items()])

with Path("data-raw/CHaccidents/RoadTrafficAccidentLocations.csv").open(encoding="utf-8-sig") as f:
    accidents = list(csv.DictReader(f))
codes = []
for field in ("AccidentType", "AccidentSeverityCategory", "RoadType", "AccidentWeekDay"):
    pairs = sorted({(r[field], r[field+"_en"], r[field+"_fr"]) for r in accidents})
    codes += [(field, *p) for p in pairs]
table("accident-codes.csv", ["source_variable", "code", "label_en", "label_fr"], codes)

sources = [
    ("CHaccidents;CHaccidents_monthly", "data-raw/CHaccidents/RoadTrafficAccidentLocations.csv",
     "https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte/download/RoadTrafficAccidentLocations.csv",
     "https://data.stadt-zuerich.ch/dataset/sid_dav_strassenverkehrsunfallorte",
     "CC BY (catalogue does not specify version)", "Bundesamt fuer Strassen ASTRA; City of Zurich, Dienstabteilung Verkehr",
     "catalogue updated 2026-03-11; 2011-2025"),
    ("CHvotes;CHvotes_cantons", "data-raw/CHvotes/swissvotes_dataset.csv",
     "https://swissvotes.ch/page/dataset/swissvotes_dataset.csv",
     "https://swissvotes.ch/page/dataset", "CC BY 4.0",
     "Swissvotes, Annee Politique Suisse, University of Bern", "CSV labelled 2026-09-28; cut-off 2026-10-20"),
]
table("sources.csv", ["datasets", "repository_input", "download_url", "landing_url",
                     "data_terms", "credit", "source_version", "access_date", "sha256"],
      [(*s, "2026-10-20", hashlib.sha256(Path(s[1]).read_bytes()).hexdigest()) for s in sources])

# Extend the same installed dictionaries for the two subsequently added families.
extra_mappings = []
for family in ("UCIcredit", "CHelectricity"):
    with Path(f"data-raw/{family}/column-mappings.csv").open() as f:
        extra_mappings.extend(tuple(r.values()) for r in csv.DictReader(f))
extra_mappings += [("CHelectricity_meters", "selected_daily", "ID in deterministic selected-meter-ids.txt"),
                  ("CHelectricity_meters", "daily_selection_weight", "source type count / selected type count; NA if not selected")]
daily = {"meter_id":"source filename ID", "date":"UTC timestamp converted to Europe/Zurich date",
         "year":"local calendar year", "month":"local calendar month", "weekday":"Monday 1 to Sunday 7",
         "intervals_expected":"92/96/100 quarter-hours per local day",
         "valid_import":"count nonmissing kWh_to_installation", "valid_export":"count nonmissing kWh_to_grid",
         "import_observed_kwh":"sum available kWh_to_installation; NA if none",
         "export_observed_kwh":"sum available kWh_to_grid; NA if none",
         "import_kwh":"observed sum only if all expected import intervals valid",
         "export_kwh":"observed sum only if all expected export intervals valid",
         "net_kwh":"complete import minus complete export"}
extra_mappings += [("CHelectricity", k, v) for k,v in daily.items()]
table("column-mappings.csv", ["dataset", "variable", "source_or_transformation"],
      [(name,k,v) for name,mapping in maps for k,v in mapping.items()] + extra_mappings)
sources += [
    ("UCIcredit", "data-raw/UCIcredit/uci-350.zip",
     "https://archive.ics.uci.edu/static/public/350/default+of+credit+card+clients.zip",
     "https://archive.ics.uci.edu/dataset/350/default+of+credit+card+clients",
     "CC BY 4.0", "I-Cheng Yeh (2009), UCI Machine Learning Repository",
     "dataset 350; DOI 10.24432/C55S3H"),
    ("CHelectricity", "data-raw/CHelectricity/daily.csv.gz",
     "https://zenodo.org/api/records/21398769/files/dataset.zip/content",
     "https://zenodo.org/records/21398769", "CC BY 4.0",
     "Kaiser, Kreft, Gonzalez Vaya and Hug (2026)",
     "Zenodo v1; archive MD5 dd40d5e24aee2a3563bc36285b463dbd; AEC deterministic daily extract"),
    ("CHelectricity_meters", "data-raw/CHelectricity/metadata.csv",
     "https://zenodo.org/api/records/21398769/files/dataset.zip/content",
     "https://zenodo.org/records/21398769", "CC BY 4.0",
     "Kaiser, Kreft, Gonzalez Vaya and Hug (2026)", "Zenodo v1; metadata.csv from dataset.zip"),
]
table("sources.csv", ["datasets", "repository_input", "download_url", "landing_url",
                     "data_terms", "credit", "source_version", "access_date", "sha256"],
      [(*s, "2026-10-20", hashlib.sha256(Path(s[1]).read_bytes()).hexdigest()) for s in sources])

# US recession inputs use a specific NBER copying permission, not CC BY.
with Path("data-raw/USrecession/column-mappings.csv").open() as f:
    us_mappings = list(csv.DictReader(f))
with (out/"column-mappings.csv").open() as f:
    existing_mappings = list(csv.DictReader(f))
table("column-mappings.csv", ["dataset","variable","source_or_transformation"],
      [tuple(r.values()) for r in existing_mappings if r["dataset"]!="USrecession"] +
      [tuple(r.values()) for r in us_mappings])
with (out/"sources.csv").open() as f:
    existing_sources = list(csv.DictReader(f))
us_sources = [
    ("USrecession", "data-raw/USrecession/h15-monthly.csv",
     "https://www.federalreserve.gov/datadownload/Output.aspx?rel=H15&filetype=zip",
     "https://www.federalreserve.gov/releases/h15/", "Public domain; credit requested",
     "Board of Governors of the Federal Reserve System; U.S. Treasury",
     "H.15 monthly RIFLGFCM03_N.M and RIFLGFCY10_N.M; 1982-2024 extract; original archive hash in provenance.json"),
    ("USrecession", "data-raw/USrecession/nber-cycles.csv",
     "https://data.nber.org/data/cycles/business_cycle_dates.json",
     "https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions",
     "Permission to copy granted with source attribution",
     "National Bureau of Economic Research, Business Cycle Dating Committee",
     "Chronology page updated 2023-03-14; five intersecting cycles; source JSON hash in provenance.json")
]
table("sources.csv", list(existing_sources[0]),
      [tuple(r.values()) for r in existing_sources if r["datasets"]!="USrecession"] +
      [(*r,"2026-10-20",hashlib.sha256(Path(r[1]).read_bytes()).hexdigest()) for r in us_sources])

# Full residential annual summaries share reviewed source terms and metadata.
annual_fields = {
 'meter_id':'source meter ID; all Apartment and Single-family house meters',
 'year':'local calendar year 2023 or 2024',
 'days_in_year':'365 or 366 local calendar days',
}
for channel in ('import','export'):
    annual_fields[channel+'_days']='count complete local days for '+channel
    annual_fields[channel+'_mean_kwh_day']='mean complete daily '+channel+' totals; NA if no complete days'
    annual_fields[channel+'_sum_kwh']='sum complete daily '+channel+' totals; NOT a full annual total if coverage incomplete'
for season,months in [('winter','January February December of the indicated year'),('summer','June July August')]:
    annual_fields[season+'_import_days']='count complete import days in '+months
    annual_fields[season+'_import_mean_kwh_day']='mean complete daily imports in '+months+'; NA if no complete days'
with Path('data-raw/CHelectricity/column-mappings.csv').open() as f:
    for row in csv.DictReader(f):
        if row['variable'] not in ('meter_id','housing_units','source_complete_intervals','max_net_injection_kw'):
            annual_fields[row['variable']]=row['source_or_transformation']+'; static source metadata, not annual treatment status'
with (out/'column-mappings.csv').open('a') as f:
    csv.writer(f).writerows(('CHelectricity_annual',k,v) for k,v in annual_fields.items())
with (out/'sources.csv').open('a') as f:
    csv.writer(f).writerow(('CHelectricity_annual','data-raw/CHelectricity/annual.csv.gz',
      'https://zenodo.org/api/records/21398769/files/dataset.zip/content',
      'https://zenodo.org/records/21398769','CC BY 4.0',
      'Kaiser, Kreft, Gonzalez Vaya and Hug (2026)',
      'Zenodo v1; all residential meters; complete-day annual and seasonal aggregates',
      '2026-10-20',hashlib.sha256(Path('data-raw/CHelectricity/annual.csv.gz').read_bytes()).hexdigest()))

# Swiss apples: source-specific market permission and CC BY weather stay distinct.
with Path('data-raw/CHapples/column-mappings.csv').open() as f:
    apple_maps=list(csv.DictReader(f))
with (out/'column-mappings.csv').open('a') as f:
    csv.writer(f).writerows(tuple(r.values()) for r in apple_maps)
with (out/'sources.csv').open('a') as f:
    w=csv.writer(f)
    for dataset,filename,url,landing,terms,credit,version in [
      ('CHapples','market.csv','https://www.datocms-assets.com/21252/1726748286-begleittabelle_neue-einblicke-schweizer-apfelmarkt.xlsx',
       'https://www.donnees-agrimarche.ch/blog/nouvel-apercu-marche-suisse-pommes',
       'Processing and publication permitted with source attribution (workbook deutsch H5)',
       'BLW, Fachbereich Marktanalysen; SWISSCOFEL','2024-09-20 workbook; Gala and Golden Delicious class I'),
      ('CHapples;CHapples_frost','weather-daily.csv.gz','https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/',
       'https://opendatadocs.meteoswiss.ch/general/terms-of-use','CC BY 4.0','Source: MeteoSwiss',
       'SIO and GUT historical daily tre200dn; April-May 2006-2025; URLs and original hashes in provenance.json')]:
        path=Path('data-raw/CHapples')/filename
        w.writerow((dataset,str(path),url,landing,terms,credit,version,'2026-10-20',hashlib.sha256(path.read_bytes()).hexdigest()))

# Swiss hydropower: retain separate electricity and weather attributions.
with Path('data-raw/CHhydro/column-mappings.csv').open() as f:
    rows=list(csv.DictReader(f))
with (out/'column-mappings.csv').open('a') as f:
    csv.writer(f).writerows(tuple(r.values()) for r in rows)
with (out/'sources.csv').open('a') as f:
    w=csv.writer(f)
    for name,url,terms,credit in [
      ('electricity-daily.csv.gz','https://api.energy-charts.info/',
       'CC BY 4.0; explicit SMARD licence in every Swiss price response',
       'Energy-Charts.info / Fraunhofer ISE; Bundesnetzagentur | SMARD.de'),
      ('weather-daily.csv.gz','https://opendatadocs.meteoswiss.ch/general/terms-of-use',
       'CC BY 4.0','Source: MeteoSwiss')]:
        path=Path('data-raw/CHhydro')/name
        w.writerow(('CHhydro',str(path),url,url,terms,credit,
          '2016-2024 snapshot; all original URLs and response hashes in provenance.json',
          '2026-10-20',hashlib.sha256(path.read_bytes()).hexdigest()))
# Paris accidents and independent rainfall: source-specific attribution.
import json
paris_root=Path('data-raw/FRaccidents_daily')
paris_meta=json.loads((paris_root/'provenance.json').read_text())
with (out/'column-mappings.csv').open('a') as f:
    csv.writer(f).writerows(('FRaccidents_daily',k,v) for k,v in {
      'date':'start date of matched 06-to-06 UTC observation interval',
      'injury_accidents':'count BAAC Paris department 75 accidents after Europe/Paris clock conversion to UTC',
      'rain_mm':'Meteo-France RR, station 75114001, mm per 06-to-06 UTC day',
      'rain_quality':'original Meteo-France QRR code',
      'weekday':'Monday 1 to Sunday 7 of interval start date',
      'month':'month of interval start date','year':'year of interval start date'}.items())
with (out/'sources.csv').open('a') as f:
    w=csv.writer(f)
    for filename,url,credit,version in [
      ('accidents-daily.csv.gz','https://github.com/jrenne/accidents-radars-france',
       'Jean-Paul Renne; Ministry of the Interior / ONISR, BAAC',paris_meta['repository_commit']),
      ('weather-daily.csv.gz',paris_meta['weather_url'],
       'Meteo-France, Paris-Montsouris station 75114001','resource metadata in data-build/FRaccidents_daily/meteo-source.json')]:
        w.writerow(('FRaccidents_daily',str(paris_root/filename),url,url,
         'Licence Ouverte / Open Licence 2.0',credit,version,'2026-10-22',
         hashlib.sha256((paris_root/filename).read_bytes()).hexdigest()))
