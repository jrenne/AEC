source(if (file.exists("tests/helpers/compare-data.R")) "tests/helpers/compare-data.R" else "helpers/compare-data.R")
e <- new.env()
objects <- c("UCIcredit","CHelectricity","CHelectricity_meters","CHelectricity_annual")
local <- all(file.exists(paste0("data/",objects,".rda")))
for (obj in objects) {
  if(local) load(paste0("data/",obj,".rda"),envir=e)
  else utils::data(list=obj,package="AEC",envir=e)
}
u <- e$UCIcredit; d <- e$CHelectricity; m <- e$CHelectricity_meters
stopifnot(nrow(u)==30000,ncol(u)==25,!anyNA(u),!anyDuplicated(u$borrower_id),
          sum(u$default_next_month)==6636, all(u$default_next_month %in% 0:1),
          all(c(0,5,6) %in% u$EDUCATION),all(c(-2,0) %in% u$PAY_0),
          min(u$BILL_AMT1)<0)
stopifnot(nrow(d)==134504,ncol(d)==13,nrow(m)==2447,ncol(m)==23,
          !anyDuplicated(d[c("meter_id","date")]),!anyDuplicated(m$meter_id),
          all(d$meter_id %in% m$meter_id),sum(m$selected_daily)==184,
          all(table(d$meter_id)==731),
          min(d$date)==as.Date("2023-01-01"),max(d$date)==as.Date("2024-12-31"),
          all(d$intervals_expected %in% c(92L,96L,100L)),
          all(d$valid_import<=d$intervals_expected),all(d$valid_export<=d$intervals_expected),
          identical(is.na(d$import_kwh),d$valid_import!=d$intervals_expected),
          identical(is.na(d$export_kwh),d$valid_export!=d$intervals_expected),
          all(is.na(d$import_observed_kwh)==(d$valid_import==0)),
          all(is.na(d$export_observed_kwh)==(d$valid_export==0)),
          isTRUE(all.equal(d$net_kwh,d$import_kwh-d$export_kwh)),
          anyNA(d$import_kwh),all(is.na(m$daily_selection_weight[!m$selected_daily])))
# Known Zurich daylight-saving transitions: local days have 23/25 hours.
stopifnot(all(d$intervals_expected[d$date==as.Date("2023-03-26")]==92),
          all(d$intervals_expected[d$date==as.Date("2023-10-29")]==100),
          all(d$intervals_expected[d$date==as.Date("2024-03-31")]==92),
          all(d$intervals_expected[d$date==as.Date("2024-10-27")]==100))
for (kind in unique(m$installation_type)) {
  z <- m[m$installation_type==kind,]
  stopifnot(sum(z$selected_daily)==min(30,nrow(z)),
    all(z$daily_selection_weight[z$selected_daily]==nrow(z)/sum(z$selected_daily)))
}
if(local) {
  root <- "inst"
  # Data only (all eight new families) stay below 3 MiB, small build inputs below 3 MiB.
  all_new <- c("CHaccidents","CHaccidents_monthly","CHvotes","CHvotes_cantons","USrecession","CHapples","CHapples_frost","CHhydro","FRradars",objects)
  stopifnot(sum(file.info(paste0("data/",all_new,".rda"))$size)<3*1024^2,
            sum(file.info(list.files("inst/data-build",recursive=TRUE,full.names=TRUE))$size)<3*1024^2)
  raw <- read.csv("data-raw/CHelectricity/daily.csv.gz",colClasses=c(meter_id="character"))
  stopifnot(identical(raw$import_kwh,d$import_kwh),identical(raw$valid_import,d$valid_import))
} else root <- system.file(package="AEC")
maps <- read.csv(file.path(root,"teaching-data/column-mappings.csv"))
for(obj in objects) stopifnot(setequal(names(e[[obj]]),maps$variable[maps$dataset==obj]))
# Prove the INSTALLED offline construction script reconstructs exactly the objects.
folder <- tempfile("aec-rebuild-");dir.create(folder)
dir.create(file.path(folder,"data-raw"));dir.create(file.path(folder,"data"))
files <- list.files(file.path(root,"data-build"),full.names=TRUE)
stopifnot(all(file.copy(files,file.path(folder,"data-raw"),recursive=TRUE)))
old <- getwd();setwd(folder)
tryCatch({
  rebuilt <- new.env()
  sys.source("data-raw/CHelectricity/build.R",envir=rebuilt)
  assert_same_teaching_data(d, rebuilt$CHelectricity)
  assert_same_teaching_data(m, rebuilt$CHelectricity_meters)
  assert_same_teaching_data(e$CHelectricity_annual, rebuilt$CHelectricity_annual)
},finally={setwd(old);unlink(folder,recursive=TRUE)})
cat("Credit/electricity: source codes, outcomes, panel keys, missingness, DST, weights, size budgets and installed offline rebuild OK.\n")
