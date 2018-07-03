library(tidyverse)
library(s20x)


bookings = read.csv("bookings.csv") %>% 
  rbind(read.csv("bookings2.csv")) %>%
  mutate(
    Villa = grepl("^ *\\nVillas?\\n",name),
    name = gsub("^ *\\nVillas?\\n","",name),
    name = gsub("(\\n|XX)","",name)
  ) %>% unique() %>%
  mutate(
    price = log(price)
    , score = exp(score)
    , review.count = log(review.count)
  ) %>% select(-size) %>%
  na.omit() #%>%
  # filter(location == "Ubud") #c("Seminyak","Legian","Canggu","Kuta", "Nusa Dua","Sanur","Jimbaran", "Ubud"))


booking.lm = lm(price ~ score * stars + review.count  * Villa  +
                score * review.count  +
                score * Villa +
                location
                , data = bookings)

summary(booking.lm)


bookings = bookings %>%
  mutate(predicted = exp(predict(booking.lm)),
         price = exp(price),
         score = log(score),
         review.count = exp(review.count),
         diff =  price - predicted
         ) 

  
best = bookings %>%
  # group_by(Villa) %>%
  filter(
    price <= 900,
    review.count >= quantile(review.count, 0.5,na.rm = TRUE),
    stars == 5,
    score >= 9,
    diff < quantile(diff, 0.5),
    location %in% c("Legian","Canggu","Sanur","Jimbaran","Uluwatu")
  ) %>% 
  arrange(diff)

best


get.url = function(name) {
  name = gsub(" ","+",name)
  paste("https://duckduckgo.com/?q=",name,sep="")
}


lapply(get.url(best$name), browseURL)
