# Packages & Init Setup ---------------------------------------------------
proj_name <- "spotify"
# devtools::install_github('charlie86/spotifyr')
pkgs <-
  c(
    "tidyverse",
    "devtools",
    "fs",
    "ggplot2",
    "ggfortify",
    "gganimate",
    "magick",
    "knitr",
    "lubridate",
    "genius",
    "httpuv",
    "spotifyr",
    "reactable"
  )
installed_packages <- pkgs %in%
  rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(pkgs[!installed_packages])
}
invisible(lapply(pkgs, library, character.only = TRUE))

source("../initR/init.R")
fx.setdir(proj_name)

# Spotify API setup ---------------------------------------------------------

id <- "026c4ec12a1347e385c2c19abf4f52c2"
secret <- "73568369dc3d4c57958979c83a9815ad"
Sys.setenv(SPOTIFY_CLIENT_ID = id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
access_token <- get_spotify_access_token()
my_id <- "crwmusic"