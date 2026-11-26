# Works both from the repository root and in R CMD check's installed context.
e <- new.env()
objects <- c("CHaccidents","CHaccidents_monthly","CHvotes","CHvotes_cantons")
local <- all(file.exists(paste0("data/", objects, ".rda")))
for (obj in objects) {
  if (local) load(paste0("data/",obj,".rda"), envir=e)
  else utils::data(list=obj, package="AEC", envir=e)
}
a <- e$CHaccidents; m <- e$CHaccidents_monthly
v <- e$CHvotes; c <- e$CHvotes_cantons
stopifnot(nrow(a)==70767L, ncol(a)==24L, nrow(m)==180L,
          nrow(v)==710L, ncol(v)==14L, nrow(c)==17482L,
          !anyDuplicated(a$accident_id), !anyDuplicated(v$vote_id),
          !anyDuplicated(c[c("vote_id","canton")]),
          all(a$municipality_code=="0261"), all(a$canton=="ZH"),
          identical(range(a$year),c(2011L,2025L)),
          all(a$fatal <= a$severe & a$severe <= a$injury),
          all(a$injury==(a$severity_code!="as4")),
          sum(a$fatal)==100L, sum(a$severe)==2997L,
          sum(a$injury)==18164L,
          identical(m$date,seq(as.Date("2011-01-01"),as.Date("2025-12-01"),by="month")),
          sum(m$accidents)==nrow(a), sum(m$injury_accidents)==sum(a$injury),
          sum(m$severe_accidents)==sum(a$severe), sum(m$fatal_accidents)==sum(a$fatal))
# Independently re-tabulate each severity category, not just the grand totals.
for (i in seq_len(nrow(m))) {
  z <- a[a$year==m$year[i] & a$month==m$month[i], ]
  stopifnot(m$accidents[i]==nrow(z),
            m$injury_accidents[i]==sum(z$severity_code %in% c("as1","as2","as3")),
            m$severe_accidents[i]==sum(z$severity_code %in% c("as1","as2")),
            m$fatal_accidents[i]==sum(z$severity_code=="as1"))
}
stopifnot(inherits(v$date,"Date"), !anyNA(v$procedure),
          max(v$date)==as.Date("2026-09-27"), min(v$date)==as.Date("1848-09-12"),
          all(v$date<=as.Date("2026-10-20")), all(c$vote_id %in% v$vote_id),
          all(c$date==v$date[match(c$vote_id,v$vote_id)]),
          max(c$date)==as.Date("2024-03-03"),
          all(is.na(v$turnout_pct) | v$turnout_pct>=0 & v$turnout_pct<=100),
          all(is.na(c$turnout_pct) | c$turnout_pct>=0 & c$turnout_pct<=100),
          !any(rowSums(!is.na(c[,4:7]))==0),
          anyNA(v$title_en), anyNA(v$eligible_voters))
stopifnot(all(vapply(split(v$objects_on_day,v$date),function(z)length(unique(z))==1,logical(1))))
# Compare to independently parsed originals when testing the repository.
if (local) {
  raw <- read.csv("data-raw/CHaccidents/RoadTrafficAccidentLocations.csv",colClasses="character")
  idx <- match(a$accident_id,raw$AccidentUID)
  stopifnot(!anyNA(idx), identical(a$severity_code,raw$AccidentSeverityCategory[idx]),
            identical(a$easting_lv95,as.numeric(raw$AccidentLocation_CHLV95_E[idx])))
  rawv <- read.csv("data-raw/CHvotes/swissvotes_dataset.csv",sep=";",colClasses="character",
                   check.names=FALSE,na.strings=c("","."),fileEncoding="UTF-8-BOM")
  idx <- match(v$vote_id,rawv$anr)
  stopifnot(!anyNA(idx), identical(v$turnout_pct,as.numeric(rawv$bet[idx])),
            sum(as.Date(rawv$datum,"%d.%m.%Y")>as.Date("2026-10-20"))==4L)
  for (ct in unique(c$canton)) {
    z <- c[c$canton==ct,]; idx <- match(z$vote_id,rawv$anr)
    stopifnot(identical(z$ballots_cast,as.numeric(rawv[[paste0(tolower(ct),"-stimmen")]][idx])))
  }
}
metadata <- if (local) "inst/teaching-data" else system.file("teaching-data",package="AEC")
mapping <- read.csv(file.path(metadata,"column-mappings.csv"))
for (obj in objects) stopifnot(setequal(mapping$variable[mapping$dataset==obj],names(e[[obj]])))
# Smoke-test neutral teaching uses with actual missing values retained.
stopifnot(nrow(aggregate(turnout_pct ~ procedure,subset(v,year>=2000),mean))>=3,
          length(coef(lm(injury_accidents ~ factor(month)+year,data=m)))==13L)
cat("Teaching data: source alignment, keys, coverage, monthly counts, missing values, metadata and examples OK.\n")
