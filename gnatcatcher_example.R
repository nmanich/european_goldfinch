# Animated map of Black-capped Gnatcatcher records
# Nicholas Anich 10/12/23

# This example automates the process of extracting the month and year from the eBird data

library(ggplot2)
library(gganimate)
library(dplyr)
library(mapdata)
library(lubridate)
library(cowplot)

# load bird data
gnat <- read.delim("ebd_US-AZ_bkcgna_197001_202312_relAug-2023.txt", sep="\t", header=TRUE, quote = "", stringsAsFactors = FALSE, na.strings=c(""))
# set date column as date class
gnat$OBSERVATION.DATE <- as_date(gnat$OBSERVATION.DATE)
# alternate way to format dates if excel messes them up
# gnat$OBSERVATION.DATE <- as.Date(gnat$OBSERVATION.DATE, origin = "1899-12-30")

# Extract the month
lubridate::month(gnat$OBSERVATION.DATE)

# Extract the year
lubridate::year(gnat$OBSERVATION.DATE)

# Now add a column for each
gnat<- gnat %>% 
  mutate(year=lubridate::year(gnat$OBSERVATION.DATE),
         month=lubridate::month(gnat$OBSERVATION.DATE))

# make outline for us and canada
usa <- map_data("usa")
mexico <- map_data("worldHires", "Mexico")

# make map
GNATMAP <- ggplot() + geom_polygon(data = usa, 
                                   aes(x=long, y = lat, group = group), 
                                   fill = "white", 
                                   color="black") +
  geom_polygon(data = mexico, aes(x=long, y = lat, group = group), 
               fill = "white", color="black") +
  geom_point(aes(x = LONGITUDE, y = LATITUDE, color = year, group = OBSERVATION.DATE),
             data = gnat, 
             alpha = .5,
             stroke = 0,
             shape = 16,
             size = 1) +
  coord_fixed(xlim = c(-114, -109),  ylim = c(31, 34), ratio = 1.2) +
  transition_time(OBSERVATION.DATE) +
  shadow_mark(past = T, future=F) +
  theme_cowplot(5) +
  scale_color_gradient(low = "light blue", high = "dark blue") +
  labs(title = "Black-capped Gnatcatcher Records - Date: {frame_time}", x ="Longitude", y = "Latitude")

# animate
anim2 <- animate(GNATMAP, 
                 fps  =  36, 
                 nframes = 730,
                 height = 3,
                 width = 3,
                 units = "in",
                 res = 250)
# display map
anim2
