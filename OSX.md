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

Si vous avez déjà Homebrew, vous aurez le message `It appears Homebrew is already installed.`.
Dans ce cas, pas besoin de le désinstaller, une simple mise à jour suffit normalement :

```bash
brew update
```

Maintenant, grâce à Homebrew, nous allons installer quelques logiciels :

```bash
brew install git node
brew install openssl && brew link openssl --force
```

## Étape 3 - Installer Oh my zsh

Pour obtenir un terminal plus _user-friendly_, plus coloré, on ne se content pas de
`bash` (le terminal par défaut), on utilise `zsh`. Ouvrez votre **Terminal** et tapez
la ligne suivante, suivie par la touche `Enter` :

```bash
curl -L http://install.ohmyz.sh | sh
```

