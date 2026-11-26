e <- new.env()
for(obj in c("CHelectricity_annual","CHelectricity","CHelectricity_meters")) {
 if(file.exists(paste0("data/",obj,".rda"))) load(paste0("data/",obj,".rda"),e)
 else utils::data(list=obj,package="AEC",envir=e)
}
a <- e$CHelectricity_annual;d <- e$CHelectricity;m <- e$CHelectricity_meters
stopifnot(nrow(a)==4046L,ncol(a)==30L,length(unique(a$meter_id))==2023L,
 !anyDuplicated(a[c("meter_id","year")]),all(table(a$meter_id)==2),
 setequal(a$meter_id,m$meter_id[m$installation_type %in% c("Apartment","Single-family house")]),
 all(a$days_in_year==ifelse(a$year==2024L,366L,365L)),
 all(a$winter_import_days<=ifelse(a$year==2024L,91L,90L)),all(a$summer_import_days<=92L))
for(channel in c("import","export")) {
 n<-a[[paste0(channel,"_days")]];v<-a[[paste0(channel,"_mean_kwh_day")]]
 total<-a[[paste0(channel,"_sum_kwh")]]
 stopifnot(all(n>=0 & n<=a$days_in_year),identical(is.na(v),n==0),
 identical(is.na(total),n==0),all(v[!is.na(v)]>=0),
 isTRUE(all.equal(total,n*v,tolerance=1e-12)))
}
# Independently aggregate the overlapping daily subsample to check semantics.
for(i in which(a$meter_id %in% d$meter_id)) {
 z<-d[d$meter_id==a$meter_id[i] & d$year==a$year[i],]
 for(channel in c("import","export")) {
  v<-z[[paste0(channel,"_kwh")]];n<-sum(!is.na(v))
  stopifnot(a[[paste0(channel,"_days")]][i]==n,
   isTRUE(all.equal(a[[paste0(channel,"_mean_kwh_day")]][i],if(n)mean(v,na.rm=TRUE) else NA_real_,tolerance=1e-12)))
 }
 for(season in c("winter","summer")) {
  months<-if(season=="winter")c(1L,2L,12L) else 6:8
  v<-z$import_kwh[z$month %in% months];n<-sum(!is.na(v))
  stopifnot(a[[paste0(season,"_import_days")]][i]==n,
   isTRUE(all.equal(a[[paste0(season,"_import_mean_kwh_day")]][i],if(n)mean(v,na.rm=TRUE) else NA_real_,tolerance=1e-12)))
 }
}
cat("Full-source annual electricity: residential universe, coverage, sums, means, seasonal windows and daily overlap OK.\n")
