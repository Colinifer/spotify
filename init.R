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
    "reactable",
    "initR"
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

source('../initR/spotify/keys.R')
