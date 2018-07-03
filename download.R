# library(tidyverse)
# library(xml2)
# library(data.table)
# # page = "https://www.booking.com/searchresults.en-gb.html?aid=344329&label=metatrivago-hotel-2186957_xqdz-bc521ffee14a131d3097e14a5672769d_los-3_nrm-1_gstadt-2_gstkid-0_curr-nzd_lang-en&sid=29038b0a0564e146605dadc41fcf0d4a&checkin_month=9&checkin_monthday=12&checkin_year=2018&checkout_month=9&checkout_monthday=15&checkout_year=2018&city=-2701757&class_interval=1&dest_id=-2701757&dest_type=city&dtdisc=0&from_sf=1&group_adults=2&group_children=0&inac=0&index_postcard=0&label_click=undef&no_rooms=1&postcard=0&room1=A%2CA&sb_price_type=total&src=searchresults&src_elem=sb&ss=Ubud&ss_all=0&ssb=empty&sshis=0&ssne=Ubud&ssne_untouched=Ubud&user_changed_date=0&rows=40&offset=40"
# page = "https://www.booking.com/searchresults.en-gb.html?label=gen173nr-1DCAEoggJCAlhYSDNYBGiuAYgBAZgBLsIBCndpbmRvd3MgMTDIAQzYAQPoAQGSAgF5qAID&sid=307e2d35f756b84794de4b3d8b0ea65e&checkin_month=9&checkin_monthday=15&checkin_year=2018&checkout_month=9&checkout_monthday=17&checkout_year=2018&class_interval=1&dest_id=835&dest_type=region&dtdisc=0&from_sf=1&genius_rate=1&group_adults=2&group_children=0&inac=0&index_postcard=0&label_click=undef&no_rooms=1&postcard=0&raw_dest_type=region&room1=A%2CA&sb_price_type=total&search_selected=1&src=index&src_elem=sb&ss=Bali%2C%20Indonesia&ss_all=0&ss_raw=bali&ssb=empty&sshis=0&ssne_untouched=Seminyak&rows=15&offset="
# 
# offsets=seq(0,6110 %/% 15)*15
# pages = paste(page, offsets, sep="")
# 
# 
# my_read_html = function(x) {
#   rd = possibly(read_html, NA)
# 
#   dl2 = NA
#   while(TRUE){
#     dl = rd(x)
#     if(!is.na(dl)) {
#       dl2 = dl
#       break
#     } else {
#       Sys.sleep(5)
#     }
#   }
#   dl2
# }
# 
# 
# booking = lapply(pages, my_read_html)
# 
# 
# 
# get.price.tag = function(listings) {
#   sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div") %>%
#            xml_find_first(".//tbody")
# 
#          ,function(x) {
#            retter = NA
# 
#            if(!is.na(x)) {
#              inner.prices = x %>% xml_find_all(".//b") %>% xml_text()
#              retter = inner.prices[grepl("NZD",inner.prices)]
#              if(length(retter) == 0)
#                retter = NA
#            }
# 
#            retter
#          })
# }
# 
# get.prices = function(listings) {
#   retter = get.price.tag(listings)
#   as.numeric(gsub("[^0-9]+","",retter))
# }
# 
# 
# get.scores = function(listings) {
#   retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
#     x %>% xml_find_first(".//span[@class='review-score-badge']") %>% xml_text()
#   })
#   as.numeric(gsub("[^0-9.]+","",retter))
# }
# 
# get.stars = function(listings) {
#   retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
#     retter = x %>% xml_find_all(".//span[@class='invisible_spoken']") %>% xml_text()
#     retter = retter[grepl("star",retter)]
#     if(length(retter) == 0) {
#       retter = NA
#     }
#     retter
#   })
#   as.numeric(gsub("[^0-9]+","",retter))
# }
# 
# get.name = function(listings) {
#   sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
# 
#     retter = x %>% xml_find_all(".//h3//span") %>% xml_text()
#     retter = retter[!grepl("(new window|unavailable)",retter,ignore.case = TRUE)]
#     if(length(retter) == 0) {
#       retter = NA
#     }
#     paste(retter,collapse="XX")
#   })
# }
# 
# get.review.count = function(listings) {
#   retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
#     x %>% xml_find_first(".//span[@class='review-score-widget__subtext']") %>% xml_text()
#   })
#   as.numeric(gsub("[^0-9]+","",retter))
# }
# 
# 
# get.size = function(listings) {
#   retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
#     z = x %>% xml_find_first(".//span[@class='sr-rt-size']") %>% xml_text()
#     if(length(z) == 0) {
#       z = NA
#     }
#     z
#   })
#   as.numeric(gsub("[^0-9]+","",retter))
# }
# 
# get.location = function(listings) {
#   retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
# 
#     z = x %>% xml_find_first(".//div[@class='\naddress\n']") %>% xml_text()
#     if(length(z) == 0) {
#       z = NA
#     } else {
#       z = paste(z, collapse="XX")
#     }
#     z
#   })
#   retter = gsub("Show on.+","",retter,ignore.case = TRUE)
#   retter = gsub("\n","",retter)
#   retter = substr(retter,2,nchar(retter) - 2)
#   ifelse(nchar(retter) == 0, NA, retter)
# }
# 
# process.details = function(x) {
#   # attribs = x %>% xml_find_all("//div[@id='hotellist_inner']/div") %>% xml_attrs()
#   
#   # retter = rbindlist(lapply(attribs, function(y) {
#   #   y %>% as.list() %>% as.data.frame()
#   # }),use.names=TRUE,fill=TRUE)
#   
#   price = get.prices(x)
#   score = get.scores(x)
#   stars = get.stars(x)
#   name = get.name(x)
#   review.count = get.review.count(x)
#   size = get.size(x)
#   location = get.location(x)
#   
#   data.frame(price,
#              score,
#              stars,
#              name,
#              review.count,
#              size,
#              location)
#   
# }
# 
# bookings = rbindlist(lapply(booking,possibly(process.details,
#                                              data.frame(price=NA,
#                                                         score=NA,
#                                                         stars=NA,
#                                                         name=NA,
#                                                         review.count=NA,
#                                                         size=NA,
#                                                         location=NA))),use.names=TRUE,fill=TRUE) %>% unique()
# 
# write.csv(bookings,
#           "bookings2.csv",
#           row.names = FALSE,
#           na = "")


best
