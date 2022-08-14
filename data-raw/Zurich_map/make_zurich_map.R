
library(rgdal)
library(raster)
library(sp)

setwd("~/Dropbox/Teaching/MyRpackages/AEC/data-raw/Zurich_map")

my_spdf_boundaries <- readOGR(
  dsn= "Zurich/" ,
  layer="Zurich_city_boundaries_final",
  verbose=FALSE
)

par(mar=c(0,0,0,0))
par(mfrow=c(1,1))
plot(my_spdf_boundaries,lwd=3,col="light gray",border=NA)

crs(my_spdf_boundaries) # get type of projection
# equivalent to
my_spdf_boundaries@proj4string

# In case not originally in decimal WGS84:
my_spdf_boundaries.WGS84 <- spTransform(my_spdf_boundaries, CRS("+proj=longlat +datum=WGS84"))
plot(my_spdf_boundaries.WGS84,col="light gray",border=NA)

# get coordinates of arrondissement j:
j <- 1
x <- my_spdf_boundaries@polygons[j][[1]]@Polygons[[1]]@coords[,1]
y <- my_spdf_boundaries@polygons[j][[1]]@Polygons[[1]]@coords[,2]
x.WGS84 <- my_spdf_boundaries.WGS84@polygons[j][[1]]@Polygons[[1]]@coords[,1]
y.WGS84 <- my_spdf_boundaries.WGS84@polygons[j][[1]]@Polygons[[1]]@coords[,2]

my_spdf_Districts <- readOGR(
  dsn= "Zurich/City_Districts" ,
  layer="stzh.adm_stadtkreise_a",
  verbose=FALSE
)

zurich_districts <- spTransform(my_spdf_Districts, CRS("+proj=longlat +datum=WGS84"))

lines(zurich_districts,col="white",lwd=3)

#j <- 1
#polygon(zurich_districts@polygons[j][[1]]@Polygons[[1]]@coords,col="yellow")

save(zurich_districts,file="../../data/zurich.rda")

stop()

nb_district <- dim(zurich_districts@data)[1]

# spplot(my_spdf_Districts,
#        zcol="name",col.regions=gray(seq(0.5,1,length.out=nb_district)))

spplot(zurich_districts,
       zcol="name",col.regions=rainbow(nb_district, start=.01,alpha=.4))


