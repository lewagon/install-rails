# Installer Ruby on Rails sur Mac OS X

## Étape 1 - Installer les outils de ligne de commande

Lancez l'application **Terminal** et tapez la ligne de commande suivante,
suivie par `Enter` :

```bash
xcode-select --install
```

## Étape 2 - Installer Homebrew

Homebrew est une application en ligne de commande pour installer d'autres logiciels.
On appelle ça aussi un **gestionnaire de paquets**. Toujours dans le **Terminal**,
tapez la ligne suivante, suivie par la touche `Enter` :

```bash
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

Cette ligne de commande 👆 va vous demander votre mot de passe. Il s'agit du **mot de passe de session** de votre ordinateur, tapez-le, rien ne s'affche, c'est normal. Finissez par la touche `Enter`.

Si vous avez déjà Homebrew, vous aurez le message `It appears Homebrew is already installed.`.
Dans ce cas, pas besoin de le désinstaller, une simple mise à jour suffit normalement :

```bash
brew update
```

Maintenant, grâce à Homebrew, nous allons installer / mettre à jour quelques logiciels :

```bash
function install_or_upgrade { brew ls | grep $1 > /dev/null; if (($? == 0)); then brew upgrade $1; else brew install $1; fi }
```

```bash
install_or_upgrade "git"
install_or_upgrade "node"
install_or_upgrade "openssl"
brew tap homebrew/dupes
install_or_upgrade "libxml2"
install_or_upgrade "libxslt"
install_or_upgrade "libiconv"
install_or_upgrade "yarn"
```

## Étape 3 - Installer Oh my zsh

Pour obtenir un terminal plus _user-friendly_, plus coloré, on ne se content pas de
`bash` (le terminal par défaut), on utilise `zsh`. Ouvrez votre **Terminal** et tapez
la ligne suivante, suivie par la touche `Enter` :

```bash
rm -rf ~/.oh-my-zsh && curl -L http://install.ohmyz.sh | sh
```

Cette ligne va vous demander un **mot de passe**. C'est votre mot de passe de session
d'ordinateur, celui que vous tapez au démarrage de l'ordinateur ou en sortie de veille.
Tapez ce mot de passe (:warning: les caractères que vous tapez **n'apparaissent pas** pour
des raisons de sécurité, c'est **normal**). Terminez par `Enter`.

Ensuite tapez les quatres lignes suivantes suivies de `Enter` à chaque fois.

```bash
if [ -h ~/.zshrc ]; then mv ~/.zshrc ~/.zshrc.backup; fi && curl https://raw.githubusercontent.com/lewagon/dotfiles/master/zshrc > ~/.zshrc
```

```bash
curl https://raw.githubusercontent.com/lewagon/dotfiles/master/irbrc > ~/.irbrc
```

```bash
curl https://raw.githubusercontent.com/lewagon/dotfiles/master/gitconfig > ~/.gitconfig
```

```bash
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
```

Fermez l'application **Terminal** (`⌘` + `Q`), relancez-là. Vous devriez voir `➜  ~` en vert. Si ce n'est pas le cas,
recommencez l'étape 3.

## Étape 4 - Configure git & GitHub

Nous allons avoir besoin d'utiliser `git` **en ligne de commande**. Il y a donc un peu de mise
en place.

Tout d'abord nous allons configurer notre nom et email. Ouvrez le **Terminal** et tapez ces lignes
de commande. :warning: Veillez à ne pas copier/coller sans regarder et à mettre vos **propres** informations.

```bash
git config --global user.email "seb@lewagon.org"
git config --global user.name "Sebastien Saunier"
```

:warning: Ne mettez pas d'accent dans le `user.name` (ici je n'ai pas mis le `é` à mon prénom),
et si possible mettez le [même email que celui de votre compte GitHub](https://github.com/settings/emails).

Nous allons maintenant générer une [clé SSH](https://fr.wikipedia.org/wiki/Secure_Shell#SSH_avec_authentification_par_cl.C3.A9s) pour pouvoir communiquer avec GitHub par le terminal. Techniquement, on utilise des clés asymétriques, nous allons générer ces dernières sur votre machine (les clés seront simplement stockés dans des fichiers, pas de magie). Il y aura une clé **publique** qu'on communiquera à GitHub, et une clé **privée** qu'il faut garder bien secrète (comme un mot de passe). J'ai écris un petit [article](http://sebastien.saunier.me/blog/2015/05/10/github-public-key-authentication.html) à ce sujet.

Lancez le **Terminal** et tapez la commande suivante (:warning: en mettant votre *propre* email !)

```bash
mkdir -p ~/.ssh && ssh-keygen -t rsa -C "seb@lewagon.org"
```

Cette commande est **intéractive**, elle va vous demander certaines informations. La première :

```
Enter file in which to save the key (/Users/seb/.ssh/id_rsa):
```

**Contentez-vous d'appuyer sur `Enter`**.

Ensuite, la commande va vous demander une **`passphrase`**. Pour la sécurité, c'est important
de protéger votre clé privée, un simple fichier sur votre ordinateur, par un mot de passe.
Ainsi, si vous vous faîtes cambrioler (et que vous n'avez pas activé [Filevault](https://support.apple.com/fr-fr/HT204837)), votre clé privée sera inutile. Si vous n'avez pas de `passphrase` et que quelqu'un met la main sur cette clé privé, cela revient à lui donner votre mot de passe GitHub, et votre mot de passe Heroku comme on verra plus tard.


Aux deux questions :

```
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
```

Entrez votre passphrase (:warning: encore une fois, rien ne s'affiche), et terminez par `Enter`.

Bien, nous allons maintenant communiquer notre clé privée à GitHub. Dans le terminal,
lancez la commande suivante :

```bash
cat ~/.ssh/id_rsa.pub | pbcopy
```

Rendez-vous ensuite sur [cette page](https://github.com/settings/ssh) pour ajouter la clé.
La commande précédente a mis dans le presse-papier votre clé publique, il n'y a donc qu'à
coller (`⌘` + `V`) dans la zone de texte.

Pour vérifier que tout est configuré, tapez la commande :

```bash
ssh -T git@github.com
```

## Étape 5 - Installer Ruby

Dans le **Terminal**, lancez les commandes suivantes (qui vous demanderont votre mot de passe de session) :

```bash
if [ -x "$(command -v rvm)" ]; then rvm implode && sudo rm -rf ~/.rvm; fi
sudo rm -rf $HOME/.rbenv /usr/local/rbenv /opt/rbenv /usr/local/opt/rbenv
```

Continuez avec :

```bash
brew uninstall --force rbenv ruby-build
unset RBENV_ROOT && source ~/.zshrc
brew install rbenv ruby-build && source ~/.zshrc
rbenv install 2.3.5 && source ~/.zshrc && rbenv global 2.3.5
```

:warning: Elle devrait prendre 5-10 minutes, c'est normal, ce n'est pas "bloqué".

Ensuite, quittez le terminal (`⌘` + `Q`) et relancez-le. Tapez la commande suivante :

```bash
ruby -v
```

Si vous avez en retour une version contenant `ruby 2.3.5p`, tout est bon !

**Si vous ave une autre version de Ruby, merci de recommencer l'étape 5**.

## Étape 6 - Installer la base de données Postgresql

Nous allons avoir besoin d'une base de données pour stocker les informations à propos
des utilisateurs, des produits, etc. Dans le **Terminal**, lancez la commande suivante :

```bash
brew install postgresql
```

Attendez un peu que l'installation se termine, ensuite tapez la commande suivante:

```bash
brew services start postgresql
```

Ainsi Postgresql tournera en tâche de fond et vous n'aurez pas à vous en soucier.

## Étape 7 - Installer Rails

Dans le **Terminal**, nous allons d'abord installer quelques gems utiles pour le cours.

```bash
gem install bundler pry hub
```

Installez également `yarn`, une dépendence de Rails depuis 5.1:

```bash
brew install yarn
```

Maintenant, nous pouvons **enfin** installer Rails :

```bash
gem install rails
```

:warning: Veillez à ne **jamais** installer une gem avec `sudo gem install`. Pas de `sudo`! Même si certains site (comme des réponses StackOverflow) le recommandent !

## Étape 8 - Vérification que tout fonctionne :

Nous allons créer un dossier temporaire et y générer une application Rails de test :

```bash
mkdir -p ~/tmp && cd ~/tmp
rails new verif_setup --webpacker -T --database=postgresql
```

Attendez un peu que ça terminal, ensuite :

```bash
cd verif_setup
rails db:create
rails s
```

Lancez votre navigateur et allez à l'adresse [localhost:3000](http://localhost:3000). Si
vous voyez la page de bienvenue de Rails, c'est tout bon !

Vous pouvez faire un peu de ménage. Commencez par quitter le serveur (`Ctrl` + `C` dans le terminal) et tapez :

```bash
cd ~/tmp/verif_setup
rails db:drop
cd ~
rm -rf ~/tmp/verif_setup
```

## Étape 9 - Installer Sublime Text

Sublime Text va être notre éditeur de texte dans lequel nous allons coder. Si vous ne l'avez pas encore, rendez-vous sur [cette page](https://www.sublimetext.com/3) pour le télécharger (version **OSX**). Une fois téléchargé, glissez-le dans le dossier Applications.

Ensuite, nous allons installer le _Package Control_ de Sublime Text pour étendre ses fonctionnalités. Pour cela, rendez-vous sur [cette page](https://packagecontrol.io/installation#st3) et suivez les instructions.

Lancez Sublime Text, et installez les packages suivants :

- All Autocomplete
- Emmet
- Git
- GitGutter

Ouvrez le fichier de préférences et remplacez tout son contenu par :

```json
{
  "detect_indentation": false,
  "draw_white_space": true,
  "ensure_newline_at_eof_on_save": true,
  "folder_exclude_patterns":
  [
    "tmp",
    "log",
    ".git",
    "_site",
    ".bundle",
    ".sass-cache",
    "build"
  ],
  "highlight_modified_tabs": true,
  "hot_exit": false,
  "ignored_packages":
  [
    "Vintage"
  ],
  "remember_open_files": false,
  "rulers":
  [
    80
  ],
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
  "trim_automatic_white_space": true,
  "trim_trailing_white_space_on_save": true,
  "use_tab_stops": true,
  "word_wrap": false
}
```

Vous êtes prêt(e) à coder !
