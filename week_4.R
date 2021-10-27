library("usethis")
library("gitcreds")

### Process for setting up a new repo and using github

### Step 0
# Make an R project

### Step 1 create a github token 
# create_github_token()


### Step 2
# gitcreds_set()
# copy in the token

### Step 3
# need at least one commit prior to this
# use_github()

### Step 4 
# now you can start push/pull/commit!


# load in dependencies
library("sf")
library("tmap")
library("tmaptools")
library("dplyr")
library("stringr")

### Homework
# Read in the gender ineuqality data
ggi <- read.csv("Gender Inequality Index (GII).csv",stringsAsFactors = F,header = T,skip = 5)

# clean up columns and make numeric
ggi <- ggi %>% select(-contains("X."),-X) %>% mutate(across(starts_with("X"),as.numeric))

# trim up the country names for merging
ggi$Country <- str_trim(ggi$Country,side = "both")

# Read in the shapefile for the world
world_shp <- st_read("World_Countries_(Generalized)/World_Countries__Generalized_.shp") %>% rename(Country=COUNTRY)

# trim up country names for merging
world_shp$Country <- str_trim(world_shp$Country,side = "both")

# join the two files
world_shp <- left_join(world_shp,ggi, by="Country")

# look at geometry
world_shp %>% st_geometry() %>% plot()

# Make a basic Map
world_shp %>% tm_shape() +
  tm_polygons("X2019",palette="Greens", style = "quantile", title="Global Gender \nInequality Quantiles") +
  tm_shape(world_shp) +
  tm_borders("black") +
  tm_scale_bar(position=c("RIGHT", "BOTTOM"),text.size = .7) +
  tm_compass(type="arrow", position=c("RIGHT","TOP"),size = 1) +
  tm_layout(legend.outside = TRUE, legend.title.size = 0.8, 
            legend.text.size = 0.7,
            legend.title.fontface = 2,
            main.title = "World Gender Inequality Index 2019")

  