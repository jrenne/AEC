"""Freeze the reviewed Swiss wholesale workbook and daily frost inputs.
Run from AEC root: python data-raw/CHapples/prepare.py WORKBOOK SIO_CSV GUT_CSV
Requires openpyxl; package use and offline R rebuild require only base R.
"""
from pathlib import Path
import sys, csv, gzip, io, hashlib, json, datetime, shutil
import openpyxl
out=Path('data-raw/CHapples')
workbook, *weather = map(Path,sys.argv[1:])
assert len(weather)==2
sheet=openpyxl.load_workbook(workbook,data_only=True)['deutsch']
assert 'Weiterverarbeitung und Publikation' in ' '.join(str(c.value) for c in sheet[5])
rows=[]
for variety,start in [('Gala',49),('Golden Delicious',75)]:
    # July/August 2023 precede September 2023 in the source's 2023/24 column.
    for offset,month in enumerate([7,8,9,10,11,12,1,2,3,4,5,6]):
        row=start-2+offset
        for season,qcol,pcol in [('2022/23',3,5),('2023/24',4,6)]:
            q=sheet.cell(row,qcol).value; p=sheet.cell(row,pcol).value
            if q is None: continue
            year=int(season[:4])+(month<7)
            date=datetime.date(year,month,1)
            rows.append([date.isoformat(),variety,'I',q,p,year-(month<9),season])
rows.sort(key=lambda r:(r[0],r[1]))
with (out/'market.csv').open('w',newline='') as f:
    w=csv.writer(f);w.writerow(['date','variety','quality_class','quantity_t','price_chf_kg','harvest_year','source_season']);w.writerows(rows)
assert len(rows)==44 and sum(r[4] is None for r in rows)==1
shutil.copyfile(workbook,out/'paired-2024.xlsx')
provenance={'retrieved':'2026-10-20','workbook_sha256':hashlib.sha256(workbook.read_bytes()).hexdigest(),
 'workbook_url':'https://www.datocms-assets.com/21252/1726748286-begleittabelle_neue-einblicke-schweizer-apfelmarkt.xlsx',
 'sheet':'deutsch','market_rows':'Gala 47:58; Golden Delicious 73:84; C:D quantities, E:F prices',
 'weather':[]}
daily=[]
for path,station in zip(weather,['SIO','GUT']):
    provenance['weather'].append({'station':station,'url':f'https://data.geo.admin.ch/ch.meteoschweiz.ogd-smn/{station.lower()}/ogd-smn_{station.lower()}_d_historical.csv','original_sha256':hashlib.sha256(path.read_bytes()).hexdigest()})
    with path.open() as f:
        for r in csv.DictReader(f,delimiter=';'):
            d=datetime.datetime.strptime(r['reference_timestamp'],'%d.%m.%Y %H:%M').date()
            if 2006<=d.year<=2025 and 4<=d.month<=5:
                assert r['station_abbr']==station and r['tre200dn']!=''
                daily.append([station,d.isoformat(),float(r['tre200dn'])])
assert len(daily)==2440
s=io.StringIO(newline='');w=csv.writer(s);w.writerow(['station','date','tmin_c']);w.writerows(daily)
(out/'weather-daily.csv.gz').write_bytes(gzip.compress(s.getvalue().encode(),mtime=0))
(out/'provenance.json').write_text(json.dumps(provenance,indent=2)+'\n')
with (out/'checksums.dcf').open('w') as f:
    for name in ['market.csv','weather-daily.csv.gz','paired-2024.xlsx']:
        f.write(f'File: {name}\nSHA256: {hashlib.sha256((out/name).read_bytes()).hexdigest()}\n\n')
