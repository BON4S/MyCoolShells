# NEWS PAGE SETTINGS -----------------------------------------------------------
# This is an example file, feel free to modify.

# SAVE PLACE AND THEME STYLE
directory=""                                                        # directory to save the html file (nothing = current)
file="news_page.html"                                               # name of the file that will be generated
css_default="news_page.css"                                         # css default - responsible for sizes, positions, etc.
css_theme="news_page_dark_theme.css"                                # css theme - responsible for colors
twitter_hide="hide"                                                 # to collapse the Twitter section at the page start, type 'hide', to show, not type

# TIME AND DATE FORMAT
update_time_format="%H:%M"                                          # 24-hour clock = "%H:M"  12-hour clock = "%I:%M %p"
update_date_format="%d/%m/%Y"                                       # can be something like: "%m-%d-%Y" or "%d/%m/%Y"  http://man7.org/linux/man-pages/man1/date.1.html
current_time_format="dd+'/'+mm+'/'+yyyy"                            # can be something like: "mm+'-'+dd+'-'+yyyy" or "dd+'/'+mm+'/'+yyyy"

# LOCATION AND CURRENCY
city_name="Porto Alegre"                                            # your city name
city_link="http://tempo.clic.com.br/rs/porto-alegre"                # useful link to be clicked on the weather and city name
weather_report="Porto Alegre Aero-Porto, Brazil"                    # look for the station name inside the file: /usr/share/weather-util/stations/stations
currency_link="https://www.google.com/search?q=1+dollar+to+real"    # useful link to be clicked on the currencies shown
currency_conversion="USD BRL"                                       # choose two: USD BRL EUR CAD HKD ISK PHP DKK HUF CZK AUD RON SEK IDR INR RUB HRK 
# ->                                                                #             THB CHF SGD PLN BGN TRY CNY NOK NZD ZAR MXN ILS GBP KRW MYR JPY

# RUN A CUSTOMIZED COMMAND INSIDE THE 'INFOS' BLOCK
custom_command() {
  echo "<hr><h2>Disk Space</h2><pre class='news-titles'>"
  df -h -t ext4 --output=source,size,avail,pcent            # <-- this example command shows the disk space (just the ftype: ext4)
  echo "</pre><hr>"
}

# FEED LINKS
# Usage:
# 1 ->  feed "NEWS TITLE" "LINK"
# 2 ->  feed "NEWS TITLE" "LINK" "NUMBER OF NEWS"     # the default news number is 6
# or use feed2 to takes news from a website using a different format (like the GitHub atom feed)
# feed2-2n and feed-2n is like feed2 and feed, but it shows two news items in the same block
# and is MANDATORY to pass 6 parameters, as below:
# feed2-2n "TITLE 1" "LINK 1" "NUMBER OF NEWS 1" \
#          "TITLE 2" "LINK 2" "NUMBER OF NEWS 2" 
news() {
  infos   # <-- 'infos' is a block that shows some useful information
  feed2-2n "VS Code (GitHub)" "https://github.com/microsoft/vscode/commits/master.atom" "4" \
           "MyCoolShells (last commits)" "https://github.com/BON4S/MyCoolShells/commits/master.atom" "4"
  feed "Google News BR" "https://news.google.com/rss?hl=en-US&gl=US&ceid=US:en" "5"
  feed "Trend Topics BR" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=BR" "10"
# ----
  feed "Trend Topics US" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=US" "10"
  feed "The Wall Street Journal" "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
  feed "The New York Times" "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
  feed "Huffpost" "https://www.huffpost.com/section/front-page/feed"
}

# TWITTER LINKS
# Usage:
# twitter "TWITTER TITLE" "ACCOUNT NAME"
twitters() {
  twitter "Space Sushi" "SpaceSushiPic"
  twitter "Lord Voldemort" "Lord_Voldemort7"
}
