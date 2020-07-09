# Reactable playground ----------------------------------------------------

options(reactable.theme = reactableTheme(
  color = "hsl(233, 9%, 87%)",
  backgroundColor = "hsl(233, 9%, 19%)",
  borderColor = "hsl(233, 9%, 22%)",
  stripedColor = "hsl(233, 12%, 22%)",
  highlightColor = "hsl(233, 12%, 24%)",
  inputStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  selectStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonHoverStyle = list(backgroundColor = "hsl(233, 9%, 25%)"),
  pageButtonActiveStyle = list(backgroundColor = "hsl(233, 9%, 28%)")
))

reactable(
  my_plists[1:30, ],
  filterable = TRUE,
  showPageSizeOptions = TRUE,
  striped = TRUE,
  highlight = TRUE,
  details = function(index) paste("Details for row", index)
)

# ggplot playground -------------------------------------------------------

plist_tracks <- my_plists %>%
  filter(owner.id == my_id) %>%
  filter(name %in% c('Thumbs Up 2020'))

limit <- 100
tracks <- get_playlist_tracks(plist_tracks$id, limit = limit)
offset_clock <- 0
# running into list issue
if (count(tracks) == limit) {
  while (count(tracks) %% limit == 0) {
    offset_clock <- offset_clock + limit
    tracks <-
      tracks %>% rbind(get_playlist_tracks(plist_tracks$id, limit = limit, offset = offset_clock))
  }
}

key_country <- tracks2%>%
  select(playlist_name, key)%>%
  group_by(playlist_name, key)%>%
  mutate(n=n())%>%
  unique()%>%
  group_by(key)%>%
  mutate(total=sum(n))%>%
  mutate(percent=round((n/total)*100))

head(key_country, 10)

playist_key <- ggplot(my_plists, aes(x=key, fill=playlist_name, y = n, 
                                text = paste("Number of Songs: ", n, "<br>",
                                             "Percent Songs in Key: ", percent, "%")))+
  geom_bar(width=0.5, stat = "identity")+
  scale_fill_manual(values=c(green, yellow, pink, blue))+
  labs(x="Key", y="Number of Songs") +
  guides(fill=guide_legend(title="Playlist"))+
  theme_minimal()+
  ggtitle("Musical Key Makeup by Playlist")

ggplotly(viz3, tooltip=c("text"))