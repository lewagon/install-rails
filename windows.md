Si vous êtes sur Windows, vous avez trois choix :

1. Installer Ubuntu en [Dual Boot](http://www.everydaylinuxuser.com/2015/11/how-to-install-ubuntu-linux-alongside.html) puis suivre le [tutoriel du programme FullStack](https://github.com/lewagon/setup/blob/master/UBUNTU.md)
1. Si votre ordinateur est très puissant, installer une **machine virtuelle** avec [Virtual Box](https://www.virtualbox.org/), y installer Ubuntu et enfin suivre le même tutoriel ci-dessus.
1. Préférer une option _cloud_, et dans ce cas continuer à lire ce qu'il y a ci-dessous.

# Configurer une _workstation_ Cloud9

## Étape 1 - Créer un compte AWS Cloud9

Créez un compte AWS. Si vous en avez déjà un, vous pouvez l'utiliser pour ça.

Allez sur [Cloud9](https://eu-west-1.console.aws.amazon.com/cloud9/home/product?region=eu-west-1). Vérifiez bien que vous êtes sur sur le datacenter **EU - Irland**.

Cliquez ensuite sur "Create an environnment":

## Étape 2 - Créer un nouveau projet

Vous allez pouvoir créer des environnements de travail. Pour rester dans le plan gratuit d'AWS, choisissez `t2.nano` comme instance EC2 au moment de la création.

## Étape 3 - Configuration de git et GitHub

Dans le terminal en bas, tapez les commandes suivantes :

```bash
curl https://raw.githubusercontent.com/lewagon/dotfiles/master/gitconfig > ~/.gitconfig

git config --global user.email "seb@lewagon.org"
git config --global user.name "Sebastien Saunier"
```

:warning: Ne mettez pas d'accent dans le `user.name` (ici je n'ai pas mis le `é` à mon prénom),
et si possible mettez le [même email que celui de votre compte GitHub](https://github.com/settings/emails).

Nous allons maintenant nous occuper de la [clé SSH](https://fr.wikipedia.org/wiki/Secure_Shell#SSH_avec_authentification_par_cl.C3.A9s) pour pouvoir communiquer avec GitHub par le terminal. Nitrous nous a déjà généré une paire de clé, il suffit de donner la clé publique à GitHub. Dans le terminal, lancez la commande :

```bash
ssh-keygen -t rsa -b 4096 -C "your_email@example.com"
# Faites ensuite "Enter" plusieurs fois
cat ~/.ssh/id_rsa.pub
```

Copiez les lignes qui viennent de s'afficher (ça commence par `ssh-rsa AAA` et ça finit par un truc du genre `hl4NX7SgX3`).

Rendez-vous ensuite sur [cette page](https://github.com/settings/ssh) pour ajouter la clé.
La commande précédente a mis dans le presse-papier votre clé publique, il n'y a donc qu'à
coller (`⌘` + `V`) dans la zone de texte.

Pour vérifier que tout est configuré, tapez la commande :

```bash
ssh -T git@github.com
```

## Étape 4 - Configuration de PostgreSQL

C'est la base de données :) Dans le terminal, installez et démarrez le service de base de données :

```bash
yes | sudo yum install postgresql postgresql-server postgresql-devel postgresql-contrib postgresql-docs
sudo service postgresql initdb -E utf8
sudo service postgresql start
```

Ensuite nous avons besoin de faire quelques petites configurations. Toujours dans le terminal :

```bash
sudo su - postgres
psql --command 'CREATE ROLE "ec2-user" LOGIN createdb;'
psql --command "UPDATE pg_database SET datistemplate = FALSE WHERE datname = 'template1';"
psql --command "DROP DATABASE template1;"
psql --command "CREATE DATABASE template1 WITH TEMPLATE = template0 ENCODING = 'UNICODE';"
psql --command "UPDATE pg_database SET datistemplate = TRUE WHERE datname = 'template1';"
psql --command "VACUUM FREEZE;"
exit
```

## Étape 5 - Vérifiez que vous avez la dernière version de Ruby

Tapez:

```bash
ruby -v
```

Si vous avez au moins 2.4, continuez!

## Étape 6 - Installer Rails

Installez également `yarn` qui est nécessaire depuis Rails 5.1:

```bash
npm install -g yarn
```

Ensuite vérifiez votre version de Rails:

```bash
rails -v
```

Si vous avez au moins 5.1, continuez!

## Étape 7 - Vérification que tout fonctionne :

Nous allons maintenant créer une application de vérification :

```bash
cd ~/environment
rails new verif_setup -T --webpacker --database=postgresql
cd verif_setup
rails db:create
rails s -b 0.0.0.0
```

Le serveur Rails va se lancer sur le port `8080` (configuré automatiquement par Cloud9).

Ensuite, cliquez sur `Preview` en haut puis `Preview running application`. Une `Browser window` va apparaître, cliez sur le bouton "Pop out into new window":

![](https://cdn-images-1.medium.com/max/800/1*tnEnYLJ9yueZvWXGnbdUtg.png)

Et vous devriez avoir le "Yay you're on Rails!"

Si vous voyez l'écran d'accueil de Rails, vous avez réussi !

Bravo !
