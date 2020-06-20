# Packages & Init Setup ---------------------------------------------------

# devtools::install_github('charlie86/spotifyr')
pkgs <- c("tidyverse", "ggplot2", "ggfortify", "gganimate", "magick", "spotifyr")
installed_packages <- pkgs %in%
  rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(pkgs[!installed_packages])
}
invisible(lapply(pkgs, library, character.only = TRUE))


# Spotify API setup ---------------------------------------------------------


