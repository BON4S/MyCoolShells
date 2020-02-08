#!/bin/bash
# SCRIPT: news_page.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script extracts news from various websites (+ tweets, weather, currency)
# and with that information it creates a lightweight html document.
#
# USAGE:
# You can run the script without parameters, or you can specify the dark theme
# and directory to save the page, just like in these three examples:
# ./news_page.sh
# ./news_page.sh --dark
# ./news_page.sh -d /folder/to/save
#
# DEPENDENCIES:
# 1 - To use the Twitter function it is necessary to install: pup (a HTML parser).
#     https://github.com/ericchiang/pup
#     Arch users (yay): yay -S pup
# 2 - And to the Weather function it is necessery to install: weather
#     http://fungi.yuggoth.org/weather/
#     Arch users (yay): yay -S weather
#
# TIPS:
# 1 - If you use Firefox, install my extension to get feed links easily:
#     https://github.com/BON4S/KillAndMore
#
# 2 - You can schedule the script to run every 3 hours by editing cron with the command:
#     export VISUAL=nano; crontab -e
#     And inserting a new line like this:
#     0 */3 * * * /home/your_username/scripts_folder/news_page/news_page.sh --dark
#
# FIXME:
# 1 - A few pages are not loading (commented '#' in the code).
#

# goes to script folder
cd $(dirname "$0")

# default file name
file="news_page.html"

# checks for parameters
color="light"
while [ -n "$1" ]; do
  case "$1" in
    -d | --dir)
      file="$2/news_page.html"
      shift
      ;;
    --dark) color="dark" ;;
    *) echo "Option $1 not recognized" ;;
  esac
  shift
done

# this takes news from a website
feed() {
  url=$2
  content=$(wget --timeout=5 --tries=2 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath '//item/title/text()' - <<<"$content"))     # extract the title
  IFS=$'\n'; link=($(xmllint --xpath '//item/link/text()' - <<<"$content"))       # extract the link
  echo -ne "<div class='news'><h2 class='news-site'>$1</h2>"
  if [ -z "$3" ]; then
    limit=6             # limits the amount of news displayed by each site
  else
    limit=$3            # you can specify the amount of news for an individual link (third parameter)
  fi
  for ((i=0; i<$limit; ++i)) do
    echo -ne "<h3 class='news-titles'><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  echo "</div>"
}

# get tweets
twitter() {
  url="https://twitter.com/$2"
  content=$(wget --timeout=5 --tries=2 -O- ${url})
  echo -ne "<div class='tweets'><h2><a href='$url'>$1</a></h2>"
  echo -ne "<div class='tweets-box brightness'>"
  echo -e $content | pup 'div.tweet'
  echo -ne"</div></div>"
}

# this takes the value of one currency and converts it to another currency
currency() {
  value=$(wget -qO- "https://api.exchangeratesapi.io/latest?base=$1" | grep -Eo "$2\":[0-9.]*" | grep -Eo "[0-9.]*") > /dev/null
  echo "1 $1 = ${value:0:4} $2"
}

# stylization
css=`cat news_page.css`   # css that is applied to all themes (light and dark)
if [ "$color" == "dark" ]; then
  theme=`cat news_page_dark_theme.css`    # dark css theme
else
  theme=`cat news_page_light_theme.css`   # light css theme
fi

# html top code
top="
<!DOCTYPE html>
<html>
  <head>
    <meta charset='UTF-8'>
    <meta name='viewport' content='width=device-width, initial-scale=1.0'>
    <title>NEWS</title>
    <style>$css$theme</style>
  </head>
  <body>
    <div id='content'>
"

# html bottom code
bottom="
    </div>
  </body>
</html>
"

# start of news page generator code
generator() {
  echo "$top"

  # top line
  echo "
  <span id='top'></span>
  <div id='top-line' class='flex'>  <!-- #top-line start -->
  <!-- ~~~~~~~~~~~~~~~~~~~~~~  Currency  ~~~~~~~~~ -->
    <div>
      <p><b>Currency</b> &nbsp;
  "
  currency USD BRL
  echo "
      </p>
    </div>
  <!-- ~~~~~~~~~~~~~~~~~~~~~~  Weather  ~~~~~~~~~~ -->
    <div>
      <a href='http://tempo.clic.com.br/rs/porto-alegre'><b>Porto Alegre</b> &nbsp;&nbsp;
  "
  weather-report -q --headers=TEMPERATURE "Porto Alegre Aero-Porto, Brazil"
  echo "&nbsp;&nbsp;"     # blank space
  weather-report -q --headers=RELATIVE_HUMIDITY "Porto Alegre Aero-Porto, Brazil"
  echo "
      </a>
    </div>
  <!-- ~~~~~~~~~~~~~~~~~~~~~~  Date  ~~~~~~~~~~~~~ -->
    <div>
      <p>
  "
  date "+%m de %B de %Y (%A)"
  echo "
      </p>
    </div>
  <!-- ~~~~~~~~~~~~~~~~~~~~~~  Screen Control  ~~~ -->
    <div class='right'>
      <span class='control'>
        <a href='#top' onclick='newsBrightness()'>☀</a>
        <a href='#top' onclick='fullScreen()'>⤢</a>
        <a href='#line1'>↓</a>
      </span>
    </div>
  <!-- ~~~~~~~~~~~~~~~~~~~~~~  Top Line End  ~~~~~ -->
  </div>  <!-- #top-line end -->
  "

  # full screen and news brightness
  echo "
  <script>
    function fullScreen() {
      if (!document.fullscreenElement) {
        document.documentElement.requestFullscreen();
    } else {
        if (document.exitFullscreen) {
          document.exitFullscreen(); 
        }
      }
    }
    function newsBrightness() {
      var element = document.querySelectorAll('.news-titles');
      [].forEach.call(element, function(e) {
        e.classList.toggle('brightness');
      });
    }  
  </script>
  "

  # news section
# ----
  feed "InfoMoney" "https://www.infomoney.com.br/feed/"
  feed "Google News BR" "https://news.google.com/rss?cf=all&pz=1&hl=pt-BR&gl=BR&ceid=BR:pt-419"
  feed "The Wall Street Journal" "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
  feed "Trend Topics BR" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=BR" "10"
# ----
  feed "Money Times" "https://moneytimes.com.br/feed/"
  feed "Orange County Register" "https://www.ocregister.com/news/feed/"
  feed "CBS8" "https://feeds.feedblitz.com/cbs8/news&x=1"
  feed "Gazeta News" "https://gazetanews.com/feed/?post_type=jm_breaking_news"
# ----
  feed "Times of India" "https://timesofindia.indiatimes.com/rssfeedstopstories.cms"
  feed "TASS" "http://tass.com/rss/v2.xml"
  feed "The Japan Times" "https://www.japantimes.co.jp/feed/topstories"
  feed "Público (Portugal)" "http://feeds.feedburner.com/PublicoRSS"
# ----
  feed "Diolinux" "https://www.diolinux.com.br/feeds/posts/default?alt=rss"
  feed "Phoronix" "https://www.phoronix.com/rss.php"
  feed "TecMundo" "https://rss.tecmundo.com.br/feed"
  feed "Arch Linux Brasil" "https://www.archlinux-br.org/feeds/news/"
# ----
  feed "Porto Imagem" "https://portoimagem.wordpress.com/feed/"
  feed "Sociedade Militar" "https://www.sociedademilitar.com.br/wp/feed"
  feed "Suno Notícias" "https://www.sunoresearch.com.br/noticias/feed/"
  feed "Trend Topics US" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=US" "10"
# ----
  feed "Gizmodo BR" "https://gizmodo.uol.com.br/feed/"
  feed "HypeScience" "https://hypescience.com/feed/"
  feed "Folha de SP" "http://feeds.folha.uol.com.br/emcimadahora/rss091.xml"
  feed "The New York Times" "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
# ----

  # twitter top line
  echo "
    <hr id='line1'>
    <div id='twitter-line' class='flex'>

      <div class='left'>
      </div>

      <div class='right'>
        <span class='control'>
          <a href='#line1' onclick='twitterBrightness()'>☀</a>
          <a href='#line1' alt='Full Screen' onclick='fullScreen()'>⤢</a>
          <a href='#top'>↑</a>
        </span>
        <a href='#line1' onclick='twitterShowHide()'>Twitter Show/Hide</a>
      </div>

      <script>
        function twitterShowHide() {
          var element = document.querySelector('#the-twitter');
          element.classList.toggle('hide');
        }
        function twitterBrightness() {
          var element = document.querySelectorAll('.tweets-box');
          [].forEach.call(element, function(e) {
            e.classList.toggle('brightness');
          });
        }
      </script>

    </div>
  "

  # get tweets
  echo "<div id='the-twitter' class='hide'>"
  twitter "President of Brazil - Jair Bolsonaro" "jairbolsonaro"
  twitter "President of United States - Donald Trump" "realDonaldTrump"
  twitter "President of Argentina - Alberto Fernández" "alferdez"
  echo "</div>" # id: the-twitter

# FEED LINKS THAT DIDN'T WORK (FIXME)
#  feed "The Hindu" "https://www.thehindu.com/feeder/default.rss"
#  feed "Aljazera" "https://www.aljazeera.com/xml/rss/all.xml"
#  feed "Xinhua" "http://www.xinhuanet.com/english/rss/chinarss.xml"
#  feed "Jornal do Comércio" "https://www.jornaldocomercio.com/_conteudo/economia/rss.xml"
#  feed "DefesaNet" "http://www.defesanet.com.br/capa/rss/"
#  feed "East-West" "https://www.ewdn.com/feed/"
#  feed "Financial Times" "https://www.ft.com/news-feed?format=rss"
#  feed "El País BR" "https://brasil.elpais.com/rss/brasil/portada.xml"

  echo "$bottom"
};  # end of news page generator code

# news page generator launcher
echo -e "\n GENERATING THE NEWS PAGE..\n"
generator > $file

# la grande finale (French)
echo -e "\n DONE!\n"
