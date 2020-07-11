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
# 1 - To show Tweets it is necessary to install: jq (a Json parser).
#     https://stedolan.github.io/jq/
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

# goes to script folder
cd $(dirname "$0")

# default settings file
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
  content=$(wget --timeout=7 --tries=2 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'title']/text()" - <<<"$content")) # extract the title
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'link']/text()" - <<<"$content"))   # extract the link
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

# feed-2n is like feed, but it shows two news items in the same block
# and is MANDATORY to pass 6 parameters, as below:
# feed-2n "TITLE 1" "LINK 1" "NUMBER OF NEWS 1" \
#         "TITLE 2" "LINK 2" "NUMBER OF NEWS 2" 
feed-2n() {
  url=$2
  content=$(wget --timeout=20 --tries=1 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'title']/text()" - <<<"$content"))       # extract the title
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'link']/text()" - <<<"$content"))  # extract the link
  echo -ne "<div class='news'><h2 class='news-site'>$1</h2>"
  limit=$3
  for ((i=0; i<$limit; ++i)) do
    echo -ne "<h3 class='news-titles'><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  url=$5
  content=$(wget --timeout=20 --tries=1 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'title']/text()" - <<<"$content"))
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'item']/*[name() = 'link']/text()" - <<<"$content"))
  echo -ne "<hr><h2 class='news-site'>$4</h2>"
  limit=$6
  for ((i=0; i<$limit; ++i)) do
    echo -ne "<h3 class='news-titles'><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  echo "</div>"
}

# this takes news from a website using a different format (like the GitHub atom feed)
feed2() {
  url=$2
  content=$(wget --timeout=20 --tries=1 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'title']/text()" - <<<"$content"))       # extract the title
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'link']/@href" - <<<"$content" | sed -r 's/.*href="([^"]+).*/\1/g'))  # extract the link
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

# feed2-2n is like feed2, but it shows two news items in the same block
# and is MANDATORY to pass 6 parameters, as below:
# feed2-2n "TITLE 1" "LINK 1" "NUMBER OF NEWS 1" \
#          "TITLE 2" "LINK 2" "NUMBER OF NEWS 2" 
feed2-2n() {
  url=$2
  content=$(wget --timeout=20 --tries=1 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'title']/text()" - <<<"$content"))       # extract the title
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'link']/@href" - <<<"$content" | sed -r 's/.*href="([^"]+).*/\1/g'))  # extract the link
  echo -ne "<div class='news'><h2 class='news-site'>$1</h2>"
  limit=$3
  for ((i=0; i<$limit; ++i)) do
    echo -ne "<h3 class='news-titles'><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  url=$5
  content=$(wget --timeout=20 --tries=1 -O- ${url}) 
  IFS=$'\n'; title=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'title']/text()" - <<<"$content"))
  IFS=$'\n'; link=($(xmllint --xpath "//*[name() = 'entry']/*[name() = 'link']/@href" - <<<"$content" | sed -r 's/.*href="([^"]+).*/\1/g'))
  echo -ne "<hr><h2 class='news-site'>$4</h2>"
  limit=$6
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
  custom-command
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

youtube() {
  if [ "$1" == "channel" ]; then
    feed2 "$2" "https://www.youtube.com/feeds/videos.xml?channel_id=$3"
  elif [ "$1" == "queries" ] || [ "$1" == "topics" ]; then
    if [ "$1" == "queries" ]; then
      trends="RELATED_QUERIES"
      name="Queries"
    else
      trends="RELATED_TOPICS"
      name="Topics"
    fi
    if [ -z "$2" ]; then
      height=280
    else
      height=$2
    fi
    echo "
      <style>.youtube-topics iframe {height: ${height}px}</style>
      <div class='news youtube-topics'>
        <h2 class='news-site'>YouTube ${name}</h2>
        <script type='text/javascript' src='https://ssl.gstatic.com/trends_nrtr/2152_RC04/embed_loader.js'></script>
        <script type='text/javascript'>
          trends.embed.renderExploreWidget('${trends}', {'comparisonItem':[{'geo':'','time':'today 12-m'}],'category':0,'property':'youtube'}, {'exploreQuery':'gprop=youtube&date=today 12-m','guestPath':'https://trends.google.com:443/trends/embed/'});
        </script>
      </div>
    "
  else
    echo "
      <div class='news'>
        <h1>ATTENTION!</h1>
        <p>You passed the wrong parameter!</p>
        <p>Parameter passed: $1</p>
        <p>Accepted parameters:
          <br><b>→ channel</b>
          <br><b>→ queries</b>
          <br><b>→ topics</b>
        </p>
      </div>
    "
  fi
}

# get tweets
twitter() {
  if [ -z "$2" ]; then
    limit=6
  else
    limit=$2
  fi

  tweets=$(curl -X GET -H "Authorization: Bearer $twitter_bearer_token" \
    "https://api.twitter.com/1.1/statuses/user_timeline.json?screen_name=$1&count=$limit"  > $directory/tweets.json)
  
  file_tweets_number=$(jq -r '. | length' $directory'tweets.json') 
  
  profile_image_url=$(jq -r .[0].user.profile_image_url_https $directory'tweets.json')
  user=$(jq -r .[0].user.name $directory'tweets.json')
  followers_count=$(jq -r .[0].user.followers_count $directory'tweets.json')

  echo -ne "<div class='tweets'>
    <div class='twitter-profile'>
      <div>
        <a href='https://twitter.com/$1'><img src="$profile_image_url" /></a>
      </div>
      <div>
        <h2><a href='https://twitter.com/$1'>$user</a></h2>
        <h3><a href='https://twitter.com/$1'>@$1</a></h3>
        <h3>$followers_count followers</h3>
      </div>
    </div>
    <div class='tweets-box'>
  "

  for ((i=0; i<$file_tweets_number; ++i)) do
    tweet_text=$(jq -r .[$i].text $directory'tweets.json')
    tweet_id=$(jq -r .[$i].id_str $directory'tweets.json')
    echo -ne "<p><a href='https://twitter.com/BonasRodrigo/status/$tweet_id'>$tweet_text</a></p>"
  done

  echo -ne "
    </div>
  </div>
  "

  rm -rf $directory'tweets.json'
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
        <div id='end'></div>
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
    var element1 = document.querySelectorAll('.news-titles');
    var element2 = document.querySelectorAll('.tweets-box');
    [].forEach.call(element1, function(e) {
      e.classList.toggle('brightness');
    });
    [].forEach.call(element2, function(e) {
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
        <a href='#' onclick='newsBrightness()'>☀</a>
        <a href='#' onclick='fullScreen()'>⤢</a>
        <a href='#end'>↓</a>
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

start-section() {
  echo "
    <hr id='line-$1'>
    <div class='section'>
      <div class='flex'>
        <div class='left'>
        </div>
        <div class='right'>
          <span class='control brightness'>
            <a href='#' onclick='newsBrightness()'>☀</a>
            <a href='#' alt='Full Screen' onclick='fullScreen()'>⤢</a>
            <a href='#top'>↑</a>
          </span>
          <a href='#line-$1' class='link-cool' onclick='section$1ShowHide()'>↙ $1 Show/Hide</a>
        </div>
      </div>
      <div class='section-$1 $2'>
  "
}

end-section() {
  echo "
      </div>
      <script>
        function section$1ShowHide() {
          var element = document.querySelector('.section-$1');
          element.classList.toggle('hide');
        }
      </script>
    </div>
    <p><br></p>
  "
}

# news page generator code
generator() {
  echo "
    $top_html
    $header
  "
  news-page
  echo "
    $bottom_html
  " 
};

# news page generator launcher
echo -e "\n GENERATING THE NEWS PAGE..\n"
generator > $directory$file

# la grande finale (French)
echo -e "\n DONE!\n"
