# Prinicpe

Chaque release de ce repository correspondra à un scénario.

* REALEASE 0.0.1 : cf. [Scenario 2](https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto#scenario-2)
<!-- * REALEASE 0.0.2 : cf. [Scenario 3](https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto#scenario-3) -->
<!-- * REALEASE 0.0.3 : cf. [Scenario 4](https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto#scenario-4) -->

# Scenarii

## Scenario 1

Une "fausse" application tournant dans un tomcat dans un conteneur Docker:
Ce conteneur ne fait "que s'exécuter" et on peut utiliser la commande:

```
docker exec -it $NOM_CONTNEUR /bin/bash -c "echo \"nouvelle ligne de log de ma fausse application\" \>\> /opt/petit-duc/petit-duc.log"
```

On souhaite parcourir les logs avec Elastic Stack et FileBeats.

Les filebeat seront installés :

- Dans des conteneurs Docker : le filebeat est installé directement dans le conteneur Docker qui contient l'application dont on souhaite surveiller les logs
- Sur l'hôte de conteneurisation : le filetbeat est installé sur l'hôte de conteneurisation, et le conteneur de l'application expose un volume docker dans lequel sont stocké les logs applicatifs.

- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec le conteneur applicatif.
- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec non plus 1, mais 2 conteneurs contenant chacun une application différente.

## Scenario 2

Une application Web Jee tournant dans un tomcat dans un conteneur Docker.
On souhaite parcourir les logs avec Elastic Stack et FileBeats.

Les filebeat seront installés :

- Dans des conteneurs Docker : le filebeat est installé directement dans le conteneur Docker qui contient l'application dont on souhaite surveiller les logs
- Sur l'hôte de conteneurisation : le filetbeat est installé sur l'hôte de conteneurisation, et le conteneur de l'application expose un volume docker dans lequel sont stocké les logs applicatifs.

- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec le conteneur applicatif.
- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec non plus 1, mais 2 conteneurs contenant chacun une application différente.

## Scenario 3

2 applications : 1 Web Jee tournant dans un tomcat dans un conteneur Docker, l'autre est une application java exécutant un jar exécutable.
Ces  2 applications ont contenues dans 2 conteneurs: k'un 
On souhaite parcourir les logs avec Elastic Stack et FileBeats.

Les filebeat seront installés :

- Dans des conteneurs Docker : le filebeat est installé directement dans le conteneur Docker qui contient l'application dont on souhaite surveiller les logs
- Sur l'hôte de conteneurisation : le filetbeat est installé sur l'hôte de conteneurisation, et le conteneur de l'application expose un volume docker dans lequel sont stocké les logs applicatifs.

- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec le conteneur applicatif.
- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec non plus 1, mais 2 conteneurs contenant chacun une application différente.

## Scenario 4

3 applications dans openshift : les trois sont déployées dans openshift sous forme d'images docker construire docker build, et poussées dnas le repo de référence openshift. 
L'une des applications est un simple jar exécutable, l'autre une appli web dans un conteneur contenant un tomcat et une appli web, et la dernière est composée de 2  microservices un en RxJAva, exposant une API REST, l'autre un client Angular5, tournant dans un conteneur nodeJS, faisant appel à la REST API pour faire de la persistance. 

On souhaite parcourir les logs des 3 applications avec Elastic Stack et FileBeats.

Les filebeat seront installés :

- Dans des conteneurs Docker : le filebeat est installé directement dans le conteneur Docker qui contient l'application dont on souhaite surveiller les logs
- Sur l'hôte de conteneurisation : le filetbeat est installé sur l'hôte de conteneurisation, et le conteneur de l'application expose un volume docker dans lequel sont stocké les logs applicatifs.

- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec le conteneur applicatif.
- Sur une VM différente "BeatVM": le filebeat est installé sur une VM "BeatVM", disctincte de l'hôte de conteneurisation. De plus, dans "BeatVM", un serveur NFS est installé, et un répertoire est ainsi partagé avec non plus 1, mais 2 conteneurs contenant chacun une application différente.

## Scenario 5: Breakout Release

3 applications dans openshift + Kubernetes en prod 
mêmes appplications que dans le scenario 4.
On souhaite surveiller/gérerles logs des 3 applications avec ELK.



# Utilisation

En utilisant cette recette, vous pourrez:

* Provisionner un systyème ELK,
* Provisionner une cible de déploiement pour les applications qui seront déployées
* Pré-configurer le système ELK pour prendre en charge le traitement des logs des applications qui vont être déployées
* Déployer vos applications
* Post-configurer le système ELK pour prendre en charge le traitement des logs des nouvelles applications déployées
* Vérifier le traitement des logs de vos applications déployées avec ELK, et Kibana notamment.

Selon les versions de cette recette, vous pourrez aussi provisionner:
* Un système Openshift / Minishift "sur une grosse VM à 48 Go RAM, 4 vCPUs")
* Un système Kubernetes (high availability, avec plus de 6 serveurs)

## Provision du système ELK 

Exécutez:

```
export PROVISIONING_HOME 
PROVISIONING_HOME=$(pwd)/provision-app-plus-elk
rm -rf $PROVISIONING_HOME
mkdir -p $PROVISIONING_HOME
cd $PROVISIONING_HOME
git clone "https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto" . 
sudo chmod +x ./operations.sh
./operations.sh
```
Ou encore, en une seule ligne:
```
export PROVISIONING_HOME && PROVISIONING_HOME=$(pwd)/provision-app-plus-elk && rm -rf $PROVISIONING_HOME && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto" . && sudo chmod +x ./operations.sh && ./operations.sh
```

## Provision de l'application exemple Web Jee / Tomcat / MariaDB

Ce repo contient uen application web Java jee, 
Il s'agit d'un fichier *war, que vous trouverez dans ce repo à l'emplacement:

`./application-1/srv-jee/appli-a-deployer-pour-test.war` 

Exécutez:

`export PROVISIONING_HOME && PROVISIONING_HOME=$(pwd)/provision-app-plus-elk && cd $PROVISIONING_HOME && export $NOMFICHIERLOG=provision-app1-qui-loggue.log && sudo chmod +x $PROVISIONING_HOME/provision-application-1-qui-loggue.sh && $PROVISIONING_HOME/provision-application-1-qui-loggue.sh && sudo chmod +x $PROVISIONING_HOME/application-1/srv-jee/tomcat/deployer-appli-web.sh && $PROVISIONING_HOME/application-1/srv-jee/tomcat/deployer-appli-web.sh $PROVISIONING_HOME/application-1/srv-jee/tomcat/appli-a-deployer-pour-test.war  >> $NOMFICHIERLOG`

Cette exécution est interactive, suivez-en les instructions, puis, lorsque vous aurez terminé, vous aurez installé [HeidiSQL](), et vous pourrez exécuter:
`deployer-appli-web.sh`


Ce qui déploiera l'application web jee exemple, amenée avec cette recette de provision. 

## TODO: évolution provision application qui loggue

Décomposer la présente recette avec les 3 recettes suivantes:
* https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos
* https://github.com/Jean-Baptiste-Lasselle/provision-cible-deploiement-dockhost-tomcat-mariadb
* https://github.com/Jean-Baptiste-Lasselle/provision-elk-sur-dockhost


# ANNEXE : System Requirements for ELK


Selon la [documentation Officielle Elastic Search ELK](https://www.elastic.co/guide/en/elasticsearch/reference/5.0/vm-max-map-count.html#vm-max-map-count) :

```
Virtual memory


Elasticsearch uses a hybrid mmapfs / niofs directory by default to store its indices. The default operating system limits on mmap counts is likely to be too low, which may result in out of memory exceptions.

On Linux, you can increase the limits by running the following command as root:

sysctl -w vm.max_map_count=262144

To set this value permanently, update the vm.max_map_count setting in /etc/sysctl.conf. To verify after rebooting, run sysctl vm.max_map_count.

The RPM and Debian packages will configure this setting automatically. No further configuration is required.
```


Et voici un exemple de l'erreur obtneue si 'lon ne prend pas en compte cette contrainte système d'Elastic Stack:

```
 * Starting Elasticsearch Server                                         [ OK ]
waiting for Elasticsearch to be up (1/30)
waiting for Elasticsearch to be up (2/30)
waiting for Elasticsearch to be up (3/30)
waiting for Elasticsearch to be up (4/30)
waiting for Elasticsearch to be up (5/30)
waiting for Elasticsearch to be up (6/30)
waiting for Elasticsearch to be up (7/30)
waiting for Elasticsearch to be up (8/30)
waiting for Elasticsearch to be up (9/30)
waiting for Elasticsearch to be up (10/30)
waiting for Elasticsearch to be up (11/30)
waiting for Elasticsearch to be up (12/30)
waiting for Elasticsearch to be up (13/30)
waiting for Elasticsearch to be up (14/30)
waiting for Elasticsearch to be up (15/30)
waiting for Elasticsearch to be up (16/30)
waiting for Elasticsearch to be up (17/30)
waiting for Elasticsearch to be up (18/30)
waiting for Elasticsearch to be up (19/30)
waiting for Elasticsearch to be up (20/30)
waiting for Elasticsearch to be up (21/30)
waiting for Elasticsearch to be up (22/30)
waiting for Elasticsearch to be up (23/30)
waiting for Elasticsearch to be up (24/30)
waiting for Elasticsearch to be up (25/30)
waiting for Elasticsearch to be up (26/30)
waiting for Elasticsearch to be up (27/30)
waiting for Elasticsearch to be up (28/30)
waiting for Elasticsearch to be up (29/30)
waiting for Elasticsearch to be up (30/30)
Couln't start Elasticsearch. Exiting.
Elasticsearch log follows below.
[2018-06-07T05:26:21,574][INFO ][o.e.n.Node               ] [] initializing ...
[2018-06-07T05:26:21,633][INFO ][o.e.e.NodeEnvironment    ] [yfKmdTg] using [1] data paths, mounts [[/var/lib/elasticsearch (/dev/mapper/centos-root)]], net usable_space [44.6gb], net total_space [48gb], types [xfs]
[jibl@pc-65 provision-app-plus-elk]$ clear
[jibl@pc-65 provision-app-plus-elk]$ sudo docker logs 6033f08809ef|more
 * Starting periodic command scheduler cron                              [ OK ]
 * Starting Elasticsearch Server                                         [ OK ]
waiting for Elasticsearch to be up (1/30)
waiting for Elasticsearch to be up (2/30)
waiting for Elasticsearch to be up (3/30)
waiting for Elasticsearch to be up (4/30)
waiting for Elasticsearch to be up (5/30)
waiting for Elasticsearch to be up (6/30)
waiting for Elasticsearch to be up (7/30)
waiting for Elasticsearch to be up (8/30)
waiting for Elasticsearch to be up (9/30)
waiting for Elasticsearch to be up (10/30)
waiting for Elasticsearch to be up (11/30)
waiting for Elasticsearch to be up (12/30)
waiting for Elasticsearch to be up (13/30)
waiting for Elasticsearch to be up (14/30)
waiting for Elasticsearch to be up (15/30)
waiting for Elasticsearch to be up (16/30)
waiting for Elasticsearch to be up (17/30)
waiting for Elasticsearch to be up (18/30)
waiting for Elasticsearch to be up (19/30)
waiting for Elasticsearch to be up (20/30)
waiting for Elasticsearch to be up (21/30)
waiting for Elasticsearch to be up (22/30)
waiting for Elasticsearch to be up (23/30)
waiting for Elasticsearch to be up (24/30)
waiting for Elasticsearch to be up (25/30)
waiting for Elasticsearch to be up (26/30)
waiting for Elasticsearch to be up (27/30)
waiting for Elasticsearch to be up (28/30)
waiting for Elasticsearch to be up (29/30)
waiting for Elasticsearch to be up (30/30)
Couln't start Elasticsearch. Exiting.
Elasticsearch log follows below.
[2018-06-07T05:26:21,574][INFO ][o.e.n.Node               ] [] initializing ...
[2018-06-07T05:26:21,633][INFO ][o.e.e.NodeEnvironment    ] [yfKmdTg] using [1] data paths, mounts [[/var/lib/elasticsearch (/dev/mapper/centos-root)]], net usable_space [44.6gb], net total_space [48gb], types [xfs]
[2018-06-07T05:26:21,634][INFO ][o.e.e.NodeEnvironment    ] [yfKmdTg] heap size [1007.3mb], compressed ordinary object pointers [true]
[2018-06-07T05:26:21,635][INFO ][o.e.n.Node               ] node name [yfKmdTg] derived from node ID [yfKmdTg1TMevn0bJ4WyRyw]; set [node.name] to override
[2018-06-07T05:26:21,635][INFO ][o.e.n.Node               ] version[6.2.4], pid[89], build[ccec39f/2018-04-12T20:37:28.497551Z], OS[Linux/3.10.0-327.el7.x86_64/amd64], JVM[Oracle Corporation/OpenJDK 64-Bit Server VM/
1.8.0_171/25.171-b11]
[2018-06-07T05:26:21,635][INFO ][o.e.n.Node               ] JVM arguments [-Xms1g, -Xmx1g, -XX:+UseConcMarkSweepGC, -XX:CMSInitiatingOccupancyFraction=75, -XX:+UseCMSInitiatingOccupancyOnly, -XX:+AlwaysPreTouch, -Xss
1m, -Djava.awt.headless=true, -Dfile.encoding=UTF-8, -Djna.nosys=true, -XX:-OmitStackTraceInFastThrow, -Dio.netty.noUnsafe=true, -Dio.netty.noKeySetOptimization=true, -Dio.netty.recycler.maxCapacityPerThread=0, -Dlog
4j.shutdownHookEnabled=false, -Dlog4j2.disable.jmx=true, -Djava.io.tmpdir=/tmp/elasticsearch.Mv6FiXSI, -XX:+HeapDumpOnOutOfMemoryError, -XX:+PrintGCDetails, -XX:+PrintGCDateStamps, -XX:+PrintTenuringDistribution, -XX
:+PrintGCApplicationStoppedTime, -Xloggc:logs/gc.log, -XX:+UseGCLogFileRotation, -XX:NumberOfGCLogFiles=32, -XX:GCLogFileSize=64m, -Des.path.home=/opt/elasticsearch, -Des.path.conf=/etc/elasticsearch]
[2018-06-07T05:26:22,187][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [aggs-matrix-stats]
[2018-06-07T05:26:22,187][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [analysis-common]
[2018-06-07T05:26:22,187][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [ingest-common]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [lang-expression]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [lang-mustache]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [lang-painless]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [mapper-extras]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [parent-join]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [percolator]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [rank-eval]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [reindex]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [repository-url]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [transport-netty4]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] loaded module [tribe]
[2018-06-07T05:26:22,188][INFO ][o.e.p.PluginsService     ] [yfKmdTg] no plugins loaded
[2018-06-07T05:26:24,461][INFO ][o.e.d.DiscoveryModule    ] [yfKmdTg] using discovery type [zen]
[2018-06-07T05:26:24,930][INFO ][o.e.n.Node               ] initialized
[2018-06-07T05:26:24,931][INFO ][o.e.n.Node               ] [yfKmdTg] starting ...
[2018-06-07T05:26:25,048][INFO ][o.e.t.TransportService   ] [yfKmdTg] publish_address {172.17.0.2:9300}, bound_addresses {0.0.0.0:9300}
[2018-06-07T05:26:25,057][INFO ][o.e.b.BootstrapChecks    ] [yfKmdTg] bound or publishing to a non-loopback address, enforcing bootstrap checks
[2018-06-07T05:26:25,059][ERROR][o.e.b.Bootstrap          ] [yfKmdTg] node validation exception
[1] bootstrap checks failed
[1]: max virtual memory areas vm.max_map_count [65530] is too low, increase to at least [262144]
[2018-06-07T05:26:25,061][INFO ][o.e.n.Node               ] [yfKmdTg] stopping ...
[2018-06-07T05:26:25,078][INFO ][o.e.n.Node               ] [yfKmdTg] stopped
[2018-06-07T05:26:25,079][INFO ][o.e.n.Node               ] [yfKmdTg] closing ...
[2018-06-07T05:26:25,090][INFO ][o.e.n.Node               ] [yfKmdTg] closed

```


# ANNEXE

```
 sudo -l -U jibl
[sudo] Mot de passe de jibl : 
Entrées par défaut pour jibl sur pc-65 :
    !visiblepw, always_set_home, match_group_by_gid, env_reset, env_keep="COLORS DISPLAY HOSTNAME HISTSIZE KDEDIR LS_COLORS", env_keep+="MAIL PS1 PS2 QTDIR USERNAME LANG LC_ADDRESS LC_CTYPE", env_keep+="LC_COLLATE
    LC_IDENTIFICATION LC_MEASUREMENT LC_MESSAGES", env_keep+="LC_MONETARY LC_NAME LC_NUMERIC LC_PAPER LC_TELEPHONE", env_keep+="LC_TIME LC_ALL LANGUAGE LINGUAS _XKB_CHARSET XAUTHORITY",
    secure_path=/sbin\:/bin\:/usr/sbin\:/usr/bin

L'utilisateur jibl peut utiliser les commandes suivantes sur pc-65 :
    (ALL) ALL
[jibl@pc-65 ~]$

```

# Sources d'information diverses

* Rappels docker volume, et bind/mount volumes: https://container42.com/2014/11/03/docker-indepth-volumes/, et https://docs.docker.com/storage/bind-mounts/#use-a-read-only-bind-mount 
* Elémentaire: https://elk-docker.readthedocs.io
* Pour aller plus loin, avec une configuration de filebeats sécurisée Certificats SSL, et des groks filters pour le logstash 
    https://www.digitalocean.com/community/tutorials/how-to-install-elasticsearch-logstash-and-kibana-elk-stack-on-ubuntu-14-04
	le tout réalise des log systèmes, là où je pourrais faire en plsu des logs applicatifs / métiers avec le opentracing.io
	les groks filters logstash, les filebeats et leur configuration, les configurations d'index Elastic Search, et les configurations de dashboards Kibana.
```
Now that your syslogs are centralized via Elasticsearch and Logstash, and you are able to visualize them with Kibana, you should be off to a good start with centralizing all of your important logs
```
<!-- * REALEASE 0.0.2 : https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html  +   https://www.elastic.co/downloads/beats/filebeat -->
<!-- * REALEASE 0.0.3 : http://blog.dbsqware.com/elasticstack-principe-installation-et-premiers-pas/ -->
