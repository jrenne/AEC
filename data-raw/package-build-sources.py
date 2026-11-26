"""Copy only reviewed small construction files into the installed R package."""
from pathlib import Path
import shutil
target = Path("inst/data-build")
for family in ("CHaccidents", "CHvotes", "UCIcredit", "CHelectricity"):
    (target/family).mkdir(parents=True,exist_ok=True)
    shutil.copy2(Path("data-raw")/family/"build.R",target/family/"build.R")
for name in ("prepare.py","zenodo-record.json","metadata.csv","daily.csv.gz",
             "checksums.dcf","selected-meter-ids.txt","prepare-annual.py","annual.csv.gz"):
    shutil.copy2(Path("data-raw/CHelectricity")/name,target/"CHelectricity"/name)
shutil.copy2("data-raw/UCIcredit/uci-record.json",target/"UCIcredit/uci-record.json")
print("Installed build sources prepared; large original archives excluded.")

# Small US inputs and source-specific attribution are installed for offline use.
(target/"USrecession").mkdir(parents=True,exist_ok=True)
for path in Path("data-raw/USrecession").iterdir():
    if path.is_file(): shutil.copy2(path,target/"USrecession"/path.name)

(target/'CHapples').mkdir(parents=True,exist_ok=True)
for path in Path('data-raw/CHapples').iterdir():
    if path.is_file(): shutil.copy2(path,target/'CHapples'/path.name)

(target/'CHhydro').mkdir(parents=True,exist_ok=True)
for path in Path('data-raw/CHhydro').iterdir():
    if path.is_file(): shutil.copy2(path,target/'CHhydro'/path.name)

(target/'FRaccidents_daily').mkdir(parents=True,exist_ok=True)
for path in Path('data-raw/FRaccidents_daily').iterdir():
    if path.is_file(): shutil.copy2(path,target/'FRaccidents_daily'/path.name)
