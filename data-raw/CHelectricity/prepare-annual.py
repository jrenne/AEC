"""Summarise ALL residential meters in 2023/2024, without coverage selection.
From AEC root: python3 data-raw/CHelectricity/prepare-annual.py dataset.zip
Only complete local-calendar-day totals enter means; no annual extrapolation.
"""
import gzip, hashlib, io, json, sys, zipfile
from pathlib import Path
import pandas as pd
root=Path('data-raw/CHelectricity')
archive=Path(sys.argv[1]);h=hashlib.md5()
with archive.open('rb') as f:
    for b in iter(lambda:f.read(1024*1024),b''): h.update(b)
assert h.hexdigest()=='dd40d5e24aee2a3563bc36285b463dbd'
assert json.loads((root/'zenodo-record.json').read_text())['metadata']['license']['id']=='cc-by-4.0'
rows=[];days=pd.date_range('2023-01-01','2024-12-31',freq='D')
edges=pd.date_range('2023-01-01','2025-01-01',freq='D',tz='Europe/Zurich')
expected=pd.Series(((edges[1:].asi8-edges[:-1].asi8)//(15*60*10**9)).astype(int),index=days)
with zipfile.ZipFile(archive) as z:
    assert z.read('metadata.csv')==(root/'metadata.csv').read_bytes()
    meta=pd.read_csv(io.BytesIO(z.read('metadata.csv')),sep=';')
    homes=meta[meta['0_installation_type'].isin(['Apartment','Single-family house'])]
    for i,meter in enumerate(sorted(homes['0_meter_id'].astype(int))):
        d=pd.read_csv(z.open(f'smart_meter_data/{meter}.csv'),sep=';',usecols=['timestamp_utc','kWh_to_installation','kWh_to_grid'])
        ts=pd.to_datetime(d.pop('timestamp_utc'),utc=True)
        assert not ts.duplicated().any()
        assert (ts.diff().dropna()==pd.Timedelta(minutes=15)).all()
        d.index=ts.dt.tz_convert('Europe/Zurich').dt.tz_localize(None).dt.normalize()
        d=d.loc[(d.index>=days[0]) & (d.index<=days[-1])]
        assert not (d<0).any().any()
        g=d.groupby(level=0);sums=g.sum(min_count=1).reindex(days)
        counts=g.count().reindex(days,fill_value=0)
        assert counts.le(expected,axis=0).all().all()
        daily=sums.where(counts.eq(expected,axis=0))
        for year in [2023,2024]:
            q=daily.loc[daily.index.year==year]
            r={'meter_id':str(meter),'year':year,'days_in_year':len(q)}
            for channel,col in [('import','kWh_to_installation'),('export','kWh_to_grid')]:
                v=q[col];n=int(v.count());r[f'{channel}_days']=n
                r[f'{channel}_mean_kwh_day']=float(v.mean()) if n else None
                r[f'{channel}_sum_kwh']=float(v.sum()) if n else None
            for season,months in [('winter',[1,2,12]),('summer',[6,7,8])]:
                v=q.loc[q.index.month.isin(months),'kWh_to_installation'];n=int(v.count())
                r[f'{season}_import_days']=n
                r[f'{season}_import_mean_kwh_day']=float(v.mean()) if n else None
            rows.append(r)
        if (i+1)%250==0: print(f'{i+1}/{len(homes)} residential meters',flush=True)
out=pd.DataFrame(rows)
with (root/'annual.csv.gz').open('wb') as f:
    with gzip.GzipFile(fileobj=f,mode='wb',filename='',mtime=0) as gz:
        with io.TextIOWrapper(gz,encoding='utf-8',newline='') as text:
            out.to_csv(text,index=False,na_rep='',lineterminator='\n')
hashline='Annual-SHA256: '+hashlib.sha256((root/'annual.csv.gz').read_bytes()).hexdigest()+'\n'
p=root/'checksums.dcf';p.write_text(''.join(l for l in p.read_text().splitlines(keepends=True) if not l.startswith('Annual-SHA256:'))+hashline)
print(f'Prepared {len(homes)} residential meters; {len(out)} meter-years.',flush=True)
