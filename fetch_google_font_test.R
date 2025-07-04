# Tested
pacman::p_load(showtext, sysfonts,stringr, dplyr, ggplot2)

# set the weight
weights_to_test <- seq(100, 900, by = 100)

# choose your font (look at it at google font for correct name)
font_g_ni <- "IBM Plex Serif"

# run the function
font_families <- fetch_google_font(font_family = font_g_ni, 
                                   weights = weights_to_test, 
                                   #if no style is selected - default is normal only
                                   style = c("normal", "italic")) 

# load and show the fonts
showtext::showtext_auto()
sysfonts::font_families() 

# test data
dat_2 <-
  font_families() %>% 
  as_tibble() %>% 
  rename("family" = "value") %>% 
  filter(str_detect(family, (font_g_ni))) %>% 
  mutate(face = if_else(grepl("normal$", family), "plain", "italic"),
         x = 1
  ) %>%
  group_by(face) %>%
  mutate(y = 1:n()) %>%
  ungroup()


text_clr <- "#FFFF00"
bkgd_clr <- "#0B0B45" # 


# Viz data
gg_fnt <-
dat_2  %>%ggplot(aes(x , y)) +
     geom_text(aes(label = family, family = family, fontface = face),color = text_clr,  size =20) +
     facet_wrap(vars(face), ncol = 2) +
     labs(title = paste0("Font Family ",font_g_ni,(" (Italic and Plain)")),
          caption = "Source: googlefonts |Graphics: dataRecode | Date: July 4, 2024") +
     theme_void() +
     theme(plot.background = element_rect(fill = bkgd_clr, color = bkgd_clr),
           plot.title = element_text(hjust = 0.5, color = "gray67", size = 74, family = "IBM Plex Serif_w700_normal"),
           plot.caption = element_text(hjust = 0.5, color = "gray77", size = 24, family = "IBM Plex Serif_w400_italic")) +
     theme(legend.position = "none") 

gg_fnt
