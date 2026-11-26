# US recession early-warning dataset: rights evidence

Reviewed and corrected on 20 October 2026. **Copying of the NBER chronology is
permitted with source attribution.** The earlier review missed a specific
permission on the dataset's own page and was consequently too conservative.
The decision below relies on that permission, not on a waiver by the user.

## NBER chronology: explicit copying permission

The official US Business Cycle Expansions and Contractions page states:

> Permission to copy is granted, provided attribution of source is given.

https://www.nber.org/research/data/us-business-cycle-expansions-and-contractions

The same page defines recessions as the month after the peak through the trough
month inclusive. Its downloadable JSON supplies the turning-point dates:
https://data.nber.org/data/cycles/business_cycle_dates.json

Credit the National Bureau of Economic Research, Business Cycle Dating
Committee, and link the chronology page. Preserve the above permission notice.
AEC retains a small chronological extract and derives monthly binary indicators
and a calendar-matched twelve-month-ahead evaluation target. Describe these as
AEC transformations; they are not NBER forecasts. The underlying chronology is
not described as CC BY or public domain, and this copying permission is not
extended to NBER papers, website design or other unrelated materials.

The original chronology HTML was downloaded and the permission checked directly.
Its SHA-256, the JSON hash, retrieval date and source URLs are recorded in
USrecession/provenance.json under the installed data-build directory. The
original full HTML remains a local audit input; it is not redistributed.

## Interest rates: direct Federal Reserve Board public-domain source

AEC extracts the Board's own H.15 monthly Treasury series RIFLGFCM03_N.M and
RIFLGFCY10_N.M from the SDMX release. The Board's disclaimer permits copying
and distribution of its information unless otherwise indicated. The H.15
Treasury-rate inputs are Board/U.S. Treasury information, not privately
licensed third-party indexes. Credit both institutions.

- https://www.federalreserve.gov/disclaimer.htm
- https://www.federalreserve.gov/releases/h15/
- https://www.federalreserve.gov/datadownload/Output.aspx?rel=H15&filetype=zip

Both rates are investment-basis constant-maturity yields, monthly business-day
averages. No different-basis pre-1981 bill series is spliced into the panel.

## Distribution scope

The compact inputs and build scripts are redistributed with AEC so that the
516-row USrecession object can be rebuilt offline. The original full H.15 ZIP
is excluded. The source-specific NBER notice and public-domain rate provenance
are retained in the package help, data-build inputs and installed rights notes.
FRED's USREC series is not copied and no FRED licence is relied on for these
inputs. AEC's software-licence placeholder and unrelated legacy data remain
separate unresolved issues. No third-party permission request was sent.
