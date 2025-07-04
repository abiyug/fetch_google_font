# load library
pacman::p_load(showtext, sysfonts,stringr, dplyr)

# function
fetch_google_font <- function(font_family, weights = 400, styles = "normal") {
  # List to store registered font families
  registered_families <- character()
  
  # Ensure styles is a vector
  if (length(styles) == 0) styles <- "normal"
  
  # Loop over each style
  for (s in styles) {
    # Loop over each weight
    for (w in weights) {
      # Construct the Google Fonts v2 URL for the specific weight and style
      variant <- ifelse(s == "italic", paste0("ital,wght@1,", w), paste0("wght@", w))
      api_url <- sprintf("https://fonts.googleapis.com/css2?family=%s:%s&display=swap", 
                         URLencode(font_family), variant)
      
      # Fetch the CSS content
      response <- httr::GET(api_url)
      css_content <- httr::content(response, "text")
      
      # Extract the font file URL using string detection
      font_url <- css_content %>% 
        stringr::str_extract("https://[^)]+.ttf") %>% 
        na.omit() %>% 
        dplyr::first()
      
      # Check if font URL was extracted successfully
      if (is.na(font_url)) {
        warning("Skipping weight ", w, " with style ", s, " for ", font_family, " - unsupported or failed to fetch.")
        next  # Skip to the next weight/style combination
      }
      
      # Download the font file to a temporary location
      temp_file <- tempfile(fileext = ".ttf")
      download.file(font_url, temp_file, mode = "wb", quiet = TRUE)
      
      # Register the font with showtext
      font_family_name <- paste0(font_family, "_w", w, "_", s)
      sysfonts::font_add(family = font_family_name, regular = temp_file)
      
      # Store the registered family name
      registered_families <- c(registered_families, font_family_name)
    }
  }
  
  if (length(registered_families) == 0) stop("No weights or styles were successfully registered for ", font_family)
  
  # Return a list of registered family names
  invisible(registered_families)
}