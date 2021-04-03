#

_You can also read this in another language: [English](readme.md)_

## My Cool Shells

> Coloquei aqui alguns scripts de shell que criei. Para utilizá-los, siga os passos abaixos.

```bash
# PASSO 1
# CLONE O REPOSITÓRIO:
git clone https://github.com/imtherouser/MyCoolShells

# PASSO 2
# DÊ PERMISSÃO DE EXECUÇÃO AOS SCRIPTS:
cd MyCoolShells
chmod +x *.sh && chmod +x /news_page/*.sh && chmod +x /auto_commit/*.sh

# PASSO 3
# EXECUTE O SCRIPT QUE DESEJARES:
./the_script.sh
```

### SCRIPTS:

> Abaixo coloquei explicações e imagens de alguns scripts. **CLIQUE PARA EXPANDIR**

<details>

<summary>🗗 default.sh</summary>

## _🙼 default.sh_

Este é um script que criei para ser usado dentro de todos os outros scripts de shell. Ele serve para estilizar de uma maneira fácil os textos dentro dos códigos, deixando-os limpos e legíveis. Também é útil para criar menus rapidamente e de diferentes maneiras. Para utilizá-lo, importe o default.sh no início do código em seu script de shell:

```bash
source "default.sh"
```

**Exemplos e features:**

**🔸 ESTILIZAÇÃO DE TEXO**

```bash
# SEM O DEFAULT.SH
echo -ne "\e[1m\e[97m SCRIPT NAME \e[2m\e[37m\e[7m teste.sh \e[0m"
echo -e "\e[34m I'm blue,\e[31m I'm red,\e[32m I'm green."
echo -e "\e[42m\e[1m\e[97m Bold White Text on Green Background "
```

```bash
# COM O DEFAULT.SH
title "SCRIPT NAME"
echo -e "$blue I'm blue,$red I'm red,$green I'm green."
echo -e "$bg_green$bold$white Bold White Text on Green Background "
```

_Ambos os exemplos imprimem exatamente o mesmo resultado._

![default.sh_text_image](screenshots/screenshot-text.png)

**🔸 CRIAÇÃO DE MENUS**

MENU DE FUNÇÕES (fmenu) - Crie menus a partir de funções. Para fazer isso, basta criar funções que terminem com "/menu":

```bash
Um_item_do_menu/menu() {
  #comandos
}
Mais_um_item/menu() {
  #comandos
}
fmenu
```

```txt
# Resultado:
 1. Um item do menu
 2. Mais um item

 Nº
```

MENU DE LISTAS (lmenu) - Crie menus a partir de listas, arrays, arquivos... Para fazer isso basta definir o parâmetro da lista e a ação:

```bash
action() {                                  # função para as ações
  echo "Sua escolha foi: ${list[choice]}"   # a ação
}
lmenu "$(ls /sys/class/net)"                # a lista
```

```txt
Resultado: Neste exemplo as tuas interfaces de rede são listadas como menu.
 1. enp0s25
 2. lo
 3. virbr0
 4. virbr0-nic
 5. wlp0s26u1u2
 6. wlp3s0

 Nº
```

MENUS DE LISTA E FUNÇÕES **2** (fmenu2 e lmenu2) - fazem as mesmas coisas que os anteriores, porém ambos tem suporte à teclado.

```text
⇩ seta para baixo:                próximo item
⇧ seta para cima:                 item anterior
⇨ seta para direita ou espaço:    escolhe a opção
⇦ seta para esquerda ou esc:      sai do script
```

![default.sh_menu_image](screenshots/screenshot-menu.gif)

---

</details>

<details>

<summary>🗗 update_arch.sh</summary>

## _🙼 update_arch.sh_

Trata-se de um script para atualizar o Arch Linux facilmente.

![updating_image](screenshots/screenshot-updating.gif)

Uso:

```bash
./update_arch.sh
```

Ao executarmos o script, o mesmo segue a seguinte sequência:

- Mostra as últimas notícias de atualização do Arch com o 'newsboat';
- Atualiza o antivírus - as assinaturas não oficiais do ClamAV;
- Limpa o cache do Paru e Pacman;
- Atualiza a mirrorlist com o 'reflector';
- Atualiza as chaves do repositório;
- Atualiza o repositório oficial do Arch;
- Atualiza o Flatpak;
- Atualiza o Snap;
- Atualiza o Arch User Repository (AUR);
- Remove pacotes desnecessários (órfãos);
- E, finalmente, pergunta se tu desejas reiniciar o sistema.

Dependências: newsboat; ClamAV; script das assinaturas não oficiais do ClamAV; paru; reflector; flatpak; snap; trash.

---

</details>

<details>

<summary>🗗 docker.sh</summary>

## _🙼 docker.sh_

Este é um script para visualizar, iniciar e parar containers do Docker.

```bash
# Uso:
./docker.sh
```

![docker_image](screenshots/screenshot-docker.gif)

---

</details>

<details>

<summary>🗗 google_calendar.sh</summary>

## _🙼 google_calendar.sh_

Esse pequeno script captura os dados do 'Google Calendar', através do 'gcalcli', e os organiza. Uso esse script junto com o 'Conky' para mostrar a agenda, de forma simples e discreta, no canto da área de trabalho (desktop).

![gcalendar_image](screenshots/screenshot-calendar.png)

```bash
# Uso:
./google_calendar.sh
```

É necessário instalar e configurar o gcalcli.

---

</details>

> Abaixo, scripts não mais utilizados (abandonados). **CLIQUE PARA EXPANDIR**

<details>

<summary>🗗 news_page.sh</summary>

## _🙼 news_page.sh_

Esse script extrai notícias de vários sites e cria um documento html leve e prático.

O script também mostra posts do Twitter, feeds do GitHub, feeds do YouTube, cotação de moedas, dados metereológicos e saídas de comandos no bash.

![news_page_image](screenshots/screenshot-news-dark.gif)

USO:

Insira teus links (feed rss) de notícias favoritos no arquivo de configuração "**news_settings➜default.sh**" e rode o script. Tu podes rodar o script sem parâmetros, ou especificar um arquivo de configuração personalizado, assim como nos exemplos abaixo:

```bash
# Exemplo sem parâmetros:
./news_page.sh

# Exemplo indicando um arquivo de configuração:
./news_page.sh -s news_settings➜Rio_de_Janeiro_News.sh

# news_page.html será gerado.
```

DEPENDÊNCIAS:

- Para usar a função de extrair posts do Twitter é necessário instalar o [jq](https://stedolan.github.io/jq/) (Json parser).

- Para usar a função de dados metereológicos é necessário instalar o [weather](http://fungi.yuggoth.org/weather/)

```bash
# Usuário do Arch (paru):
paru -S weather

# Usuário do Debian ou Ubuntu:
sudo apt-get install weather-util
```

DICA 1:

Para manter a página atualizada, você pode agendar o script para ser executado a cada 12 horas, basta editar o 'cron' com o comando:

```bash
export VISUAL=nano; crontab -e
```

e insira uma nova linha como essa (com o caminho completo ao script):

```txt
0 */12 * * * /home/nome_do_user/pasta_dos_scripts/news_page/news_page.sh -s news_settings➜Pindamonhangaba.sh
```

DICA 2:

Você pode obter o feed principal do seu GitHub, para isso vá na página inicial e copie o link de onde estiver escrito "Subscribe to your news feed". E coloque no seu aquivo de configuração algo como:

```text
feed2 "GitHub Main Feed" "https://github.com/imtherouser.private.atom?token=QWERTYQWERTYQWERTY" "8"
```

Além do feed principal tu também consegues extrair commits de projetos, como na imagem abaixo:

![news_page_image](screenshots/screenshot-news-github.gif)

---

</details>
