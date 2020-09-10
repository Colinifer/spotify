# API calls - test code ---------------------------------------------------------------

# if (count(my_plists) == 50) {
#   offset_clock <- offset_clock + max
# }
# while(count(my_plists) < 50)
# 
# 
# offset_clock <- 0
# while (offset_clock < 50) {
#   get_user_playlists(my_id, limit = max_limit, offset = offset_clock)
# }
# 
#   my_plists <- get_user_playlists(my_id, limit = max_limit, offset = offset_clock) %>% count()
#   
#   if (count(my_plists) == 50) {
#     offset_clock <- offset_clock + max
#   }
# 
# 
#  %>% t <- get_user_playlists(my_id, limit = 50)
# 
# if (length(my_plists_offset) < 50) {
#   print("50!")
# } else  (length(my_plists_offset))
# 
# # make more efficient
#  my_plists_offset_0 <- get_user_playlists(my_id, limit = 50)
#  my_plists_offset_1 <-
#    get_user_playlists(my_id, limit = 50, offset = 50)
#  my_plists_offset_2 <-
#    get_user_playlists(my_id, limit = 50, offset = 100)
#  my_plists_offset_3 <-
#    get_user_playlists(my_id, limit = 50, offset = 150)
#  my_plists_offset_4 <-
#    get_user_playlists(my_id, limit = 50, offset = 200)
#  my_plists_offset_4 <-
#    get_user_playlists(my_id, limit = 50, offset = 250)
#  my_plists <-
#   rbind(
#     my_plists_offset_0,
#     my_plists_offset_1,
#     my_plists_offset_2,
#     my_plists_offset_3,
#     my_plists_offset_4
#   )
# 
# rm(my_plists_offset_0)
# rm(my_plists_offset_1)
# rm(my_plists_offset_2)
# rm(my_plists_offset_3)
# rm(my_plists_offset_4)
# 
# my_plists_songs <- my_plists %>%
#   filter(name %in% c("q2-20", "Thumbs Up 2019", "Thumbs Up 2020"))
# 
# # Make this math a function
# # x <- get_playlist(my_plists$id[1])
# # x$track$total
# # x$track$total / 50
# # x$track$total %% 50 + (floor(x$track$total/50) * 50)


# API calls ---------------------------------------------------------------


# Get all playlists -------------------------------------------------------
limit <- 50
all_plists <- get_my_playlists(limit = limit)
offset_clock <- 0
if (count(all_plists) == limit) {
  while (count(all_plists) %% limit == 0) {
    offset_clock <- offset_clock + limit
    all_plists <-
      all_plists %>% rbind(get_my_playlists(limit = limit, offset = offset_clock))
  }
}
data_structure <- str(my_plists)
sapply(my_plists, class)
# Write CSV
all_plists[, !(names(my_plists) %in% "images")] %>% write.csv(file = paste(deparse(substitute(my_plists)), ".csv", sep = ""))

## potentially add dataframe of followed playlists
my_plists <- all_plists %>%
  filter(owner.id == my_id) %>% 
  filter(tracks.total > 0) %>% 
  filter(name != "Thumbs Up 2018 [Local]") %>% 
  filter(name != "Classics")

query_plist <- my_plists %>% 
  filter(name %in% c("Thumbs Up 2020"))


# Get tracks from playlists -----------------------------------------------

# x <- my_plists$id[2]

plist_tracks <- data.frame()
all_plist_id <- my_plists$id
fx.all_playlist_tracks <- function(x) {
  plist_length <- my_plists %>% filter(id == x) %>% select(tracks.total)
  limit <- 100
  clock_length <- as.integer(round(plist_length / limit))
  x_tracks <- data.frame()
  for (i in 0:clock_length) {
    x_tracks <-
      x_tracks %>% rbind(get_playlist_tracks(x, limit = limit, offset = (i * limit)))
  }
  x_tracks <- x_tracks %>% 
    mutate(
      playlist.id = my_plists %>% filter(id == x) %>% select(id),
      playlist.name = my_plists %>% filter(id == x) %>% select(name),
      playlist.href = my_plists %>% filter(id == x) %>% select(href)
    )
  plist_tracks <- plist_tracks %>% rbind(x_tracks)
  # rm(plist_length, limit, clock_length, offset_clock, x_tracks, plist_tracks)
}
plist_tracks <- all_plist_id %>% 
  lapply(fx.all_playlist_tracks)
plist_tracks_merged <- do.call("rbind", plist_tracks)
saveRDS(plist_tracks_merged, "data/library.rds")



# remove list rows
all_tracks <- as.data.frame(tracks[, !(names(tracks) %in% "images")]) %>% write.csv(file = paste(deparse(substitute(my_plists)), ".csv", sep = ""))

plist_tracks <- my_plists %>%
  filter(owner.id == my_id) %>%
  filter(name %in% c("q2-20"))



# Get track features ------------------------------------------------------

features <- get_track_audio_features(head(tracks$track.id, 100))


tracks_audio <- data.frame()
all_plist_id <- my_plists$id
fx.all_tracks_audio_analysis <- function(playlist_id) {
  plist_length <- plist_tracks_merged %>% filter(playlist.id == playlist_id) %>% select(track.id) %>% nrow()
  all_tracks_id <- plist_tracks_merged %>% 
    filter(playlist.id == playlist_id) %>% 
    select(track.id)
  limit <- 100
  clock_length <- as.integer(round(plist_length / limit))
  x_tracks <- data.frame()
  for (i in 0:clock_length) {
    x_tracks <-
      x_tracks %>% rbind(get_track_audio_features(x, limit = limit, offset = (i * limit)))
  }
  tracks_audio <- tracks_audio %>% rbind(x_tracks)
  # rm(plist_length, limit, clock_length, offset_clock, x_tracks, plist_tracks)
}

tracks_audio <- all_tracks_id %>% 
  lapply(fx.all_tracks_audio_analysis)

plist_tracks_merged <- do.call("rbind", plist_tracks)

saveRDS(plist_tracks_merged, "data/library.rds")


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
                                               limit = 50,
                                               offset = 0) %>%
  select(name, genres) %>%
  rowwise %>%
  mutate(genres = paste(genres, collapse = ', ')) %>%
  ungroup
# %>% kable()

my_top_tracks <-
  get_my_top_artists_or_tracks(type = 'tracks',
                               time_range = 'short_term',
                               limit = 50,
                               offset = 0) %>%
  mutate(artist.name = map_chr(artists, function(x)
    x$name[1])) %>%
  select(name, artist.name, album.name)
# %>% kable()