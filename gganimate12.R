# Animated map of European Goldfinch records
# Nicholas Anich 3/6/2022

library(ggplot2)
library(gganimate)
library(dplyr)
library(mapdata)
library(lubridate)
library(cowplot)

# load bird data
eugo <- read.csv("Finalfullmasterdatasetv17xorblankas1.csv")

# set date column as date class
eugo$OBSERVATION.DATE <- as_date(eugo$OBSERVATION.DATE)

# make outline for us and canada
usa <- map_data("usa")
canada <- map_data("worldHires", "Canada")

# make map
EUGOMAP <- ggplot() + geom_polygon(data = usa, 
                                  aes(x=long, y = lat, group = group), 
                                  fill = "white", 
                                  color="black") +
  geom_polygon(data = canada, aes(x=long, y = lat, group = group), 
               fill = "white", color="black") +
  geom_point(aes(x = LONGITUDE, y = LATITUDE, color = Year, group = OBSERVATION.DATE),
             data = eugo, 
             alpha = .5,
             stroke = 0,
             shape = 16,
             size = 1) +
  coord_fixed(xlim = c(-96, -81),  ylim = c(38, 49.5), ratio = 1.2) +
  transition_time(OBSERVATION.DATE) +
  shadow_mark(past = T, future=F) +
  theme_cowplot(5) +
  scale_color_gradient(low = "light blue", high = "dark blue") +
  labs(title = "European Goldfinch Records - Date: {frame_time}", x ="Longitude", y = "Latitude")

# animate
anim1 <- animate(EUGOMAP, 
                 fps  =  36, 
                 nframes = 730,
                 height = 3,
                 width = 3,
                 units = "in",
                 res = 250)
# display map
anim1
