e <- new.env()
objects <- c("CHapples","CHapples_frost")
local <- all(file.exists(paste0("data/",objects,".rda")))
for(obj in objects) {
  if(local) load(paste0("data/",obj,".rda"),envir=e)
  else utils::data(list=obj,package="AEC",envir=e)
}
a <- e$CHapples; f <- e$CHapples_frost
stopifnot(nrow(a)==44L,ncol(a)==10L,nrow(f)==40L,ncol(f)==9L,
 !anyDuplicated(a[c("date","variety")]),!anyDuplicated(f[c("station","year")]),
 all(f$valid_days==61L),all(f$expected_days==61L),all(f$cold_degree_days>=0),
 sum(is.na(a$price_chf_kg))==1L,
 a$variety[is.na(a$price_chf_kg)]=="Gala",a$date[is.na(a$price_chf_kg)]==as.Date("2023-07-01"))
# Explicit checks catch the source season/crop-year trap and published totals.
stopifnot(all(a$harvest_year[format(a$date,"%m") %in% c("07","08")]==2022L),
 all(a$source_season[format(a$date,"%m") %in% c("07","08")]=="2023/24"))
d <- subset(a,!format(date,"%m") %in% c("07","08"))
stopifnot(nrow(d)==40L,!anyNA(d),all(table(d$variety,d$harvest_year)==10L),
 identical(as.numeric(xtabs(quantity_t~harvest_year+variety,d)),c(18267,18115,5772,5492)),
 all(d$frost_mean_days[d$harvest_year==2022]==3),
 all(d$frost_mean_days[d$harvest_year==2023]==2),
 identical(f$frost_days[f$year==2022],c(3L,3L)),
 identical(f$frost_days[f$year==2023],c(3L,1L)))
root <- if(local) "inst" else system.file(package="AEC")
maps <- read.csv(file.path(root,"teaching-data/column-mappings.csv"))
for(obj in objects) stopifnot(setequal(names(e[[obj]]),maps$variable[maps$dataset==obj]))
# Independently aggregate the packaged daily observations and compare each count.
w <- read.csv(file.path(root,"data-build/CHapples/weather-daily.csv.gz"))
for(i in seq_len(nrow(f))) {
 x <- w[w$station==f$station[i] & substr(w$date,1,4)==f$year[i],]
 stopifnot(nrow(x)==61L,sum(x$tmin_c<0)==f$frost_days[i],
           min(x$tmin_c)==f$minimum_tmin_c[i],sum(abs(pmin(x$tmin_c,0)))==f$cold_degree_days[i])
}
# An added harvest indicator necessarily absorbs the instrument: no extra shocks.
d$month <- factor(format(d$date,"%m"))
base <- model.matrix(~factor(harvest_year)+variety+month,d)
stopifnot(qr(cbind(base,d$frost_mean_days))$rank==qr(base)$rank)
# Installed frozen inputs reconstruct exactly; no network needed.
folder <- tempfile("aec-apples-");dir.create(folder)
dir.create(file.path(folder,"data-raw"));dir.create(file.path(folder,"data"))
stopifnot(file.copy(file.path(root,"data-build/CHapples"),file.path(folder,"data-raw"),recursive=TRUE))
old <- getwd();setwd(folder)
tryCatch({
 rebuilt <- new.env();sys.source("data-raw/CHapples/build.R",envir=rebuilt)
 for(obj in objects) stopifnot(identical(e[[obj]],rebuilt[[obj]]))
},finally={setwd(old);unlink(folder,recursive=TRUE)})
cat("Apples: keys, source totals, season alignment, weather counts, identification and installed offline rebuild OK.\n")
