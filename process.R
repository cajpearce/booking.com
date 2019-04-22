library(tidyverse)
library(xml2)
library(data.table)


get.price.tag = function(listings) {
  sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div") %>%
           xml_find_first(".//tbody")
         
         ,function(x) {
           retter = NA
           
           if(!is.na(x)) {
             inner.prices = x %>% xml_find_all(".//b") %>% xml_text()
             retter = inner.prices[grepl("NZD",inner.prices)]
             if(length(retter) == 0)
               retter = NA
           }
           
           retter
         })
}

get.prices = function(listings) {
  retter = get.price.tag(listings)
  as.numeric(gsub("[^0-9]+","",retter))
}


get.scores = function(listings) {
  retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    x %>% xml_find_first(".//span[@class='review-score-badge']") %>% xml_text()
  })
  as.numeric(gsub("[^0-9.]+","",retter))
}

get.stars = function(listings) {
  retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    retter = x %>% xml_find_all(".//span[@class='invisible_spoken']") %>% xml_text()
    retter = retter[grepl("star",retter)]
    if(length(retter) == 0) {
      retter = NA
    }
    retter
  })
  as.numeric(gsub("[^0-9]+","",retter))
}

get.name = function(listings) {
  sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    
    retter = x %>% xml_find_all(".//h3//span") %>% xml_text()
    retter = retter[!grepl("(new window|unavailable)",retter,ignore.case = TRUE)]
    if(length(retter) == 0) {
      retter = NA
    }
    paste(retter,collapse="XX")
  })
}

get.review.count = function(listings) {
  retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    x %>% xml_find_first(".//span[@class='review-score-widget__subtext']") %>% xml_text()
  })
  as.numeric(gsub("[^0-9]+","",retter))
}


get.size = function(listings) {
  retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    z = x %>% xml_find_first(".//span[@class='sr-rt-size']") %>% xml_text()
    if(length(z) == 0) {
      z = NA
    }
    z
  })
  as.numeric(gsub("[^0-9]+","",retter))
}

get.location = function(listings) {
  retter = sapply(listings %>% xml_find_all("//div[@id='hotellist_inner']/div"), function(x) {
    
    z = x %>% xml_find_first(".//div[@class='\naddress\n']") %>% xml_text()
    if(length(z) == 0) {
      z = NA
    } else {
      z = paste(z, collapse="XX")
    }
    z
  })
  retter = gsub("Show on.+","",retter,ignore.case = TRUE)
  retter = gsub("\n","",retter)
  retter = substr(retter,2,nchar(retter) - 2)
  ifelse(nchar(retter) == 0, NA, retter)
}

process.details = function(x) {
  # attribs = x %>% xml_find_all("//div[@id='hotellist_inner']/div") %>% xml_attrs()
  
  # retter = rbindlist(lapply(attribs, function(y) {
  #   y %>% as.list() %>% as.data.frame()
  # }),use.names=TRUE,fill=TRUE)
  
  price = get.prices(x)
  score = get.scores(x)
  stars = get.stars(x)
  name = get.name(x)
  review.count = get.review.count(x)
  size = get.size(x)
  location = get.location(x)
  
  data.frame(price,
             score,
             stars,
             name,
             review.count,
             size,
             location)
  
}

# TODO alter this to work with saved html pages
# bookings = rbindlist(lapply(booking,possibly(process.details,
#                                              data.frame(price=NA,
#                                                         score=NA,
#                                                         stars=NA,
#                                                         name=NA,
#                                                         review.count=NA,
#                                                         size=NA,
#                                                         location=NA))),use.names=TRUE,fill=TRUE) %>% unique()
# 
# 
# the.path = file.path("data", Location)
# dir.create(the.path, showWarnings = FALSE)
# the.file.path = file.path(the.path, paste0(Sys.Date(),".csv"))
# 
# bookings %>% fwrite(the.file.path)
