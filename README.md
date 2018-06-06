# Prinicpe

Chaque release de ce repository correspondra à une implémentation (et ses tests) d'une source d'information.

Les sources d'informations scannées par ce repo:


* REALEASE 0.0.1 : https://elk-docker.readthedocs.io
<!-- * REALEASE 0.0.2 : https://www.elastic.co/guide/en/beats/filebeat/current/filebeat-getting-started.html  +   https://www.elastic.co/downloads/beats/filebeat -->
<!-- * REALEASE 0.0.3 : http://blog.dbsqware.com/elasticstack-principe-installation-et-premiers-pas/ -->


# Scenario

Une application Web Jee tournant dansun tomcat dans un conteneur Docker.
On souhaite parcourir les logs avec Elastic Stack et FileBeats.

Les filebeat seront installés :

- Dans des conteneurs Docker
- Sur l'hôte de conteneurisation


# Utilisation

Pour utiliser cette recette, exécutez:

```
export PROVISIONING_HOME
PROVISIONING_HOME=$(pwd)/provision-app-plus-elk.io
cd $PROVISIONING_HOME
git clone "https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto" . 
sudo chmod +x ./operations.sh
./operations.sh
```
Ou encore, en une seule ligne:
```
export PROVISIONING_HOME && PROVISIONING_HOME=$(pwd)/provision-app-plus-elk && rm -rf $PROVISIONING_HOME && mkdir -p $PROVISIONING_HOME && cd $PROVISIONING_HOME && git clone "https://github.com/Jean-Baptiste-Lasselle/elastic-stack-tuto" . && sudo chmod +x ./operations.sh && ./operations.sh
```

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




