#!/bin/bash
# SCRIPT: news_page.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script extracts news from various websites (+ tweets, weather, currency)
# and with that information it creates a lightweight html document.
#
# USAGE:
# You can run the script without parameters, or you can specify the settigns file
# like in these examples:
# ./news_page.sh
# ./news_page.sh -s news_settings➜Los_Angeles.sh
# and to use this script you don't need to edit this file,
# YOU MUST EDIT THE FILE: news_settings➜default.sh
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
# 2 - You can schedule the script to run every 12 hours by editing cron with the command:
#     export VISUAL=nano; crontab -e
#     And inserting a new line like this:
#     0 */12 * * * /home/your_username/scripts_folder/news_page/news_page.sh
#
# FIXME:
# 1 - A few pages are not loading (commented '#' in the code).

# goes to script folder
cd $(dirname "$0")

# deafault settings file
settings="news_settings➜default.sh"

# checks for settings parameter
while [ -n "$1" ]; do
  case "$1" in
    -s | --settings)
      settings=$2
      shift
      ;;
    *) echo "Option $1 not recognized" ;;
  esac
  shift
done

# get the settings
source $settings

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

# block with useful information
infos() {
  echo "
  <div class='news'>
    <h2 class='news-site'>Useful Information</h2>
    <h3 class='news-titles'>
      <a href=''>News updated at: 
  "
  date +"$update_time_format - $update_date_format"
  echo "
      </a>
    </h3>
    <h3 class='news-titles'>
      <a href='$currency_link'>Currency: 
  "
  currency $currency_conversion
  echo "
      </a>
    </h3>
  "
  custom_command
  echo "
    <h2 class='news-site'>$city_name</h2>
    <h3 class='news-titles'>
      <a href='$city_link'>
  "
  weather-report -q --headers=TEMPERATURE "$weather_report"
  echo "➜ "
  date +"$update_time_format"
  echo "
      </a>
    </h3>
    <h3 class='news-titles'>
      <a href='$city_link'>
  "
  weather-report -q --headers=RELATIVE_HUMIDITY "$weather_report"
  echo "➜ "
  date +"$update_time_format"
  echo "
      </a>
    </h3>
  </div>
  "
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
  value=$(wget -qO- "https://api.exchangeratesapi.io/latest?base=$1" |
  grep -Eo "$2\":[0-9.]*" | grep -Eo "[0-9.]*") > /dev/null
  echo "1 $1 = ${value:0:4} $2"
}

# stylization
css1=`cat $css_default`     # css that is applied to all themes
css2=`cat $css_theme`       # css color theme

# html top code
top_html="
  <!DOCTYPE html>
  <html>
    <head>
      <meta charset='UTF-8'>
      <meta name='viewport' content='width=device-width, initial-scale=1.0'>
      <title>NEWS</title>
      <style>$css1$css2</style>
    </head>
    <body>
      <div id='content'>
"

# html bottom code
bottom_html="
      </div>
    </body>
  </html>
"

# formats the current date
current_date="
  let today = new Date();
  let yyyy = today.getFullYear();
  let m = (today.getMonth()+1).toString();
  let mm = (m.length == 1) ? '0'+m : m;
  let d = today.getDate().toString();
  let dd = (d.length == 1) ? '0'+d : d;
  document.getElementById('dateElement').innerHTML = $current_time_format;
"

# puts the browser in full screen
full_screen="
  function fullScreen() {
    if (!document.fullscreenElement) {
      document.documentElement.requestFullscreen();
  } else {
      if (document.exitFullscreen) {
        document.exitFullscreen(); 
      }
    }
  }
"

# adjusts the brightness of news headlines
news_brightness="
  function newsBrightness() {
    var element = document.querySelectorAll('.news-titles');
    [].forEach.call(element, function(e) {
      e.classList.toggle('brightness');
    });
  }
"

# top line
header="
  <span id='top'></span>
  <div class='top-line flex'>
    <div class='left'>
    </div>
    <div class='right'>
      <span>
        <a style='margin:0;' href='$city_link'><b>
          $city_name &nbsp;
          <span id='dateElement'></span>
          &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
        </b></a>
      </span>
      <span class='control'>
        <a href='#top' onclick='newsBrightness()'>☀</a>
        <a href='#top' onclick='fullScreen()'>⤢</a>
        <a href='#line1'>↓</a>
      </span>
    </div>
  </div> 
  <script>
    $current_date
    $full_screen
    $news_brightness
  </script>
"

# twitter top line functions
twitter_topline_controls="
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
"

# twitter top line
twitter_top_line="
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
      $twitter_topline_controls
    </script>
  </div>
"

# news page generator code
generator() {
  echo "
    $top_html
    $header
  "
  # news section
  news
  # twitter section
  echo "
    $twitter_top_line
    <div id='the-twitter' class='$twitter_hide'>
  "
  twitters
  echo "
    </div>
    $bottom_html
  " 
};

# news page generator launcher
echo -e "\n GENERATING THE NEWS PAGE..\n"
generator > $directory$file

# la grande finale (French)
echo -e "\n DONE!\n"

# USEFUL REFERENCE:
# Shell Naming Conventions
# https://google.github.io/styleguide/shellguide.html#s7-naming-conventions

# FEED LINKS THAT DIDN'T WORK (FIXME)
# feed "The Hindu" "https://www.thehindu.com/feeder/default.rss"
# feed "Aljazera" "https://www.aljazeera.com/xml/rss/all.xml"
# feed "Xinhua" "http://www.xinhuanet.com/english/rss/chinarss.xml"
# feed "Jornal do Comércio" "https://www.jornaldocomercio.com/_conteudo/economia/rss.xml"
# feed "DefesaNet" "http://www.defesanet.com.br/capa/rss/"
# feed "East-West" "https://www.ewdn.com/feed/"
# feed "Financial Times" "https://www.ft.com/news-feed?format=rss"
# feed "El País BR" "https://brasil.elpais.com/rss/brasil/portada.xml"
