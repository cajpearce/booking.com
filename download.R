################################################
# This file downloads HTML pages from booking.com
# This is done in a separate stage so that way we still save progress in case something goes wrong
################################################

library(tidyverse)
library(xml2)
library(data.table)


# provide the page -------
# TODO turn this into a dynamic page provided on load?
page = "https://www.booking.com/searchresults.en-gb.html?label=gen173nr-1FCAEoggI46AdIM1gEaK4BiAEBmAEJuAEXyAEP2AEB6AEB-AELiAIBqAIDuALlm_TlBcACAQ&sid=4f91c36d570d27e02bd7307739ac0119&tmpl=searchresults&ac_click_type=b&ac_position=0&checkin_month=9&checkin_monthday=17&checkin_year=2019&checkout_month=9&checkout_monthday=19&checkout_year=2019&class_interval=1&dest_id=104&dest_type=country&dtdisc=0&from_sf=1&group_adults=2&group_children=0&inac=0&index_postcard=0&label_click=undef&no_rooms=1&postcard=0&raw_dest_type=country&room1=A%2CA&sb_price_type=total&search_selected=1&shw_aparth=1&slp_r_match=0&src=index&src_elem=sb&srpvid=8a2904f820590031&ss=Italy&ss_all=0&ss_raw=italy&ssb=empty&sshis=0&ssne=Wellington&ssne_untouched=Wellington&rows=15&offset="


# get the location and property count ------------------
z = read_html(page)
heading = z %>% xml_find_first("//div[@data-block-id='heading']//h1") %>% xml_text() %>% trimws()

# get the searched location (e.g. Italy)
Location = gsub("[:].+$","",heading)

# get the number of properties available (to guide offsets)
number.of.hotels = gsub(",","",gsub("^.+[:] ([0-9,]+) .+$","\\1",heading)) %>% as.numeric()
offsets=seq(0,number.of.hotels %/% 15)*15


# create the html path for saving files
html.path = file.path("html", Location)
dir.create(the.path, showWarnings = FALSE)


# start scraping the html files

for(offset in offsets) {
  x = paste(page, offset, sep="")
  rd = possibly(read_html, NA)

  dl2 = NA
  while(TRUE){
    dl = rd(x)
    if(!is.na(dl)) {
      dl2 = dl
      break
    } else {
      Sys.sleep(5)
    }
  }
  
  # save the html file
  html.file.path = file.path(html.path, paste0(offset,".html"))
  dl2 %>% write_html(html.file.path)
  
  # dont return anything
  NULL
}
