"""Extract compact inputs from the original Board H.15 ZIP and NBER JSON.
Run from AEC root: python3 data-raw/USrecession/prepare.py H15.zip cycles.json
Network access is not required. The checked-in compact inputs support rebuilds
without retaining the full H.15 release. New snapshots require a reviewed hash.
"""
from pathlib import Path
import csv, hashlib, json, sys, zipfile, xml.etree.ElementTree as ET
folder=Path('data-raw/USrecession')
manifest=json.loads((folder/'provenance.json').read_text())
paths=[Path(v) for v in sys.argv[1:]]
if len(paths)!=2: raise SystemExit('Supply the H.15 ZIP and NBER JSON paths.')
for path,key in zip(paths,['h15_archive','nber_json']):
    assert hashlib.sha256(path.read_bytes()).hexdigest()==manifest[key]['sha256'],key
with zipfile.ZipFile(paths[0]) as archive:
    root=ET.fromstring(archive.read('H15_data.xml'))
series={}
for element in root.iter():
    code=element.attrib.get('SERIES_NAME')
    if code in ('RIFLGFCM03_N.M','RIFLGFCY10_N.M'):
        series[code]={v.attrib['TIME_PERIOD']:v.attrib['OBS_VALUE'] for v in element
                      if 'TIME_PERIOD' in v.attrib and '1982-01'<=v.attrib['TIME_PERIOD'][:7]<='2024-12'}
assert len(series)==2
assert all(len(v)==516 for v in series.values())
assert set(series['RIFLGFCM03_N.M'])==set(series['RIFLGFCY10_N.M'])
with (folder/'h15-monthly.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(['source_period','yield_3m','yield_10y'])
    for date in sorted(series['RIFLGFCM03_N.M']):
        w.writerow([date,series['RIFLGFCM03_N.M'][date],series['RIFLGFCY10_N.M'][date]])
cycles=json.loads(paths[1].read_text())
with (folder/'nber-cycles.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(['peak','trough'])
    w.writerows((c['peak'],c['trough']) for c in cycles if c['peak'] and c['trough']>='1982-01-01')
print('Extracted 516 monthly yield pairs and 5 intersecting NBER cycles.')
