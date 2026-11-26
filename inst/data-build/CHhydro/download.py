import urllib.request,urllib.error,time,gzip,json,os
from pathlib import Path
root=Path(os.environ.get('AEC_ENERGY_INPUTS','/tmp/aec-swiss-electricity'));root.mkdir(parents=True,exist_ok=True)
queries=[('power-ch-2021-22','public_power?country=ch&start=2021-01-01&end=2022-12-31'),('power-de-2021-22','public_power?country=de&start=2021-01-01&end=2022-12-31'),('prices-ch-2021-22','price?bzn=CH&start=2021-01-01&end=2022-12-31'),('power-ch-2023','public_power?country=ch&start=2023-01-01&end=2023-12-31'),('power-de-2023','public_power?country=de&start=2023-01-01&end=2023-12-31'),('prices-ch-2023','price?bzn=CH&start=2023-01-01&end=2023-12-31'),('power-ch-2016-20','public_power?country=ch&start=2016-01-01&end=2020-12-31'),('power-de-2016-20','public_power?country=de&start=2016-01-01&end=2020-12-31'),('prices-ch-2016-20','price?bzn=CH&start=2016-01-01&end=2020-12-31'),('power-ch-2024','public_power?country=ch&start=2024-01-01&end=2024-12-31'),('power-de-2024','public_power?country=de&start=2024-01-01&end=2024-12-31'),('prices-ch-2024','price?bzn=CH&start=2024-01-01&end=2024-12-31')]
for name,query in queries:
 target=root/(name+'.json')
 if target.exists():
  try:
   if 'unix_seconds' in json.loads(target.read_bytes()):continue
  except:pass
 for attempt in range(4):
  try:
   req=urllib.request.Request('https://api.energy-charts.info/'+query,headers={'Accept-Encoding':'gzip','User-Agent':'AEC-teaching-research/1.0'})
   with urllib.request.urlopen(req,timeout=55) as response:
    raw=response.read()
    if response.headers.get('Content-Encoding')=='gzip':raw=gzip.decompress(raw)
   data=json.loads(raw);assert 'unix_seconds' in data
   target.write_bytes(raw);print(name,len(data['unix_seconds']),flush=True);break
  except urllib.error.HTTPError as e:
   if e.code!=429:raise
   wait=max(1,int(e.headers.get('Retry-After','35')));print('API rate limit; respecting Retry-After',wait,flush=True);time.sleep(wait)
  except Exception:
   if attempt==3:raise
   time.sleep(5)
 else:raise RuntimeError('Source unavailable after bounded retries')
