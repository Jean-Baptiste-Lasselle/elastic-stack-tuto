#!/bin/bash
# Hôte Docker sur centos 7



# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							ENV								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------
export MAISON_OPERATIONS
# MAISON_OPERATIONS=$(pwd)/provision-apps-plus-elk.io
MAISON_OPERATIONS=`pwd`

# -
export NOMFICHIERLOG
NOMFICHIERLOG="$(pwd)/provision-tuto-elk-filebeats.log"



######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
# -

export NOM_CONTENEUR_ELK1=conteneur-elk-jibl

# export ADRESSE_IP_HOTE_DOCKER_ELK_PAR_DEFAUT
# ADRESSE_IP_HOTE_DOCKER_ELK_PAR_DEFAUT=0.0.0.0

######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -


# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							FONCTIONS						##########################################
##############################################################################################################################################


# --------------------------------------------------------------------------------------------------------------------------------------------
# Cette fonction permet de re-synchroniser l'hôte docker sur un serveur NTP, sinon# certaines installations dépendantes
# de téléchargements avec vérification de certtificat SSL
#
# ---
# Dixit : https://services.renater.fr/ntp/article/presentation_ntp_article
# Dixit : https://services.renater.fr/ntp/serveurs_francais
# Dixit : http://www.pool.ntp.org/zone/fr
# ---
# France — fr.pool.ntp.org
# 
# To use this specific pool zone, add the following to your ntp.conf file:
# 
# 	   server 0.fr.pool.ntp.org
# 	   server 1.fr.pool.ntp.org
# 	   server 2.fr.pool.ntp.org
# 	   server 3.fr.pool.ntp.org
#  
# 
# 
synchroniserSurServeurNTP () {
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ------	SYNCHRONSITATION SUR UN SERVEUR NTP PUBLIC (Y-en-a-til des gratuits dont je puisse vérifier le certificat SSL TLSv1.2 ?)
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	# ---	Pour commencer, pour ne PAS FAIRE PETER TOUS LES CERTIFICATS SSL vérifiés pour les installation yum
	# ---	
	# ---	Sera aussi utilise pour a provision de tous les noeuds d'infrastructure assurant des fonctions d'authentification:
	# ---		Le serveur Free IPA Server
	# ---		Le serveur OAuth2/SAML utilisé par/avec Free IPA Server, pour gérer l'authentification 
	# ---		Le serveur Let's Encrypt et l'ensemble de l'infrastructure à clé publique gérée par Free IPA Server
	# ---		Toutes les macines gérées par Free-IPA Server, donc les hôtes réseau exécutant des conteneurs Girofle
	# 
	# 
	# >>>>>>>>>>> Mais en fait la synchronisation NTP doit se faire sur un référentiel commun à la PKI à laquelle on choisit
	# 			  de faire confiance pour l'ensemble de la provision. Si c'est une PKI entièrement interne, alors le système 
	# 			  comprend un repository linux privé contenant tous les packes à installer, dont docker-ce.
	# 
	# ---------------------------------------------------------------------------------------------------------------------------------------------
	echo "date avant la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	sudo which ntpdate
	sudo yum install -y ntp
	sudo ntpdate 0.fr.pool.ntp.org
	echo "date après la re-synchronisation [Serveur NTP=$SERVEUR_NTP :]" >> $NOMFICHIERLOG
	date >> $NOMFICHIERLOG
	# pour re-synchroniser l'horloge matérielle, et ainsi conserver l'heure après un reboot, et ce y compris après et pendant
	# une coupure réseau
	sudo hwclock --systohc

}




# --------------------------------------------------------------------------------------------------------------------------------------------
# 
# Cette fonction permet d'attendre que le conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire sinon une erreur est générée (TODO: à implémenter avec exit code)
checkHealth () {
	export ETATCOURANTCONTENEUR=starting
	export ETATCONTENEURPRET=healthy
	export NOM_DU_CONTENEUR_INSPECTE=$1
	
	while  $(echo "+provision+girofle+ $NOM_DU_CONTENEUR_INSPECTE - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG); do
	
	ETATCOURANTCONTENEUR=$(sudo docker inspect -f '{{json .State.Health.Status}}' $NOM_DU_CONTENEUR_INSPECTE)
	if [ $ETATCOURANTCONTENEUR == "\"healthy\"" ]
	then
		echo " +++provision+ app + elk +  $NOM_DU_CONTENEUR_INSPECTE est prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR]">> $NOMFICHIERLOG
		break;
	else
		echo " +++provision+ app + elk +  $NOM_DU_CONTENEUR_INSPECTE n'est pas prêt - HEALTHCHECK: [$ETATCOURANTCONTENEUR] - attente d'une seconde avant prochain HealthCheck - ">> $NOMFICHIERLOG
		sleep 1s
	fi
	done	
}

# --------------------------------------------------------------------------------------------------------------------------------------------
##############################################################################################################################################
#########################################							OPS								##########################################
##############################################################################################################################################
# --------------------------------------------------------------------------------------------------------------------------------------------


# rm  -rf $MAISON_OPERATIONS
# mkdir -p $MAISON_OPERATIONS
# cd $MAISON_OPERATIONS
rm -f $NOMFICHIERLOG
touch $NOMFICHIERLOG

# je dois faire simplement une synchrinsation NTP, pour mettre à jour date et heure système.
# Et non à la fois installation du client NTP, et mise à jour de l'heure et la date système.
synchroniserSurServeurNTP


echo " +++provision+ app + elk +  COMMENCEE  - " >> $NOMFICHIERLOG


# PARTIE INTERACTIVE
clear
echo " "
echo "##########################################################"
echo "##########################################################"
echo " "


echo " " >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "# Setup Tutoriel ELK en cours..." >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo " " >> $NOMFICHIERLOG
clear

echo "########### "
echo "########### "
echo "########### Setup Tutoriel ELK en cours..."
echo "########### "

# PARTIE SILENCIEUSE

# on rend les scripts à exécuter, exécutables.
# sudo chmod +x ./provision-hote-docker.sh >> $NOMFICHIERLOG
# sudo chmod +x ./provision-elk.sh >> $NOMFICHIERLOG

# --------------------------------------------------------------------------------------------------------------------------------------------
# 			PROVISION HÔTE DOCKER
# --------------------------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------
# ------ >>>  REFACTORISATION: https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos
# ---------------------------------------
# provision hôte docker: devra être faite par la recette dédiée et séparée:  https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos
# ./provision-hote-docker.sh >> $NOMFICHIERLOG
export URI_REPO_RECETTE_PROV_DOCKHOST=https://github.com/Jean-Baptiste-Lasselle/provision-hote-docker-sur-centos
export DOCKHOST_PROVISONING_HOME=$HOME/provision-hote-docker
rm -rf $DOCKHOST_PROVISONING_HOME
mkdir -p $DOCKHOST_PROVISONING_HOME
cd $DOCKHOST_PROVISONING_HOME
git clone "$URI_REPO_RECETTE_PROV_DOCKHOST" .
sudo chmod +x operations.sh
./operations.sh
cd $MAISON_OPERATIONS


# --------------------------------------------------------------------------------------------------------------------------------------------
# 			PROVISION ELK
# --------------------------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------
# ------ >>>  REFACTORISATION: https://github.com/Jean-Baptiste-Lasselle/provision-elk-sur-dockhost
# ---------------------------------------
# 1. provision ELK 
# ./provision-elk.sh >> $NOMFICHIERLOG
export URI_REPO_RECETTE_PROV_ELK=https://github.com/Jean-Baptiste-Lasselle/provision-elk-sur-dockhost
export ELK_PROVISIONING_HOME
ELK_PROVISIONING_HOME=$(pwd)/provision-elk-sur-dockhost
rm -rf $ELK_PROVISIONING_HOME
mkdir -p $ELK_PROVISIONING_HOME
cd $ELK_PROVISIONING_HOME
git clone "$URI_REPO_RECETTE_PROV_ELK" . 
sudo chmod +x ./operations.sh
./operations.sh
cd $MAISON_OPERATIONS



# --------------------------------------------------------------------------------------------------------------------------------------------
# 			PROVISION CIBLE DEPLOIEMENT APPLICATIONS SURPERVISEE PAR ELK
# --------------------------------------------------------------------------------------------------------------------------------------------

# ---------------------------------------
# ------ >>>  REFACTORISATION: https://github.com/Jean-Baptiste-Lasselle/provision-cible-deploiement-dockhost-tomcat-mariadb
# ---------------------------------------
# 3. provision d'une cible de déploiement hôte docker / tomcat / mariadb 
#    devra être faite par la recette dédiée et séparée:  
#      https://github.com/Jean-Baptiste-Lasselle/provision-cible-deploiement-dockhost-tomcat-mariadb
export URI_REPO_RECETTE_PROV_CIBLE_DEPLOIEMENT=https://github.com/Jean-Baptiste-Lasselle/provision-cible-deploiement-dockhost-tomcat-mariadb
export PROVISIONING_HOME_CIBLE
PROVISIONING_HOME_CIBLE=$(pwd)/provision-cible-deploiement-apps-qui-emettent-logs
rm -rf $PROVISIONING_HOME_CIBLE
mkdir -p $PROVISIONING_HOME_CIBLE
cd $PROVISIONING_HOME_CIBLE
git clone "$URI_REPO_RECETTE_PROV_CIBLE_DEPLOIEMENT" . 
sudo chmod +x ./operations.sh
./operations.sh
cd $MAISON_OPERATIONS


echo "########### "
echo "########### "
echo "########### Tutoriel ELK prêt à l'emploi! "
echo "########### "

echo " " >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo "# Tutoriel ELK prêt à l'emploi!." >> $NOMFICHIERLOG
echo "##########################################################" >> $NOMFICHIERLOG
echo " " >> $NOMFICHIERLOG
clear
###  Mais bon, pour moi, le cycle de création d'applications et déploiements, commence ici avec le FULLSTACK-MAVEN-PLUGIN


# ---------------------------------------
# ------ >>>  REFACTORISATION: https://github.com/Jean-Baptiste-Lasselle/provision-application-1-qui-loggue
# ---------------------------------------
# 4. provision d'une première application qui loggue:
#    devra être faite par la recette dédiée et séparée
# ./provision-application-1-qui-loggue.sh >> $NOMFICHIERLOG


