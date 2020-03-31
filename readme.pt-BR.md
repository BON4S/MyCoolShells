#

README EM PORTUGUÊS

You can also read this in another language: [English](readme.md)

## My Cool Shells

Coloquei aqui alguns scripts shell que criei e costumo utilizar.

Sinta-se livre para modificar, melhorar e usar como desejar.

Basta clonar o repositório, dar permissão e executar:

```bash
git clone https://github.com/BON4S/MyCoolShells
cd MyCoolShells
chmod +x *.sh && chmod +x /news_page/*.sh
./the_script.sh
```

Abaixo coloquei screenshots e explicações de alguns scripts.

**CLIQUE ABAIXO PARA EXPANDIR:**

<details>

<summary>🗗 news_page.sh</summary>

## _ARQUIVO: news_page.sh_

Esse script extrai notícias de vários sites e cria um documento html leve e prático.

O script também mostra posts do Twitter, feeds do GitHub, cotação de moedas, dados metereológicos e saídas de comandos no bash.

NEWS PAGE DARK THEME (rodando no [meu tema do Firefox](https://addons.mozilla.org/en-US/firefox/addon/focus-and-darkness/))

![news_page_image](screenshots/screenshot-news-dark.gif)

USO:

Insira teus links (rss) de notícias favoritos no arquivo de configuração "**news_settings➜default.sh**" e rode o script. Tu podes rodar o script sem parâmetros, ou especificar um arquivo de configuração personalizado, assim como nos exemplos abaixo:

```bash
# Exemplo sem parâmetros:
./news_page.sh

# Exemplo indicando um arquivo de configuração:
./news_page.sh -s news_settings➜Rio_de_Janeiro.sh
```

_news_page.html_ será gerado.

DEPENDÊNCIAS:

- Para usar a função de extrair posts do Twitter é necessário instalar o [pup](https://github.com/ericchiang/pup) (HTML parser).

```bash
# Usuário do Arch (yay):
yay -S pup

# Usuário de outra distro: Faça o download do executável zipado no link abaixo e descompacte-o na pasta "/bin".
# https://github.com/EricChiang/pup/releases/tag/v0.4.0
```

- Para usar a função de dados metereológicos é necessário instalar o [weather](http://fungi.yuggoth.org/weather/)

```bash
# Usuário do Arch (yay):
yay -S weather

# Usuário do Debian ou Ubuntu:
sudo apt-get install weather-util
```

DICA 1:

Se tu usas o Firefox instale a minha extensão para pegar links de feed facilmente: [Kill and More](https://github.com/BON4S/KillAndMore)

DICA 2:

Para manter a página atualizada, você pode agendar o script para ser executado a cada 12 horas, basta editar o 'cron' com o comando:

```bash
export VISUAL=nano; crontab -e
```

e dentro da edição insira uma nova linha como essa (com o caminho completo ao script):

```txt
0 */12 * * * /home/nome_do_user/pasta_dos_scripts/news_page/news_page.sh -s news_settings➜Pindamonhangaba.sh
```

DICA 3:

Você pode obter o feed principal do seu GitHub, para isso vá na página inicial e copie o link de onde estiver escrito "Subscribe to your news feed". E coloque no seu aquivo de configuração algo como:

```text
feed2 "GitHub Main Feed" "https://github.com/BON4S.private.atom?token=QWERTYQWERTYQWERTY" "8"
```

Além do feed principal tu também consegues pegar commits (entre outros) de projetos, como na imagem abaixo:

![news_page_image](screenshots/screenshot-news-github.gif)

</details>

<details>

<summary>🗗 default.sh</summary>

## _ARQUIVO: default.sh_

Esse é um código padrão que criei para colocar em todos os scripts. Ele serve para estilizar de uma maneira fácil os textos dentro dos códigos, deixando-os limpos e legíveis. Também é útil para criar menus rapidamente e de diferentes maneiras.

Uso: importe o default.sh no início do código do seu script.

```bash
source "default.sh"
```

**_ESTILIZAÇÃO DE TEXO_**

Sem o default.sh:

```bash
echo -ne "\e[1m\e[97m SCRIPT NAME \e[2m\e[37m\e[7m teste.sh \e[49m"

echo -e "\e[34m I'm blue,\e[33m I'm yellow,\e[32m I'm green."

echo -e "\e[107m\e[1m\e[31m Bold Red Text on White Background "
```

Com o default.sh:

```bash
title "SCRIPT NAME"

echo -e "$blue I'm blue,$yellow I'm yellow,$green I'm green."

echo -e "$bg_white$bold$red Bold Red Text on White Background "
```

![default.sh_text_image](screenshots/screenshot-text.png)

Ambos os exemplos imprimem exatamente o mesmo resultado.

NOTA: _Consulte outras opções de cores e estilos dentro do default.sh._

**_CRIAÇÃO DE MENUS_**

Com default.sh também podemos criar menus a partir de funções com os comandos **_fmenu_** e **_fmenu2_**, ou a partir de listas com os comandos **_lmenu_** e **_lmenu2_**. Veja os exemplos abaixo:

MENU DE FUNÇÕES

fmenu - Crie menus a partir de funções. Para fazer isso, basta criar funções que terminem com "/menu":

```bash
Um_item_do_menu/menu() {
  #comandos
}
Mais_um_item/menu() {
  #comandos
}
fmenu
```

Resultado:

```txt
 1. Um item do menu
 2. Mais um item

 Nº
```

MENU DE LISTAS

lmenu - Crie menus a partir de listas, arrays, arquivos... Para fazer isso basta definir o parâmetro da lista e a ação:

```bash
action() {                                  # função para as ações
  echo "Sua escolha foi: ${list[choice]}"   # a ação
}
lmenu "$(ls /sys/class/net)"                # a lista
```

Resultado:

```txt
Neste exemplo as tuas interfaces de rede são listadas como menu:

 1. enp0s25
 2. lo
 3. virbr0
 4. virbr0-nic
 5. wlp0s26u1u2
 6. wlp3s0

 Nº
```

MENUS DE LISTA E FUNÇÕES **2**

**fmenu2** e **lmenu2** fazem as mesmas coisas que os anteriores, porém ambos tem suporte ao teclado.

```text
⇩ seta para baixo:                próximo item
⇧ seta para cima:                 item anterior
⇨ seta para direita ou espaço:    escolhe a opção
⇦ seta para esquerda ou esc:      sai do script
```

![default.sh_menu_image](screenshots/screenshot-menu.gif)

</details>

<details>

<summary>🗗 update_arch.sh</summary>

## _ARQUIVO: update_arch.sh_

Esse script é uma ótima maneira de atualizar o Arch Linux sem que haja erros durante o processo.

![updating_image](screenshots/screenshot-updating.gif)

Uso:

```bash
./update_arch.sh
```

Ao executarmos o script, o mesmo segue a seguinte sequência:

- Mostra as últimas notícias de atualização do Arch com o 'newsboat';
- Atualiza o antivírus - as assinaturas não oficiais do ClamAV;
- Limpa o cache do Yay e Pacman;
- Atualiza a mirrorlist com o 'reflector';
- Atualiza as chaves do repositório;
- Atualiza o repositório oficial do Arch;
- Atualiza o Flatpak;
- Atualiza o Snap;
- Atualiza o Arch User Repository (AUR);
- E, finalmente, pergunta se tu desejas reiniciar o sistema.

Dependências: newsboat; ClamAV; script das assinaturas não oficiais do ClamAV; Yay; reflector; Flatpak; Snap.

</details>

<details>

<summary>🗗 google_calendar.sh</summary>

## _ARQUIVO: google_calendar.sh_

Esse pequeno script captura os dados da minha agenda da Google via 'gcalcli'.

Uso-o para imprimir, com um resultado simples e discreto, meus compromissos no canto da área de trabalho. Faço isso com a ajuda do 'Conky', o qual consegue mostar as informações geradas por qualquer script no desktop.

![gcalendar_image](screenshots/screenshot-calendar.png)

Uso:

```bash
./google_calendar.sh
```

Para usar esse script, é necessário instalar e configurar o gcalcli (ativar a API do Google).

</details>
