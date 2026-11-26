# Run at AEC root after prepare.py, or rebuild from the committed compact inputs.
p <- "data-raw/CHelectricity/"
hashes <- read.dcf(paste0(p,"checksums.dcf"))
for (nm in c("daily.csv.gz","metadata.csv","selected-meter-ids.txt")) {
  field <- c("daily.csv.gz"="Daily-SHA256","metadata.csv"="Metadata-SHA256",
             "selected-meter-ids.txt"="Selection-SHA256")[[nm]]
  actual <- strsplit(system2("shasum",c("-a","256",shQuote(paste0(p,nm))),stdout=TRUE)," +")[[1]][1]
  stopifnot(identical(actual,unname(hashes[1,field])))
}
CHelectricity <- read.csv(paste0(p,"daily.csv.gz"), colClasses=c(meter_id="character"),
                         na.strings="",check.names=FALSE)
CHelectricity$date <- as.Date(CHelectricity$date)
x <- read.csv(paste0(p,"metadata.csv"),sep=";",check.names=FALSE,
              colClasses="character",na.strings="")
mapping <- c(meter_id="0_meter_id",installation_type="0_installation_type",
  object_type="0_object_type",housing_units="0_num_housing_units",
  source_complete_intervals="0_num_data_points",max_net_injection_kw="0_max_net_injection",
  has_electric_water_heater="1_ewh",has_heat_pump="1_hp",has_heat_pump_backup="1_hp-add",
  has_hotwater_heat_pump="1_hp-wh",has_ev_charging="1_ev",has_storage_heating="1_storage_heating",
  has_direct_heating="1_direct_heating",equipment_changed="1_change",
  energy_tariff="2_energy_tariff",grid_tariff="2_grid_tariff",
  tariff_from="2_tariff_from",tariff_to="2_tariff_to",
  pilot_waterheater_control="2_wh_control",pilot_heatpump_control="2_hp_control",
  pilot_ev_control="2_ev_control")
CHelectricity_meters <- x[unname(mapping)]
names(CHelectricity_meters) <- names(mapping)
for (nm in c("housing_units","source_complete_intervals","max_net_injection_kw")) {
  CHelectricity_meters[[nm]] <- as.numeric(CHelectricity_meters[[nm]])
}
for (nm in c(grep("^has_",names(mapping),value=TRUE),"equipment_changed",
             "pilot_waterheater_control","pilot_heatpump_control","pilot_ev_control")) {
  z <- CHelectricity_meters[[nm]]
  stopifnot(all(is.na(z) | z %in% c("True","False")))
  CHelectricity_meters[[nm]] <- ifelse(is.na(z),NA,z=="True")
}
for (nm in c("tariff_from","tariff_to")) CHelectricity_meters[[nm]] <- as.Date(CHelectricity_meters[[nm]])
selected <- readLines(paste0(p,"selected-meter-ids.txt"))
CHelectricity_meters$selected_daily <- CHelectricity_meters$meter_id %in% selected
groups <- CHelectricity_meters$installation_type
N <- table(groups); n <- table(groups[CHelectricity_meters$selected_daily])
CHelectricity_meters$daily_selection_weight <- ifelse(CHelectricity_meters$selected_daily,
   as.numeric(N[groups])/as.numeric(n[groups]),NA_real_)
for (nm in names(CHelectricity_meters)) if(is.character(CHelectricity_meters[[nm]]))
  CHelectricity_meters[[nm]] <- enc2utf8(CHelectricity_meters[[nm]])
stopifnot(!anyDuplicated(CHelectricity[c("meter_id","date")]),
          nrow(CHelectricity_meters)==2447L,
          all(CHelectricity$meter_id %in% CHelectricity_meters$meter_id))
save(CHelectricity,file="data/CHelectricity.rda",version=2,compress="xz")
save(CHelectricity_meters,file="data/CHelectricity_meters.rda",version=2,compress="xz")
write.csv(data.frame(dataset="CHelectricity_meters",variable=names(mapping),
  source_or_transformation=unname(mapping)),paste0(p,"column-mappings.csv"),row.names=FALSE)

# All residential meters: annual summaries, independent of the daily subsample.
actual <- strsplit(system2("shasum",c("-a","256",shQuote(paste0(p,"annual.csv.gz"))),stdout=TRUE)," +")[[1]][1]
stopifnot(identical(actual,unname(hashes[1,"Annual-SHA256"])))
a <- read.csv(paste0(p,"annual.csv.gz"),colClasses=c(meter_id="character"),na.strings="")
meta_fields <- setdiff(names(CHelectricity_meters),c("housing_units",
 "source_complete_intervals","max_net_injection_kw","selected_daily","daily_selection_weight"))
CHelectricity_annual <- merge(a,CHelectricity_meters[meta_fields],by="meter_id",sort=FALSE)
CHelectricity_annual <- CHelectricity_annual[order(as.integer(CHelectricity_annual$meter_id),
 CHelectricity_annual$year),]
rownames(CHelectricity_annual) <- NULL
stopifnot(nrow(CHelectricity_annual)==4046L,
 !anyDuplicated(CHelectricity_annual[c("meter_id","year")]),
 all(CHelectricity_annual$installation_type %in% c("Apartment","Single-family house")))
save(CHelectricity_annual,file="data/CHelectricity_annual.rda",version=2,compress="xz")
