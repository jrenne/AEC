"""Build a deterministic teaching extract from Zenodo v1, stdlib + pandas.

From AEC root: python3 data-raw/CHelectricity/prepare.py /path/to/dataset.zip
The large original archive is NOT copied into Git or into the R package.
"""
import csv, gzip, hashlib, io, json, sys, zipfile
from pathlib import Path
import pandas as pd

root = Path("data-raw/CHelectricity")
archive = Path(sys.argv[1])
digest = hashlib.md5()
with archive.open("rb") as f:
    for block in iter(lambda: f.read(1024*1024), b""):
        digest.update(block)
assert digest.hexdigest() == "dd40d5e24aee2a3563bc36285b463dbd", "Wrong Zenodo v1 archive"
record = json.loads((root / "zenodo-record.json").read_text())
assert record["metadata"]["license"]["id"] == "cc-by-4.0"
z = zipfile.ZipFile(archive)
metadata_bytes = z.read("metadata.csv")
(root / "metadata.csv").write_bytes(metadata_bytes)
meta = pd.read_csv(io.BytesIO(metadata_bytes), sep=";")
selected = []
for kind, group in meta.groupby("0_installation_type", sort=True):
    ids = [str(int(n)) for n in group["0_meter_id"]]
    ids.sort(key=lambda n: hashlib.sha256(("AEC-electricity-v1:"+n).encode()).hexdigest())
    selected.extend(ids[:30])
selected = sorted(selected, key=int)
(root / "selected-meter-ids.txt").write_text("\n".join(selected)+"\n")
days = pd.date_range("2023-01-01", "2024-12-31", freq="D")
local_edges = pd.date_range("2023-01-01", "2025-01-01", freq="D", tz="Europe/Zurich")
expected = ((local_edges[1:].asi8-local_edges[:-1].asi8) // (15*60*10**9)).astype(int)
pieces = []
for meter in selected:
    d = pd.read_csv(z.open(f"smart_meter_data/{meter}.csv"), sep=";")
    ts = pd.to_datetime(d["timestamp_utc"], utc=True)
    assert not ts.duplicated().any()
    assert (ts.diff().dropna() == pd.Timedelta(minutes=15)).all()
    d["date"] = ts.dt.tz_convert("Europe/Zurich").dt.tz_localize(None).dt.normalize()
    d = d[d.date.between(days[0], days[-1])]
    active = ["kWh_to_installation", "kWh_to_grid"]
    assert not (d[active] < 0).any().any()
    g = d.groupby("date")[active]
    sums = g.sum(min_count=1).reindex(days)
    counts = g.count().reindex(days, fill_value=0)
    a = pd.DataFrame({"meter_id":meter,"date":days.strftime("%Y-%m-%d"),
        "year":days.year,"month":days.month,"weekday":days.dayofweek+1,
        "intervals_expected":expected,"valid_import":counts[active[0]].to_numpy(),
        "valid_export":counts[active[1]].to_numpy(),
        "import_observed_kwh":sums[active[0]].to_numpy(),
        "export_observed_kwh":sums[active[1]].to_numpy()})
    assert (a.valid_import <= a.intervals_expected).all()
    assert (a.valid_export <= a.intervals_expected).all()
    a["import_kwh"] = a.import_observed_kwh.where(a.valid_import == a.intervals_expected)
    a["export_kwh"] = a.export_observed_kwh.where(a.valid_export == a.intervals_expected)
    a["net_kwh"] = a.import_kwh-a.export_kwh
    pieces.append(a)
panel = pd.concat(pieces,ignore_index=True)
# Deterministic gzip header; full precision; no partial-day extrapolation.
with (root / "daily.csv.gz").open("wb") as f:
    with gzip.GzipFile(fileobj=f,mode="wb",filename="",mtime=0) as gz:
        with io.TextIOWrapper(gz,encoding="utf-8",newline="") as text:
            panel.to_csv(text,index=False,na_rep="",lineterminator="\n")
with (root / "checksums.dcf").open("w") as f:
    for field,name in [("Daily-SHA256","daily.csv.gz"),("Metadata-SHA256","metadata.csv"),
                       ("Selection-SHA256","selected-meter-ids.txt")]:
        f.write(f"{field}: {hashlib.sha256((root/name).read_bytes()).hexdigest()}\n")
    f.write("Archive-MD5: "+digest.hexdigest()+"\n")
    if (root / "annual.csv.gz").exists():
        f.write("Annual-SHA256: "+hashlib.sha256((root/"annual.csv.gz").read_bytes()).hexdigest()+"\n")
print(f"Prepared {len(selected)} installations, {len(panel)} daily rows; all {len(meta)} metadata rows retained.")
