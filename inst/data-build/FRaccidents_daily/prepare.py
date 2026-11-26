"""Prepare compact Paris inputs from the article repository and Meteo-France.
Usage: python3 data-raw/FRaccidents_daily/prepare.py REPLICATION_ROOT WEATHER_GZ
Run from AEC. Original archives remain outside the installed package.
"""
from pathlib import Path
import csv, gzip, hashlib, json, sys, subprocess
from collections import Counter
from datetime import date, datetime, timedelta, timezone
from zoneinfo import ZoneInfo
root, weather = Path(sys.argv[1]), Path(sys.argv[2])
out = Path('data-raw/FRaccidents_daily')
accident = root/'data/processed/accidents.csv.gz'
start, end = date(2011,1,1), date(2019,12,31)
counts=Counter(); seen=set(); retained=0
with gzip.open(accident,'rt') as f:
    for r in csv.DictReader(f):
        if r['code_departement']!='75' or not '2010'<=r['annee']<='2020': continue
        assert r['id_accident'] not in seen
        seen.add(r['id_accident'])
        # BAAC clock time is local civil time; RR covers 06 UTC to 06 UTC.
        t=datetime.fromisoformat(r['date_accident']+'T'+r['heure_accident']).replace(tzinfo=ZoneInfo('Europe/Paris'))
        d=(t.astimezone(timezone.utc)-timedelta(hours=6)).date()
        if start<=d<=end: counts[d]+=1; retained+=1
with gzip.open(out/'accidents-daily.csv.gz','wt',newline='') as f:
    w=csv.writer(f);w.writerow(['date','injury_accidents'])
    d=start
    while d<=end:
        w.writerow([d,counts[d]]);d+=timedelta(days=1)
weather_rows=[]
with gzip.open(weather,'rt',encoding='utf-8-sig') as f:
    for r in csv.DictReader(f,delimiter=';'):
        if r['NUM_POSTE']=='75114001' and '20110101'<=r['AAAAMMJJ']<='20191231':
            weather_rows.append([datetime.strptime(r['AAAAMMJJ'],'%Y%m%d').date(),r['RR'],r['QRR']])
assert len(weather_rows)==3287 and len({r[0] for r in weather_rows})==3287
assert all(r[1] for r in weather_rows)
with gzip.open(out/'weather-daily.csv.gz','wt',newline='') as f:
    w=csv.writer(f);w.writerow(['date','rain_mm','rain_quality']);w.writerows(weather_rows)
def sha(p):
    h=hashlib.sha256()
    with open(p,'rb') as f:
        for b in iter(lambda:f.read(1024*1024),b''):h.update(b)
    return h.hexdigest()
meta={'retrieved':'2026-10-22','selection':'Paris department 75; 2011-2019; 06 UTC to 06 UTC next day; pre-pandemic complete years',
      'accident_repository':'https://github.com/jrenne/accidents-radars-france',
      'repository_commit':subprocess.check_output(['git','-C',str(root),'rev-parse','HEAD'],text=True).strip(),
      'accident_input_sha256':sha(accident),'weather_input_sha256':sha(weather),
      'weather_url':'https://meteofrance.s3.sbg.io.cloud.ovh.net/data/synchro_ftp/BASE/QUOT/Q_75_previous-1950-2024_RR-T-Vent.csv.gz',
      'station':'75114001 PARIS-MONTSOURIS','accidents_retained':retained,
      'compact_sha256':{p.name:sha(p) for p in out.glob('*.csv.gz')}}
(out/'provenance.json').write_text(json.dumps(meta,indent=2)+'\n')
print(meta)
