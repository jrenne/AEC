# Run from the AEC root; all compact inputs are included for offline rebuilding.
root <- 'data-raw/FRaccidents_daily'
meta <- jsonlite::fromJSON(file.path(root,'provenance.json'))
for(n in names(meta$compact_sha256)) stopifnot(identical(
 digest::digest(file.path(root,n),algo='sha256',file=TRUE),meta$compact_sha256[[n]]))
a <- read.csv(gzfile(file.path(root,'accidents-daily.csv.gz')))
w <- read.csv(gzfile(file.path(root,'weather-daily.csv.gz')))
stopifnot(!anyDuplicated(a$date),!anyDuplicated(w$date),identical(a$date,w$date))
FRaccidents_daily <- merge(a,w,by='date',sort=TRUE)
FRaccidents_daily$date <- as.Date(FRaccidents_daily$date)
FRaccidents_daily$injury_accidents <- as.integer(FRaccidents_daily$injury_accidents)
FRaccidents_daily$rain_quality <- as.integer(FRaccidents_daily$rain_quality)
FRaccidents_daily$weekday <- as.integer(format(FRaccidents_daily$date,'%u'))
FRaccidents_daily$month <- as.integer(format(FRaccidents_daily$date,'%m'))
FRaccidents_daily$year <- as.integer(format(FRaccidents_daily$date,'%Y'))
stopifnot(nrow(FRaccidents_daily)==3287L,all(diff(FRaccidents_daily$date)==1),
 !anyNA(FRaccidents_daily),all(FRaccidents_daily$rain_mm>=0),
 all(FRaccidents_daily$injury_accidents>=0),
 sum(FRaccidents_daily$injury_accidents)==meta$accidents_retained)
save(FRaccidents_daily,file='data/FRaccidents_daily.rda',compress='xz',version=2)
print(c(days=nrow(FRaccidents_daily),accidents=sum(FRaccidents_daily$injury_accidents),
 size_bytes=file.info('data/FRaccidents_daily.rda')$size))
