# My Cool Shells

| Shells created to make life easier. | ![BON4S!_IMAGE](screenshots/screenshot-BON4S.gif) |
|-|-|

VERSÃO EM PORTUGUÊS

Read this in another language: [English](readme.en.md)

--------

## *Índice*

- [My Cool Shells](#my-cool-shells)
  - [*Índice*](#user-content-índice)
  - [*O que é isso?*](#user-content-o-que-é-isso)
  - [*ARQUIVO: header.sh*](#arquivo-headersh)
  - [*ARQUIVO: news_page.sh*](#arquivo-news_pagesh)
  - [*ARQUIVO: update_arch.sh*](#arquivo-update_archsh)
  - [*ARQUIVO: google_calendar.sh*](#arquivo-google_calendarsh)

--------

## *O que é isso?*

Coloquei aqui alguns scripts shell que criei e costumo utilizar.

Sinta-se livre para modificar, melhorar e usar como desejar.

Basta clonar o repositório, dar permissão e executar:

```bash
git clone https://github.com/BON4S/MyCoolShells
cd MyCoolShells
chmod +x *.sh
./the_script.sh
```

Abaixo, segue a explicação de alguns scripts.

--------

## *ARQUIVO: header.sh*

Esse é um código padrão que criei para colocar em todos os scripts. Ele serve para estilizar de uma maneira fácil os textos dentro dos códigos, deixando-os limpos e legíveis. Também é útil para criar menus rapidamente e de diferentes maneiras.

Uso: inclua o código do header.sh no seu script:

```bash
source "header.sh"
```

***ESTILIZAÇÃO DE TEXO***

Com header.sh podemos estilizar o texto com variáveis e funções.

EXEMPLOS

Sem o header.sh:

```bash
echo -ne "\e[1m\e[97m SCRIPT NAME \e[2m\e[37m\e[7m teste.sh \e[49m"

echo -e "\e[34m I'm blue,\e[33m I'm yellow,\e[32m I'm green."

echo -e "\e[107m\e[1m\e[31m Bold Red Text on White Background "
```

Com o header.sh:

```bash
Title "SCRIPT NAME"

echo -e "$blue I'm blue,$yellow I'm yellow,$green I'm green."

echo -e "$bg_white$bold$red Bold Red Text on White Background "
```

![header_text_image](screenshots/screenshot-text.png)

Ambos os exemplos imprimem exatamente o mesmo resultado.

NOTA: *Consulte outras opções de cores e estilos dentro do header.sh.*

***CRIAÇÃO DE MENUS***

Com header.sh também podemos criar menus a partir de funções com o comando ***FMenu***, ou a partir de listas com o comando ***LMenu***. Veja os exemplos abaixo:

![header_menu_image](screenshots/screenshot-menu.gif)

MENU DE FUNÇÕES

FMenu - Crie menus a partir de funções. Para fazer isso, basta criar funções que terminem com "/menu":

```bash
Um_item_do_menu/menu() {
  #comandos
}
Mais_um_item/menu() {
  #comandos
}
FMenu
```

Resultado:

```txt
 1. Um item do menu
 2. Mais um item

 Nº
```

MENU DE LISTAS

LMenu - Crie menus a partir de listas, arrays, arquivos... Para fazer isso basta definir o parâmetro da lista e a ação:

```bash
MenuAction() {                              # função para as ações
  echo "Sua escolha foi: ${list[choice]}"   # a ação
}
LMenu "$(ls /sys/class/net)"                # a lista
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

--------

## *ARQUIVO: news_page.sh*

Esse script extrai notícias de vários sites e cria um documento html leve e prático.

TEMA CLARO (padrão)

![news_page_image](screenshots/screenshot-news-light.png)

TEMA ESCURO (--dark)

![news_page_image](screenshots/screenshot-news-dark.png)

USO

Insira seus links (rss) de notícias favoritos no script e execute-o.

Tu podes rodar o script sem parâmetros, ou podes especificar o tema escuro e/ou o diretório para salvar a página, assim como nos três exemplos abaixo:

```bash
./news_page.sh

./news_page.sh --dark

./news_page.sh -d /pasta/para/salvar
```

*news_page.html* será gerado.

DICA 1: Se tu usas o Firefox instale a minha extensão para pegar links de feed facilmente: [Kill and More](https://github.com/BON4S/KillAndMore)

DICA 2: Para manter a página atualizada, você pode agendar o script para ser executado a cada 3 horas, basta editar o 'cron' com o comando:

```bash
export VISUAL=nano; crontab -e
```

e dentro da edição insira uma nova linha como essa (com o caminho completo ao script):

```txt
0 */3 * * * /home/user/pasta_do_script/news_page.sh --dark
```

--------

## *ARQUIVO: update_arch.sh*

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

Dependências: newsboat; ClamAV; script das assinaturas não oficiais do ClamAV; reflector; Flatpak; Snap.

--------

## *ARQUIVO: google_calendar.sh*

Esse pequeno script captura os dados da minha agenda da Google via 'gcalcli'.

Uso-o para imprimir, com um resultado simples e discreto, meus compromissos no canto da área de trabalho. Faço isso com a ajuda do 'Conky', o qual consegue mostar as informações geradas por qualquer script no desktop.

![gcalendar_image](screenshots/screenshot-calendar.png)

Uso:

```bash
./google_calendar.sh
```

Para usar esse script, é necessário instalar e configurar o gcalcli (ativar a API do Google).
