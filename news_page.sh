#!/bin/bash
# SCRIPT: news_page.sh
# AUTHOR: BON4S https://github.com/BON4S
#
# DESCRIPTION:
# This script extracts news from various websites and creates a
# lightweight html document.
#
# USAGE:
# You can run the script without parameters, or you can specify the dark theme
# and directory to save the page, just like in these three examples:
# ./news_page.sh
# ./news_page.sh --dark
# ./news_page.sh -d /folder/to/save
#
# TIP 1: Save this javascript line below as a link in your browser's bookmarks bar:
# javascript:void(d=document); void(el=d.getElementsByTagName('link')); for(i=0;i<el.length;i++){ if( el[i].getAttribute('rel').indexOf('alternate')!=-1 && (el[i].getAttribute('type').indexOf('application/rss+xml')!=-1 || el[i].getAttribute('type').indexOf('text/xml')!=-1)){ void(prompt('RSS:', el[i].getAttribute('href')))}}
# Clicking on this javascript will open a dialog box with the rss url of the site.
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
  urlnews=$2
  wget --timeout=5 --tries=2 -O content.xml ${urlnews}  # save the whole page into an xml file
  IFS=$'\n'; title=($(xmllint --xpath '//item/title/text()' content.xml)) # extract the title
  IFS=$'\n'; link=($(xmllint --xpath '//item/link/text()' content.xml))   # extract the link
  echo -ne "<div class='news'><h2>$1</h2>"
  news_limit=5    # limits the amount of news displayed by each site
  for ((i=0; i<$news_limit; ++i)) do
    echo -ne "<h3><a href='${link[i]}'>${title[i]}</a></h3>"
  done
  echo "</div>"
}
if [ "$color" == "dark" ]; then
  css_color="
  ::-webkit-scrollbar {
    background-color: #323234;
  }
  ::-webkit-scrollbar-thumb {
    background-color: #555;
  }
  body {
    background-color: #1E1F1E;
  }
  div {
    scrollbar-color: #555 #323234;
  }
  h2, h3, h3 a {
    color: #D2C9B8;
  }
"
else
  css_color="
  h2, h3, h3 a {
    color: #606060;
  }
"
fi
css_default="
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
h2 {
  font-weight: bold;
}
h3 a {
  font-weight: normal;
}
h2, h3, h3 a {
  font-family: 'SF Pro Text', 'Graphik', 'Helvetica Neue', 'Roboto', 'Helvetica', 'Arial', sans-serif;
  font-size: 13px;
  line-height: 15px;
  margin: 12px 0;
  text-align: left;
  text-decoration: none;
}
.news {
  display: inline-block;
  margin: 16px;
  vertical-align: top;
  width: 270px;
}
"
top_code="<!DOCTYPE html><html><head><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'><title>NEWS</title><style>$css_color$css_default</style></head><body><div id='content'>"
bottom_code="</div></body></html>"
HtmlGenerator() {
  echo "$top_code"
# ----
  ReadFeed "InfoMoney" "https://www.infomoney.com.br/feed/"
  ReadFeed "Google News BR" "https://news.google.com/rss?cf=all&pz=1&hl=pt-BR&gl=BR&ceid=BR:pt-419"
  ReadFeed "The Wall Street Journal" "https://feeds.a.dj.com/rss/RSSWorldNews.xml"
  ReadFeed "Trend Topics BR" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=BR"
# ----
  ReadFeed "Gizmodo BR" "https://gizmodo.uol.com.br/feed/"
  ReadFeed "Orange County Register" "https://www.ocregister.com/news/feed/"
  ReadFeed "CBS8" "https://feeds.feedblitz.com/cbs8/news&x=1"
  ReadFeed "Folha de SP" "http://feeds.folha.uol.com.br/emcimadahora/rss091.xml"
# ----
  ReadFeed "Público (Portugal)" "http://feeds.feedburner.com/PublicoRSS"
  ReadFeed "Gazeta News" "https://gazetanews.com/feed/?post_type=jm_breaking_news"
  ReadFeed "Suno Notícias" "https://www.sunoresearch.com.br/noticias/feed/"
  ReadFeed "Money Times" "https://moneytimes.com.br/feed/"
# ----
  ReadFeed "Google News US" "https://news.google.com/rss?cf=all&pz=1&hl=en-US&gl=US&ceid=US:en"
  ReadFeed "Google News, Topic: China" "https://news.google.com/rss/search?cf=all&pz=1&q=china&oq=china&hl=pt-BR&gl=BR&ceid=BR:pt-419"
  ReadFeed "The Japan Times" "https://www.japantimes.co.jp/news_category/national/feed/"
  ReadFeed "Mundo-Nipo" "http://feeds.feedburner.com/Mundo-Nipo?format=xml"
# ----
  ReadFeed "Porto Imagem" "https://portoimagem.wordpress.com/feed/"
  ReadFeed "Diolinux" "https://www.diolinux.com.br/feeds/posts/default?alt=rss"
  ReadFeed "TecMundo" "https://rss.tecmundo.com.br/feed"
  ReadFeed "HypeScience" "https://hypescience.com/feed/"
# ----
  ReadFeed "Sociedade Militar" "https://www.sociedademilitar.com.br/wp/feed"
  ReadFeed "The New York Times" "https://rss.nytimes.com/services/xml/rss/nyt/HomePage.xml"
  ReadFeed "Arch Linux Brasil" "https://www.archlinux-br.org/feeds/news/"
  ReadFeed "Trend Topics US" "https://trends.google.com/trends/trendingsearches/daily/rss?geo=US"
# ----
#  ReadFeed "Jornal do Comércio" "https://www.jornaldocomercio.com/_conteudo/economia/rss.xml"
#  ReadFeed "DefesaNet" "http://www.defesanet.com.br/capa/rss/"
#  ReadFeed "East-West" "https://www.ewdn.com/feed/"
#  ReadFeed "Baguete" "https://www.baguete.com.br/rss/noticias/feed"
#  ReadFeed "Financial Times" "https://www.ft.com/news-feed?format=rss"
#  ReadFeed "El País BR" "https://brasil.elpais.com/rss/brasil/portada.xml"
  echo "$bottom_code"
}; echo -e "\n GENERATING THE NEWS PAGE..\n" && HtmlGenerator > $file
rm content.xml        # delete xml file created during website download process
echo -e "\nDONE!\n"


# The feeds below work. I will add them when I form a group of four (one line on my screen).
# ReadFeed "Phoronix" "https://www.phoronix.com/rss.php"