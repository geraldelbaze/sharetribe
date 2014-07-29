## installation sharetribe sur plateforme Ubuntu 14.04 (Apache2, PHP, MySQL, PureFTPD, BIND, Dovecot, ISPConfig 3)
## sur serveur dédié sans virtualisation 
##
## merci à Arnaud Delcasse pour son aide (et sa patience)
## MLG corporate ;-)
## par Gérald Elbaze: contact@illacapartager.fr



## installation Serveur Ubuntu 14.04 + Apache2, PHP, MySQL, PureFTPD, BIND, Dovecot, ISPConfig 3

* suivre la procédure suivante:  http://bit.ly/1qIoQEN

## connexion à ispconfig

http://nomdedomaine.tld:8080


**PREPARATION INSTALLATION DE SHARETRIBE**
**ATTENTION - A PARTIR DE LA IL FAUT ETRE TRES PRECIS** 

## RAPPEL SUR LE FONCTIONNEMENT DE SHARETRIBE

Sharetribre est en réalité constitué de deux éléments:
1- le dashboard : c'est ce qui permet de proposer la création de tribu (tribe)
	il s'agit d'un onepage personnalisable offrant la possibilité de créer des communautés.
	vous pouvez voir cette page ici :https://www.sharetribe.com/ 

2- les tribus (tribes): chacune forme une plateforme dédiée. Par exemple à un Système d'Echange Local.

Donc vous devez d'abord arbitrer ce que vous souhaitez faire:
- un service global dont l'objet de création des communautés
- des communautés (autant que vous voulez) simplement.

Dans le premier cas, en tant qu'admin vous recevrez des demandes pour la création de nouvelles communautés
Dans le second cas, vous choisissez d'ouvrir un ou plusieurs communautés que vous animez.

**NB**
Sharetribe qui a développé l'outil Sharetribe commercialise pour la France une offre très intéressante
pour créer des communautés et en assurer l'infogérance. La distribution en logiciel libre de 
l'outil Sharetribe repose sur ce type de services associés qui permettent de financer la poursuite 
du développement. Donc pensez à les contacter, cela équivaut à soutenir le projet !

## POURQUOI CE CHOIX EST FONDAMENTAL ?

Lors de son déploiement voici comment Sharetribe procède:
> le dashboard va automatiquement se positionner sur www.nomdomaine.tld
> les communautés sur sous-domaine.nomdomaine.tld

Or avec ispconfig vous devez l'anticiper !

**A FAIRE AVANT DE RAPATRIER SHARETRIBE**
## ETAPE 1: Configuration d'ISPConfig

### Création de l'espace web et du user

Cette étape suppose que vous ayez préalablement créer un premier client sous ISPConfig.
Si vous gérez les DNS de votre sous ISPConfig, il vous faut le régler pour les nondomain.tld
ainsi que pour les sous-domaines pour chacun des communautés.
Si vous gérez les DNS chez un registrar (Gandi par ex), il vous faut le régler pour les nondomain.tld
ainsi que pour les sous-domaines pour chacun des communautés puis attendre la propagation.

> vous souhaitez ouvrir un service total sharetribe
Ajouter un site.
Puis Domaine: nomdomaine.tld (sans le www)
Puis Sous-domaine automatique : "*."
Puis Cliquez sur la case à cocher Ruby pour pouvoir executer Ruby
Puis Enregistrer

> vous souhaitez ouvrir des "tribus" (communautés)
Choisissez le nom de sous-domaine qui sera celui de la communauté: tribu1.nondomain.tld
Ajouter un site.
Puis Domaine: tribu1.nomdomaine.tld
Puis Sous-domaine automatique : "Aucun"
Puis Cliquez sur la case à cocher Ruby pour pouvoir executer Ruby
Puis Enregistrer

Automatiquement un user est créé: le format est de type web[x] (web1, web2...)
Son groupe est de type client[x] (client1, client2...)

**CE POINT EST FONDAMENTAL !**
Tout ce que vous ferez ensuite devrait être fait avec ce compte, sous peine de rendre impossible
l'exécution des programmes.

### Création de la base de données
Le dispositif de sharetribe suppose la création de 3 bases.
Si vous ne souhaitez ne fonctionner qu'en production (pas de test, pas de déploiement...)
vous pouvez créer une seule base. (#mode couillu le caribou)

Création de la base: attention bien préciser le même client et le même user

Votre base de données est vide. C'est normal. Elle sera dumpée lors de l'installation de Sharetribe

## ETAPE 2: INSTALLATION DE SHARETRIBE

* Connexion en SSH à votre serveur
Conseil utile: ouvrir deux onglets ssh: l'un sera avec le user admin de votre serveur
l'autre avec user créé avec ISPConfig de la forme web[x]. Pour y accéder sudo -u web1 -s

La procédure d'installation "classique" est documentée sur l'adresse suivante, mais elle demande
à être complétée. D'où ce doc.
https://github.com/sharetribe/sharetribe

* 1- Installation de ruby, gem et git
**AVEC VOTRE USER D'ADMINISTRATION**
Ruby (la version 2.1.1. Si vous avez déjà de multiples versions de Ruby, utilisez RVM)
RubyGems / Git
- sudo aptitude install ruby2.1.1
- sudo gem install bundler
- sudo aptitude install git

Ruby: permet de faire fonctionner Ruby in Rails (langage dans lequel est développé Sharetribe)
Gems: les différentes librairies de Ruby
Git: permet de rapatrier Sharetribe et de le maintenir à jour.

**A PARTIR DE LA ON BASCULE EN USER WEB[x]** on supposera web1
Pour basculer: 
> sudo -u web1 -s
Invite de commande vous demande mot de passe:
>  entrez mot de passe admin (celui qui vous permet de vous connecter en ssh)
Puis 
> cd /var/www/[lenomdevotresite]/web  ## vous voici dans le dossier sur lequel pointe ispconfig
et dans lequel nous allons installer Sharetribe

> git clone git://github.com/sharetribe/sharetribe.git ## permet de rapatrier les sources 
> ls

Un dossier sharetribe a été créé

## ETAPE 3: PARAMETRAGE DE SHARETRIBE

> cd sharetribe

### PARAMETRAGE DI FICHIER ACCES A LA BASE DE DONNEES

Fonctionnement de vi: http://bit.ly/1k5mXz4

> cp config/database.example.yml config/database.yml ## permet de créer le fichier de configuration
pour l'accès à la base de données
> vi config/database.yml ## permet d'éditer le fichier database.yml
    - modifier le nom de la base de données pour la partie "production"
    - modifiler le mot de passe de la base données pour la partie "production"
Utilisez les informations que vous avez parametrées lors de la création de la base de données
sous ISPConfig

### PARAMETRAGE DU FICHIER CONF DE SHARETRIBE
> cp config/config.example.yml config/config.yml
> vi config/config.yml  ## permet d'éditer le fichier config.yml

Dans le fonctionnement décrit (classique), vous pouvez vous limitez à remplir:

domain: "nomddomaine.tld" ## sans le www

mail_delivery_method: smtp

  smtp_email_address: "smtp.gmail.com"
  smtp_email_port: "587" ## attention dans la version d'origine ils ont oubliés les ""
  smtp_email_user_name: "votrenomdevoite@gmail.com"
  smtp_email_password: "votremdp"
  smtp_email_domain: "localhost"

(Mais vous pouvez aussi utilisez une boite créée avec ISPConfig sur votre domaine.)

 # The address where the notifications of feedbacks from Sharetribe UI are sent
  feedback_mailer_recipients:  'A REMPLIR ICI AVEC VOTRE ADRESSE'

 # Global Service name
 # If you want to call this service with different name on this server, you can specify it here
 # This can also be set community specific in community.settings["service_name"]
 global_service_name: VOUS_POUVEZ_PERSONNALISER_LE_NOM
    
## ETAPE 4: POURSUITE DE L'INSTALLATION
**AVEC VOTRE USER D'ADMINISTRATION** (ou dans l'onglet ssh de ce user)

> sudo aptitude install mysql-server-5.5 ## INUTILE: A ETE INSTALLE LORS DE L'INSTALL ISPCONFIG
> sudo mysql_secure_installation ## PARFOIS NECESSAIRE
> sudo aptitude install sphinxsearch ## PERMET DE DISPOSER DU MOTEUR DE RECHERCHE
> sudo aptitude install imagemagick ## PERMET DE TRAITER LES IMAGES
> sudo aptitude install build-essential mysql-client libmysql-ruby libmysqlclient-dev
> sudo gem install mysql2 -v 0.2.7 ## PERMET A GEM DE DIALOGUE AVEC MYSQL
> sudo aptitude install libxml2-dev libxslt-dev
> sudo aptitude install nodejs ## JavaScript
> bundle install ## Attention jamais de sudo bundle install ## il se peut aussi parfois 
que vous ayez besoin de passer l'argument --deployment en plus: bundle install --deployment

**AVEC VOTRE USER WEB[x]** donc soit dans le bon onglet, soit sudo -u web1 -s
> rake RAILS_ENV=production db:structure:load

La commande rake permet d'envoyer des tâches à executer vers les executables rails.
RAIL_ENV indique le mode (ici on est dans l'environnement "production".
Cette commande permet d'envoyer dans la base créée la structure des différentes tables.
Suppose que le fichier database.yml a été correctement rempli

> rake RAILS_ENV=production db:seed ## permet de préparer le fonctionnement de la base de données

Ces deux instructions proposées dans la doc originale fonctionne mal.
> rake RAILS_ENV=production thinking_sphinx:index ##NE PAS UTILISER
> rake RAILS_ENV=production thinking_sphinx:start ##NE PAS UTILISER

Il vaut mieux privilégier la nouvelle formulation de la commande. De plus même si les fonctions
start et stop fonctionne je vous conseille d'utiliser la fonction 'regenerate' qui recréé tous 
les fichiers conf et structure les données
> rake RAILS_ENV=production ts:regenerate ## Permet de faire fonctionner le moteur de recherche
dans l'environnement rails.

NB/ le pid se trouve dans sharetribe/logs (cela peut service pour monitorer les services)

> rake assets:precompile ## va copier toutes les informations CSS notamment dans le répertoire /public
puis compiler toutes les informations nécessaires au fonctionnement de sharetribe


**AVEC VOTRE USER D'ADMINISTRATION** (ou dans l'onglet ssh de ce user)
> sudo aptitude install libapache2-mod-passenger
> sudo gem install passenger

Passenger fait la jointure entre apache (serveur web) et rails

## ETAPE 5: PREMIERES DONNEES DANS LE BASE DE DONNEES

A ce stade Sharetribe est installé, mais n'a rien dans le ventre.
Or il ne peut formellement démarrer qu'avec une première communauté créée.
Donc nous allons devoir la créer par une série d'instruction envoyée via une console rake

> rails console production ## permet d'ouvrir une console rail dans l'environnement 'production'
Cela ouvre dans votre terminal une ligne de commande.
c = Community.create(:name => "your_chosen_name_here", :domain => "your_chosen_subdomain_here")
your_chosen_name_here: le nom de votre communauté
your_chosen_subdomain_here: le nom de votre sous-domaine (celui paramétré dans ispconfig)

Dès que vous allez valider cette commande,il incrémente et attend les autres instructions.
**IMPORTANT**
Une ligne après l'autre. D'un seul tenant (sans retour chariot). Attention à bien vérifier
que les " " sont bien des guillemets et non des signes de citation.

> tt = c.transaction_types.create(:type => "Vendre",:price_field => 1,:price_quantity_placeholder => nil);
> tt_trans = TransactionTypeTranslation.create(:transaction_type_id => tt.id,:locale => "fr",:name => "Acheter",:action_button_label => "Vendre");
> ca = c.categories.create;
> ca_trans = CategoryTranslation.create(:category_id => ca.id,:locale => "fr",:name => "Objets");
> CategoryTransactionType.create(:category_id => ca.id, :transaction_type_id => tt.id)

Puis la commande quit va déclenche la création des données
> quit

Ne vous inquiétez pas des traductions et des mots... tout se règlera par la suite. (Etape 9)

A ce stade, votre Sharetribe est fonctionnel. Il n'est pas encore relié à Apache. 
MAis pour permettre les phases de développement et de test, sharetribe embarque
des outils et des paramétrages nombreux.
Par exemple on peut faire des tests sur le port 3000 grâce à Webrick (serveur web embarqué dans rails)

Pour lancer la "production", il faut deux terminaux ou deux onglets.
Les deux doivent être avec le user web[x]

> rails server -e production ## lance la production
> rake RAILS_ENV=production jobs:work ## lance les jobs en tache de fond (envoi de mél, newsletter, affichage, etc...)

Vous pouvez sur http://sousdomaine.votredomaine.tld:3000 voir les premiers éléments de votre sharetribe

## ETAPE 6: PARAMETRAGE D'APACHE
**AVEC VOTRE USER D'ADMINISTRATION** (ou dans l'onglet ssh de ce user)
On peut le faire depuis ispconfig, mais c'est quand même nettement plus efficace directement
en mode édition:

> cd /etc/apache2/sites-enabled/
> ls
> sudo vi 100-sousdomaine.votredomaine.tld.vhost ## parfois c'est un autre nombre que 100

Pour faire simple:
A chaque fois que vous avez: /var/www/clients/client[x]/web[x]/web/
vous devez ajouter en sharetribe/public/
cela donne /var/www/clients/client[x]/web[x]/web/sharetribe/public/

Cela permet à Apache de ne plus considérer que le dossier référent est dans web mais plus 
loin dans l'arborescence.

Pour permettre également à Rails de fonctionner dans le bon environnement (et déclencher 
tout seul le serveur rails) il faut également ajouter après ServerAdmin:

  RailsEnv production 

On sauvegarde, puis on relance Apache

sudo /etc/init.d/apache2 restart

A ce stade, votre site est désormais visible et pratiquement fonctionnel sur:

http://sousdomaine.vottredomaine.tld

l'instuction rails server -e production n'est désormais plus utile puisque c'est Apache qui
a pris le relais pour déclencher à la demande le serveur rails

Mais les tâches de fond demeurent effectuées par 
> rake RAILS_ENV=production jobs:work
Or au bout d'un temps de non utilisation, ce service s'éteind. Donc nous allons devoir le
place dans un process dit "daemon".

## ETAPE 7: DAEMONISATION DES PROCESS

Cette daemonisation est documentée ici: https://github.com/collectiveidea/delayed_job/wiki
Et la distribution de Sharetribe est livrée avec la fonction delayed_job
Pour la lancer l'instruction est la suivante: 
> RAILS_ENV=production script/delayed_job start

Ce qui aura pour effet de vous renvoyer une erreur puisqu'il ne trouve pas dans gem le
paquet daemons.
Nous allons donc l'installer.

**AVEC VOTRE USER WEB[x]** donc soit dans le bon onglet, soit sudo -u web1 -s

> gem install daemons

Dans un monde idéal, il ne reste plus qu'à faire un bundle install... mais non.

Nous devons d'abord modifier le fichier Gemfile (dans /sharetribe)

> vi Gemfile

y ajouter 

gem 'daemons', '~> 1.1.9' ## à ajouter après gem 'statesman', '~> 0.5.0'

Puis basculer **AVEC VOTRE USER D'ADMINISTRATION** 

> bundle install --no-deployment ## toujours sans sudo devant

Puis basculer **AVEC VOTRE USER WEB[x]** 

> bundle install --deployment

Cela est juste destiné à passer outre le Gemfile.lock

Si vous lancez:
> RAILS_ENV=production script/delayed_job start

cela doit fonctionner. Tous les méls qui étaient en attente dans la plateforme doivent partir

## ETAPE 8: MONITORING DES SERVICES

Cela peut être utile de monitorer ses services. Voire qu'ils soient relancés automatiquement
en cas de problème.
Pour cela je vous propose d'utiliser monit.

Pour l'installer.

**AVEC VOTRE USER D'ADMINISTRATION** 

> sudo apt-get install monit
> sudo vi /etc/monit/monitrc

Dans le fichier:
 set httpd port 2812 and
     #use address localhost  # only accept connection from localhost
     #allow localhost        # allow localhost to connect to the server and
     allow admin:monit      # require user 'admin' with password 'monit'
     #allow @monit           # allow users of group 'monit' to connect (rw)
     #allow @users readonly  # allow users of group 'users' to connect readonly

Pour lancer le service
> sudo /etc/init.d/monit start

Cela doit vous permettre de vous connecter sur ce serveur avec l'url de type
nomdedomaine:2812

Login admin
mdp: monit

Nous avons besoin de monitorer deux services (vous pouvez paramétrer les autres aussi)
Sphinx et Delayed_job
Donc en fin de fichier nous allons pouvoir ajouter.

check process sphinx with pidfile /var/www/[votresiteweb]/web/sharetribe/log/production.sphinx.pid
##

check process delayed_job with pidfile /var/www/[votresiteweb]/web/sharetribe/tmp/pids/delayed_job.pid
        start program = "/var/www/[votresiteweb]/web/sharetribe/script/delayed_job -e production start" as uid web[x] and gid client[x]
        stop program = "/var/www/[votresiteweb]/web/sharetribe/script/delayed_job -e production stop" as uid web[x] and gid client[x]
        if mem is greater than 300.0 MB for 1 cycles then restart
        if cpu is greater than 50% for 2 cycles then alert
        if cpu is greater than 80% for 3 cycles then restart
        group background

Puis 
> sudo /etc/init.d/monit restart

Vos deux services sont monitorés.

**ATTENTION**

Sharetribe est livré avec des tas d'outils et de leurs sondes pour contrôler la production.
Mais les plateformes sont payants, quoique très performantes. Newrelic notamment.

## ETAPE 9: PARAMETRAGE D'UNE COMMUNAUTE

Désormais parfaitement documenté ici : 
https://github.com/geraldelbaze/sharetribe/blob/master/docs/customize-marketplace.md

## ETAPE 10: TROUBLESHOOTING

Je vais stocker ici les erreurs les plus fréquentes rencontrées.

# confusion de user.

# je viens de changer le domaine ou le sous-domaine et plus rien ne marche !
>> supprimer les cookies créés par les noms de domaines et de sous-domaines.
