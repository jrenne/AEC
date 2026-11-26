e <- new.env();local <- file.exists('data/CHhydro.rda')
if(local) load('data/CHhydro.rda',envir=e) else utils::data('CHhydro',package='AEC',envir=e)
d <- e$CHhydro
stopifnot(nrow(d)==3288L,ncol(d)==18L,!anyDuplicated(d$date),
 all(d$date==seq(as.Date('2016-01-01'),as.Date('2024-12-31'),by='day')),
 sum(d$price_eur_mwh<0)==6L,sum(is.na(d$river_mw))==10L,
 all(is.na(d$river_mw)==(d$river_valid_hours<d$hours)),
 !anyNA(d[names(d)!='river_mw']),all(d$reservoir_mw>0),all(d$pumped_generation_mw>=0),
 isTRUE(all.equal(d$wind_de_mw,d$wind_onshore_de_mw+d$wind_offshore_de_mw)),
 d$hours[d$date==as.Date('2023-03-26')]==23L,
 d$hours[d$date==as.Date('2023-10-29')]==25L,
 sum(d$hours==23L)==9L,sum(d$hours==25L)==9L,sum(d$hours)==78912L)
root <- if(local) 'inst' else system.file(package='AEC')
folder <- file.path(root,'data-build/CHhydro')
# Annual energy benchmarks come independently from native hourly/quarterly responses.
b <- read.csv(file.path(folder,'validation.csv'))
for(i in seq_len(nrow(b))) {
 x <- d[format(d$date,'%Y')==b$year[i],]
 stopifnot(abs(sum(x$reservoir_mw*x$hours)-b$reservoir_mwh[i])<1e-5,
 abs(sum(x$wind_onshore_de_mw*x$hours)-b$wind_onshore_de_mwh[i])<1e-5,
 abs(sum(x$wind_offshore_de_mw*x$hours)-b$wind_offshore_de_mwh[i])<1e-5)
}
w <- read.csv(file.path(folder,'weather-daily.csv.gz'))
# The first lagged rain sum needs seven days preceding the stored electricity panel.
for(station in c('SIO','GUT')) {
 x <- w[w$station==station & w$date>='2015-12-25' & w$date<='2015-12-31',]
 stopifnot(nrow(x)==7L,abs(sum(x$rain_mm)-d[[paste0('rain_previous7_',tolower(station),'_mm')]][1])<1e-12)
}
maps <- read.csv(file.path(root,'teaching-data/column-mappings.csv'))
stopifnot(setequal(names(d),maps$variable[maps$dataset=='CHhydro']))
# Installed inputs reconstruct the object exactly without network or optional libraries.
target <- tempfile('aec-hydro-');dir.create(target)
dir.create(file.path(target,'data-raw'));dir.create(file.path(target,'data'))
stopifnot(file.copy(folder,file.path(target,'data-raw'),recursive=TRUE))
old <- getwd();setwd(target)
tryCatch({rebuilt<-new.env();sys.source('data-raw/CHhydro/build.R',envir=rebuilt)
 stopifnot(identical(d,rebuilt$CHhydro))},finally={setwd(old);unlink(target,recursive=TRUE)})
cat('Hydro: calendar, DST, source energy totals, negative prices, coverage, weather joins and installed offline rebuild OK.\n')
