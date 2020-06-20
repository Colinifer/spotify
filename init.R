# Packages & Init Setup ---------------------------------------------------

# devtools::install_github('charlie86/spotifyr')
pkgs <-
  c(
    "tidyverse",
    "ggplot2",
    "ggfortify",
    "gganimate",
    "magick",
    "knitr",
    "lubridate",
    "genius",
    "httpuv",
    "spotifyr"
  )
installed_packages <- pkgs %in%
  rownames(installed.packages())
if (any(installed_packages == FALSE)) {
  install.packages(pkgs[!installed_packages])
}
invisible(lapply(pkgs, library, character.only = TRUE))


# Spotify API setup ---------------------------------------------------------

id <- "026c4ec12a1347e385c2c19abf4f52c2"
secret <- "73568369dc3d4c57958979c83a9815ad"
Sys.setenv(SPOTIFY_CLIENT_ID = id)
Sys.setenv(SPOTIFY_CLIENT_SECRET = secret)
access_token <- get_spotify_access_token()

my_id <- "crwmusic"
my_plists_offset_0 <- get_user_playlists(my_id, limit = 50)
my_plists_offset_1 <- get_user_playlists(my_id, limit = 50, offset = 50)
my_plists_offset_2 <- get_user_playlists(my_id, limit = 50, offset = 100)
my_plists_offset_3 <- get_user_playlists(my_id, limit = 50, offset = 150)
my_plists_offset_4 <- get_user_playlists(my_id, limit = 50, offset = 200)
my_plists <-
  rbind(
    my_plists_offset_0,
    my_plists_offset_1,
    my_plists_offset_2,
    my_plists_offset_3,
    my_plists_offset_4
  )


my_plists_songs <- my_plists %>%
  filter(name %in% c("q2-20"))

tracks <- get_playlist_tracks(my_plists_songs)
features <- get_track_audio_features(tracks)


recently_played <- get_my_recently_played(limit = 20) %>%
  mutate(
    artist.name = map_chr(track.artists, function(x)
      x$name[1]),
    played_at = as_datetime(played_at)
  ) %>%
  select(track.name, artist.name, track.album.name, played_at)
  # %>% kable()

my_top_artists <- get_my_top_artists_or_tracks(type = 'artists',
                             time_range = 'short_term',
                             limit = 50) %>%
  select(name, genres) %>%
  rowwise %>%
  mutate(genres = paste(genres, collapse = ', ')) %>%
  ungroup
  # %>% kable()

my_top_tracks <- get_my_top_artists_or_tracks(type = 'tracks', time_range = 'short_term', limit = 5) %>% 
  mutate(artist.name = map_chr(artists, function(x) x$name[1])) %>% 
  select(name, artist.name, album.name)
  # %>% kable()
