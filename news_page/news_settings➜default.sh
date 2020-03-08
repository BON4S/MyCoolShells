# NEWS PAGE SETTINGS -----------------------------------------------------------

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
news() {
  infos   # <-- 'infos' is a block that shows some useful information
  feed "InfoMoney" "https://www.infomoney.com.br/feed/" "7"
  feed "Google News BR" "https://news.google.com/rss?cf=all&pz=1&hl=pt-BR&gl=BR&ceid=BR:pt-419" "5"
  feed "Trend Topics BR" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=BR" "10"
# ----
  feed "The Wall Street Journal" "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
  feed "Orange County Register" "https://www.ocregister.com/news/feed/"
  feed "CBS8" "https://feeds.feedblitz.com/cbs8/news&x=1"
  feed "Gazeta News" "https://gazetanews.com/feed/?post_type=jm_breaking_news"
# ----
  feed "Times of India" "https://timesofindia.indiatimes.com/rssfeedstopstories.cms"
  feed "TASS" "http://tass.com/rss/v2.xml"
  feed "The Japan Times" "https://www.japantimes.co.jp/feed/topstories"
  feed "Público (Portugal)" "http://feeds.feedburner.com/PublicoRSS"
# ----
  feed "Diolinux" "https://feeds.feedburner.com/Diolinux?format=xml"
  feed "Phoronix" "https://www.phoronix.com/rss.php"
  feed "TecMundo" "https://rss.tecmundo.com.br/feed"
  feed "Arch Linux Brasil" "https://www.archlinux-br.org/feeds/news/"
# ----
  feed "Porto Imagem" "https://portoimagem.wordpress.com/feed/"
  feed "Sociedade Militar" "https://www.sociedademilitar.com.br/wp/feed"
  feed "Suno Notícias" "https://www.sunoresearch.com.br/noticias/feed/"
  feed "Trend Topics US" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=US" "10"
# ----
  feed "Money Times" "https://moneytimes.com.br/feed/"
  feed "Gizmodo BR" "https://gizmodo.uol.com.br/feed/"
  feed "HypeScience" "https://hypescience.com/feed/"
  feed "Folha de SP" "http://feeds.folha.uol.com.br/emcimadahora/rss091.xml"
# ----
  #feed "The New York Times" "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
}

# TWITTER LINKS
# Usage:
# twitter "TWITTER TITLE" "ACCOUNT NAME"
twitters() {
  twitter "President of Brazil - Jair Bolsonaro" "jairbolsonaro"
  twitter "President of United States - Donald Trump" "realDonaldTrump"
  twitter "President of Argentina - Alberto Fernández" "alferdez"
}
