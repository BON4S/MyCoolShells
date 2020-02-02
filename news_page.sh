#!/bin/bash
# SCRIPT: news_page.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script extracts news (and tweets) from various websites and creates a
# lightweight html document.
#
# USAGE:
# You can run the script without parameters, or you can specify the dark theme
# and directory to save the page, just like in these three examples:
# ./news_page.sh
# ./news_page.sh --dark
# ./news_page.sh -d /folder/to/save
#
# DEPENDENCIES:
# To use the Twitter function it is necessary to install the pup (a HTML parser).
# https://github.com/ericchiang/pup
#
# TIP 1: If you use Firefox, install my extension to get feed links easily:
# https://github.com/BON4S/KillAndMore
#
# TIP 2: You can schedule the script to run every 3 hours by editing cron with the command:
# export VISUAL=nano; crontab -e
# And inserting a new line like this:
# 0 */3 * * * /home/user/script_folder/news_page.sh --dark
#
# FIXME: A few pages are not loading (commented '#' in the code).

cd $(dirname "$0")                # goes to script folder

file="news_page.html"
color="light"

while [ -n "$1" ]; do             # checks for parameters
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

ReadFeed(){
  urlNews=$2
  pageContent=$(wget --timeout=5 --tries=2 -O- ${urlNews}) 
  IFS=$'\n'; title=($(xmllint --xpath '//item/title/text()' - <<<"$pageContent"))     # extract the title
  IFS=$'\n'; link=($(xmllint --xpath '//item/link/text()' - <<<"$pageContent"))       # extract the link
  echo -ne "<div class='news'><h2>$1</h2>"
  if [ -z "$3" ]; then
    newsLimit=6                              # limits the amount of news displayed by each site
  else
    newsLimit=$3   # you can specify the amount of news for an individual link (third parameter)
  fi
  for ((i=0; i<$newsLimit; ++i)) do
    echo -ne "<h3><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  echo "</div>"
}

Twitter(){
  urlTwitter="https://twitter.com/$2"
  pageContent=$(wget --timeout=5 --tries=2 -O- ${urlTwitter})
  echo -ne "<div class='tweets'><h2><a href='$urlTwitter'>$1</a></h2>"
  echo -ne "<div class='tweets-box brightness'>"
  echo -e $pageContent | pup 'div.tweet'
  echo -ne"</div></div>"
}

if [ "$color" == "dark" ]; then
  cssColor="
  ::-webkit-scrollbar {
    background-color: #2b2926;
  }
  ::-webkit-scrollbar-thumb {
    background-color: #404040;
  }
  body {
    background-color: #1E1F1E;
  }
  div {
    scrollbar-color: #404040 #2b2926;
  }
  hr, p, h2, h2 a, h3, h3 a, .menu a, tweets-box a {
    color: rgb(202, 187, 159);
    text-shadow: 0 0 2px #000000ba;
  }
  .QuoteTweet-fullname {
    color: #576275;
  }
  .QuoteTweet-text {
    color: rgb(142, 130, 170);
    border: #2e2731 1px solid;
  }
  a.twitter-timeline-link {
    color: rgb(104, 54, 48);
  }
  a.pretty-link {
    color: rgb(155, 155, 155);
  }
  .js-pinned-text {
    color: rgb(164, 137, 86);
  }
  .js-retweet-text {
    color: rgb(91, 85, 68);
  }
  div.tweet {
    border-bottom: #a9a9a93d 1px dashed;
  }
  .u-hiddenVisually {
    color: #606060;
  }
  .fullname {
    color: #9c9d9f;
  }
  .username {
    color: #4a4a4a;
  }
  .time {
    color: chartreuse;
  }
"
else
  cssColor="
  ::-webkit-scrollbar {
    background-color: #eaeaea;
  }
  ::-webkit-scrollbar-thumb {
    background-color: #d5d5d5;
  }
  div {
    scrollbar-color: #d5d5d5 #eaeaea;
  }
  hr, p, h2, h2 a, h3, h3 a, .menu a, tweets-box a  {
    color: #6c6c6c;
  }
  hr {
    color: #ccc;
  }
  .QuoteTweet-text {
    color: #5B5B5B;
    border: #e3e3e3 1px solid;
  }
  .QuoteTweet-fullname {
    color: #c9c9c9;
  }
  a.twitter-timeline-link {
    color: #afafaf;
  }
  a.pretty-link {
    color: #595959;
  }
  .js-pinned-text {
    color: #b3b3b3;
  }
  .js-retweet-text{
    color: #976f6f;
  }
  div.tweet {
    border-bottom: #c8c8c8 1px dashed;
  }
  .u-hiddenVisually {
    color: #97a6b7;
  }
  .fullname {
    color: #444;
  }
  .username {
    color: #bababa;
  }
"
fi
cssDefault="
html, body {
  margin: 0;
  padding: 0;
  border: none;
  width: 100%;
  height: 100%;
  overflow: hidden;
  text-align: center;
}
#content {
  width: 100%;
  height: 100%;
  overflow: auto;
}
h2, .js-pinned-text, .js-retweet-text {
  font-weight: bold;
}
h3 a {
  font-weight: normal;
}
p, h2, h2 a, h3, h3 a, .menu a, .tweets-box p a, a.pretty-link, .js-pinned-text, .js-retweet-text,
tweet-text, .QuoteTweet-text, .fullname, .username, .time, .stream-item-header, stream-item-header a,
.account-group, .u-hiddenVisually, .tweet-timestamp {
  font-family: 'SF Pro Text', 'Graphik', 'Helvetica Neue', 'Roboto', 'Helvetica', 'Arial', sans-serif;
  font-size: 12px;
  line-height: 16px;
  letter-spacing: 0.5px;
  text-decoration: none;
  outline: none;
  text-shadow: 0 0 2px #000000ba;
}
hr, p, h2, h2 a, h3, h3 a {
  margin: 13px 0;
  text-align: left;
}
.tweets-box a {
  cursor: default;
}
.u-hiddenVisually {
  font-size: 11px;
}
.QuoteTweet-text {
  margin: 4px 32px;
  padding: 2px 4px 5px 2px;
}
.menu {
  text-align: right;
}
.menu a {
  margin: 0 20px;
}
hr {
  border: 1px dashed;
}
.news {
  width: 270px;
}
.news {
  display: inline-block;
  margin: 16px;
  vertical-align: top;
}
.tweets {
  display: inline-block;
  margin: 6px 40px;
  vertical-align: top;
}
.tweets, .tweets-box {
  width: 380px;
}
.tweets-box {
  height: 450px;
  padding: 8px;
  overflow: auto;
}
.tweets-box img, div.PlayableMedia-player, div.PlayableMedia-container  {
  max-width: 366px;
  background-size: contain;
}
.tweets h2, .tweets h2 a {
  margin-bottom: 0;
}
div.tweet {
  margin-bottom: 16px;
  padding-bottom: 34px;
}
.twitter-atreply, .twitter-atreply s, .u-textTruncate, .u-textTruncate s,
.twitter-hashtag, .twitter-hashtag s {
  word-spacing: -3px;
  text-decoration: none;
}
img.Emoji {
  max-width: 12px;
}
.AdaptiveMedia-singlePhoto, .AdaptiveMedia-container {
  padding: 0 !important;
  padding-top: 0 !important;
}
.avatar, .js-action-profile-avatar, .ReplyingToContextBelowAuthor, .ProfileTweet-action,
.ProfileTweet-action--more, .js-more-ProfileTweet-actions, .UserBadges, ._timestamp,
.twitter-timeline-link, .u-hiddenVisually, .stream-item-footer, .self-thread-context,
.self-thread-tweet-cta, .media-tags-container, .AdaptiveMedia-badgeText {
  display: none;
}
.hide {
  display: none;
}
.brightness {
  opacity: 0.6;
}
"
topCode="<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>NEWS</title><style>$cssColor$cssDefault</style></head><body><div id='content'>"
bottomCode="</div></body></html>"
HtmlGenerator() {
  echo "$topCode"
  echo "<div id='top' class='menu'><a href='#line1'>Down</a></div>"
# ----
  ReadFeed "InfoMoney" "https://www.infomoney.com.br/feed/"
  ReadFeed "Google News BR" "https://news.google.com/rss?cf=all&pz=1&hl=pt-BR&gl=BR&ceid=BR:pt-419"
  ReadFeed "The Wall Street Journal" "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
  ReadFeed "Trend Topics BR" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=BR" "10"
# ----
  ReadFeed "Money Times" "https://moneytimes.com.br/feed/"
  ReadFeed "Orange County Register" "https://www.ocregister.com/news/feed/"
  ReadFeed "CBS8" "https://feeds.feedblitz.com/cbs8/news&x=1"
  ReadFeed "Gazeta News" "https://gazetanews.com/feed/?post_type=jm_breaking_news"
  # ----
  ReadFeed "Times of India" "https://timesofindia.indiatimes.com/rssfeedstopstories.cms"
  ReadFeed "TASS" "http://tass.com/rss/v2.xml"
  ReadFeed "The Japan Times" "https://www.japantimes.co.jp/feed/topstories"
  ReadFeed "Público (Portugal)" "http://feeds.feedburner.com/PublicoRSS"
# ----
  # 
  # put three more here
  #
  # ReadFeed "Google News US" "https://news.google.com/rss?cf=all&pz=1&hl=en-US&gl=US&ceid=US:en"
# ----
  ReadFeed "Diolinux" "https://www.diolinux.com.br/feeds/posts/default?alt=rss"
  ReadFeed "Phoronix" "https://www.phoronix.com/rss.php"
  ReadFeed "TecMundo" "https://rss.tecmundo.com.br/feed"
  ReadFeed "Arch Linux Brasil" "https://www.archlinux-br.org/feeds/news/"
# ----
  ReadFeed "Porto Imagem" "https://portoimagem.wordpress.com/feed/"
  ReadFeed "Sociedade Militar" "https://www.sociedademilitar.com.br/wp/feed"
  ReadFeed "Suno Notícias" "https://www.sunoresearch.com.br/noticias/feed/"
  ReadFeed "Trend Topics US" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=US" "10"
# ----
  ReadFeed "Gizmodo BR" "https://gizmodo.uol.com.br/feed/"
  ReadFeed "HypeScience" "https://hypescience.com/feed/"
  ReadFeed "Folha de SP" "http://feeds.folha.uol.com.br/emcimadahora/rss091.xml"
  ReadFeed "The New York Times" "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
# ----
  echo "
    <hr id='line1'>
    <div class='menu'>
      <a href='#line1' onclick='twitterBrightness()'>Twitter Brightness</a>
      <a href='#line1' onclick='twitterShowHide()'>Twitter Show/Hide</a>
      <a href='#top'>Up</a>
    </div>
    <div id='the-twitter' class='hide'>
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
  "
# ----
  Twitter "President of Brazil - Jair Bolsonaro" "jairbolsonaro"
  Twitter "President of United States - Donald Trump" "realDonaldTrump"
  Twitter "President of France - Emmanuel Macron" "EmmanuelMacron"
  Twitter "President of Argentina - Alberto Fernández" "alferdez"
# ----
  echo "</div>"
# ----
# -- feed links that didn't work --
#  ReadFeed "The Hindu" "https://www.thehindu.com/feeder/default.rss"
#  ReadFeed "Aljazera" "https://www.aljazeera.com/xml/rss/all.xml"
#  ReadFeed "Xinhua" "http://www.xinhuanet.com/english/rss/chinarss.xml"
#  ReadFeed "Jornal do Comércio" "https://www.jornaldocomercio.com/_conteudo/economia/rss.xml"
#  ReadFeed "DefesaNet" "http://www.defesanet.com.br/capa/rss/"
#  ReadFeed "East-West" "https://www.ewdn.com/feed/"
#  ReadFeed "Baguete" "https://www.baguete.com.br/rss/noticias/feed"
#  ReadFeed "Financial Times" "https://www.ft.com/news-feed?format=rss"
#  ReadFeed "El País BR" "https://brasil.elpais.com/rss/brasil/portada.xml"
  echo "$bottomCode"
}; echo -e "\n GENERATING THE NEWS PAGE..\n" && HtmlGenerator > $file
echo -e "\n DONE!\n"
