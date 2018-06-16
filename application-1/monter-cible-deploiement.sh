#!/bin/bash
############################################################
############################################################
# 					Compatibilité système		 		   #
############################################################
############################################################

# ----------------------------------------------------------
# [Pour Comparer votre version d'OS à
#  celles mentionnées ci-dessous]
# 
# ¤ distributions Ubuntu:
#		lsb_release -a
#
# ¤ distributions CentOS:
# 		cat /etc/redhat-release
# 
# 
# ----------------------------------------------------------

# ----------------------------------------------------------
# testé pour:
# 
# 
# 
# 
# ----------------------------------------------------------
# (Ubuntu)
# ----------------------------------------------------------
# 
# ¤ [TEST-OK]
#
# 	[Distribution ID: 	Ubuntu]
# 	[Description: 		Ubuntu 16.04 LTS]
# 	[Release: 			16.04]
# 	[codename:			xenial]
# 
# 
# 
# 
# 
# 
# ----------------------------------------------------------
# (CentOS)
# ----------------------------------------------------------
# 
# 
# 
# ...
# ----------------------------------------------------------


############################################################
############################################################
#					variables d'environnement			   #
############################################################
############################################################

######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -#
######### -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -# -#
# - 
# - Environnement hérité
# - 
# 
# export MAISON
# export NOM_CONTENEUR_TOMCAT
# export NOM_CONTENEUR_SGBDR

# export ADRESSE_IP_SRV_JEE
# NUMERO_PORT_SRV_JEE=$SAISIE_NUMERO_PORT_SRV_JEE
# export NUMERO_PORT_SRV_JEE

# ADRESSE_IP_SGBDR=$ADRESSE_IP_SRV_JEE
# export ADRESSE_IP_SGBDR
# NUMERO_PORT_SGBDR=$SAISIE_NUMERO_PORT_SGBDR
# export NUMERO_PORT_SGBDR

# export DB_MGMT_USER_NAME
# export DB_MGMT_USER_PWD

# export DB_APP_USER_NAME
# export DB_APP_USER_PWD


# export NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN
# export URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN

# export MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME
# export MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD

# MAISON=`pwd`

# NOM_CONTENEUR_TOMCAT=ciblededeploiement-composant-srv-jee
# NOM_CONTENEUR_SGBDR=ciblededeploiement-composant-sgbdr

# ADRESSE_IP_SRV_JEE=192.168.1.63
# NUMERO_PORT_SRV_JEE=8888

# ADRESSE_IP_SGBDR=192.168.1.63
# NUMERO_PORT_SGBDR=3308

# DB_MGMT_USER_NAME=jean
# DB_MGMT_USER_PWD=jean

# DB_APP_USER_NAME=appli1-de-jean
# DB_APP_USER_PWD=mdp@ppli1-je@n


############################################################
# # l'utilisateur linux qui fera office d'opérateur
# # pour le compte du plugin maven "fullstack-maven-plugin"
# # cet utilisateur devrait être différent de celui utilisé
# # pour construire la cible de déploiement. Il devrait de 
# # plus être inexistant avant, et créé pour le
# # comissionning de la cible de déploiement.
# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=jean
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=jean
# # le repo git qui assistera le
# # plugin maven "fullstack-maven-plugin"
# NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=assistant-deploiements-appli1
# URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/assistant-deploiements-appli1.git


# 
# export NOM_CONTENEUR_ELK1=conteneur-elk-jibl
# ----------------------------------------------------------
# 
# 
# >>>> ENV. SETUP.

VERSION_TOMCAT=8.0

# NOM_BDD_APPLI=bdd_appli1
NOM_BDD_APPLI=bdd_appli1

MARIADB_MDP_ROOT_PASSWORD=peuimporte


# Avec cet utilisateur, on va créer la BDD $NOM_BDD_APPLI, et
# créer l'utilisateur $DB_APP_USER_NAME
MARIADB_DB_MGMT_USER_NAME=$DB_MGMT_USER_NAME
MARIADB_DB_MGMT_USER_PWD=$DB_MGMT_USER_PWD


MARIADB_DB_APP_USER_NAME=$DB_APP_USER_NAME
MARIADB_DB_APP_USER_PWD=$DB_APP_USER_PWD

VERSION_MARIADB=10.1
CONTEXTE_DU_BUILD_DOCKER=$MAISON/application-1/bdd/mariadb
# export NOM_IMAGE_DOCKER_SGBDR=bytes-io/sgbdr:v3.0.8
export NOM_IMAGE_DOCKER_SGBDR=bytes-io/sgbdr:v3
NO_PORT_EXTERIEUR_MARIADB=$NUMERO_PORT_SGBDR
NOM_CONTENEUR_MARIADB=$NOM_CONTENEUR_SGBDR
REPERTOIRE_HOTE_BCKUP_CONF_MARIADB=$MAISON/mariadb-conf/bckup

# >>>>>>>>>>>> [$CONF_MARIADB_A_APPLIQUER] >>> DOIT EXISTER
# CONF_MARIADB_A_APPLIQUER=$MAISON/application-1/bdd/mariadb/my.cnf
CONF_MARIADB_A_APPLIQUER=$MAISON/application-1/bdd/mariadb/my.cnf


############################################################
############################################################
#					déclarations fonctions				   #
############################################################
############################################################
# ----------------------------------------------------------
# ces fichiers générés sont des dépendances du
# build de l'image mariadb.
generer_fichiers () {
	# > script sql pour créer la bdd
	rm -f $CONTEXTE_DU_BUILD_DOCKER/creer-bdd-application.sql
	echo "CREATE DATABASE $NOM_BDD_APPLI; " >> $CONTEXTE_DU_BUILD_DOCKER/creer-bdd-application.sql
	# > script shell pour créer la bdd
	rm -f $CONTEXTE_DU_BUILD_DOCKER/creer-bdd-application.sh
	echo "mysql -u root -p$MARIADB_MDP_ROOT_PASSWORD < ./creer-bdd-application.sql" > $CONTEXTE_DU_BUILD_DOCKER/creer-bdd-application.sh
	# ============= >>> MAIS EN FAIT IL FAUT FAIRE DE LA MACHINE A ETATS SUR VERSION DOCKER COMPOSE FILE <<< ======================================
	# ============= >>> MAIS EN FAIT IL FAUT FAIRE DE LA MACHINE A ETATS SUR VERSION DOCKER COMPOSE FILE <<< ======================================
	# ============= >>> MAIS EN FAIT IL FAUT FAIRE DE LA MACHINE A ETATS SUR VERSION DOCKER COMPOSE FILE <<< ======================================
	# docker cp ./creer-bdd-application.sql $NOM_CONTENEUR_SGBDR:. 
	# docker cp ./creer-bdd-application.sh $NOM_CONTENEUR_SGBDR:. 
	# docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash < ./creer-bdd-application.sh
	# ou alors:
	# docker exec -it $NOM_CONTENEUR_SGBDR /bin/bash < ./creer-bdd-application.sh


	# > scripts sql/sh pour créer l'utilisateur applicatif
	rm -f $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sql
	echo "use mysql; " >> $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sql
	# echo "select @mdp:= PASSWORD('$MARIADB_DB_APP_USER_PWD');" >> $CONTEXTE_DU_BUILD_DOCKER./creer-utilisateur-applicatif.sql
	echo "CREATE USER '$MARIADB_DB_APP_USER_NAME'@'%' IDENTIFIED BY '$MARIADB_DB_APP_USER_PWD';" >> $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sql
	echo "GRANT ALL PRIVILEGES ON $NOM_BDD_APPLI.* TO '$MARIADB_DB_APP_USER_NAME'@'%' WITH GRANT OPTION;" >> $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sql
	
	
		# > script shell pour créer l'utilisateur applicatif
	rm -f $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sh
	echo "mysql -u root -p$MARIADB_MDP_ROOT_PASSWORD < ./creer-utilisateur-applicatif.sql" >> $CONTEXTE_DU_BUILD_DOCKER/creer-utilisateur-applicatif.sh
	
	rm -f $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sql
	echo "use mysql; " >> $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sql
	# plus facile d'appliquer les  mêmes droits aux deux utilisateurs pour commencer. donc idem pour $MARIADB_DB_MGMT_USER_NAME
	echo "-- # Plus facile d'appliquer les  mêmes droits aux deux utilisateurs pour commencer." >> $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sql
	echo "-- # Donc idem pour $MARIADB_DB_MGMT_USER_NAME" >> $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sql
	echo "GRANT ALL PRIVILEGES ON $NOM_BDD_APPLI.* TO '$MARIADB_DB_MGMT_USER_NAME'@'%' WITH GRANT OPTION;" >> $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sql

	# > script shell pour configurer l'utilisateur utilisé par le dveloppeur pour gérer la BDD applicative.
	rm -f $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sh
	echo "mysql -u root -p$MARIADB_MDP_ROOT_PASSWORD < ./configurer-utilisateur-mgmt.sql" >> $CONTEXTE_DU_BUILD_DOCKER/configurer-utilisateur-mgmt.sh
}

# ---------------------------------------------------------
# [description]
# ---------------------------------------------------------
# Cette fonction permet d'attendre que le
# conteneur soit dans l'état healthy
# Cette fonction prend un argument, nécessaire
# sinon une erreur est générée (TODO: à implémenter avec
# exit code)
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

#----------------------------------------------------------#
############################################################
#					exécution des opérations			   #
############################################################
#----------------------------------------------------------#



##########################################################
##### 				INSTALLATION DOCKER			 #########
##########################################################
# installation docker

clear
##########################################################
##### MONTEE INFRASTRUCTURE CIBLE DE DEPLOIEMENT #########
##########################################################



rm -rf $REPERTOIRE_HOTE_BCKUP_CONF_MARIADB
mkdir -p $REPERTOIRE_HOTE_BCKUP_CONF_MARIADB



# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# > construction du conteneur SERVEUR JEE  <
# >    -------------------------------     <
# >    ce conteneur est une dépendance     <
# >    -------------------------------     <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<


sudo docker run --name $NOM_CONTENEUR_TOMCAT -p $NUMERO_PORT_SRV_JEE:8080 -d tomcat:$VERSION_TOMCAT

checkHealth $NOM_CONTENEUR_TOMCAT
# http://adressIP:8888/

# clear
# echo POINT DEBUG
# echo CONTENEUR TOMCAT CREE CONF DS CONTENEUR
# echo "   sudo docker exec -it ccc /bin/bash"
# read
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
# >    construction du conteneur SGBDR     <
# >    -------------------------------     <
# >    ce conteneur est une dépendance     <
# >    -------------------------------     <
# >>>>>>>>>>>>>>>>>>>>><<<<<<<<<<<<<<<<<<<<<
#



# export NOM_IMAGE_DOCKER_SGBDR=bytes-io/sgbdr:v3
cd $CONTEXTE_DU_BUILD_DOCKER
clear
pwd
generer_fichiers
sudo docker build --tag $NOM_IMAGE_DOCKER_SGBDR -f ./mariadb.dockerfile $CONTEXTE_DU_BUILD_DOCKER
cd $MAISON



clear
# > créer le conteneur avec usr, et root_user
# La "--collation-server" permet de définir l'ordre lexicographique des mots formés à partir de l'alphabet définit par le jeu de caractères utilisé
# La "--character-set-server" permet de définir l'encodage et le jeu de caractères utilisé
# sudo docker run --name $NOM_CONTENEUR_MARIADB -e MYSQL_ROOT_PASSWORD=$MARIADB_MDP_ROOT_PASSWORD -e MYSQL_USER=$MARIADB_DB_MGMT_USER_NAME -e MYSQL_PASSWORD=$MARIADB_DB_MGMT_USER_PWD -p $NO_PORT_EXTERIEUR_MARIADB:3306 -v $REPERTOIRE_HOTE_BCKUP_CONF_MARIADB:/etc/mysql -d $NOM_IMAGE_DOCKER_SGBDR  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci
sudo docker run --name $NOM_CONTENEUR_MARIADB -e MYSQL_ROOT_PASSWORD=$MARIADB_MDP_ROOT_PASSWORD -e MYSQL_USER=$MARIADB_DB_MGMT_USER_NAME -e MYSQL_PASSWORD=$MARIADB_DB_MGMT_USER_PWD -p $NO_PORT_EXTERIEUR_MARIADB:3306 -d $NOM_IMAGE_DOCKER_SGBDR  --character-set-server=utf8mb4 --collation-server=utf8mb4_unicode_ci

checkHealth $NOM_CONTENEUR_MARIADB

echo ""
echo " ---------------------------------------------------------------------------------------------------- "
echo " ------------------------- "
echo " génération du fichier [./configurer-user-et-bdd-sql.sh] "
echo " ------------------------- "
echo ""
echo ""
echo ""
rm -f ./configurer-user-et-bdd-sql.sh
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"chmod +x /creer-bdd-application.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"/creer-bdd-application.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo ""
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"chmod +x /creer-utilisateur-applicatif.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"/creer-utilisateur-applicatif.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo ""
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"chmod +x /configurer-utilisateur-mgmt.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo "docker exec $NOM_CONTENEUR_MARIADB /bin/bash -c \"/configurer-utilisateur-mgmt.sh\"" >> ./configurer-user-et-bdd-sql.sh
echo " " 
sudo chmod +x ./configurer-user-et-bdd-sql.sh

echo "			" 
# echo "			sudo ./configurer-user-et-bdd-sql.sh" 
echo " " 
# echo " --------------------------------------------------------  "
# echo "   Pour créer BDD et utilisateurs SQL, exécutez:" 
# echo "			" 
# echo "			sudo ./configurer-user-et-bdd-sql.sh" 
# echo "			" 
echo " --------------------------------------------------------  "
echo " -- Installez \"HeidiSQL\" sur votre poste           ----  "
echo " -- travail 	:									   ----  "
echo " -- https://www.heidisql.com/						   ----  "
echo " -- 												   ----  "
echo " -- Avec \"HeidiSQL\", vous allez vérifier que vous  ----  "
echo " -- pouvez vous connecter à l'adressse IP $ADRESSE_IP_SGBDR sur   ----  "
echo " -- le numéro de port $NUMERO_PORT_SGBDR, avec les				   ----  "
echo " -- 2 utilisateurs suivants:						   ----  "
echo " -- 												   ----  "
echo " --------------------------------------------------------  "
echo "   - Un utilisateur SQL utilisé par l'application:"
echo "  	[nom d'utilisateur = $MARIADB_DB_MGMT_USER_NAME]"
echo "  	[mot de passe = $MARIADB_DB_MGMT_USER_PWD] "
echo "   - Un utilisateur SQL utilisé par le développeur avec HeidiSQL:"
echo "  	[nom d'utilisateur = $DB_MGMT_USER_NAME] "
echo "  	[mot de passe = $DB_MGMT_USER_PWD] "
echo "   - Vous constaterez de plus que tous les deux ont accès  "
echo "     à une bdd nommée \"$NOM_BDD_APPLI\", et ont les "
echo "     droits pour y créer / détruire une table."
echo " --------------------------------------------------------  "
echo " ---------------------------------------------------------------------------------------------------- "


sudo ./configurer-user-et-bdd-sql.sh
# sleep 5s
# sudo ./configurer-user-et-bdd-sql.sh
echo " --------------------------------------------------------  "
echo " --- Si la connexion pour l'un des ces  "
echo " --- utilisateurs devait échouer, ouvrez un nouveau        "
echo " --- terminal, exécutez la commande:  "
echo "			" 
echo "			sudo ./configurer-user-et-bdd-sql.sh" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
read


############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
##########################											GESTION SUDOERS												############################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
############################################################################################################################################################
#
# TODO =>>> mettre à jour la configuration /etc/sudoers
rm -f $MAISON/application-1/sudoers.ajout


# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=jean
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=jean
# NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=assistant-deploiements-appli1
# URL_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN=https://github.com/Jean-Baptiste-Lasselle/assistant-deploiements-appli1.git

echo "" >> $MAISON/application-1/sudoers.ajout
echo "# Allow DEPLOYEUR-MAVEN-PLUGIN to execute deployment commands" >> $MAISON/application-1/sudoers.ajout
echo "$MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME ALL=NOPASSWD: /usr/bin/docker cp*, /usr/bin/docker restart*, /usr/bin/docker exec*, /bin/rm -rf ./$NOM_REPO_GIT_ASSISTANT_DEPLOYEUR_MVN_PLUGIN" >> $MAISON/application-1/sudoers.ajout
echo "" >> $MAISON/application-1/sudoers.ajout
# echo "" >> $MAISON/application-1/sudoers.ajout
clear
echo " --- Justez avaant de toucher /etc/sudoers:  "
echo "			" 
echo "			cat $MAISON/application-1/sudoers.ajout" 
echo "			" 
echo " ---------------------------------------------------------------------------------------------------- "
cat $MAISON/application-1/sudoers.ajout
echo " ---------------------------------------------------------------------------------------------------- "
echo " ---------	Pressez la touche entrée pour ajouter en fin de /etc/sudoers 					------- "
echo " ---------------------------------------------------------------------------------------------------- "
read
# cat $MAISON/application-1/sudoers.ajout >> /etc/sudoers
# echo 'foobar ALL=(ALL:ALL) ALL' | sudo EDITOR='tee -a' visudo

# MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME=jean
# MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD=jean

# celui-ci marche, c'est testé:
cat $MAISON/application-1/sudoers.ajout | sudo EDITOR='tee -a' visudo

clear
echo " --------------------------------------------------------  "
echo " --- De plus, l'utilisateur linux que votre plugin  "
echo " --- doit utiliser est: "
echo " --- 				 "
echo " --- 				nom d'utilisateur linux: $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME"
echo " --- 				 "
echo " --- 				mot de passe: $MVN_PLUGIN_OPERATEUR_LINUX_USER_PWD"
echo " --- 				 "
echo " --- "
echo " --- "
echo " contenu du fichier         /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME       :"
cat /etc/sudoers|grep $MVN_PLUGIN_OPERATEUR_LINUX_USER_NAME
echo " --- "
echo " --- "
echo " --- "
echo " ---------------------------------------------------------------------------------------------------- "
read

# TODO: générer le $MAISON/application-1/config.fullstack.maven.plugin.xml

# TODO: installer le DATASDOURCE dans le serveur JEE

# # installation du $TOMCAT_HOME/conf/context.xml $CATALINA_BASE/conf/context.xml
# # (si aucune configuration d'hôtes virutels multiples, $CATALINE_BASE prend la valeur de $CATALINA_HOME)
# sudo docker cp $MAISON/application-1/srv-jee/tomcat/context.xml $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/conf
sudo docker cp $MAISON/application-1/srv-jee/tomcat/server.xml $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/conf

# Injection de la valeur du nom de la BDD de l'application, dans le script de création de la tabel de données de tests.
sed -i "s/VAL_NOM_BDD_APPLI/$NOM_BDD_APPLI/g" $MAISON/application-1/bdd/mariadb/create-bdd-test-data1.sql
chmod 777 $MAISON/application-1/bdd/mariadb/create-bdd-test-data1.sql
sudo docker cp $MAISON/application-1/bdd/mariadb/create-bdd-test-data1.sql $NOM_CONTENEUR_MARIADB:/root/creer-bdd-et-table-test-avec-donnees.sql
# Cette opération peut être laissée, suggérée à l'utililisateur
sudo docker exec -it $NOM_CONTENEUR_MARIADB /bin/bash -c "mysql -u root -p$MARIADB_MDP_ROOT_PASSWORD < /root/creer-bdd-et-table-test-avec-donnees.sql"



# # installation du dbcp.jar
# déjà installé de base avec tomcat 8.0
# # installation de la bonne version du connecteur jdbc, en fonction de la version de MariaDB

 # cette versiond e connecteur MariaDB / JDBC n'est comptatible qu'avec Java 8 et Java 9, pas Java 7, or c'esty Java 7 qui est installé dans le conteneur docker
# VERSION_CONNECTEUR_JDBC_MARIADB=2.2.1
# MAISON=`pwd`
# mkdir -p $MAISON/application-1/srv-jee/
VERSION_CONNECTEUR_JDBC_MARIADB=1.7.1
wget https://downloads.mariadb.com/Connectors/java/connector-java-$VERSION_CONNECTEUR_JDBC_MARIADB/mariadb-java-client-$VERSION_CONNECTEUR_JDBC_MARIADB.jar -O $MAISON/application-1/srv-jee/mariadb-java-client-$VERSION_CONNECTEUR_JDBC_MARIADB.jar

# TODO: remplcaer automatiquement dans le fichier $MAISON/lauriane/context.xml, la valeur du nom du driver, l'adresse IP etc....

sudo docker cp $MAISON/application-1/srv-jee/mariadb-java-client-$VERSION_CONNECTEUR_JDBC_MARIADB.jar $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/lib


# installation de la JSTL dans le serveur (au lieu du projet) ...?
VERSION_JSTL=1.2
# wget http://central.maven.org/maven2/javax/servlet/jstl/1.2/jstl-$VERSION_JSTL.jar
# sudo docker cp ./jstl-1.2.jar $NOM_CONTENEUR_TOMCAT:/usr/local/tomcat/lib

# pour un éventuel passage en mode debug du serveur (utilisé pour: debug deploiement datasource)
# sudo docker cp $MAISON/application-1/srv-jee/tomcat/logging-debug.properties ciblededeploiement-composant-srv-jee:/usr/local/tomcat/conf/logging.properties
sudo docker cp $MAISON/application-1/srv-jee/tomcat/logging.properties ciblededeploiement-composant-srv-jee:/usr/local/tomcat/conf

# => Définit le niveau de log de l'applicationd ans le serveur jee
# NIVEAU_DE_LOG=INFO
# NIVEAU_DE_LOG=FINE
# NIVEAU_DE_LOG=FINEST
NIVEAU_DE_LOG=DEBUG
sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c "echo \"export CATALINA_OPTS=\\\"\$CATALINA_OPTS -Dorg.slf4j.simpleLogger.defaultLogLevel=$NIVEAU_DE_LOG\\\"\" >> /usr/local/tomcat/bin/setenv.sh"
 
sudo docker restart $NOM_CONTENEUR_TOMCAT

checkHealth $NOM_CONTENEUR_TOMCAT

clear
echo " --------------------------------------------------------  "
echo " --- Enfin, dans le conteneur Tomcat, vous pouvez :        "
echo " ---  "
echo " --- 				 "
# echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"rm -f /usr/local/tomcat/conf/context.xml\""
echo " --- vérifier le déploiement du connecteur JDBC /MARIADB: "
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"ls -all /usr/local/tomcat/lib\""
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"ls -all /usr/local/tomcat/lib|grep jdbc\""
echo " --- vérifier le déploiement du context.xml: "
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"cat /usr/local/tomcat/conf/context.xml\""
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"more /usr/local/tomcat/conf/context.xml\""
echo " --- vérifier les logs serveurs: "
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"ls -all /usr/local/tomcat/logs/\""
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"more /usr/local/tomcat/logs/catalina*.log|grep dbcp\""
echo " --- vérifier les logs de l'application 1: "
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"ls -all /usr/local/tomcat/logs/\""
echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"more /usr/local/tomcat/logs/localhost*.log\""

# echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"rm -f /usr/local/tomcat/logs/catalina*.log\""
# echo " --- 				sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c \"ls -all /usr/local/tomcat/logs/\""
echo " --- 				 "
echo " --- "
echo " --- "
echo " --- contenu du fichier  /usr/local/tomcat/conf/context.xml :"
sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c "cat /usr/local/tomcat/conf/context.xml"
echo " --- Bibliothèques serveur       :"
sudo docker exec -it $NOM_CONTENEUR_TOMCAT /bin/bash -c "ls -all /usr/local/tomcat/lib"
echo " --- "
echo " --- "
echo " --- "
# echo " --- prochains coups d'essais: https://examples.javacodegeeks.com/enterprise-java/tomcat/tomcat-connection-pool-configuration-example/ "
echo " ---------------------------------------------------------------------------------------------------- "
read
# ----------------------------------------------------------------------------------------------------------------------------------------------
# pour consulter les logs serveur:
# --------------------------------
# sudo docker exec -it ciblededeploiement-composant-srv-jee /bin/bash -c "more /usr/local/tomcat/logs/catalina.2018-01-18.log"
# ----------------------------------------------------------------------------------------------------------------------------------------------



# ============= >>> générer les fichiers  (QUI VONT FFAIRE OBJET D'UN ADD DANS LES DOCKER COMPOSE FILE et autres DOCKERFILES) <<< =============
# ============= >>> générer les fichiers  (QUI VONT FFAIRE OBJET D'UN ADD DANS LES DOCKER COMPOSE FILE et autres DOCKERFILES) <<< =============
# ============= >>> générer les fichiers  (QUI VONT FFAIRE OBJET D'UN ADD DANS LES DOCKER COMPOSE FILE et autres DOCKERFILES) <<< =============

