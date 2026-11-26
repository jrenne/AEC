"""Freeze CHhydro intermediates from checked API responses and MeteoSwiss files.
Run with pandas: AEC_ENERGY_INPUTS=... AEC_WEATHER_INPUTS=... python prepare.py
Rebuilding the installed R object from these intermediates needs only base R.
"""
from pathlib import Path
import os,json,hashlib,gzip,io
import pandas as pd
out=Path(__file__).resolve().parent
energy=Path(os.environ.get('AEC_ENERGY_INPUTS','/tmp/aec-swiss-electricity'))
weather=Path(os.environ.get('AEC_WEATHER_INPUTS','/tmp/aec-swiss-apples'))
provenance=json.loads((out/'provenance.json').read_text())
for source in provenance['sources']:
    root=weather if source['file'].endswith('.csv') else energy
    assert hashlib.sha256((root/source['file']).read_bytes()).hexdigest()==source['sha256'],source['file']
frames=[]
for window in ['2016-20','2021-22','2023','2024']:
    series=[]
    for country,keep in [('ch',{'Hydro water reservoir':'reservoir_mw','Hydro pumped storage':'pumped_generation_mw','Hydro Run-of-River':'river_mw','Nuclear':'nuclear_mw','Load':'load_mw'}),('de',{'Wind onshore':'wind_onshore_de_mw','Wind offshore':'wind_offshore_de_mw'})]:
        x=json.loads((energy/f'power-{country}-{window}.json').read_text())
        idx=pd.to_datetime(x['unix_seconds'],unit='s',utc=True)
        assert idx.is_unique and idx.is_monotonic_increasing
        expected=4 if country=='de' else 1
        assert (idx.to_series().diff().dropna()==pd.Timedelta(minutes=60/expected)).all()
        d=pd.DataFrame({keep[s['name']]:s['data'] for s in x['production_types'] if s['name'] in keep},index=idx)
        assert set(d)==set(keep.values())
        series.append(d.resample('h').mean().where(d.resample('h').count().eq(expected)))
    p=json.loads((energy/f'prices-ch-{window}.json').read_text())
    assert 'CC BY 4.0' in p['license_info'] and 'SMARD.de' in p['license_info']
    series.append(pd.DataFrame({'price_eur_mwh':p['price']},index=pd.to_datetime(p['unix_seconds'],unit='s',utc=True)))
    assert all(series[0].index.equals(s.index) for s in series[1:])
    frames.append(pd.concat(series,axis=1))
d=pd.concat(frames).sort_index();assert d.index.is_unique
d.index=d.index.tz_convert('Europe/Zurich')
counts=d.groupby(d.index.date).count();daily=d.groupby(d.index.date).mean();daily.index.name='date'
daily['hours']=d.groupby(d.index.date).size()
for column in counts:
    daily[column]=daily[column].where(counts[column].eq(daily.hours))
    if column!='river_mw':assert counts[column].eq(daily.hours).all()
daily['river_valid_hours']=counts.river_mw
daily=daily[['hours','reservoir_mw','pumped_generation_mw','river_mw','river_valid_hours','nuclear_mw','load_mw','price_eur_mwh','wind_onshore_de_mw','wind_offshore_de_mw']]
assert len(daily)==3288 and daily.river_mw.isna().sum()==10 and (daily.price_eur_mwh<0).sum()==6
weather_rows=[]
for st in ['sio','gut']:
    w=pd.read_csv(weather/(st+'-daily.csv'),sep=';',usecols=['reference_timestamp','tre200d0','rre150d0'])
    w['date']=pd.to_datetime(w.reference_timestamp,format='%d.%m.%Y %H:%M').dt.date
    w=w[w.date.between(pd.Timestamp('2015-12-25').date(),pd.Timestamp('2024-12-31').date())]
    w=w.rename(columns={'tre200d0':'temperature_c','rre150d0':'rain_mm'})[['date','temperature_c','rain_mm']]
    w.insert(0,'station',st.upper());assert len(w)==3295 and not w.isna().any().any()
    weather_rows.append(w)
w=pd.concat(weather_rows,ignore_index=True)
for name,frame,index in [('electricity-daily.csv.gz',daily,True),('weather-daily.csv.gz',w,False)]:
    (out/name).write_bytes(gzip.compress(frame.to_csv(index=index,lineterminator='\n').encode(),mtime=0))
with (out/'checksums.dcf').open('w') as f:
    for name in ['electricity-daily.csv.gz','weather-daily.csv.gz']:
        f.write(f'File: {name}\nSHA256: {hashlib.sha256((out/name).read_bytes()).hexdigest()}\n\n')
print('Frozen 3288 electricity days and 6590 station-days; no interpolation.')
# Independent native-interval annual benchmarks for the R tests. No daily means.
bench={}
for window in ['2016-20','2021-22','2023','2024']:
    for country,keep in [('ch',{'Hydro water reservoir':'reservoir_mwh'}),('de',{'Wind onshore':'wind_onshore_de_mwh','Wind offshore':'wind_offshore_de_mwh'})]:
        x=json.loads((energy/f'power-{country}-{window}.json').read_text())
        years=pd.to_datetime(x['unix_seconds'],unit='s',utc=True).tz_convert('Europe/Zurich').year
        for series in x['production_types']:
            if series['name'] not in keep:continue
            for year,values in pd.Series(series['data'],index=years).groupby(level=0):
                assert not values.isna().any()
                bench.setdefault(year,{})[keep[series['name']]]=values.sum()/(4 if country=='de' else 1)
pd.DataFrame.from_dict(bench,orient='index').rename_axis('year').to_csv(out/'validation.csv')
with (out/'checksums.dcf').open('w') as f:
    for name in ['electricity-daily.csv.gz','weather-daily.csv.gz','validation.csv']:
        f.write(f'File: {name}\nSHA256: {hashlib.sha256((out/name).read_bytes()).hexdigest()}\n\n')
