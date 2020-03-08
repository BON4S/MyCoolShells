#

ENGLISH README - *English is not my first language, so if you see something wrong please correct me.*

You can also read this in another language: [Portuguese](readme.pt-BR.md)

## My Cool Shells

I put here some of the shell scripts that I created and use (feel free to modify, improve and use as you wish).

To use, clone the repository, give permission and run:

```bash
git clone https://github.com/BON4S/MyCoolShells
cd MyCoolShells
chmod +x *.sh && chmod +x /news_page/*.sh
./the_script.sh
```

**CLICK BELOW TO EXPAND:**

<details>

<summary>news_page.sh</summary>

## *FILE: news_page.sh*

This script extracts news from various websites and creates a lightweight and practical html document.

The script also shows Twitter posts, currency quotes, weather and custom shell script outputs.

NEWS PAGE DARK THEME (running on [my Firefox theme](https://addons.mozilla.org/en-US/firefox/addon/focus-and-darkness/))

![news_page_image](screenshots/screenshot-news-dark.gif)

USAGE:

Insert your favorite news links (rss) in the settings file "**news_settings➜default.sh**" and run the script. You can run the script without parameters, or you can specify a custom settings file, as in the examples below:

```bash
# Without parameters:
./news_page.sh

# Specifying the settings file:
./news_page.sh -s news_settings➜Los_Angeles.sh
```

*news_page.html* will be generated.

DEPENDENCIES:

- To use the Twitter function it is necessary to install: [pup](https://github.com/ericchiang/pup) (a HTML parser).

```bash
# Arch users (yay):
yay -S pup

# Users from other distros: Download the zipped executable from the link below and unzip it to the '/bin' folder.
# https://github.com/EricChiang/pup/releases/tag/v0.4.0
```

- To use the currency function it is necessary to install: [weather](http://fungi.yuggoth.org/weather/)

```bash
# Arch users (yay):
yay -S weather

# Debian and Ubuntu users:
sudo apt-get install weather-util
```

TIP 1:

If you use Firefox, install my extension to get feed links easily: [Kill and More](https://github.com/BON4S/KillAndMore)

TIP 2:

You can schedule the script to run every 12 hours by editing cron with the command:

```bash
export VISUAL=nano; crontab -e
```

and inside the edition insert a line like this:

```txt
0 */12 * * * /home/your_username/scripts_folder/news_page/news_page.sh -s news_settings➜Los_Angeles.sh
```

</details>

<details>

<summary>default.sh</summary>

## *FILE: default.sh*

This is a basic code that I created to be used in all shell scripts as a common code. It serves to stylize the texts used in the scripts, creating clean and readable code, and is also useful for creating menus quickly in a different way.

To use this, just include the code in your script:

```bash
source "default.sh"
```

***TEXT STYLIZER***

With default.sh, we can style the text with variables and functions.

EXEMPLES

Without default.sh:

```bash
echo -ne "\e[1m\e[97m SCRIPT NAME \e[2m\e[37m\e[7m teste.sh \e[49m"

echo -e "\e[34m I'm blue,\e[33m I'm yellow,\e[32m I'm green."

echo -e "\e[107m\e[1m\e[31m Bold Red Text on White Background "
```

With default.sh:

```bash
title "SCRIPT NAME"

echo -e "$blue I'm blue,$yellow I'm yellow,$green I'm green."

echo -e "$bg_white$bold$red Bold Red Text on White Background "
```

![default.sh_text_image](screenshots/screenshot-text.png)

Both examples print exactly the same result.

*See other color and style options inside default.sh.*

***MENU CREATOR***

With default.sh we can also create menus from functions with the ***fmenu*** command, or from lists with the ***lmenu*** command. See the examples below:

![default.sh_menu_image](screenshots/screenshot-menu.gif)

FUNCTION MENU

fmenu - Create menus from functions. To do this, simply create functions ending with "/menu":

```bash
The_menu_item/menu() {
  #commands
}
Another_item/menu() {
  #commands
}
fmenu
```

Result:

```txt
 1. The menu item
 2. Another item

 Nº
```

LIST MENU

lmenu - Create menus from lists, arrays, files... To do this, just set the list parameter and the action:

```bash
action() {                                  # actions function
  echo "Your choice was: ${list[choice]}"   # the action
}
lmenu "$(ls /sys/class/net)"                # the list
```

Result:

```txt
In this example, your network interfaces will be listed as a menu:

 1. enp0s25
 2. lo
 3. virbr0
 4. virbr0-nic
 5. wlp0s26u1u2
 6. wlp3s0

 Nº
```

</details>

<details>

<summary>update_arch.sh</summary>

## *FILE: update_arch.sh*

This script is a good way to update the Arch Linux without errors during the process.

![updating_image](screenshots/screenshot-updating.gif)

Usage:

```bash
./update_arch.sh
```

When we run the script it does the following sequence:

- Shows the latest Arch update news with the 'newsboat';
- Update antivirus - the unofficial ClamAV signatures;
- Clear Yay and Pacman's cache;
- Update mirrorlist with the 'reflector';
- Update repository keys;
- Update Arch official repository;
- Update the Flatpak;
- Update the Snap;
- Update the Arch User Repository (AUR);
- And finally, ask if you want to restart the system.

Dependencies: newsboat; ClamAV; unofficial ClamAV signatures script; Yay; reflector; Flatpak; Snap.

</details>

<details>

<summary>google_calendar.sh</summary>

## *FILE: google_calendar.sh*

This little script captures data from my Google Calendar via gcalcli.

I use it to print, with a simple and discreet result, my appointments on the desktop. I use Conky to show.

![gcalendar_image](screenshots/screenshot-calendar.png)

Usage:

```bash
./google_calendar.sh
```

To use this script it is necessary to install and configure gcalcli (activate the Google API).

</details>