# booking.com

When searching for a hotel, I have a few stringent criteria:

1. It must be highly rated for the area
2. It must have enough aggregator reviews to be reliable
3. It must be reasonably priced for the number of stars it has

Using booking.com we can see all this information, but when viewing only 15 hotels per page it can be difficult to accurately capture whether a hotel satisfies these 3 criteria when compared to other hotels. I decided this script was necessary to find the best hotels for the price.

## Methods

In order to use this script, you must first navigate to [booking.com](https://www.booking.com/) and perform a search. For your sake it is probably preferable to select the days you are actually interested in staying, but otherwise choose as wide of an area as you're interested in staying (e.g. "Auckland" instead of "Parnell" if you are happy to stay anywhere in Auckland).

Once you have your search results, navigate to the second page (scroll to the bottom). You then need to copy this URL and remove the last 2 numbers. For example:

1. I searched for Bali from September 14 to September 17 
2. Navigated to the second page
3. removed the last two numbers
4. https://www.booking.com/searchresults.html?label=gen173nr-1FCAEoggJCAlhYSDNYBGiuAYgBAZgBMcIBCndpbmRvd3MgMTDIAQzYAQHoAQH4AQKSAgF5qAID&sid=aeb1b40010e98779c71de406db62ec2b&checkin_month=9&checkin_monthday=14&checkin_year=2018&checkout_month=9&checkout_monthday=17&checkout_year=2018&class_interval=1&dest_id=835&dest_type=region&from_sf=1&group_adults=2&group_children=0&label_click=undef&no_rooms=1&raw_dest_type=region&room1=A%2CA&sb_price_type=total&src=index&src_elem=sb&ss=Bali&ssb=empty&rows=15&offset=

This URL then needs to be copied into the script, and thus webscraping can be done.

## Results

A linear model was used to predict hotel price from the obtained metric. An R^2 of 0.70 was obtained.

The following results from R are the 5 best hotels for my holiday in Bali:

![Bali results](https://raw.githubusercontent.com/cajpearce/booking.com/master/images/Bali.PNG)

## Shortfalls

Two main negatives stick out:
1. Being that this is webscraping off an aggregator and not an API, not all hotels will show up due to various reasons. Sometimes the order may change mid-scrape, sometimes the listing may not fit into the scraping template I have written. You could save the scrape and re-run it again to combine unique values.
2. A hotel is just a hotel. Though ratings are great for finding the best hotel, bare in mind that the best hotels may not have the best score.
